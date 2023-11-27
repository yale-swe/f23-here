/**
 * Reply Controller Tests
 *
 * A suite of Jest tests for testing functionalities related to replies to messages.
 * These tests cover reply creation and liking of replies.
 */

import { jest } from "@jest/globals";

import { replyToMessage, likeReply } from "../../controllers/reply.js";

import MessageModel from "../../models/Message.js";
import ReplyModel from "../../models/Reply.js";
import httpMocks from "node-mocks-http";

jest.mock("../../models/Message");
const mockReplySave = jest.fn();
ReplyModel.prototype.save = mockReplySave;

describe("likeReply", () => {
	it("should successfully create a reply to a message", async () => {
		const mockMessage = {
			_id: "parentMessageId",
			replies: [],
			save: jest.fn().mockResolvedValue({}),
		};
		const mockReply = {
			_id: "newReplyId",
			parent_message: "parentMessageId",
			content: "Reply content",
		};

		MessageModel.findById = jest.fn().mockResolvedValue(mockMessage);
		mockReplySave.mockResolvedValue(mockReply);

		const req = httpMocks.createRequest({
			body: { message_id: mockMessage._id, content: "Reply content" },
		});
		const res = httpMocks.createResponse();

		await replyToMessage(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(mockMessage._id);
		expect(mockReplySave).toHaveBeenCalled();
		expect(mockMessage.replies).toContain(mockReply._id);
		expect(mockMessage.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockReply);
	});
	it("should return 404 if the parent message is not found", async () => {
		MessageModel.findById.mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: {
				message_id: "nonexistentMessageId",
				content: "Reply content",
			},
		});
		const res = httpMocks.createResponse();

		await replyToMessage(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(
			"nonexistentMessageId"
		);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Parent message not found");
	});

	it("should handle server errors", async () => {
		MessageModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { message_id: "parentMessageId", content: "Reply content" },
		});
		const res = httpMocks.createResponse();

		await replyToMessage(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith("parentMessageId");
		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("likeReply", () => {
	it("should successfully increase the likes of a reply", async () => {
		const mockReplyId = "replyId";
		const mockReply = {
			_id: mockReplyId,
			likes: 1,
			save: jest.fn().mockResolvedValue({ _id: mockReplyId, likes: 2 }),
		};

		ReplyModel.findById = jest.fn().mockResolvedValue(mockReply);

		const req = httpMocks.createRequest({
			body: { reply_id: mockReplyId },
		});
		const res = httpMocks.createResponse();

		await likeReply(req, res);

		expect(ReplyModel.findById).toHaveBeenCalledWith(mockReplyId);
		expect(mockReply.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		const responseData = JSON.parse(res._getData());
		expect(responseData.likes).toBe(2);
	});
	it("should return 404 if the reply is not found", async () => {
		ReplyModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { reply_id: "nonexistentReplyId" },
		});
		const res = httpMocks.createResponse();

		await likeReply(req, res);

		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Reply not found");
	});
	it("should return 505 on server error", async () => {
		ReplyModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { reply_id: "replyId" },
		});
		const res = httpMocks.createResponse();

		await likeReply(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

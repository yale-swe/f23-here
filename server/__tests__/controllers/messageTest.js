/**
 * Message Controller Tests
 *
 * A suite of Jest tests for testing functionalities related to messages.
 * These tests cover message retrieval, creation, liking, visibility changes, and message deletion.
 *
 */

import { jest } from "@jest/globals";
import {
	getAllMessages,
	postMessage,
	incrementLikes,
	changeVisibility,
	deleteMessage,
} from "../../controllers/message.js";

import UserModel from "../../models/User.js";
import MessageModel from "../../models/Message.js";
import httpMocks from "node-mocks-http";

jest.mock("../../models/User");
jest.mock("../../models/Reply");
jest.mock("../../models/Message");

describe("postMessage", () => {
	it("should successfully post a message", async () => {
		const mockUserId = "userId";
		const mockUser = {
			_id: mockUserId,
			messages: [],
			save: jest.fn().mockResolvedValue({}),
		};
		const mockMessageData = {
			user_id: mockUserId,
			text: "Test message",
			visibility: "public",
			location: { type: "Point", coordinates: [50.0, 50.0] },
		};
		const mockSavedMessage = {
			...mockMessageData,
			_id: "newMessageId",
		};

		MessageModel.prototype.save = jest
			.fn()
			.mockResolvedValue(mockSavedMessage);

		UserModel.findById = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			body: mockMessageData,
		});

		const res = httpMocks.createResponse();

		await postMessage(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUserId);
		expect(MessageModel.prototype.save).toHaveBeenCalled();
		expect(mockUser.messages).toContain(mockSavedMessage._id);
		expect(mockUser.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockSavedMessage);
	});
	it("should return 404 if the user posting the message is not found", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { user_id: "nonexistentUserId", text: "Test message" },
		});
		const res = httpMocks.createResponse();

		await postMessage(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith("nonexistentUserId");
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain(
			"User posting this message is not found"
		);
	});
	it("should handle server errors", async () => {
		UserModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { user_id: "userId", text: "Test message" },
		});
		const res = httpMocks.createResponse();

		await postMessage(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("getAllMessages", () => {
	const mockReplies = [{ _id: "reply1Id" }, { _id: "reply2Id" }];
	const mockMessages = [
		{
			_id: "message1Id",
			user_id: "userId1",
			text: "Message 1 text",
			likes: 5,
			location: {
				type: "Point",
				coordinates: [50.0, 50.0],
			},
			visibility: "friends",
			replies: mockReplies,
		},
		{
			_id: "message2Id",
			user_id: "userId2",
			text: "Message 2 text",
			likes: 10,
			location: {
				type: "Point",
				coordinates: [40.0, 40.0],
			},
			visibility: "public",
			replies: [],
		},
	];
	MessageModel.find = jest.fn().mockImplementation(() => ({
		populate: jest.fn().mockResolvedValue(mockMessages),
	}));
	it("should retrieve all messages successfully", async () => {
		const req = httpMocks.createRequest();
		const res = httpMocks.createResponse();

		await getAllMessages(req, res);

		expect(MessageModel.find).toHaveBeenCalledWith({});
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockMessages);
	});
	it("should return 500 when server error occur", async () => {
		MessageModel.find = jest.fn().mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest();
		const res = httpMocks.createResponse();

		await getAllMessages(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("incrementLikes", () => {
	const mockMessage = {
		_id: "messageId",
		text: "Test message",
		likes: 0,
	};
	MessageModel.findByIdAndUpdate = jest.fn().mockResolvedValue({
		...mockMessage,
		likes: mockMessage.likes + 1,
	});
	it("should successfully increment the likes of a message", async () => {
		const req = httpMocks.createRequest({
			body: { messageId: mockMessage._id },
		});
		const res = httpMocks.createResponse();

		await incrementLikes(req, res);

		expect(MessageModel.findByIdAndUpdate).toHaveBeenCalledWith(
			"messageId",
			{ $inc: { likes: 1 } },
			{ new: true }
		);
		expect(res.statusCode).toBe(200);
		const responseData = JSON.parse(res._getData());
		expect(responseData.likes).toBe(mockMessage.likes + 1);
	});
	it("should return 500 on server errors", async () => {
		MessageModel.findByIdAndUpdate.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { messageId: mockMessage._id },
		});
		const res = httpMocks.createResponse();

		await incrementLikes(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("changeVisibility", () => {
	it("should successfully toggle the visibility of a message when 'public'", async () => {
		const mockMessageData = {
			_id: "messageId",
			visibility: "public",
			save: jest.fn().mockResolvedValue(this),
		};
		MessageModel.findById = jest.fn().mockResolvedValue(mockMessageData);

		const initialVisibility = mockMessageData.visibility;
		const expectedNewVisibility =
			initialVisibility === "public" ? "friends" : "public";

		const req = httpMocks.createRequest({
			body: { messageId: mockMessageData._id },
		});
		const res = httpMocks.createResponse();

		await changeVisibility(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(mockMessageData._id);
		expect(mockMessageData.save).toHaveBeenCalled();

		expect(res.statusCode).toBe(200);
		const responseData = JSON.parse(res._getData());
		expect(responseData.visibility).toBe(expectedNewVisibility);
	});
	it("should successfully toggle the visibility of a message when 'friends'", async () => {
		const mockMessageData = {
			_id: "messageId",
			visibility: "friends",
			save: jest.fn().mockResolvedValue(this),
		};
		MessageModel.findById = jest.fn().mockResolvedValue(mockMessageData);

		const initialVisibility = mockMessageData.visibility;
		const expectedNewVisibility =
			initialVisibility === "public" ? "friends" : "public";

		const req = httpMocks.createRequest({
			body: { messageId: mockMessageData._id },
		});
		const res = httpMocks.createResponse();

		await changeVisibility(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(mockMessageData._id);
		expect(mockMessageData.save).toHaveBeenCalled();

		expect(res.statusCode).toBe(200);
		const responseData = JSON.parse(res._getData());
		expect(responseData.visibility).toBe(expectedNewVisibility);
	});
	it("should return 404 if the message is not found", async () => {
		const invalidId = "invalidId";
		MessageModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { messageId: invalidId },
		});
		const res = httpMocks.createResponse();

		await changeVisibility(req, res);

		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Message not found");
	});
	it("should return an error (500) for unexpected visibility value", async () => {
		const invalidVisibilityMessage = {
			_id: "messageId",
			visibility: "invalidVisibility",
			save: jest.fn(),
		};
		MessageModel.findById = jest
			.fn()
			.mockResolvedValue(invalidVisibilityMessage);

		const req = httpMocks.createRequest({
			body: { messageId: "messageId" },
		});
		const res = httpMocks.createResponse();

		await changeVisibility(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Unexpected visibility value");
	});
	it("should return 500 on server errors", async () => {
		MessageModel.findById = jest.fn().mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { messageId: "messageId" },
		});
		const res = httpMocks.createResponse();

		await changeVisibility(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("deleteMessage", () => {
	it("should successfully delete a message", async () => {
		const mockMessageId = "messageId";
		const mockMessage = { _id: mockMessageId };
		const mockUser = {
			messages: [mockMessageId],
			save: jest.fn().mockResolvedValue({}),
			messages: {
				remove: jest.fn(),
			},
		};

		MessageModel.findById = jest.fn().mockResolvedValue(mockMessage);
		MessageModel.findByIdAndDelete = jest
			.fn()
			.mockResolvedValue(mockMessage);
		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			body: { messageId: mockMessageId },
		});
		const res = httpMocks.createResponse();

		await deleteMessage(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(mockMessageId);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			messages: mockMessageId,
		});

		expect(mockUser.messages.remove).toHaveBeenCalledWith(mockMessageId);
		expect(mockUser.save).toHaveBeenCalled();
		expect(MessageModel.findByIdAndDelete).toHaveBeenCalledWith(
			mockMessageId
		);

		expect(res.statusCode).toBe(200);
		const responseData = JSON.parse(res._getData());
		expect(responseData).toEqual(mockMessage);
	});
	it("should delete a message even if no user is associated with it", async () => {
		const mockMessageId = "messageId";
		const mockMessage = {
			_id: mockMessageId,
		};

		MessageModel.findById = jest.fn().mockResolvedValue(mockMessage);
		UserModel.findOne = jest.fn().mockResolvedValue(null);

		MessageModel.findByIdAndDelete = jest
			.fn()
			.mockResolvedValue(mockMessage);

		const req = httpMocks.createRequest({
			body: { messageId: mockMessageId },
		});
		const res = httpMocks.createResponse();

		await deleteMessage(req, res);

		expect(MessageModel.findById).toHaveBeenCalledWith(mockMessageId);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			messages: mockMessageId,
		});
		expect(MessageModel.findByIdAndDelete).toHaveBeenCalledWith(
			mockMessageId
		);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockMessage);
	});

	it("should return 404 if the message is not found", async () => {
		MessageModel.findById.mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { messageId: "nonexistentMessageId" },
		});
		const res = httpMocks.createResponse();

		await deleteMessage(req, res);

		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Message not found");
	});
	it("should handle server errors", async () => {
		MessageModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { messageId: "messageId" },
		});
		const res = httpMocks.createResponse();

		await deleteMessage(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

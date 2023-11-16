import { jest } from "@jest/globals";

import {
	getAllMessages,
	postMessage,
	incrementLikes,
	changeVisibility,
} from "../../controllers/message.js";

import MessageModel from "../../models/Message.js";
import httpMocks from "node-mocks-http";
jest.mock("../../models/User");
jest.mock("../../models/Reply");
jest.mock("../../models/Message");

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
			save: jest.fn().mockResolvedValue(this), // Save returns the instance itself
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

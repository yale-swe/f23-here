/**
 * User Controller Tests
 *
 * A suite of Jest tests for testing various functionalities of the user controller.
 * These tests cover user data retrieval, friend management, messaging, and profile updates.
 *
 */

import { jest } from "@jest/globals";
import {
	getUserById,
	getUserByEmailOrUsername,
	getUserFriends,
	addUserFriendById,
	addUserFriendByName,
	removeUserFriendByName,
	getUserMessages,
	deleteUser,
	toggleNotifyFriends,
	updateUserProfile,
	removeUserFriendById,
} from "../../controllers/user.js";

import UserModel from "../../models/User.js";
import MessageModel from "../../models/Message.js";
import httpMocks from "node-mocks-http";
import bcrypt from "bcrypt";
jest.mock("../../models/User");
jest.mock("../../models/Reply");
jest.mock("../../models/Message");

const userId = "validUserId";
const mockUser = {
	_id: userId,
	userName: "JohnD",
	firstName: "John",
	lastName: "Doe",
	email: "john.doe@yale.edu",
	password: "here",
	avatar: "avatar.jpg",
};

describe("getUserMessages", () => {
	it("should successfully find user messages and return them", async () => {
		const mockUserId = "validUserId";
		const mockMessages = [
			{
				_id: "message1",
				text: "Hello, this is message 1!",
				replies: ["reply1", "reply2"],
			},
			{
				_id: "message2",
				text: "Hey, message 2 here!",
				replies: ["reply3"],
			},
		];

		const populateMock = jest.fn();

		populateMock.mockResolvedValue({
			messages: mockMessages,
		});

		UserModel.findById = jest.fn().mockReturnValue({
			populate: populateMock,
		});

		const req = httpMocks.createRequest({ params: { userId: mockUserId } });
		const res = httpMocks.createResponse();

		await getUserMessages(req, res);

		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toMatchObject(mockMessages);
	});

	it("should return a 404 if no user is found", async () => {
		const populateMock = jest.fn();

		populateMock.mockResolvedValue(null);

		UserModel.findById = jest.fn().mockReturnValue({
			populate: populateMock,
		});

		const req = httpMocks.createRequest({ params: { userId } });
		const res = httpMocks.createResponse();

		await getUserMessages(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});

	it("should return a 500 if an error occurs", async () => {
		const errorMessage = "Error occurred";
		UserModel.findById = jest.fn().mockImplementation(() => {
			throw new Error(errorMessage);
		});

		const req = httpMocks.createRequest({ params: { userId } });
		const res = httpMocks.createResponse();

		await getUserMessages(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("getUserById", () => {
	it("should sucessfully find a user by ID and return it", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(mockUser);
		const req = httpMocks.createRequest({ params: { userId } });
		const res = httpMocks.createResponse();

		await getUserById(req, res);

		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toMatchObject(mockUser);
	});

	it("should return a 404 if no user is found", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(null);
		const req = httpMocks.createRequest({ params: { userId } });
		const res = httpMocks.createResponse();

		await getUserById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});

	it("should return a 500 if an error occurs", async () => {
		const errorMessage = "Error occurred";
		UserModel.findById = jest.fn().mockImplementation(() => {
			throw new Error(errorMessage);
		});

		const req = httpMocks.createRequest({ params: { userId } });
		const res = httpMocks.createResponse();

		await getUserById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("getUserByEmailOrUsername", () => {
	it("should sucessfully find a user by email and return it", async () => {
		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			body: { email: mockUser.email },
		});
		const res = httpMocks.createResponse();

		await getUserByEmailOrUsername(req, res);

		expect(UserModel.findOne).toHaveBeenCalledWith({
			$or: [
				{ email: { $regex: new RegExp(`^${mockUser.email}$`, "i") } },
				{ userName: undefined },
			],
		});
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toMatchObject(mockUser);
	});

	it("should sucessfully find a user by userName and return it", async () => {
		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			body: { userName: mockUser.userName },
		});
		const res = httpMocks.createResponse();

		await getUserByEmailOrUsername(req, res);

		expect(UserModel.findOne).toHaveBeenCalledWith({
			$or: [
				{ email: { $regex: new RegExp(`^${undefined}$`, "i") } },
				{ userName: mockUser.userName },
			],
		});
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toMatchObject(mockUser);
	});

	it("should return 404 if user is not found", async () => {
		UserModel.findOne = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { userName: undefined },
		});
		const res = httpMocks.createResponse();

		await getUserByEmailOrUsername(req, res);

		expect(UserModel.findOne).toHaveBeenCalledWith({
			$or: [
				{ email: { $regex: new RegExp(`^${undefined}$`, "i") } },
				{ userName: undefined },
			],
		});
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should handle server errors and return 500", async () => {
		UserModel.findOne = jest.fn().mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { email: "test@example.com", userName: "testUser" },
		});
		const res = httpMocks.createResponse();

		await getUserByEmailOrUsername(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("getUserFriends", () => {
	const friends = ["friend1Id", "friend2Id"];
	const newUser = {
		...mockUser,
		friends: friends,
	};
	it("should return a list of user friends", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(newUser);

		const req = httpMocks.createRequest({
			params: { userId },
		});
		const res = httpMocks.createResponse();

		await getUserFriends(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(friends);
	});
	it("should return 404 if user is not found", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId },
		});
		const res = httpMocks.createResponse();

		await getUserFriends(req, res);
		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should return a 500 if an error occurs", async () => {
		const errorMessage = "Error occurred";
		UserModel.findById = jest.fn().mockImplementation(() => {
			throw new Error(errorMessage);
		});

		const req = httpMocks.createRequest({
			params: { userId },
		});
		const res = httpMocks.createResponse();

		await getUserFriends(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(userId);
		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("addUserFriendById", () => {
	const mockUser = {
		_id: "userId",
		userName: "user",
		friends: new Map(),
		save: jest.fn(),
	};
	const mockFriend = {
		_id: "friendId",
		userName: "friend",
		friends: new Map(),
		save: jest.fn(),
	};

	it("should successfully add a friend", async () => {
		UserModel.findById = jest
			.fn()
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findById).toHaveBeenCalledWith(mockFriend._id);

		expect(mockUser.friends.get(mockFriend._id)).toEqual(
			mockFriend.userName
		);
		expect(mockFriend.friends.get(mockUser._id)).toEqual(mockUser.userName);

		expect(mockUser.save).toHaveBeenCalled();
		expect(mockFriend.save).toHaveBeenCalled();

		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "Friend added successfully",
		});
	});

	it("should not add a friend who is already in the friend list", async () => {
		mockUser.friends.set(mockFriend._id, mockFriend.userName);

		UserModel.findById = jest
			.fn()
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain(
			"Friend is already in user's friend list"
		);
	});

	it("should not allow a user to friend themselves", async () => {
		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockUser._id },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain("You can't friend yourself!");
	});

	it("should return 404 if the user is not found", async () => {
		UserModel.findById = jest.fn().mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});

	it("should return 404 if the friend is not found", async () => {
		const invalidFriendId = "nonexistentFriendId";
		UserModel.findById = jest
			.fn()
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: invalidFriendId },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findById).toHaveBeenCalledWith(invalidFriendId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Friend not found");
	});

	it("should return 500 if server errors occur", async () => {
		const errorMessage = "Internal Server Error";
		UserModel.findById = jest.fn().mockImplementation(() => {
			throw new Error(errorMessage);
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await addUserFriendById(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("addUserFriendByName", () => {
	const mockUser = {
		_id: "userId",
		userName: "JohnD",
		friends: new Map(),
		save: jest.fn(),
	};
	const mockFriend = {
		_id: "friendId",
		userName: "JaneD",
		friends: new Map(),
		save: jest.fn(),
	};

	it("should successfully add a friend by name", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(mockUser);
		UserModel.findOne = jest.fn().mockResolvedValue(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			userName: mockFriend.userName,
		});

		expect(mockUser.friends.get(mockFriend._id)).toEqual(
			mockFriend.userName
		);
		expect(mockFriend.friends.get(mockUser._id)).toEqual(mockUser.userName);

		expect(mockUser.save).toHaveBeenCalled();
		expect(mockFriend.save).toHaveBeenCalled();

		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "Friend added successfully",
		});
	});

	it("should not allow a user to friend themselves", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(mockUser);
		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockUser.userName },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain("You can't friend yourself!");
	});

	it("should not add a friend who is already in the friend list", async () => {
		mockUser.friends.set(mockFriend._id, mockFriend.userName);

		UserModel.findById = jest.fn().mockResolvedValueOnce(mockUser);
		UserModel.findOne = jest.fn().mockResolvedValueOnce(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			userName: mockFriend.userName,
		});
		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain(
			"Friend is already in user's friend list"
		);
	});

	it("should return 404 if the user is not found", async () => {
		UserModel.findById = jest.fn().mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: "nonexistentUserId" },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith("nonexistentUserId");
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});

	it("should return 404 if the friend is not found", async () => {
		UserModel.findById = jest.fn().mockResolvedValueOnce(mockUser);
		UserModel.findOne = jest.fn().mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: "nonexistentFriendName" },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			userName: "nonexistentFriendName",
		});
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Friend not found");
	});

	it("should return 505 on server errors", async () => {
		const errorMessage = "Internal Server Error";
		UserModel.findById = jest.fn().mockImplementation(() => {
			throw new Error(errorMessage);
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await addUserFriendByName(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("removeUserFriendById", () => {
	let mockUser;
	let mockFriend;

	beforeEach(() => {
		mockUser = {
			_id: "userId",
			userName: "JohnD",
			friends: {
				delete: jest.fn(),
				has: jest.fn().mockReturnValue(true),
			},
			save: jest.fn(),
		};

		mockFriend = {
			_id: "friendId",
			userName: "JaneD",
			friends: {
				delete: jest.fn(),
				has: jest.fn().mockReturnValue(true),
			},
			save: jest.fn(),
		};

		jest.clearAllMocks();
	});
	it("should successfully remove a friend", async () => {
		UserModel.findById
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findById).toHaveBeenCalledWith(mockFriend._id);

		expect(mockUser.friends.delete).toHaveBeenCalledWith(mockFriend._id);
		expect(mockFriend.friends.delete).toHaveBeenCalledWith(mockUser._id);

		expect(mockUser.save).toHaveBeenCalled();
		expect(mockFriend.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "Friend removed successfully",
		});
	});
	it("should return 400 if the friend is not in the user's friend list", async () => {
		mockUser.friends = new Map();

		UserModel.findById
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendById(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain("Friend is not in user's friend list");
	});
	it("should return 404 if the user is not found", async () => {
		UserModel.findById
			.mockResolvedValueOnce(null)
			.mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: "nonexistentUserId" },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith("nonexistentUserId");
		expect(UserModel.findById).toHaveBeenCalledWith(mockFriend._id);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should return 404 if the friend is not found", async () => {
		UserModel.findById
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(null);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: "nonexistentFriendId" },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendById(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findById).toHaveBeenCalledWith("nonexistentFriendId");
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Friend not found");
	});
	it("should return 500 if server errors occur", async () => {
		UserModel.findById.mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendId: mockFriend._id },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendById(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("removeUserFriendByName", () => {
	let mockUser;
	let mockFriend;

	beforeEach(() => {
		mockUser = {
			_id: "userId",
			userName: "JohnD",
			friends: {
				delete: jest.fn(),
				has: jest.fn().mockReturnValue(true),
			},
			save: jest.fn(),
		};

		mockFriend = {
			_id: "friendId",
			userName: "JaneD",
			friends: {
				delete: jest.fn(),
				has: jest.fn().mockReturnValue(true),
			},
			save: jest.fn(),
		};

		jest.clearAllMocks();
	});

	it("should successfully remove a friend by name", async () => {
		UserModel.findById.mockResolvedValue(mockUser);
		UserModel.findOne.mockResolvedValue(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			userName: mockFriend.userName,
		});

		expect(mockUser.friends.delete).toHaveBeenCalledWith(mockFriend._id);
		expect(mockFriend.friends.delete).toHaveBeenCalledWith(mockUser._id);

		expect(mockUser.save).toHaveBeenCalled();
		expect(mockFriend.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "Friend removed successfully",
		});
	});

	it("should return 400 if the friend is not in the user's friend list", async () => {
		mockUser.friends.has.mockReturnValue(false);

		UserModel.findById.mockResolvedValue(mockUser);
		UserModel.findOne.mockResolvedValue(mockFriend);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendByName(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain("Friend is not in user's friend list");
	});
	it("should return 404 if the user is not found", async () => {
		UserModel.findById.mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId: "nonexistentUserId" },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendByName(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith("nonexistentUserId");
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should return 404 if the friend is not found", async () => {
		UserModel.findById.mockResolvedValue(mockUser);
		UserModel.findOne.mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: "nonexistentFriendName" },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendByName(req, res);

		expect(UserModel.findOne).toHaveBeenCalledWith({
			userName: "nonexistentFriendName",
		});
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Friend not found");
	});

	it("should return 500 if server errors occur", async () => {
		UserModel.findById.mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: { friendName: mockFriend.userName },
		});
		const res = httpMocks.createResponse();

		await removeUserFriendByName(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("deleteUser", () => {
	const mockUser = {
		_id: "userId",
		messages: ["message1Id", "message2Id"],
	};
	it("should delete the user and their messages successfully", async () => {
		UserModel.findById = jest.fn().mockResolvedValue(mockUser);
		UserModel.findByIdAndDelete = jest.fn().mockResolvedValue({});
		MessageModel.deleteMany = jest.fn().mockResolvedValue({});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
		});
		const res = httpMocks.createResponse();

		await deleteUser(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(MessageModel.deleteMany).toHaveBeenCalledWith({
			_id: { $in: mockUser.messages },
		});
		expect(UserModel.findByIdAndDelete).toHaveBeenCalledWith(mockUser._id);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "User and their messages successfully deleted",
		});
	});
	it("should return 404 if the user is not found", async () => {
		const invalidId = "nonexistentUserId";
		UserModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId: invalidId },
		});
		const res = httpMocks.createResponse();

		await deleteUser(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(invalidId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should handle server errors", async () => {
		UserModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
		});
		const res = httpMocks.createResponse();

		await deleteUser(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("toggleNotifyFriends", () => {
	const mockUser = {
		_id: "userId",
		notifyFriends: false,
		save: jest.fn().mockResolvedValue({}),
	};
	it("should toggle notifyFriends status successfully", async () => {
		const toggledValue = !mockUser.notifyFriends;
		UserModel.findById = jest.fn().mockResolvedValue(mockUser);

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
		});
		const res = httpMocks.createResponse();

		await toggleNotifyFriends(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(mockUser._id);
		expect(mockUser.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			notifyFriends: toggledValue,
		});
	});
	it("should return 404 if the user is not found", async () => {
		const invalidId = "nonexistentUserId";
		UserModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId: invalidId },
		});
		const res = httpMocks.createResponse();

		await toggleNotifyFriends(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(invalidId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found");
	});
	it("should handle server errors", async () => {
		UserModel.findById = jest.fn().mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			params: { userId: "validUserId" },
		});
		const res = httpMocks.createResponse();

		await toggleNotifyFriends(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("updateUserProfile", () => {
	it("should update the user profile successfully", async () => {
		const newUser = {
			...mockUser,
			save: jest.fn().mockResolvedValue({}),
		};
		bcrypt.genSalt = jest.fn().mockResolvedValue("someSalt");
		bcrypt.hash = jest.fn().mockResolvedValue("hashedPassword");
		UserModel.findById = jest.fn().mockResolvedValue(newUser);

		const updatedData = {
			userName: "UpdatedUserName",
			password: "newPassword",
			firstName: "UpdatedFirstName",
			lastName: "UpdatedLastName",
			email: "updated@example.com",
			avatar: "updatedAvatar.jpg",
		};

		const req = httpMocks.createRequest({
			params: { userId: "validUserId" },
			body: updatedData,
		});
		const res = httpMocks.createResponse();

		await updateUserProfile(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(newUser._id);
		expect(bcrypt.genSalt).toHaveBeenCalled();
		expect(bcrypt.hash).toHaveBeenCalledWith("newPassword", "someSalt");
		expect(newUser.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "User profile updated successfully.",
			user: expect.objectContaining({
				...updatedData,
				password: "hashedPassword",
			}),
		});
	});
	it("should not update any fields if none are provided", async () => {
		const newUser = {
			...mockUser,
			save: jest.fn().mockResolvedValue({}),
		};
		bcrypt.genSalt = jest.fn().mockResolvedValue("someSalt");
		bcrypt.hash = jest.fn().mockResolvedValue("hashedPassword");
		UserModel.findById = jest.fn().mockResolvedValue(newUser);

		const req = httpMocks.createRequest({
			params: { userId: newUser._id },
			body: {},
		});
		const res = httpMocks.createResponse();

		await updateUserProfile(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(newUser._id);
		expect(newUser.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "User profile updated successfully.",
			user: expect.objectContaining({
				_id: newUser._id,
				userName: newUser.userName,
				firstName: newUser.firstName,
				lastName: newUser.lastName,
				email: newUser.email,
				password: newUser.password,
				avatar: newUser.avatar,
			}),
		});
	});

	it("should return 404 if the user is not found", async () => {
		let invalidId = "nonexistentUserId";
		UserModel.findById = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			params: { userId: invalidId },
			body: {},
		});
		const res = httpMocks.createResponse();

		await updateUserProfile(req, res);

		expect(UserModel.findById).toHaveBeenCalledWith(invalidId);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("User not found.");
	});
	it("should return 505 when server errors occur", async () => {
		UserModel.findById.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			params: { userId: mockUser._id },
			body: {},
		});
		const res = httpMocks.createResponse();

		await updateUserProfile(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

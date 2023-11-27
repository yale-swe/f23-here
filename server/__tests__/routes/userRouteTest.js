/**
 * User Routes Tests
 *
 * A suite of Jest tests for testing User routes.
 *
 */

import { jest } from "@jest/globals";
import {
	getUserFriends,
	getUserById,
	getUserByEmailOrUsername,
	getUserMessages,
} from "../../controllers/user.js";
import request from "supertest";
import express from "express";
import userRouter from "../../routes/user";
import UserModel from "../../models/User";

const app = express();
app.use(express.json());
app.use("/users", userRouter);

describe("User Router", () => {
	afterEach(() => {
		jest.restoreAllMocks();
	});
	test("GET /users/:userId - should get user by ID", async () => {
		const mockUser = { _id: "507f191e810c19729de860ea", name: "John Doe" };
		const findByIdSpy = jest
			.spyOn(UserModel, "findById")
			.mockResolvedValue(mockUser);

		const res = await request(app).get("/users/507f191e810c19729de860ea");

		expect(findByIdSpy).toHaveBeenCalledWith("507f191e810c19729de860ea");
		expect(res.statusCode).toBe(200);
		expect(res.body).toEqual(mockUser);
	});
	test("GET /users/:userId/friends - should get user friends", async () => {
		const mockUser = {
			_id: "507f191e810c19729de860ea",
			friends: ["friend1", "friend2"],
		};
		jest.spyOn(UserModel, "findById").mockResolvedValue(mockUser);

		const res = await request(app).get(
			"/users/507f191e810c19729de860ea/friends"
		);

		expect(UserModel.findById).toHaveBeenCalledWith(
			"507f191e810c19729de860ea"
		);
		expect(res.statusCode).toBe(200);
		expect(res.body).toEqual(mockUser.friends);
	});
	test("PUT /users/:userId/friends - should add user friend by ID", async () => {
		const mockUser = {
			_id: "507f191e810c19729de860ea",
			friends: new Map(),
			save: jest.fn(),
		};
		mockUser.friends.set = jest.fn();
		mockUser.friends.has = jest.fn().mockReturnValue(false);

		const mockFriend = {
			_id: "friendId",
			userName: "FriendUser",
			friends: new Map(),
			save: jest.fn(),
		};
		mockFriend.friends.set = jest.fn();

		jest.spyOn(UserModel, "findById")
			.mockResolvedValueOnce(mockUser)
			.mockResolvedValueOnce(mockFriend);

		const res = await request(app)
			.put("/users/507f191e810c19729de860ea/friends")
			.send({ friendId: "friendId" });

		expect(UserModel.findById).toHaveBeenCalledWith(
			"507f191e810c19729de860ea"
		);
		expect(UserModel.findById).toHaveBeenCalledWith("friendId");
		expect(mockUser.friends.set).toHaveBeenCalledWith(
			"friendId",
			mockFriend.userName
		);
		expect(mockFriend.friends.set).toHaveBeenCalledWith(
			"507f191e810c19729de860ea",
			mockUser.userName
		);
		expect(mockUser.save).toHaveBeenCalled();
		expect(mockFriend.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
	});

	test("getUserFriends return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		getUserFriends(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("getUserById return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		getUserById(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("getUserByEmailOrUsername return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		getUserByEmailOrUsername(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("getUserMessages return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		getUserMessages(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
});

import { jest } from "@jest/globals";

import request from "supertest";
import express from "express";
import userRouter from "../../routes/user"; // Adjust the path as needed
import UserModel from "../../models/User"; // Adjust the path as needed

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

	// ... other tests for different routes
});

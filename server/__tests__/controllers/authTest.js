/**
 * Authentication Controller Tests
 *
 * A suite of Jest tests for testing user authentication functionalities.
 * These tests cover user registration and login.
 *
 */

import { jest } from "@jest/globals";
import { register, login } from "../../controllers/auth.js";

import UserModel from "../../models/User.js";
import httpMocks from "node-mocks-http";
import bcrypt from "bcrypt";
jest.mock("../../models/User");
jest.mock("../../models/Reply");
jest.mock("../../models/Message");

describe("register", () => {
	it("should successfully register a new user", async () => {
		const mockUser = {
			_id: "someUserId",
			userName: "testUser",
			firstName: "John",
			lastName: "Doe",
			email: "test@example.com",
			password: "hashedPassword",
		};
		bcrypt.genSalt = jest.fn().mockResolvedValue("someSalt");
		bcrypt.hash = jest.fn().mockResolvedValue("hashedPassword");

		UserModel.prototype.save = jest.fn().mockResolvedValue(mockUser);

		const requestBody = {
			userName: "testUser",
			password: "password123",
			email: "test@example.com",
			firstName: "John",
			lastName: "Doe",
		};

		const req = httpMocks.createRequest({
			method: "POST",
			url: "/register",
			body: requestBody,
		});

		const res = httpMocks.createResponse();

		await register(req, res);

		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockUser);
		expect(bcrypt.genSalt).toHaveBeenCalledWith(10);
		expect(bcrypt.hash).toHaveBeenCalledWith("password123", "someSalt");
	});
	it("should return a 500 status code on registration error", async () => {
		const errorMessage = "Error occurred";
		UserModel.prototype.save = jest
			.fn()
			.mockRejectedValue(new Error(errorMessage));

		const req = httpMocks.createRequest({
			body: {
				userName: "testuser",
				password: "password",
				email: "test@example.com",
				firstName: "John",
				lastName: "Doe",
			},
		});
		const res = httpMocks.createResponse();

		await register(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain(errorMessage);
	});
});

describe("login", () => {
	it("should successfully log in a user", async () => {
		const mockUser = {
			_id: "someUserId",
			userName: "testUser",
			email: "test@example.com",
			password: await bcrypt.hash("password123", 10),
		};

		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		bcrypt.compare = jest.fn().mockResolvedValue(true);

		const requestBody = {
			inputLogin: "test@example.com",
			password: "password123",
		};

		const req = httpMocks.createRequest({
			method: "POST",
			url: "/login",
			body: requestBody,
		});

		const res = httpMocks.createResponse();

		await login(req, res);

		expect(res.statusCode).toBe(200);
	});
	it("should handle user not found during login", async () => {
		UserModel.findOne = jest.fn().mockResolvedValue(null);

		const requestBody = {
			inputLogin: "nonExistentUser",
			password: "password123",
		};

		const req = httpMocks.createRequest({
			body: requestBody,
		});

		const res = httpMocks.createResponse();

		await login(req, res);

		expect(res.statusCode).toBe(404);
		expect(UserModel.findOne).toHaveBeenCalledWith({
			$or: [
				{ email: "nonExistentUser" },
				{ userName: "nonExistentUser" },
			],
		});
	});
	it("should handle incorrect password during login", async () => {
		const mockUser = {
			_id: "someUserId",
			userName: "testUser",
			email: "test@example.com",
			password: await bcrypt.hash("password123", 10),
		};

		UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

		bcrypt.compare = jest.fn().mockResolvedValue(false);

		const requestBody = {
			inputLogin: "test@example.com",
			password: "incorrectPassword",
		};

		const req = httpMocks.createRequest({
			method: "POST",
			url: "/login",
			body: requestBody,
		});

		const res = httpMocks.createResponse();

		await login(req, res);

		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain(
			"Incorrect login information. Please try again."
		);
	});
	it("should handle server error during login", async () => {
		UserModel.findOne.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const requestBody = {
			inputLogin: "test@example.com",
			password: "password123",
		};

		const req = httpMocks.createRequest({
			method: "POST",
			url: "/login",
			body: requestBody,
		});

		const res = httpMocks.createResponse();

		await login(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

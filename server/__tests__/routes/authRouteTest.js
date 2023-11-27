/**
 * Authentication Routes Tests
 *
 * A suite of Jest tests for testing Authentication routes.
 *
 */

import { jest } from "@jest/globals";
import { register, login } from "../../controllers/auth";
import express from "express";
import router from "../../routes/auth";

const app = express();
app.use(express.json());
app.use("/auth", router);

describe("Auth Router", () => {
	test("login register return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		register(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("login should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		login(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
});

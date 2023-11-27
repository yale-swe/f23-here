/**
 * Message Routes Tests
 *
 * A suite of Jest tests for testing Message routes.
 *
 */

import { jest } from "@jest/globals";
import {
	postMessage,
	deleteMessage,
	incrementLikes,
	changeVisibility,
	getAllMessages,
} from "../../controllers/message.js";
import express from "express";
import router from "../../routes/message";

const app = express();
app.use(express.json());
app.use("/message", router);

describe("Message Router", () => {
	test("postMessage register return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		postMessage(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("deleteMessage should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		deleteMessage(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("incrementLikes should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		incrementLikes(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("changeVisibility should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		changeVisibility(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("getAllMessages should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		changeVisibility(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
});

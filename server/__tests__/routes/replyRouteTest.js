/**
 * Reply Routes Tests
 *
 * A suite of Jest tests for testing Reply routes.
 *
 */

import { jest } from "@jest/globals";
import express from "express";
import router from "../../routes/reply";
import { replyToMessage, likeReply } from "../../controllers/reply";

const app = express();
app.use(express.json());
app.use("/reply", router);

describe("Reply Router", () => {
	test("replyToMessage should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		replyToMessage(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
	test("likeReply should return 505 error", () => {
		const req = null;
		const res = {
			status: jest.fn().mockReturnThis(),
			send: jest.fn(),
			json: jest.fn(),
		};

		likeReply(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
		expect(res.json).toHaveBeenCalledWith(expect.anything());
	});
});

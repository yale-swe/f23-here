/**
 * Message Routes
 *
 * Express routes for message-related operations in the application. Include routes for
 * posting, deleting, liking messages, changing message visibility, and retrieving all messages.
 * The routing logic is managed by the message controller.
 *
 * Routes:
 *  - GET /get_all_messages: Retrieves all messages.
 *  - POST /post_message: Posts a new message.
 *  - POST /delete_message: Deletes a specific message.
 *  - POST /increment_likes: Increments the likes count of a message.
 *  - POST /change_visibility: Changes the visibility of a message.
 */

import express from "express";
import {
	postMessage,
	deleteMessage,
	incrementLikes,
	changeVisibility,
	getAllMessages,
} from "../controllers/message.js";

const router = express.Router();

router.get("/get_all_messages", getAllMessages);

router.post("/post_message", postMessage);
router.post("/delete_message", deleteMessage);
router.post("/increment_likes", incrementLikes);
router.post("/change_visibility", changeVisibility);

export default router;

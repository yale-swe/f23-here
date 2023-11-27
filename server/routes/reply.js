/**
 * Reply Routes
 *
 * Express routes for operations related to message replies. Includes routes for
 * replying to messages and liking replies. The request handling is delegated to the reply controller.
 *
 * Routes:
 *  - POST /reply-to-message: Handles the creation of a reply to a message.
 *  - POST /like-reply: Manages the liking of a specific reply.
 */

import express from "express";
import { replyToMessage, likeReply } from "../controllers/reply.js";

const router = express.Router();

router.post("/reply-to-message", replyToMessage);
router.post("/like-reply", likeReply);

export default router;

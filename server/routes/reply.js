import express from "express";
import { replyToMessage, likeReply } from "../controllers/reply.js";

const router = express.Router();

router.post("/reply-to-message", replyToMessage);
router.post("/like-reply", likeReply);

export default router;

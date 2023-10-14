import express from "express";
import { reply_to_message, like_reply } from '../controllers/reply.js';

const router = express.Router();

router.post("/reply_to_message", reply_to_message);
router.post("/like_reply", like_reply);

export default router;
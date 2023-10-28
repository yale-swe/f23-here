import express from "express";
import {
	postMessage,
	deleteMessage,
	incrementLikes,
	changeVisibility,
} from "../controllers/message.js";

const router = express.Router();

router.post("/post_message", postMessage);
router.post("/delete_message", deleteMessage);
router.post("/increment_likes", incrementLikes);
router.post("/change_visibility", changeVisibility);

export default router;

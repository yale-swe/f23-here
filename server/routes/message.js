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

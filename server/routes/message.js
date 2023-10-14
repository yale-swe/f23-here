import express from "express";
import { post_message, delete_message, increment_likes, change_visibility } from "../controllers/message.js";

const router = express.Router();

router.post("/post_message", post_message);
router.post("/delete_message", delete_message);
router.post("/increment_likes", increment_likes);
router.post("/change_visibility", change_visibility);

export default router;
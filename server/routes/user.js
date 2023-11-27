import express from "express";
import {
	getUserFriends,
	getUserById,
	getUserByEmailOrUsername,
	addUserFriendById,
	removeUserFriendById,
	getUserMessages,
	deleteUser,
	toggleNotifyFriends,
	updateUserProfile,
	addUserFriendByName,
	removeUserFriendByName,
} from "../controllers/user.js";

const router = express.Router();

router.get("/search", getUserByEmailOrUsername);
router.get("/:userId", getUserById);

router.get("/:userId/friends", getUserFriends);
router.get("/:userId/messages", getUserMessages);

router.put("/:userId/friends", addUserFriendById);
router.put("/:userId/friends_name", addUserFriendByName);
router.put("/:userId/toggle-notify-friends", toggleNotifyFriends);
router.put("/:userId/update-profile", updateUserProfile);

router.delete("/:userId/friends", removeUserFriendById);
router.delete("/:userId/friends_name", removeUserFriendByName);
router.delete("/:userId", deleteUser);

export default router;

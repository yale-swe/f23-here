import express from "express";
import {
	getUserFriends,
	getUserById,
	getUserByEmailOrUsername,
	addUserFriend,
	removeUserFriend,
	getUserMessages,
	deleteUser,
	toggleNotifyFriends,
	updateUserProfile,
} from "../controllers/user.js";

const router = express.Router();

router.get("/search", getUserByEmailOrUsername);
router.get("/:userId", getUserById);

router.get("/:userId/friends", getUserFriends);
router.get("/:userId/friends", getUserMessages);

router.put("/:userId/friends", addUserFriend);
router.put("/:userId/toggle-notify-friends", toggleNotifyFriends);
router.put("/:userId/update-profile", updateUserProfile);

router.delete("/:userId/friends", removeUserFriend);
router.delete("/:userId", deleteUser);

export default router;

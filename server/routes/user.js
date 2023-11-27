/**
 * User Routes
 *
 * Express routes for user-related operations. This module handles various user actions,
 * including retrieving user data, managing friends, messages, and user settings.
 *
 * Routes:
 *  - GET /search: Search for a user by email or username.
 *  - GET /:userId: Get user details by their ID.
 *  - GET /:userId/friends: Get a user's friends.
 *  - GET /:userId/messages: Get messages for a user.
 *  - PUT /:userId/friends: Add a friend to a user by their ID.
 *  - PUT /:userId/friends_name: Add a friend to a user by their name.
 *  - PUT /:userId/toggle-notify-friends: Toggle notification settings for a user's friends.
 *  - PUT /:userId/update-profile: Update a user's profile.
 *  - DELETE /:userId/friends: Remove a friend from a user by their ID.
 *  - DELETE /:userId/friends_name: Remove a friend from a user by their name.
 *  - DELETE /:userId: Delete a user's profile.
 */

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

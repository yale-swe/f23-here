/**
 * User Controller
 *
 * This file serves as the controller for user-related operations in the API.
 * It includes functionalities for user profile management such as retrieving user messages, deleting a user,
 * toggling notification settings, and updating user profile information.
 *
 * Dependencies:
 *  - UserModel: Used for operations related to user data in the database.
 *  - MessageModel: Utilized in operations involving user messages.
 *  - ReplyModel: Used in conjunction with MessageModel for message-reply relationships.
 *  - bcrypt: A library for hashing and comparing passwords, crucial for user authentication and data security.
 * 	- Handlers (handleServerError, handleSuccess, handleNotFound): These utility functions
 * 		are used for consistent handling of HTTP responses across different scenarios such as success, server errors, or resource not found errors.
 */

import UserModel from "../models/User.js";
import bcrypt from "bcrypt";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
	handleBadRequest,
} from "../utils/handlers.js";
import MessageModel from "../models/Message.js";
import ReplyModel from "../models/Reply.js";

/**
 * Retrieves a user by their unique ID.
 *
 * Fetches a user's details from the database.
 * It accepts a user ID passed in the request parameters, finds the corresponding user, and returns their details.
 * If the user is not found, it sends a 'not found' response. In case of server errors, it handles them appropriately.
 *
 * @param {Object} req - The request object, containing the userId parameter.
 * @param {Object} res - The response object used to send back the user data or an error message.
 */
export const getUserById = async (req, res) => {
	try {
		const user = await UserModel.findById(req.params.userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Retrieves a user by email or username.
 *
 * Searches for a user in the database using either the provided email or username. It uses a case-insensitive
 * match for the email and a direct match for the username. If the user is found, their details are returned.
 * Otherwise, a 'not found' response is sent.
 *
 * @param {Object} req - Request object with user's email and username.
 * @param {Object} res - Response object to return the user data or an error message.
 */
export const getUserByEmailOrUsername = async (req, res) => {
	try {
		const { email, userName } = req.body;

		// Find the user by email or username
		const user = await UserModel.findOne({
			$or: [
				{ email: { $regex: new RegExp(`^${email}$`, "i") } },
				{ userName: userName },
			],
		});

		if (!user) {
			return handleNotFound(res, "User not found");
		}
		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Retrieves the friends list of a specific user.
 *
 * Fetches the friends list of a user identified by their userId. The function looks up the user
 * in the database and returns their friends list. If the user is not found, a 'not found' response is sent.
 *
 * @param {Object} req - Request object containing the userId parameter.
 * @param {Object} res - Response object to return the friends list or an error message.
 */
export const getUserFriends = async (req, res) => {
	try {
		const userId = req.params.userId;
		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user.friends);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Adds a user as a friend by their ID.
 *
 * Adds a specified user (friendId) as a friend to another user (userId). It ensures that
 * a user cannot add themselves as a friend and checks if the friend is already in the user's friend list.
 * If the users are valid and not already friends, the friend is added to the user's friend list.
 *
 * @param {Object} req - Request object containing userId in params and friendId in the body.
 * @param {Object} res - Response object to send success or error message.
 */
export const addUserFriendById = async (req, res) => {
	const { userId } = req.params;
	const { friendId } = req.body;

	try {
		// Check if the user is trying to friend themselves
		if (userId == friendId) {
			return handleBadRequest(res, "You can't friend yourself!");
		}

		const user = await UserModel.findById(userId);
		const friend = await UserModel.findById(friendId);

		// Check if the user and friend exist
		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		// Check if the friend is already in the user's friend list
		if (user.friends.has(friendId)) {
			return handleBadRequest(
				res,
				"Friend is already in user's friend list"
			);
		}

		// Add the friend to the user's friend list
		user.friends.set(friendId, friend.userName);
		friend.friends.set(userId, user.userName);

		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend added successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Adds a user as a friend by their username.
 *
 * Similar to addUserFriendById, but this function uses the friend's username (friendName) instead of their ID.
 * It handles the same checks for self-friending and existing friendship. Upon successful addition,
 * a success message is sent back.
 *
 * @param {Object} req - Request object containing userId in params and friendName in the body.
 * @param {Object} res - Response object to send success or error message.
 */
export const addUserFriendByName = async (req, res) => {
	const { userId } = req.params;
	const { friendName } = req.body;

	try {
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findOne({ userName: friendName });

		// Check if the user and friend exist
		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		} else if (friend._id == user._id) {
			return handleBadRequest(res, "You can't friend yourself!");
		}

		// Check if the friend is already in the user's friend list
		if (user.friends.has(friend._id.toString())) {
			return handleBadRequest(
				res,
				"Friend is already in user's friend list"
			);
		}

		// Add the friend to the user's friend list
		user.friends.set(friend._id.toString(), friend.userName);
		friend.friends.set(userId, user.userName);

		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend added successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Removes a user from the friend list by their ID.
 *
 * Deletes a specified user (friendId) from another user's (userId) friend list. It checks if both users exist
 * and if the specified friend is actually in the user's friend list. If the conditions are met, the friend is removed.
 *
 * @param {Object} req - Request object containing userId in params and friendId in the body.
 * @param {Object} res - Response object to send success or error message.
 */
export const removeUserFriendById = async (req, res) => {
	const { userId } = req.params;
	const { friendId } = req.body;

	try {
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findById(friendId);

		// Check if the user and friend exist
		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		//Check if the friend is in the user's friend list
		if (!user.friends.has(friendId)) {
			return handleBadRequest(res, "Friend is not in user's friend list");
		}

		// Remove the friend from the user's friend list
		user.friends.delete(friendId);
		friend.friends.delete(userId);

		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend removed successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Removes a user from the friend list by their username.
 *
 * Similar to removeUserFriendById, but identifies the friend to be removed by their username (friendName).
 * It verifies the existence of both users and their friendship before removing the friend from the user's friend list.
 *
 * @param {Object} req - Request object containing userId in params and friendName in the body.
 * @param {Object} res - Response object to send success or error message.
 */
export const removeUserFriendByName = async (req, res) => {
	const { userId } = req.params;
	const { friendName } = req.body;

	try {
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findOne({ userName: friendName });

		// Check if the user and friend exist
		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		// Check if the friend is in the user's friend list
		if (!user.friends.has(friend._id.toString())) {
			return handleBadRequest(res, "Friend is not in user's friend list");
		}

		// Remove the friend from the user's friend list
		user.friends.delete(friend._id.toString());
		friend.friends.delete(userId);

		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend removed successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Retrieves all messages of a specific user.
 *
 * Fetches the messages of a user by their userId. Messages are populated along with their replies.
 * Returns the messages if the user is found, otherwise, sends a 'not found' response.
 *
 * @param {Object} req - Request object containing userId in params.
 * @param {Object} res - Response object to send user messages or error message.
 */
export const getUserMessages = async (req, res) => {
	try {
		const { userId } = req.params;

		// Find the user and populate their messages and replies
		const user = await UserModel.findById(userId).populate({
			path: "messages",
			model: MessageModel,
			populate: {
				path: "replies",
				model: ReplyModel,
			},
		});

		// If the user is not found, return an error
		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user.messages);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Deletes a user and their messages.
 *
 * Removes a user and all of their messages from the database using the userId. Sends a success message upon
 * completion, or a 'not found' response if the user doesn't exist.
 *
 * @param {Object} req - Request object containing userId in params.
 * @param {Object} res - Response object to send success or error message.
 */
export const deleteUser = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		// Delete all messages associated with the user and then delete the user
		await MessageModel.deleteMany({ _id: { $in: user.messages } });
		await UserModel.findByIdAndDelete(userId);

		handleSuccess(res, {
			message: "User and their messages successfully deleted",
		});
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Toggles the 'notifyFriends' status of a user.
 *
 * Switches the 'notifyFriends' field of a user between true and false. If the user is found, the status
 * is toggled and saved, otherwise, a 'not found' response is sent.
 *
 * @param {Object} req - Request object containing userId in params.
 * @param {Object} res - Response object to send the updated status or error message.
 */
export const toggleNotifyFriends = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		// Toggle the notifyFriends status and save the user
		user.notifyFriends = !user.notifyFriends;
		await user.save();
		handleSuccess(res, { notifyFriends: user.notifyFriends });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Updates a user's profile information.
 *
 * Modifies the profile details (username, password, names, email, avatar) of a user. Password is hashed if updated.
 * On successful update, returns the updated user details, otherwise, sends a 'not found' response.
 *
 * @param {Object} req - Request object containing userId in params and user details in the body.
 * @param {Object} res - Response object to send the updated user profile or error message.
 */
export const updateUserProfile = async (req, res) => {
	try {
		const userId = req.params.userId;
		const { userName, password, firstName, lastName, email, avatar } =
			req.body;

		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found.");
		}

		// Update the user's profile details if provided
		if (userName) user.userName = userName;
		if (firstName) user.firstName = firstName;
		if (lastName) user.lastName = lastName;
		if (email) user.email = email;
		if (avatar) user.avatar = avatar;

		// Re-Hash the password if provided
		if (password) {
			const salt = await bcrypt.genSalt(10);
			user.password = await bcrypt.hash(password, salt);
		}

		await user.save();

		handleSuccess(res, {
			message: "User profile updated successfully.",
			user,
		});
	} catch (err) {
		handleServerError(res, err);
	}
};

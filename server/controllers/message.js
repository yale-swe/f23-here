/**
 * Message Controller
 *
 * This file contains functions for managing messages in the API. It provides capabilities
 * for creating, deleting, updating, and retrieving messages. The functions interact with the database
 * primarily using the MessageModel and handle various scenarios, including error responses.
 *
 * Dependencies:
 *  - MessageModel: Utilized for database interactions related to messages. It is essential for CRUD operations on message data.
 *  - ReplyModel (if used in this file): Used for handling replies associated with messages.
 *  - Handlers (handleServerError, handleSuccess, handleNotFound): These utility functions
 * 		are used for consistent handling of HTTP responses across different scenarios such as success, server errors, or resource not found errors.
 */

import MessageModel from "../models/Message.js";
import UserModel from "../models/User.js";
import {
	handleNotFound,
	handleServerError,
	handleSuccess,
} from "../utils/handlers.js";

/**
 * Retrieves all messages.
 *
 * Fetches all messages from the database. It uses the MessageModel to find and return all messages.
 * On success, it returns the list of messages to the client.
 * On failure, it handles server errors appropriately.
 *
 * @param {Object} req - The request object.
 * @param {Object} res - The response object used to send the retrieved messages or error message.
 */
export const getAllMessages = async (req, res) => {
	try {
		// Get all messages from the database
		const messages = await MessageModel.find({}).populate("replies");
		handleSuccess(res, messages);
	} catch (error) {
		handleServerError(res, error);
	}
};

/**
 * Posts a new message.
 *
 * Creates and stores a new message in the database.
 * If the user exists, it proceeds to create a new message with the provided details (user ID, text, visibility, location) and saves it.
 * On successful creation, the new message is returned to the client.
 * If the user is not found or an error occurs, it handles the response accordingly.
 *
 * @param {Object} req - The request object containing the message and user details.
 * @param {Object} res - The response object used to reply to the client.
 */
export const postMessage = async (req, res) => {
	try {
		// Check if the user exists
		const user = await UserModel.findById(req.body.user_id);
		if (!user) {
			return handleNotFound(
				res,
				"User posting this message is not found"
			);
		}

		// Create a new message with the provided details
		const message = new MessageModel({
			user_id: req.body.user_id,
			text: req.body.text,
			visibility: req.body.visibility,
			location: req.body.location,
		});

		// Save the message to the database
		const saved_message = await message.save();
		user.messages.push(saved_message._id);
		await user.save();

		handleSuccess(res, saved_message);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Deletes a specific message.
 *
 * If the message is found, it then checks for the associated user and removes the message ID from the user's messages.
 * On success, it sends a confirmation response to the client.
 * If the message is not found, or an error occurs, it handles the response accordingly.
 *
 * @param {Object} req - The request object containing the message ID to be deleted.
 * @param {Object} res - The response object used to send the status or error message.
 */
export const deleteMessage = async (req, res) => {
	try {
		const messageId = req.body.messageId;

		// Check if the message exists
		const message = await MessageModel.findById(messageId);
		if (!message) {
			return handleNotFound(res, "Message not found");
		}

		// Check if the user exists
		const user = await UserModel.findOne({ messages: messageId });
		if (user) {
			user.messages.remove(messageId);
			await user.save();
		}

		// Delete the message from the database
		const delete_res = await MessageModel.findByIdAndDelete(messageId);
		handleSuccess(res, delete_res);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Increments the like count of a message.
 *
 * Increases the like count for a specific message by one. It finds the message by ID and
 * uses the `$inc` operator to increment the likes. The updated message is then returned to the client.
 * If an error occurs during this process, the error is handled appropriately.
 *
 * @param {Object} req - The request object containing the message ID whose likes are to be incremented.
 * @param {Object} res - The response object used to send the updated message or error message.
 */
export const incrementLikes = async (req, res) => {
	try {
		// Find the message by ID and increment the likes
		const message = await MessageModel.findByIdAndUpdate(
			req.body.messageId,
			{ $inc: { likes: 1 } },
			{ new: true }
		);
		handleSuccess(res, message);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Changes the visibility of a message.
 *
 * This function toggles the visibility of a specified message between 'public' and 'friends'.
 * Depending on the current state, it toggles the visibility to the other state (i.e., from 'public' to 'friends' or vice versa).
 * In case of an unexpected visibility value, an error is returned.
 * On success, the updated message is returned to the client.
 * If the message is not found or an error occurs, it handles the response accordingly.
 *
 * @param {Object} req - The request object containing the message ID and the desired visibility change.
 * @param {Object} res - The response object used to reply to the client.
 */
export const changeVisibility = async (req, res) => {
	try {
		const message = await MessageModel.findById(req.body.messageId);

		// Check if the message exists
		if (!message) {
			return handleNotFound(res, "Message not found");
		}

		// Toggle the visibility of the message
		let newVisibility;
		if (message.visibility === "public") {
			newVisibility = "friends";
		} else if (message.visibility === "friends") {
			newVisibility = "public";
		} else {
			return handleServerError(res, {
				message: "Unexpected visibility value",
			});
		}

		// Update the message and return it
		message.visibility = newVisibility;
		const updatedMessage = message;
		await message.save();

		handleSuccess(res, updatedMessage);
	} catch (err) {
		handleServerError(res, err);
	}
};

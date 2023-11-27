/**
 * Reply Controller
 *
 * This file includes functions for managing replies to messages in the API. It includes
 * functionality to add a reply to a message (`replyToMessage`) and to increment the like count of a reply (`likeReply`).
 * The functions interact with the MessageModel and ReplyModel.
 *
 * Dependencies:
 *  - MessageModel: Model for message data interaction.
 *  - ReplyModel: Model for reply data interaction.
 *  - Handlers (handleServerError, handleSuccess, handleNotFound): These utility functions
 * 		are used for consistent handling of HTTP responses across different scenarios such as success, server errors, or resource not found errors.
 */

import MessageModel from "../models/Message.js";
import ReplyModel from "../models/Reply.js";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
} from "../utils/handlers.js";

/**
 * Creates a reply to a specific message.
 *
 * Handles the creation of a reply to an existing message.
 * If the parent message is found, it proceeds to create a new reply
 * with the provided content and associates it with the parent message.
 * The reply is then saved to the database, and its ID is added to the parent message's replies.
 * On successful creation, the new reply is returned.
 * If the parent message is not found or an error occurs, it handles the response accordingly.
 *
 * @param {Object} req - The request object containing the parent message ID and reply content.
 * @param {Object} res - The response object used to reply to client.
 */
export const replyToMessage = async (req, res) => {
	try {
		// Check if the parent message exists
		const message = await MessageModel.findById(req.body.message_id);
		if (!message) {
			return handleNotFound(res, "Parent message not found");
		}

		// Create a new reply with the provided content
		const reply = new ReplyModel({
			parent_message: req.body.message_id,
			content: req.body.content,
		});

		// Save the reply to the database
		const saved_reply = await reply.save();
		message.replies.push(saved_reply._id);
		await message.save();
		handleSuccess(res, saved_reply);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Increments the like count of a reply.
 *
 * Increases the like count for a specific reply by one. It finds the reply by its ID
 * and increments the like count. The updated reply is then saved and returned to the client.
 * If the reply is not found or an error occurs during the update process, the error is handled appropriately.
 *
 * @param {Object} req - The request object containing the reply ID whose likes are to be incremented.
 * @param {Object} res - The response object used to send the updated reply or error message.
 */
export const likeReply = async (req, res) => {
	try {
		// Check if the reply exists
		const reply = await ReplyModel.findById(req.body.reply_id);
		if (!reply) {
			return handleNotFound(res, "Reply not found");
		}

		// Increment the likes by one and save the reply
		reply.likes += 1;
		const updated_reply = await reply.save();
		handleSuccess(res, updated_reply);
	} catch (err) {
		handleServerError(res, err);
	}
};

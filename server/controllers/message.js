import MessageModel from "../models/Message.js";
import UserModel from "../models/User.js";
import {
	handleNotFound,
	handleServerError,
	handleSuccess,
} from "../utils/handlers.js";

export const getAllMessages = async (req, res) => {
	try {
		const messages = await MessageModel.find({}).populate("replies");
		handleSuccess(res, messages);
	} catch (error) {
		handleServerError(res, error);
	}
};

export const postMessage = async (req, res) => {
	try {
		const user = await UserModel.findById(req.body.user_id);
		if (!user) {
			return handleNotFound(
				res,
				"User posting this message is not found"
			);
		}
		const message = new MessageModel({
			user_id: req.body.user_id,
			text: req.body.text,
			visibility: req.body.visibility,
			location: req.body.location,
		});
		const saved_message = await message.save();

		user.messages.push(saved_message._id);
		await user.save();

		handleSuccess(res, saved_message);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const deleteMessage = async (req, res) => {
	try {
		const messageId = req.body.messageId;

		const message = await MessageModel.findById(messageId);
		if (!message) {
			return handleNotFound(res, "Message not found");
		}

		const user = await UserModel.findOne({ messages: messageId });
		if (user) {
			user.messages.remove(messageId);
			await user.save();
		}

		const delete_res = await MessageModel.findByIdAndDelete(messageId);
		handleSuccess(res, delete_res);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const incrementLikes = async (req, res) => {
	try {
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

export const changeVisibility = async (req, res) => {
	try {
		const message = await MessageModel.findById(req.body.messageId);

		if (!message) {
			return handleNotFound(res, "Message not found");
		}
		let newVisibility;
		if (message.visibility === "public") {
			newVisibility = "friends";
		} else if (message.visibility === "friends") {
			newVisibility = "public";
		} else {
			return handleServerError(res, "Unexpected visibility value");
		}

		message.visibility = newVisibility;
		const updatedMessage = await message.save();

		handleSuccess(res, updatedMessage);
	} catch (err) {
		handleServerError(res, err);
	}
};

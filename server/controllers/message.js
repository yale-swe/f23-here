import MessageModel from "../models/Message.js";
import UserModel from "../models/User.js";
import {
	handleNotFound,
	handleServerError,
	handleSuccess,
} from "../utils/handlers.js";

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
			req.body.id,
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
		const message = await MessageModel.findByIdAndUpdate(
			req.body.id,
			req.body.new_data,
			{ new: true }
		);
		handleSuccess(res, message);
	} catch (err) {
		handleServerError(res, err);
	}
};

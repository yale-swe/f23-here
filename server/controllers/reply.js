import MessageModel from "../models/Message.js";
import ReplyModel from "../models/Reply.js";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
} from "../utils/handlers.js";

// Reply to a message
export const replyToMessage = async (req, res) => {
	try {
		const message = await MessageModel.findById(req.body.message_id);
		if (!message) {
			return handleNotFound(res, "Parent message not found");
		}
		const reply = new ReplyModel({
			parent_message: req.body.message_id,
			content: req.body.content,
		});
		const saved_reply = await reply.save();

		message.replies.push(saved_reply._id);
		await message.save();
		handleSuccess(res, saved_reply);
	} catch (err) {
		handleServerError(res, err);
	}
};

// changes value of like field in ReplySchema to true.
export const likeReply = async (req, res) => {
	try {
		const reply = await ReplyModel.findById(req.body.reply_id);
		if (!reply) {
			return handleNotFound(res, "Reply not found");
		}

		reply.likes += 1;
		const updated_reply = await reply.save();
		handleSuccess(res, updated_reply);
	} catch (err) {
		handleServerError(res, err);
	}
};

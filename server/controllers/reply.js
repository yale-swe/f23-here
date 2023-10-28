import ReplyModel from "../models/Reply.js";
import { handleServerError, handleSuccess } from '../utils/handlers.js';

// Reply to a message
export const reply_to_message = async (req, res) => {
    try {
        const reply = await ReplyModel.create({
            parent_message: req.body.message_id,
            content: req.body.content,
        }).exec();
        handleSuccess(res, reply);
    } catch (err) {
        handleServerError(res, err);
    }
};

// changes value of like field in ReplySchema to true.
export const like_reply = async (req, res) => {
    try {
        const reply = await ReplyModel.findByIdAndUpdate(req.body._id, {likes: true}, {new: true}).exec();
        handleSuccess(res, reply);
    } catch (err) {
        handleServerError(res, err);
    }
};


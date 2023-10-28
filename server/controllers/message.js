import MessageModel from "../models/Message.js";
import UserModel from "../models/User.js";
import { handleNotFound, handleServerError, handleSuccess } from '../utils/handlers.js';

// Post message
export const post_message = async (req, res) => {
    try {
        const user = await UserModel.findById(req.body.user_id);
        if (!user) {
            return handleNotFound(res, "User posting this message is not found");
        }
        const message = new MessageModel({
            user_id: req.body.user_id,
            text: req.body.text,
            visibility: req.body.visibility,
            location: req.body.location,
        });
        const saved_message = await message.save();

        // Add to user
        user.messages.push(saved_message._id);
        await user.save();

        handleSuccess(res, saved_message);

    } catch (err) {
        handleServerError(res, err);
    }
};

// Delete message
export const delete_message = async (req, res) => {
    try {
        const user = await UserModel.findById(req.body.user_id);
        const delete_res = await MessageModel.findByIdAndDelete(req.body.id).exec();

        // Delete from user
        if (user) {
            console.log("deleting");
            user.messages.remove(req.body.id);
            await user.save();
        }
        handleSuccess(res, delete_res);

    } catch (err) {
        handleServerError(res, err);
    }
};

// Like a message (increments by 1)
export const increment_likes = async (req, res) => {
    try {
        const message = await MessageModel.findByIdAndUpdate(req.body.id, {$inc: {likes: 1}}, {new: true}).exec();
        handleSuccess(res, message);
    } catch (err) {
        handleServerError(res, err);
    }
};

// Change message visibility
export const change_visibility = async (req, res) => {
    try {
        // pass visibility value through new_data field in req
        const message = await MessageModel.findByIdAndUpdate(req.body.id, req.body.new_data, { new: true }).exec();
        handleSuccess(res, message);
    } catch (err) {
        handleServerError(res, err);
    }
};


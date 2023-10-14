const MessageModel = require('../models/Message.js');
import { handleServerError, handleSuccess } from '../utils/handlers.js';

// Post message
export const post_message = async (req, res) => {
    try {
        const message = await MessageModel.create({
            id: req.body.id,
            user_id: req.body.user_id,
            text: req.body.text,
            visibility: req.body.visibility,
        }).exec();
        handleSuccess(res, message);
    } catch (err) {
        handleServerError(res, err);
    }
};

// Delete message
export const delete_message = async (req, res) => {
    try {
        const delete_res = await MessageModel.findByIdAndDelete(req.body.id).exec();
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


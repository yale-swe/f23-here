/**
 * Message Model Schema
 *
 * Defines the Mongoose schema for user messages in the application. It includes fields for user ID,
 * message text, likes, location, visibility, and replies. Integrates with the Reply model for managing message replies.
 */

import mongoose from "mongoose";
const { Schema } = mongoose;

export const MessageSchema = new Schema({
	user_id: {
		type: Schema.Types.ObjectId,
		required: true,
	},
	text: {
		type: String,
		required: [true, "Please enter the content of the message"],
	},
	likes: {
		type: Number,
		default: 0,
	},
	location: {
		type: {
			type: String,
			enum: ["Point"],
			required: true,
		},
		coordinates: {
			type: [Number],
			required: true,
		},
	},
	visibility: {
		type: String,
		enum: ["friends", "public"],
		default: "friends",
	},
	replies: [
		{
			type: mongoose.Schema.Types.ObjectId,
			ref: "Reply",
			default: [],
		},
	],
});

const MessageModel = mongoose.model("Message", MessageSchema);
export default MessageModel;

/**
 * Reply Model Schema
 *
 * This schema defines the structure for replies within the application.
 * Each reply is linked to a parent message and includes content and likes.
 */

import mongoose, { mongo } from "mongoose";
const { Schema } = mongoose;

export const ReplySchema = new Schema({
	parent_message: {
		type: Schema.Types.ObjectId,
		required: true,
	},
	content: {
		type: String,
		required: true,
	},
	likes: {
		type: Number,
		default: 0,
	},
});

const ReplyModel = mongoose.model("Reply", ReplySchema);
export default ReplyModel;

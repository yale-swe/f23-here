// Data model schema for User
import mongoose from "mongoose";
import { MessageSchema } from "./Message.js";

const { Schema } = mongoose;

export const UserSchema = new Schema({
	id: {
		type: Schema.Types.UUID,
		required: true,
		unique: true,
	},
	userName: {
		type: String,
		required: true,
	},
	firstName: {
		type: String,
		required: true,
	},
	lastName: {
		type: String,
		required: true,
	},
	messages: [MessageSchema],
	friends: [UserSchema],
	notifyFriends: Boolean,
	email: {
		type: String,
		required: [true, "Please enter a valid email"],
	},
	password: {
		type: String,
		required: [true, "Please enter a valid password"],
	},
	avatar: {
		type: String,
		default: "no-photo.jpg",
	},
});

export const UserModel = mongoose.model("User", UserSchema);

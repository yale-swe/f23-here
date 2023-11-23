// Data model schema for User
import mongoose from "mongoose";
import { MessageSchema } from "./Message.js";

const { Schema } = mongoose;

export const UserSchema = new Schema({
	userName: {
		type: String,
		required: true,
		unique: true,
	},
	firstName: {
		type: String,
		required: true,
	},
	lastName: {
		type: String,
		required: true,
	},
	messages: [
		{
			type: mongoose.Schema.Types.ObjectId,
			ref: "Message",
			default: [],
		},
	],
	friends: {
		type: Map,
		of: String,
		ref: "User",
		default: {},
	},
	notifyFriends: {
		type: Boolean,
		default: true,
	},
	email: {
		type: String,
		required: [true, "Please enter a valid email"],
		unique: true,
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

const UserModel = mongoose.model("User", UserSchema);
export default UserModel;

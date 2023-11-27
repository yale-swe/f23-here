/**
 * User Model Schema
 *
 * Defines the Mongoose schema for users in the application. It includes fields for personal details (username, first name,
 * last name), contact information (email), authentication (password), and references to related data like messages and friends.
 * Enforces uniqueness on usernames and emails, and maintains a list of message IDs and a map of friends for each user.
 */
import mongoose from "mongoose";

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

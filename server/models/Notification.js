/**
 * Notification Model Schema
 *
 * Defines the Mongoose schema for user message notification in the application. It includes fields for user ID 
 * (who posted the original message),
 * message text (of the original message), 
 * notification text,
 * and the location of the original message
 */

import mongoose from "mongoose";
const { Schema } = mongoose;

export const NotificationSchema = new Schema({
	user_id: {
		type: Schema.Types.ObjectId,
		required: true,
	},
	message_text: {
		type: String,
		required: [true, "Please enter the content of the message"],
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
	notification_text: {
        type: String,
		required: [true, "Please enter the content of the notification"],
    }
});

const NotificationModel = mongoose.model("Notification", NotificationSchema);
export default NotificationModel;

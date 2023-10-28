// Data model schema for Message
import mongoose from "mongoose";
import { ReplySchema } from "./Reply.js";
const { Schema } = mongoose;

export const MessageSchema = new Schema({
    id: {
        type: Schema.Types.UUID,
        required: true,
        unique: true,
    },
    user_id: {
        type: Schema.Types.UUID,
        required: true,
    },
    text: {
        type: String,
        required: [true, "Please enter the content of the message"]
    },
    likes: {
        type: Number,
        default: 0,
    },
    location: {
        type: {
          type: String, 
          enum: ['Point'],
          required: true
        },
        coordinates: {
          type: [Number],
          required: true
        }
    },
    visibility: {
        type: String,
        enum : ['friends','public'],
        default: 'friends'
    },
    replies: [ReplySchema],
});

const MessageModel = mongoose.model("Message", MessageSchema);
export default MessageModel;

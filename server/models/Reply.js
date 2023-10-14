// Data model schema for Replies
import mongoose, { mongo } from "mongoose";
const { Schema } = mongoose;

export const ReplySchema = new Schema({
    parent_message: {
        type: Schema.Types.UUID,
        required: true,
    },
    content: {
        type: String,
        required: true,
    },
    likes: {
        type: Number,
        default: true,
    },
});

export const ReplyModel = mongoose.model("Reply", ReplySchema);

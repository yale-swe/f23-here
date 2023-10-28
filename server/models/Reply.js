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
        default: false,
    },
});

const ReplyModel = mongoose.model("Reply", ReplySchema);
export default ReplyModel;

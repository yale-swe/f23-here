import mongoose from "mongoose";
import dotenv from "dotenv";

// run and set env variables
dotenv.config();

export const connectDB = async () => {
    const conn = await mongoose.connect(process.env.MONGO_URL, {
		useNewUrlParser: true,
		useUnifiedTopology: true,
	});
    console.log(`MongoDb Connected: ${conn.connection.host}`);
}

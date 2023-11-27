/**
 * MongoDB Database Connection
 *
 * A module for establishing a connection to a MongoDB database using Mongoose.
 * It uses environment variables to configure the connection.
 *
 */

import mongoose from "mongoose";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

/**
 * Establishes a connection to the MongoDB database using Mongoose.
 *
 * @function connectDB
 * @memberof module:db/connection
 * @returns {Promise<void>} - A Promise that resolves when the database connection is established.
 * @throws {Error} - If an error occurs during the database connection.
 */
export const connectDB = async () => {
	const conn = await mongoose.connect(process.env.MONGO_URL, {
		useNewUrlParser: true,
		useUnifiedTopology: true,
	});
	console.log(`MongoDb Connected: ${conn.connection.host}`);
};

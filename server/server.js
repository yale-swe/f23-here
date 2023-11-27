/**
 * Express.js Application
 *
 * A Node.js application built with Express.js for handling various API routes and middleware.
 * It includes routes for user authentication, messaging, replies, and user profiles.
 *
 * @module app
 */

import express from "express";
import helmet from "helmet";
import morgan from "morgan";
import dotenv from "dotenv";
import cors from "cors";
import { connectDB } from "./db.js";
import authRoutes from "./routes/auth.js";
import messageRoutes from "./routes/message.js";
import replyRoutes from "./routes/reply.js";
import userRoutes from "./routes/user.js";

// Load environment variables from .env file
dotenv.config();
const app = express();
const PORT = process.env.PORT || 6001;

// API Key middleware
const apiKeyAuth = (req, res, next) => {
	const userApiKey = req.get("X-API-Key");
	if (!userApiKey) {
		return res.status(401).json({ error: "API key is required" });
	}
	if (userApiKey !== process.env.API_KEY) {
		return res.status(403).json({ error: "Invalid API key" });
	}
	next();
};

// Apply the API Key middleware globally
app.use(apiKeyAuth);

// Connect to DB
connectDB();

app.use(express.json());
app.use(morgan("common"));
app.use(
	cors({
		origin: "*",
	})
);
app.use(helmet());
app.use(helmet.crossOriginResourcePolicy({ policy: "cross-origin" }));

// Base Routes
app.use("/auth", authRoutes);
app.use("/message", messageRoutes);
app.use("/reply", replyRoutes);
app.use("/user", userRoutes);

const server = app.listen(PORT, console.log(`Server running on port ${PORT}`));

// Handle unhandled promise rejections
process.on("unhandledRejection", (err, promise) => {
	console.log(`Error: ${err.message}`);
	server.close(() => process.exit(1));
});

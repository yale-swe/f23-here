import express from "express";
import helmet from "helmet";
import morgan from "morgan";
import dotenv from "dotenv";
import cors from "cors";
import { connectDB } from "./db.js";

// run and set env variables
dotenv.config();
const app = express();
const PORT = process.env.PORT || 6001;

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

const server = app.listen(
	PORT,
	console.log(`Server running on port ${PORT}`)
);

// Handle unhandled promise rejections
process.on("unhandledRejection", (err, promise) => {
	console.log(`Error: ${err.message}`);
	server.close(() => process.exit(1));
});

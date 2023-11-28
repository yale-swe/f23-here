/**
 * Authentication Controller
 *
 * This file serves as the Authentication Controller, handling user registration and login processes.
 * It includes functions to register new users and authenticate existing users, ensuring secure handling of user credentials.
 * The controller relies on bcrypt for password hashing and comparison, ensuring security best practices.
 *
 * Dependencies:
 *  - UserModel: Utilized for database interactions with the user collection. Essential for retrieving and storing user data during registration and login.
 *  - bcrypt: A library for hashing and comparing passwords, used to securely manage user passwords.
 *   - Handlers (handleServerError, handleSuccess, handleNotFound): These utility functions
 * 		are used for consistent handling of HTTP responses across different scenarios such as success, server errors, or resource not found errors.
 */

import UserModel from "../models/User.js";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
	handleBadRequest,
} from "../utils/handlers.js";
import bcrypt from "bcrypt";

/**
 * Registers a new user.
 *
 * Accepts user details from the request, hashes the password, and creates a new user record.
 * On success, returns the created user, excluding the password.
 * On error, handles server errors appropriately.
 *
 * @param {Object} req - The request object containing user data.
 * @param {Object} res - The response object used to reply to the client.
 */
export const register = async (req, res) => {
	try {
		const { userName, password, email, firstName, lastName } = req.body;

		const salt = await bcrypt.genSalt(10); // Generate a salt for password hashing
		const passwordHash = await bcrypt.hash(password, salt); // Hash the password

		// Create a new user with the hashed password
		const newUser = new UserModel({
			userName,
			firstName,
			lastName,
			email: email.toLowerCase(),
			password: passwordHash,
		});

		// Save the user to the database
		const savedUser = await newUser.save();
		handleSuccess(res, savedUser);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Handles user login.
 *
 * Returns the user's details (excluding the password)
 * on successful login if the input credentials match against the stored credentials.
 * If the user is not found or the password does not match, it sends an appropriate error response.
 *
 * @param {Object} req - The request object containing the login credentials.
 * @param {Object} res - The response object used to reply to the client.
 */
export const login = async (req, res) => {
	try {
		const { inputLogin, password } = req.body;

		// Find the user by email or username
		const user = await UserModel.findOne({
			$or: [{ email: inputLogin }, { userName: inputLogin }],
		});

		// If the user is not found, return an error
		if (!user) {
			return handleNotFound(res, "User not found");
		}

		// Compare the input password with the stored password
		const isMatch = await bcrypt.compare(password, user.password);
		if (!isMatch) {
			return handleBadRequest(
				res,
				"Incorrect login information. Please try again."
			);
		}

		// If the passwords match, return the user details
		delete user.password;
		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

import User from "../models/User.js";
import { handleServerError, handleSuccess } from "../utils/handlers.js";

export const register = async (req, res) => {
	try {
		const { userName, password, email, firstName, lastName } = req.body;

		const salt = await bcrypt.genSalt(10);
		const passwordHash = await bcrypt.hash(password, salt);

		const newUser = new User({
			userName,
			firstName,
			lastName,
			email,
			password: passwordHash,
		});

		const savedUser = await newUser.save();
		handleSuccess(res, savedUser);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const login = async (req, res) => {
	try {
		const { inputLogin, password } = req.body;

		const user = await User.findOne({
			$or: [{ email: inputLogin }, { username: inputLogin }],
		});

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		const isMatch = await bcrypt.compare(password, user.password);
		if (!isMatch) {
			return handleBadRequest(
				res,
				"Incorrect login information. Please try again."
			);
		}

		delete user.password;
		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const updateUserProfile = async (req, res) => {
	try {
		const userId = req.params.id;
		const { userName, password, firstName, lastName, email, avatar } =
			req.body;

		const user = await User.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found.");
		}

		if (userName) user.userName = userName;
		if (firstName) user.firstName = firstName;
		if (lastName) user.lastName = lastName;
		if (email) user.email = email;
		if (email) user.avatar = avatar;

		if (password) {
			const salt = await bcrypt.genSalt(10);
			user.password = await bcrypt.hash(password, salt);
		}

		await user.save();

		handleSuccess(res, {
			message: "User profile updated successfully.",
			user,
		});
	} catch (err) {
		handleServerError(res, err);
	}
};

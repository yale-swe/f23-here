import UserModel from "../models/User.js";
import { handleServerError, handleSuccess } from "../utils/handlers.js";

export const register = async (req, res) => {
	try {
		const { userName, password, email, firstName, lastName } = req.body;

		const salt = await bcrypt.genSalt(10);
		const passwordHash = await bcrypt.hash(password, salt);

		const newUser = new UserModel({
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

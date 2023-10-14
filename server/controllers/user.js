import User from "../models/User.js";
import { handleBadRequest } from "../utils/handlers.js";

export const getUserById = async (req, res) => {
	try {
		const user = await User.findById(req.params.userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const getUserByEmailOrUsername = async (req, res) => {
	try {
		const { emailOrUsername } = req.params;

		const user = await User.findOne({
			$or: [{ email: emailOrUsername }, { userName: emailOrUsername }],
		});

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const getUserFriends = async (req, res) => {
	try {
		const userId = req.params.userId;
		const user = await User.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user.friends);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const addUserFriend = async (req, res) => {
	const { userId } = req.params;
	const { friendId } = req.body;

	try {
		if (userId == friendId) {
			return handleBadRequest(res, "You can't friend yourself!");
		}

		const user = await User.findById(userId);
		const friend = await User.findById(friendId);

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		if (user.friends.includes(friendId)) {
			return handleBadRequest(
				res,
				"Friend is already in user's friend list"
			);
		}

		user.friends.push(friendId);
		friend.friends.push(userId);
		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend added successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

export const removeUserFriend = async (req, res) => {
	const { userId } = req.params;
	const { friendId } = req.body;

	try {
		const user = await User.findById(userId);
		const friend = await User.findById(friendId);

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		if (!user.friends.includes(friendId)) {
			return handleBadRequest(res, "Friend is not in user's friend list");
		}

		user.friends.remove(friendId);
		friend.friends.remove(userId);
		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend removed successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

export const getUserMessages = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await User.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user.messages);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const deleteUser = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await User.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		await user.remove();

		handleSuccess(res, { message: "User successfully deleted" });
	} catch (err) {
		handleServerError(res, err);
	}
};

export const toggleNotifyFriends = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await User.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		user.notifyFriends = !user.notifyFriends;
		await user.save();
		handleSuccess(res, { notifyFriends: user.notifyFriends });
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

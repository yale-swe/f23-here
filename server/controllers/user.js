import UserModel from "../models/User.js";
import bcrypt from "bcrypt";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
	handleBadRequest,
} from "../utils/handlers.js";
import MessageModel from "../models/Message.js";
import ReplyModel from "../models/Reply.js";

export const getUserById = async (req, res) => {
	try {
		const user = await UserModel.findById(req.params.userId);

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
		const { email, userName } = req.body;

		const user = await UserModel.findOne({
			$or: [
				{ email: { $regex: new RegExp(`^${email}$`, "i") } },
				{ userName: userName },
			],
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
		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user.friends);
	} catch (err) {
		handleServerError(res, err);
	}
};

export const addUserFriendById = async (req, res) => {
	const { userId } = req.params;
	const { friendId } = req.body;

	try {
		if (userId == friendId) {
			return handleBadRequest(res, "You can't friend yourself!");
		}

		const user = await UserModel.findById(userId);
		const friend = await UserModel.findById(friendId);

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		if (user.friends.has(friendId)) {
			return handleBadRequest(
				res,
				"Friend is already in user's friend list"
			);
		}

		user.friends.set(friendId, friend.userName);
		friend.friends.set(userId, user.userName);
		
		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend added successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

export const addUserFriendByName = async (req, res) => {
	const { userId } = req.params;
	const { friendName } = req.body;

	try {
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findOne({ userName: friendName });

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		} else if (friend._id == user._id) {
			return handleBadRequest(res, "You can't friend yourself!");
		}

		if (user.friends.has(friend._id.toString())) {
			return handleBadRequest(
				res,
				"Friend is already in user's friend list"
			);
		}

		user.friends.set(friend._id.toString(), friend.userName);
		friend.friends.set(userId, user.userName);

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
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findById(friendId);

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		if (!user.friends.has(friendId)) {
			return handleBadRequest(res, "Friend is not in user's friend list");
		}

		user.friends.delete(friendId);
		friend.friends.delete(userId);
		await user.save();
		await friend.save();
		handleSuccess(res, { message: "Friend removed successfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

export const removeUserFriendByName = async (req, res) => {
	const { userId } = req.params;
	const { friendName } = req.body;

	try {
		const user = await UserModel.findById(userId);
		const friend = await UserModel.findOne({ userName: friendName });

		if (!user) {
			return handleNotFound(res, "User not found");
		} else if (!friend) {
			return handleNotFound(res, "Friend not found");
		}

		if (!user.friends.has(friend._id.toString())) {
			return handleBadRequest(res, "Friend is not in user's friend list");
		}

		user.friends.remove(friend._id.toString());
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

		const user = await UserModel.findById(userId).populate({
			path: "messages",
			model: MessageModel,
			populate: {
				path: "replies",
				model: ReplyModel,
			},
		});

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

		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		await MessageModel.deleteMany({ _id: { $in: user.messages } });
		await UserModel.findByIdAndDelete(userId);

		handleSuccess(res, {
			message: "User and their messages successfully deleted",
		});
	} catch (err) {
		handleServerError(res, err);
	}
};

export const toggleNotifyFriends = async (req, res) => {
	try {
		const { userId } = req.params;

		const user = await UserModel.findById(userId);

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
		const userId = req.params.userId;
		const { userName, password, firstName, lastName, email, avatar } =
			req.body;

		const user = await UserModel.findById(userId);

		if (!user) {
			return handleNotFound(res, "User not found.");
		}

		if (userName) user.userName = userName;
		if (firstName) user.firstName = firstName;
		if (lastName) user.lastName = lastName;
		if (email) user.email = email;
		if (avatar) user.avatar = avatar;

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

/**
 * Metrics Controller
 *
 * This file serves as the controller for metrics-related operations in the API.
 * It includes functionalities for managing metrics records such as creating new records,
 * incrementing click counts, and retrieving metrics data by name.
 *
 * Dependencies:
 *  - MetricsModel: The Mongoose model used for metrics data interactions with the MongoDB database.
 *  - Handlers: Utility functions for handling various HTTP response scenarios, such as server errors,
 *    successful responses, and resource not found errors.
 */

import MetricsModel from "../models/Metrics.js";
import {
	handleServerError,
	handleSuccess,
	handleNotFound,
} from "../utils/handlers.js";

/**
 * Creates a new metrics record.
 *
 * Initializes a new metrics record with default clicks (0) and a specified total_distribution from the request body.
 *
 * @param {Object} req - The request object containing the total_distribution value.
 * @param {Object} res - The response object to send back the created metrics data or an error message.
 */
export const createMetrics = async (req, res) => {
	try {
		const { total_distribution = 50, metrics_name } = req.body;

		const metrics = new MetricsModel({
			clicks: 0,
			total_distribution,
			metrics_name,
		});

		await metrics.save();
		handleSuccess(res, metrics);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Increments the click counter of a metrics record.
 *
 * Accepts a metrics name from the request body and increments its clicks counter by 1.
 *
 * @param {Object} req - Request object containing the metricsName in the body.
 * @param {Object} res - Response object to send back the updated metrics data or an error message.
 */
export const incrementClicks = async (req, res) => {
	try {
		const { metrics_name } = req.body;
		console.log(metrics_name);
		const metrics = await MetricsModel.findOneAndUpdate(
			{ metrics_name: metrics_name },
			{ $inc: { clicks: 1 } },
			{ new: true }
		);

		if (!metrics) {
			return handleNotFound(res, "Metrics record not found");
		}

		handleSuccess(res, { message: "Metrics incremented sucessfully" });
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Retrieves a metrics record by its name.
 *
 * Fetches a metrics record from the database using its name.
 *
 * @param {Object} req - Request object containing the metricsName in the body.
 * @param {Object} res - Response object to return the metrics data or an error message.
 */
export const getMetricsByName = async (req, res) => {
	try {
		const { metrics_name } = req.body;
		const metrics = await MetricsModel.findOne({
			metrics_name: metrics_name,
		});

		if (!metrics) {
			return handleNotFound(res, "Metrics record not found");
		}

		handleSuccess(res, metrics);
	} catch (err) {
		handleServerError(res, err);
	}
};

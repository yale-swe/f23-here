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
	handleBadRequest,
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
		const { total_distribution = 50, metricsName } = req.body;

		const metrics = new MetricsModel({
			clicks: 0,
			total_distribution,
			metrics_name: metricsName,
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
		const { metricsName } = req.body;
		const metrics = await MetricsModel.findOneAndUpdate(
			{ metrics_name: metricsName },
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
		const { metricsName } = req.body;
		const metrics = await MetricsModel.findOne({
			metrics_name: metricsName,
		});

		if (!metrics) {
			return handleNotFound(res, "Metrics record not found");
		}

		handleSuccess(res, metrics);
	} catch (err) {
		handleServerError(res, err);
	}
};

/**
 * Updates the total distribution of a specified metrics record.
 *
 * Accepts a metrics name and a new total distribution value from the request body
 * and updates the corresponding metrics record in the database.
 *
 * @param {Object} req - Request object containing the metricsName and newTotalDistribution in the body.
 * @param {Object} res - Response object to send back a confirmation message or an error message.
 */
export const updateTotalDistribution = async (req, res) => {
	try {
		const { metricsName, newTotalDistribution } = req.body;

		// Checking if newTotalDistribution is a valid number
		if (typeof newTotalDistribution !== "number") {
			handleBadRequest(res, "Invalid total distribution value");
			return;
		}
		const updatedMetrics = await MetricsModel.findOneAndUpdate(
			{ metrics_name: metricsName },
			{ $set: { total_distribution: newTotalDistribution } },
			{ new: true }
		);

		if (!updatedMetrics) {
			return handleNotFound(res, "Metrics record not found");
		}

		handleSuccess(res, {
			message: `Metrics total distribution updated successfully to ${newTotalDistribution}`,
		});
	} catch (err) {
		handleServerError(res, err);
	}
};

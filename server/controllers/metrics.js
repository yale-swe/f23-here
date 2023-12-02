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
		const totalDistribution = req.body.total_distribution || 50; // Default to 50 if not provided
		const metrics = new MetricsModel({
			clicks: 0,
			total_distribution: totalDistribution,
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

		handleSuccess(res, metrics);
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

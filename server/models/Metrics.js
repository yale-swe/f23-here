/**
 * Metrics Model Schema
 *
 * Defines the Mongoose schema for metrics records in the application. It includes fields for metrics name,
 * click count, and total distribution. The metrics name is unique for each record, ensuring no duplicates.
 * The schema is used to for A/B testing of the application.
 *
 * Schema Fields:
 *  - metrics_name: Unique name identifier for the metrics record.
 *  - clicks: Count of clicks, used for tracking user interactions.
 *  - total_distribution: Represents the distribution value, defaulting to 50.
 *
 */

import mongoose from "mongoose";
const { Schema } = mongoose;

export const MetricsSchema = new Schema({
	clicks: {
		type: Number,
		default: 0,
	},
	total_distribution: {
		type: Number,
		default: 50,
	},
	metrics_name: {
		type: String,
		required: true,
		unique: true,
	},
});

const MetricsModel = mongoose.model("Metrics", MetricsSchema);
export default MetricsModel;

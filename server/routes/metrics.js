/**
 * Metrics Routes
 *
 * Express routes for operations related to metrics records. Includes routes for
 * creating, incrementing the click count of a metric, and retrieving metric data by name.
 * The request handling is delegated to the metrics controller.
 *
 * Routes:
 *  - POST /create-metrics: Handles the creation of a new metrics record.
 *  - POST /increment-clicks: Handles incrementing the click count of a metric.
 *  - POST /get-metrics: Retrieves a metrics record by its name.
 */

import express from "express";
import {
	createMetrics,
	incrementClicks,
	getMetricsByName,
} from "../controllers/metrics.js";

const router = express.Router();

router.post("/create-metrics", createMetrics);

router.post("/increment-clicks", incrementClicks);

router.post("/get-metrics", getMetricsByName);

export default router;

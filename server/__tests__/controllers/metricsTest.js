import { jest } from "@jest/globals";
import {
	createMetrics,
	incrementClicks,
	getMetricsByName,
	updateTotalDistribution,
} from "../../controllers/metrics.js";
import MetricsModel from "../../models/Metrics.js";
import httpMocks from "node-mocks-http";

jest.mock("../../models/Metrics");

describe("createMetrics", () => {
	it("should successfully create a metrics record", async () => {
		const mockMetricsData = {
			clicks: 0,
			total_distribution: 50,
			metrics_name: "TestMetric",
		};
		MetricsModel.prototype.save = jest.fn().mockImplementation(function () {
			return { ...mockMetricsData, _id: this._id };
		});

		const req = httpMocks.createRequest({
			body: { total_distribution: 50, metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await createMetrics(req, res);

		const responseData = JSON.parse(res._getData());

		expect(MetricsModel.prototype.save).toHaveBeenCalled();
		expect(res.statusCode).toBe(200);
		expect(responseData).toMatchObject(mockMetricsData);
		expect(responseData).toHaveProperty("_id");
	});

	it("should return 500 on server errors", async () => {
		MetricsModel.prototype.save = jest.fn().mockImplementation(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { total_distribution: 50, metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await createMetrics(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("incrementClicks", () => {
	it("should successfully increment the clicks of a metrics record", async () => {
		const mockMetricsData = {
			_id: "someMetricsId",
			metrics_name: "TestMetric",
			clicks: 1,
		};
		MetricsModel.findOneAndUpdate = jest
			.fn()
			.mockResolvedValue(mockMetricsData);

		const req = httpMocks.createRequest({
			body: { metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await incrementClicks(req, res);

		expect(MetricsModel.findOneAndUpdate).toHaveBeenCalledWith(
			{ metrics_name: "TestMetric" },
			{ $inc: { clicks: 1 } },
			{ new: true }
		);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: "Metrics incremented sucessfully",
		});
	});
	it("should return 404 if the metrics record is not found", async () => {
		MetricsModel.findOneAndUpdate = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { metricsName: "NonexistentMetric" },
		});
		const res = httpMocks.createResponse();

		await incrementClicks(req, res);

		expect(MetricsModel.findOneAndUpdate).toHaveBeenCalledWith(
			{ metrics_name: "NonexistentMetric" },
			{ $inc: { clicks: 1 } },
			{ new: true }
		);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Metrics record not found");
	});
	it("should handle server errors", async () => {
		MetricsModel.findOneAndUpdate.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await incrementClicks(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("getMetricsByName", () => {
	it("should successfully retrieve a metrics record by name", async () => {
		const mockMetricsData = {
			_id: "someMetricsId",
			metrics_name: "TestMetric",
			clicks: 10,
			total_distribution: 50,
		};
		MetricsModel.findOne = jest.fn().mockResolvedValue(mockMetricsData);

		const req = httpMocks.createRequest({
			body: { metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await getMetricsByName(req, res);

		expect(MetricsModel.findOne).toHaveBeenCalledWith({
			metrics_name: "TestMetric",
		});
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual(mockMetricsData);
	});

	it("should return 404 if the metrics record is not found", async () => {
		MetricsModel.findOne = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: { metricsName: "NonexistentMetric" },
		});
		const res = httpMocks.createResponse();

		await getMetricsByName(req, res);

		expect(MetricsModel.findOne).toHaveBeenCalledWith({
			metrics_name: "NonexistentMetric",
		});
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Metrics record not found");
	});

	it("should handle server errors", async () => {
		MetricsModel.findOne.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { metricsName: "TestMetric" },
		});
		const res = httpMocks.createResponse();

		await getMetricsByName(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

describe("updateTotalDistribution", () => {
	it("should successfully update the total distribution of a metrics record", async () => {
		let newTotalDistribution = 500;

		const mockMetricsData = {
			_id: "someMetricsId",
			metrics_name: "TestMetric",
			total_distribution: 100,
		};

		MetricsModel.findOneAndUpdate = jest
			.fn()
			.mockResolvedValue(mockMetricsData);

		const req = httpMocks.createRequest({
			body: {
				metricsName: "TestMetric",
				newTotalDistribution: newTotalDistribution,
			},
		});
		const res = httpMocks.createResponse();

		await updateTotalDistribution(req, res);

		expect(MetricsModel.findOneAndUpdate).toHaveBeenCalledWith(
			{ metrics_name: "TestMetric" },
			{ $set: { total_distribution: 500 } },
			{ new: true }
		);
		expect(res.statusCode).toBe(200);
		expect(JSON.parse(res._getData())).toEqual({
			message: `Metrics total distribution updated successfully to ${newTotalDistribution}`,
		});
	});

	it("should return 400 bad request when invalid total distribution value is provided", async () => {
		const req = httpMocks.createRequest({
			body: {
				metricsName: "TestMetric",
				newTotalDistribution: "invalid",
			},
		});

		const res = httpMocks.createResponse();

		await updateTotalDistribution(req, res);
		expect(res.statusCode).toBe(400);
		expect(res._getData()).toContain("Invalid total distribution value");
	});

	it("should return 404 not found when metrics record is not found", async () => {
		MetricsModel.findOneAndUpdate = jest.fn().mockResolvedValue(null);

		const req = httpMocks.createRequest({
			body: {
				metricsName: "NonexistentMetric",
				newTotalDistribution: 100,
			},
		});
		const res = httpMocks.createResponse();

		await updateTotalDistribution(req, res);

		expect(MetricsModel.findOneAndUpdate).toHaveBeenCalledWith(
			{ metrics_name: "NonexistentMetric" },
			{ $set: { total_distribution: 100 } },
			{ new: true }
		);
		expect(res.statusCode).toBe(404);
		expect(res._getData()).toContain("Metrics record not found");
	});

	it("should handle server errors", async () => {
		MetricsModel.findOneAndUpdate.mockImplementationOnce(() => {
			throw new Error("Internal Server Error");
		});

		const req = httpMocks.createRequest({
			body: { metricsName: "TestMetric", newTotalDistribution: 100 },
		});
		const res = httpMocks.createResponse();

		await updateTotalDistribution(req, res);

		expect(res.statusCode).toBe(500);
		expect(res._getData()).toContain("Internal Server Error");
	});
});

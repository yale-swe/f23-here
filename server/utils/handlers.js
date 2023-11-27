/**
 * Express Response Handlers
 *
 * Utility functions for handling different types of HTTP responses in an Express.js application.
 * These functions provide consistent ways to send responses with appropriate status codes and data/messages.
 *
 */

/**
 * Sends a successful response with a status code of 200 and JSON data.
 *
 * @param {Object} res - Express response object.
 * @param {Object} data - Data to include in the response.
 * @returns {Object} - The Express response object.
 */
export const handleSuccess = (res, data) => {
	return res.status(200).json(data);
};

/**
 * Sends a response for a bad request with a status code of 400 and a custom error message.
 *
 * @param {Object} res - Express response object.
 * @param {string} message - Custom error message.
 * @returns {Object} - The Express response object.
 */
export const handleBadRequest = (res, message) => {
	return res.status(400).json({ message: message });
};

/**
 * Sends a response for a server error with a status code of 500 and an error message.
 *
 * @param {Object} res - Express response object.
 * @param {Error} err - Error object containing the error message.
 * @returns {Object} - The Express response object.
 */
export const handleServerError = (res, err) => {
	return res.status(500).json({ message: err.message });
};

/**
 * Sends a response for a resource not found with a status code of 404 and a custom error message.
 *
 * @param {Object} res - Express response object.
 * @param {string} message - Custom error message.
 * @returns {Object} - The Express response object.
 */
export const handleNotFound = (res, message) => {
	return res.status(404).json({ message: message });
};

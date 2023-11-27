/**
 * Authentication Routes
 *
 * Express routes for user authentication. Includes routes for user registration and login,
 * delegating the request handling to the authentication controller.
 *
 * Routes:
 *  - POST /register: Handles new user registration.
 *  - POST /login: Handles user login.
 */

import express from "express";
import { login, register } from "../controllers/auth.js";

const router = express.Router();

router.post("/register", register);
router.post("/login", login);

export default router;

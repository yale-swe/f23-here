import { jest } from "@jest/globals";
import {
	register,
    login
} from "../../controllers/auth.js";

import UserModel from "../../models/User.js";
import ReplyModel from "../../models/Reply.js";
import MessageModel from "../../models/Message.js";
import httpMocks from "node-mocks-http";
import bcrypt from "bcrypt";
jest.mock("../../models/User");
jest.mock("../../models/Reply");
jest.mock("../../models/Message");

const userId = "validUserId";
const mockUser = {
    _id: userId,
	userName: "JohnD",
	firstName: "John",
	lastName: "Doe",
	email: "john.doe@yale.edu",
	password: "here",
	avatar: "avatar.jpg",
};

describe("register", () => {
    it('should successfully register a new user', async () => {
        const mockUser = {
          _id: 'someUserId',
          userName: 'testUser',
          firstName: 'John',
          lastName: 'Doe',
          email: 'test@example.com',
          password: 'hashedPassword',
        };
    
        // Mock the bcrypt.genSalt and bcrypt.hash methods
        bcrypt.genSalt = jest.fn().mockResolvedValue('someSalt');
        bcrypt.hash = jest.fn().mockResolvedValue('hashedPassword');

        UserModel.prototype.save = jest.fn().mockResolvedValue(mockUser);
    
        const requestBody = {
          userName: 'testUser',
          password: 'password123',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        };
    
        const req = httpMocks.createRequest({
          method: 'POST',
          url: '/register',
          body: requestBody,
        });
    
        const res = httpMocks.createResponse();
    
        await register(req, res);
    
        // Check that the response status is 200
        expect(res.statusCode).toBe(200);
    
        // Check that the response data matches the expected user
        expect(JSON.parse(res._getData())).toEqual(mockUser);
    
        // Check that genSalt and hash were called
        expect(bcrypt.genSalt).toHaveBeenCalledWith(10);
        expect(bcrypt.hash).toHaveBeenCalledWith('password123', 'someSalt');
      });

      it('should return a 500 status code on registration error', async () => {
        const errorMessage = 'Error occurred';
        UserModel.prototype.save = jest.fn().mockRejectedValue(new Error(errorMessage)); // Simulate an error during registration
    
        const req = httpMocks.createRequest({
            body: {
            userName: 'testuser',
            password: 'password',
            email: 'test@example.com',
            firstName: 'John',
            lastName: 'Doe',
        },
    });
        const res = httpMocks.createResponse();
    
        await register(req, res);
    
        expect(res.statusCode).toBe(500); // Check that the status code is 500
        expect(res._getData()).toContain(errorMessage); // Check that the response contains the error message
    });
});

describe("login", () => {
    it('should successfully log in a user', async () => {
      const mockUser = {
        _id: 'someUserId',
        userName: 'testUser',
        email: 'test@example.com',
        password: await bcrypt.hash('password123', 10),
      };

      // Mock UserModel.findOne to return the mockUser
      UserModel.findOne = jest.fn().mockResolvedValue(mockUser);
  
      // Mock bcrypt.compare to always return true
      bcrypt.compare = jest.fn().mockResolvedValue(true);
  
      const requestBody = {
        inputLogin: 'test@example.com',
        password: 'password123',
      };
  
      const req = httpMocks.createRequest({
        method: 'POST',
        url: '/login',
        body: requestBody,
      });
  
      const res = httpMocks.createResponse();
  
      await login(req, res);
  
      // Check that the response status is 200
      expect(res.statusCode).toBe(200);
    });

    it('should handle user not found during login', async () => {
        // Mock UserModel.findOne to return null (user not found)
        UserModel.findOne = jest.fn().mockResolvedValue(null);

        const requestBody = {
            inputLogin: 'nonExistentUser',
            password: 'password123',
        };

        const req = httpMocks.createRequest({
            body: requestBody,
        });

        const res = httpMocks.createResponse();

        await login(req, res);

        // Check that the response status is 404
        expect(res.statusCode).toBe(404);

        // Check that handleNotFound was called
        expect(UserModel.findOne).toHaveBeenCalledWith({"$or": [{"email": "nonExistentUser"}, {"userName": "nonExistentUser"}]})
        });

    it('should handle incorrect password during login', async () => {
        const mockUser = {
            _id: 'someUserId',
            userName: 'testUser',
            email: 'test@example.com',
            password: await bcrypt.hash('password123', 10),
        };

        // Mock UserModel.findOne to return the mockUser
        UserModel.findOne = jest.fn().mockResolvedValue(mockUser);

        // Mock bcrypt.compare to return false (incorrect password)
        bcrypt.compare = jest.fn().mockResolvedValue(false);

        const requestBody = {
            inputLogin: 'test@example.com',
            password: 'incorrectPassword',
        };

        const req = httpMocks.createRequest({
            method: 'POST',
            url: '/login',
            body: requestBody,
        });

        const res = httpMocks.createResponse();

        await login(req, res);

        // Check that the response status is 400
        expect(res.statusCode).toBe(400);

        // Check that handleBadRequest was called
        expect(res._getData()).toContain(
            'Incorrect login information. Please try again.'
        );
    });

    it('should handle server error during login', async () => {
        // Mock UserModel.findOne to throw an error
        UserModel.findOne.mockImplementationOnce(() => {
            throw new Error("Internal Server Error");
        });
    
        const requestBody = {
          inputLogin: 'test@example.com',
          password: 'password123',
        };
    
        const req = httpMocks.createRequest({
          method: 'POST',
          url: '/login',
          body: requestBody,
        });
    
        const res = httpMocks.createResponse();
    
        await login(req, res);
    
        // Check that the response status is 500
        expect(res.statusCode).toBe(500);
    
        // Check that handleServerError was called
        expect(res._getData()).toContain("Internal Server Error");
      });

});
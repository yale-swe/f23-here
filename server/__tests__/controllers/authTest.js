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

      it('should handle server error during registration', async () => {

        // Mock the UserModel constructor to throw an error during save
        UserModel.findById = jest.fn().mockImplementationOnce(() => {
            throw new Error("Internal Server Error");
        });

        const req = httpMocks.createRequest({
            params: {userId: userId},
            body: {},
        });
        const res = httpMocks.createResponse();
    
        await register(req, res);
    
        // Check that the response status is 500
        expect(res.statusCode).toBe(500);
        // Check that the response data contains the error message
        expect(res._getData()).toContain("Internal Server Error");
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
  
      // Check that handleSuccess was called
      expect(res._getData()).toMatchObject(mockUser);
    });
});
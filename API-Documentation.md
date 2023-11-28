# API Documentation

This document outlines the API endpoints for the Here app, a location-based AR social app. The API is designed to facilitate the app's core functionalities including authentication message mangement, replies mangement, and user mangemenet.

For access to the API, please reach out to phuc.duong@yale.edu to request the `X-API-Key`, which is required for authentication and access control.

Our backend services are deployed on Vercel. The data is stored and managed with MongoDB Atlas.

Below you will find detailed descriptions of each endpoint, including the HTTP methods, request URLs, necessary parameters, expected request  and examples of use.

## Table of Contents

- [Base URL](#base-url)
- [Authentication Endpoints](#authentication-endpoints)
  - [Register](#register)
  - [Login](#login)
- [User Endpoints](#user-endpoints)
  - [Search User by Email or Username](#search-user-by-email-or-username)
  - [Get User by ID](#get-user-by-id)
  - [Get User Friends](#get-user-friends)
  - [Get User's Messages](#get-users-messages)
  - [Add User's Friend by ID](#add-users-friend-by-id)
  - [Add User's Friend by Name](#add-users-friend-by-name)
  - [Remove User's Friend by ID](#remove-users-friend-by-id)
  - [Remove User's Friend by Name](#remove-users-friend-by-name)
  - [Toggle Notify Friends](#toggle-notify-friends)
  - [Update User's Profile](#update-users-profile)
  - [Delete User](#delete-user)
- [Message Endpoints](#message-endpoints)
  - [Get All Messages](#get-all-messages)
  - [Post Message](#post-message)
  - [Delete Message](#delete-message)
  - [Increment Likes](#increment-likes)
  - [Change Visibility](#change-visibility)
- [Reply Endpoints](#reply-endpoints)
  - [Like Reply](#like-reply)
  - [Add Reply](#add-reply)



## Base URL

- **Base URL:** `https://here-swe.vercel.app/`

## Authentication Endpoints

### Register

Creates a new user account.

- **Endpoint:** `POST /auth/register`
- **Body:**

```json
{
  "userName": "JohnD",
  "firstName": "John",
  "lastName": "Doe",
  "email": "johndoe@yale.edu",
  "password": "secretpassword"
}
```

### Login

Authenticates a user and returns user data if successful.

- **Endpoint:** `POST /auth/login`
- **Body:**

```json
{
  "inputLogin": "JohnD",
  "password": "secretpassword"
}
```

## User Endpoints

### Search User by Email or Username

Search for a user by their email address or username. Do not need to include both.

- **Endpoint:** `GET /user/search`
- **Body:**

```json
{
  "email": "user@yale.edu",
  "userName": "JohnD"
}
```

### Get User by ID

Retrieve a user by their unique identifier.

- **Endpoint:** `GET /user/:userId`

### Get User Friends

Retrieve a list of friends for a user.

- **Endpoint:** `GET /user/:userId/friends`

### Get User's Messages

Retrieve messages for a user.

- **Endpoint:** `GET /user/:userId/messages`

### Add User's Friend by ID

Add a friend to a user's friend list by their user ID. This will also add the user to the friend's friend list.

- **Endpoint:** `PUT /user/:userId/friends`
- **Body:**
  ```json
  {
    "friendId": "friendUserId"
  }


### Add User's Friend by Name

Add a friend to a user's friend list by their username. This endpoint functions similarly to adding by ID, but uses the friend's username instead.

- **Endpoint:** `PUT /user/:userId/friends_name`
- **Body:**
  ```json
  {
    "friendName": "friendUserName"
  }

### Remove User's Friend by ID

Remove a friend from a user's friend list using the friend's user ID. This also removes the user from the friend's friend list.

- **Endpoint:** `DELETE /user/:userId/friends`
- **Body:**
  ```json
  {
    "friendId": "friendUserId"
  }

### Remove User's Friend by Name

Remove a friend from a user's friend list using the friend's username. Functions similarly to removing by ID, but targets the friend by their username.

- **Endpoint:** `DELETE /user/:userId/friends_name`
- **Body:**
  ```json
  {
    "friendName": "friendUserName"
  }


### Toggle Notify Friends

Toggle the notification setting for a user's friends.

- **Endpoint:** `PUT /user/:userId/toggle-notify-friends`

### Update User's Profile

Update a user's profile information.

- **Endpoint:** `PUT /user/:userId/update-profile`
- **Body:**

```json
{
  "userName": "newUserName",
  "password": "newPassword",
  "firstName": "newFirstName",
  "lastName": "newLastName",
  "email": "newEmail@yale.edu",
  "avatar": "urlToAvatar"
}
```

### Delete User

Delete a user and their associated messages.

- **Endpoint:** `DELETE /user/:userId`


## Message Endpoints

### Get All Messages

Gets all the messages in the database

- **Endpoint:** `GET /message/get_all_messages`

### Post Message

Allows a user to post a message.

- **Endpoint:** `POST /message/post_message`
- **Body:**

```json
{
  "user_id": "653d51478ff5b3c9ace45c26",
  "text": "Hi, this is a test message - Jane",
  "visibility": "friends",
  "location": {
    "type": "Point",
    "coordinates": [40.7128, -74.0060]
  }
}
```

### Delete Message

Allows a user to delete their message.

- **Endpoint:** `POST /message/delete_message`
- **Body:**

```json
{
  "messageId": "653d62a37ce9c61f28dcaa7f"
}
```

### Increment Likes

Increments the number of likes on a message.

- **Endpoint:** `POST /message/increment_likes`
- **Body:**

```json
{
  "id": "653d62de7ce9c61f28dcaa87"
}
```

### Change Visibility

Changes the visibility of a user's message.

- **Endpoint:** `POST /message/change_visibility`
- **Body:**

```json
{
  "id": "653d62de7ce9c61f28dcaa87",
  "new_visibility": "public"
}
```

## Reply Endpoints

### Like Reply

Increments the number of likes on a reply.

- **Endpoint:** `GET /reply/like_reply`
- **Body:**

```json
{
  "reply_id": "653d62de7ce9c61f28dcaa87"
}
```

### Add Reply

Add a reply to a message.

- **Endpoint:** `POST /reply/reply_to_message`
- **Body:**

```json
{
  "message_id": "653ea4a35b858b2542ea4f13",
  "content": "this is a test reply to a test message"
}
```
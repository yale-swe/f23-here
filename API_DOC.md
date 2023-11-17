# API Documentation

This document outlines the API endpoints for Here. Please contact phuc.duong@yale.edu for the X-API-Key.
Our backend is deployed on Vercel.

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

### Add User's Friend

Add a friend to a user's friend list. Will also add that user to the other user's friend list.

- **Endpoint:** `PUT /user/:userId/friends`
- **Body:**

```json
{
  "friendId": "friendUserId"
}
```

### Remove User's Friend

Remove a friend from a user's friend list.

- **Endpoint:** `DELETE /user/:userId/friends`
- **Body:**

```json
{
  "friendId": "friendUserId"
}
```

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
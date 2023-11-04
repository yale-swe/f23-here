Note that base url will change with deployment of backend.

# AUTH 
- REGISTER: POST "http://localhost:6000/auth/register"
    - params:
    {
        "userName": "JohnDED",
        "firstName": "John",
        "lastName": "Doe",
        "email": "johnDoE@yale.edu",
        "password": "secretpassword"
    }

- LOGIN: GET "http://localhost:6000/auth/login"
    - params:
    {
        "inputLogin": "JaneD",
        "password": "secretpassword"
    }

# MESSAGE
- POST MESSAGE: POST "http://localhost:6000/message/post_message"
    - params:
    {
        "user_id": "653d51478ff5b3c9ace45c26",
        "text": "Hi, this is a test message - Jane",
        "visibility": "friends",
        "location": {
            "type": "Point",
            "coordinates": [40.7128, -74.0060]
        }
    }

- DELETE MESSAGE: POST "http://localhost:6000/message/delete_message"
    - params:
    {
        "messageId": "653d62a37ce9c61f28dcaa7f"
    }

- INCREMENT LIKES: POST "http://localhost:6000/message/increment_likes"
    - params:
    {
        "id": "653d62de7ce9c61f28dcaa87"
    }

- CHANGE VISIBILITY: POST "http://localhost:6000/message/change_visibility"
    - params:
    {
        "id": "dsfsf",
        "new_data": ""
    }   

# REPLY
- ADD REPLY: POST "http://localhost:6000/reply/reply_to_message"
    - params:
    {
        "message_id": "653ea4a35b858b2542ea4f13",
        "content": "this is a test reply to a test message"
    }

- LIKE REPLY: GET "http://localhost:6000/reply/like_reply"
    - params:
    {
        "reply_id": "somekindofreplyid"
    }

# USER
- SEARCH USER BY USER_ID: GET "http://localhost:6000/user/search"
    - params:
    {
        "userId": ""
    }
- SEARCH USER BY EMAIL: GET "http://localhost:6000/user/search"
    - params:
    {
        "email": "janedoe@yale.edu"
    }

- SEARCH USER BY USERNAME: GET "http://localhost:6000/user/search"
    - params:
    {
        "userName": ""
    }

- ADD USER FRIEND: PUT "http://localhost:6000/user/userid"
    - params:
    {
        "friendId": "friend's id"
    }

- GET FRIEND OF USER: GET "http://localhost:6000/user/userId/friends"

- TOGGLE NOTIFY FRIENDS: PUT "http://localhost:6000/user/userId/toggle-notify-friends"

- UPDATE PROFILE: PUT "http://localhost:6000/user/userId/update-profile"
    - params:
    {
    "userName": "john_d",
    "password": "hello",
    "firstName": "Johnn",
    "lastName": "Doee",
    "email": "john.doe@yale.edu",
    "avatar": ""
    }

- REMOVE USER FRIEND: GET "http://localhost:6000/user/search/johndoe@yale.edu"

- DELETE USER: DELETE "http://localhost:6000/user/653d58a37ab5eaf376965b82"

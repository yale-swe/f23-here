# Here
Here is an innovative location-based augmented reality (AR) social app shifts the focus from the present moment to the here and now. 
With our app, users can leave messages or AR content at specific locations for their friends or the general public to discover. 
These planted messages become digital markers in the physical world, creating a unique and immersive social experience. 
Users can explore their surroundings and stumble upon messages from both old and new friends within a certain distance range, which initially starts at 10 meters but expands as messages gain more likes, views, and replies. 
Beyond personal connections, our platform encourages participation in large-scale public discussions, allowing users to engage in meaningful discourse about the world around them. 
Join us in redefining social interaction in the digital age with a fresh perspective on location-based AR communication.

# Deployment
Requirements: iOS 16.0 and above
We are using TestFlight Internal to deploy Here Beta Version. To use this app:
1. Email xinran.li@yale.edu to request access to Here!
2. You will receive an email from TestFlight saying that "Here - discover messages in AR 0.1.0 for iOS is now available to test." Click on "View in TestFlight" to find the redeem code.
3. Download TestFlight on you iPhone and accept the invitation in TestFlight, enter the redeem code, then TestFlight will automatically download the app for you.
4. Try our app!

Refer to API_DOC.md for API Deployment.

# Additonal Changes Instructions

### Important Note

When introducing changes, always create a new branch from the main branch. After implementing your changes, initiate a pull request and request a code review from a teammate. Following approval, merge your changes into the main branch. Ensure that your merge passes all checks in GitHub Actions to maintain build integrity. Make sure there is at least 85% statement coverage across all files for the backend when implementing new changes.

### Adding Backend Routes
To add a new backend route, navigate to the `server` folder. In the `controllers` folder. Add a controller method corresponding to one of authentication (`auth.js`), message (`message.js`), reply (`reply.js`), and user (`user.js`). Then, navigate to the `routes` folder. Import the controller method and define/add the corresponding route.

1. **Plan the Endpoint:**
   - Decide the HTTP method (GET, POST, PUT, DELETE) appropriate for the action.
   - Choose a descriptive endpoint path that follows RESTful conventions and aligns with existing routes.

2. **Update or Create the Route File:**
   - Locate the `routes` directory within the `server` folder.
   - If a relevant route file (e.g., `message.js` for message-related features) exists, open it; otherwise, create a new `.js` file.

3. **Implement the Route:**
   - Import necessary modules and middleware.
   - Define the route using `router.METHOD(PATH, HANDLER)`.
   - Use `handleSuccess`, `handleBadRequest`, `handleServerError`, and `handleNotFound` for response handling found in `utils`.

4. **Create Controller Functions:**
   - Navigate to the `controllers` directory within the `server` folder.
   - Create a new controller file or open an existing one that corresponds to the new route.
   - Write a new controller function that includes:
     - Input validation and sanitation.
     - Interaction with the database through Mongoose models.
     - Proper response with success or error messages.

5. **Testing:**
   - Write unit tests for your new controller functions.
   - For detailed instructions see the testing instructions below.
   - Run tests to ensure your code behaves as expected.

6. **Documentation:**
   - Comment your code to explain the functionality of routes and controllers.
   - Update `API_DOC.md` the new endpoints and their usage.

### Example Route and Controller Implementation

```javascript
// In user.js route file
router.get("/:userId", getUserById);

// In user.js controller file
export const getUserById = async (req, res) => {
	try {
		const user = await UserModel.findById(req.params.userId);

		if (!user) {
			return handleNotFound(res, "User not found");
		}

		handleSuccess(res, user);
	} catch (err) {
		handleServerError(res, err);
	}
};
```

### Adding Backend Tests

1. **Locate the Test File:** Navigate to the `__tests__` directory under `server`. Here, you'll find organized subdirectories for different aspects of the API, such as `controllers`, `models`, and `routes`.

2. **Create a Test File:** If a test file does not already exist in the section you edit, create one within the appropriate subdirectory. The file should be named after the feature with the suffix `Test.js`.

4. **Write Test Cases:**
    - Import the necessary modules and mock dependencies.
    - Use `describe` blocks to group related tests.
    - Within each `describe` block, write individual `it` or `test` functions for each aspect of the feature you want to test.
    - Use `expect` to assert expected outcomes.

5. **Mocking:**
    - Mock any models or external calls that your feature interacts with to isolate the feature's functionality.
    - Use `jest.mock()` to replace actual implementations with mock functions that return testable results.

6. **Running Tests:**
    - To run your tests, use the command `npm test`.
    - Ensure that your new tests pass without interfering with existing tests.

7. **Review and Refactor:**
    - Review your tests to ensure they're comprehensive and cover all possible scenarios.

### Example

Here is an example of a basic test case:

```javascript
describe("Function", () => {
  it("should return 400", async () => {
    // Setup
    // ...

    // Execution
    const result = await function();

    // Assertion
    expect(result).toBe(expectedResult);
  });
});
```

# Testing
## Backend
To run our testing script in the backend, execute the following:

```bash
npm test
```

Current Coverge: 
| % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s |
|---------|----------|---------|---------|-------------------|
| 89.72   | 91.89    | 85.18   | 89.86   |                   |

## Frontend
To run our testing script in the frontend, execute the following command in XCode:

1. **Run Tests**
   - **Command**: `Cmd/Ctrl + U`
   - **Description**: This command will execute the testing script.

2. **View Coverage Report**
   - **Command**: `Cmd/Ctrl + 9`
   - **Description**: Use this command to access and view the code coverage report.

Current Coverge: 
| % Stmts | 
|---------|
| 6.7%    |

**NOTE**: As discussed with Professor Antonopoulos, we are currently encountering an error
that prevents all of us from properly running the tests. Here is the encountered error:

Failed to load the test bundle. Underlying Error: The bundle “newHereUITests” couldn’t be loaded. 
The bundle couldn’t be loaded. Try reinstalling the bundle. 

We were told to not worry about getting 80% statement coverage for the frontend tests,
especially since we've met the requirement for backend tests. During break, we will 
work on resolving this error and finishing the frontend tests.
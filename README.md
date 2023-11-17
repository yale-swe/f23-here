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

NOTE: As discussed with Professor Antonopoulos, we are currently encountering an error
that prevents all of us from properly running the tests. Here is the encountered error:

Failed to load the test bundle. Underlying Error: The bundle “newHereUITests” couldn’t be loaded. 
The bundle couldn’t be loaded. Try reinstalling the bundle. 

We were told to not worry about getting 80% statement coverage for the frontend tests,
especially since we've met the requirement for backend tests. During break, we will 
work on resolving this error and finishing the frontend tests.
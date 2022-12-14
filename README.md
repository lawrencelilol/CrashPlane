# CrashPlane

A FlappyBird Clone using Swift and SpriteKit

CrashPlane App is developed based on project provided here:https://www.hackingwithswift.com/read/36/overview

This repository is the demostration of the implementation of the GameStep SDK. The main structure consists with three parts: the controller of the game, the scene and the SDK implementation.

To best imitate a true developing environent, internal coding of the SDK were encapsulated in the ```GameStepSDK``` folder, like an imported package.

If the user wants to see how much coins earned since last login of the game, user needs to quit the app first and open the app to see the new coins earned.
***

## User Guide (for users to install and test the app on their phone for the first time)

1. Clone the project to Xcode
2. Run the App. (It may has errors about APP identifier) 
<img width="247" alt="image" src="https://user-images.githubusercontent.com/35508198/206640681-9750cdb9-1237-40d9-b530-3348eaf0185f.png">

Just change the App identifier based on your machine. It should work.

3. After the app runs successfully, the first thing it would ask permission to access user's health data.

<img src="https://user-images.githubusercontent.com/35508198/206640932-1ae62e1e-cb59-418e-930a-05dc49ce7437.png"  width="20%" height="8%">


click Allow and the app should start fetches your step data.

4. It may show 0 step and 0 coins after you first enter the game for now.
<img src="https://user-images.githubusercontent.com/35508198/206641115-98f21208-d6d2-480d-a63c-45bd73dd0a65.png"  width="20%" height="8%">


You just need to quit the App and reopen it again. Then you coins should be there!


<img src="https://user-images.githubusercontent.com/35508198/206641249-0bf2a453-ace9-4490-9b5e-90c0e1419bbd.png"  width="20%" height="8%">


Then you can start playing the game and revive with the coins you earned!

5. If you are bored and want to walks a couple miles to earn more coins, you just need to quit the game. After finish walking,
you decide to play the game again and check to see the coins you just earned, you just need to open the app again. 

<img src="https://user-images.githubusercontent.com/35508198/206641913-8eca0fff-e48b-4c04-b4f4-2ff71bf5025e.png"  width="20%" height="8%">


You will see you have earned more coins just for walking around!

***
## GameStep SDK
GameStep SDK functions as following:
1. Retreiving steps data from Apple HealthKit.
2. Converting steps to coins (100 steps = 1 coin).
3. Store the coins and steps data permanantly to the phone through Apple Developer Tool ```UserDefault``` class.
4. Open up a Coins interface for developer to manipulate the SDK.

### Retreiving steps data from Apple HealthKit.

The original code for accessing the healthkit data is from azarmshap on youtube, https://www.youtube.com/watch?v=ohgrzM9gfvM And it was revised to match the data mapping.

The folder ```HealthInfo``` is where the SDK get access the data. The developer need to manually add the Healthkit capability from XCode and sign fo the privacy info list for accessing user's health data.

The file HealthStore contains the major methods like: asking for authorization from the user to get access to healthkit, fetching the steps data in a given date range, and get the today's step count so far whenever the user launches the app. In the current file, the query in the function ```fetchStep``` will fetch the data of today in a 1 hr frequency, which can be further extend to 1 week, 1 month and further, and the frequency can be narrowed to 1 min or 1 sec if necessary. In future versions, we will open up an interface for developer to customize the time and frequency manner when accessing the steps data. It will return the a Healthkit collection which will be further be transformed into a collection of array of Step object, which initialize with ```date```, ```count``` and ```UUID```. The function ```getStep``` will directly return a double that contains today's step so far whenever this function gets called.

The step is used to represent a customized data period of steps. It has attributes like ```step``` ```count```, ```UUID``` and ```date```.

### Converting steps to coins (100 steps = 1 coin).

The ```GameStep``` file act as a main controller of the SDK, which it receive the steps data from the healthkit access, handle calls from the developer, and do the converting and storing procedure. 

The ```GameStep``` main class have variables like:
- ```healthstore``` is used to retreive steps from healthkit.
- ```currentStep```, is used to record the newest step retreived from the healthkit.
- ```theCoin``` is used to record the newest coin converted.


### Store the data
```defaults``` stores the the last state of steps and coins from last update of before the user quit the app from last time.
***

## How to use GameStep SDK
1. Import the package.
2. Initialize the instance of GameStep.
3. Use the interface for the coins and steps to manipulate.
  - ```getCoins``` will return the current coin the user have.
      - The ```getCoins``` will only be recalculated when user relaunch the app. During a single session, the coin would not update itself since the step is not updated.
  - ```consumeCoins``` will consume the coin for game modifying.
  - Step is also opened to user through ```getSteps``` if the user needed.
      - To better motivate the user to exercise, the ```getStep``` method will get the step data from today's step data from 12am. As a result of that, the all step data will recount for each day, and to encourage the user to use the app, the user have to launch the app to convert the coin to store it permamently.
5. The SDK will handle the update and store new data whenever the function were called.

In future versions, if applicable, we hope the SDK will explore more powerful features in the SDK and build a platform for it. 


***

## Develop Environment
* Swift 5
* iOS 16.1

*** 

## Use Cases
### A-Level Use Case
#### 1. Play the Game
- Actors: Users
- Precondition:
  1. User downloaded the app.
  2. User allow the healthkit connection
- Basic Flow
  1. User launch the app.
  2. User tap the screen and play the game.
  3. User died.
  4. Next use case
- Alternative Flow
  2A1. User quit before play
  2A2. User quic after play
  3A1. User Revive: go to use case 3
- Post condition:
  - successful condition:
    - user plays the game until he/she died.
  - failure condition
    - user fails before he/she died in the game. Like Alternative Flow 1 & 2
#### 2. Step for coins
  - Actor: Users
  - Precondition
    1. User downloaded the app.
  - Basic Flow
    1. User launch the app.
    2. The coins were converted steps from last time the user open the app, i.e. last time: 10000 steps and 50 coins, this time 15000 steps, 5000 more steps will convert to 50 coins, so now the user has 100 coins.
  - Alternative Flow
    2A1: 
      - Pre-condition: user open the app for the very first time
        1. User will be prompt to ask for access of steps data
      - Post-condition:
        - Successful condition:
          - User allow access, step converted to coins
        - Failure condition:
          - User not allow access, no steps fetched and no coins.
          - But still able to play the game.
          
### B-Level Use Case
#### 3. Revive
  - Pre-condition.
    - Success in Use case 2
    - Finish the basic flow in Use case 1
  - Basic flow
    1. User died from playing
    2. User choose to revive
    3. User have enough coins to revive
    4. User revives, the score before died keeps
  - Alternative Flow
    2A1:
      1. User choose new game
      2. Coins were deducted
    2A2:
      1. User choose to revive.
      2. no enough coin
      3. game over scene
  -post condition
    1. Success Condition
      - User continue on the game
    2. Failed Condition
      1. User start new game without old score
      
    
    

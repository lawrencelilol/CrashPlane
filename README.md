# CrashPlane

A FlappyBird Clone using Swift and SpriteKit

Credit to :https://www.hackingwithswift.com/read/36/overview

This repository is the demostration of the implementation of the GameStep SDK. The main structure consists with three parts: the controller of the game, the scene and the SDK implementation.

To best imitate a true developing environent, internal coding of the SDK were encapsulated in the ```GameStepSDK``` folder, like a imported package.

## The SDK
The SDK functions as following:
1. Retreiving steps data from Apple HealthKit.
2. Converting steps to coins (100 steps = 1 coin).
3. Store the coins and steps data permanantly to the phone through Apple Developer Tool ```UserDefault``` class.
4. Open up a Coins interface for developer to manipulate the SDK.

### Retreiving steps data from Apple HealthKit.
The folder ```HealthInfo``` is where the SDK get access the data. The developer need to manually add the Healthkit capability from XCode and sign fo the privacy info list for accessing user's health data.

The file HealthStore contains the major methods like: asking for authorization from the user to get access to healthkit, fetching the steps data in a given date range, and get the today's step count so far whenever the user launches the app. In the current file, the query in the function ```fetchStep``` will fetch the data of today in a 1 hr frequency, which can be further extend to 1 week, 1 month and further, and the frequency can be narrowed to 1 min or 1 sec if necessary. In future versions, we will open up an interface for developer to customize the time and frequency manner when accessing the steps data. It will return the a Healthkit collection which will be further be transformed into a collection of array of Step object, which initialize with ```date```, ```count``` and ```UUID```. The function ```getStep``` will directly return a double that contains today's step so far whenever this function gets called.

The step is used to represent a customized data period of steps. It has attributes like ```step``` ```count```, ```UUID``` and ```date```.

### Converting steps to coins (100 steps = 1 coin).
The ```GameStep``` file act as a main controller of the SDK, which it receive the steps data from the healthkit access, handle calls from the developer, and do the converting and storing procedure. 

The ```GameStep``` main class have variables like:
- ```healthstore``` is used to retreive steps from healthkit.
- ```currentStep``, is used to record the newest step retreived from the healthkit.
- ```theCoin``` is used to record the newest coin converted.


### Store the data
```defaults``` is the last state of steps and coins from last update of before the user quit the app from last time.
***

## How to use th SDK
1. Import the package.
2. Initialize the instance of GameStep.
3. Use the interface for the coins and steps to manipulate.
  - ```getCoins``` will return the current coin the user have
  - ```consumeCoins``` will consume the coin for game modifying.
  - Step is also opened to user through ```getSteps``` if the user needed.
5. The SDK will handle the update and store new data whenever the function were called.

In future versions, if applicable, we hope the SDK will explore more powerful features in the SDK and build a platform for it. 

***

## Develop Environment
Swift 5

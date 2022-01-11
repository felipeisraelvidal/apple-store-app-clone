#  Apple Store App Clone

This project is the re-creation of the Apple Store app and is for study purposes.

It was developed using the Coordinator Pattern

## How to Run

First you must clone the [backend repository](https://github.com/felipeisraelvidal/apple-store-app-backend) of this project. In this repository you will find information on how to run the backend for the application to work correctly.

In the NetworkManager, responsible for making requests to the server, the base url was configured using localhost. If you want to run the application on your real device, you will need to use your ip address instead of localhost.

*If you're testing on Simulator*
```swift
// Apple Store > Modules > Sources > Networking > NetworkManager

public final class NetworkManager {
    ...
    
    private let baseURL = "http://localhost:3000"
    
    ...
}
```

*If you're testing on a real device*
```swift
// Apple Store > Modules > Sources > Networking > NetworkManager

public final class NetworkManager {
    ...
    
    private let baseURL = "http://999.999.99.999:3000" // Replace with your ip address
    
    ...
}
```

## Coordinators

As mentioned earlier, this project was developed using the Coordinator design pattern. This is considered one of the ideal patterns to use with UIKit.

Below is a diagram of what the app's architecture would look like when finished.

![diagram](https://user-images.githubusercontent.com/41072759/148875595-e5eb6d7f-9712-4014-969b-ccbc4d1b332d.png) 

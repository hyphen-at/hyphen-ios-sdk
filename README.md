# hyphen-ios-sdk

Hyphen aims for Firebase Auth for Web3: non-custodial mobile wallet SDK utilizing user's mobile devices as cold-wallet.

## Quick Start
### Step 1. Get your API keys

Your API requests are authenticated using API keys. Any request that doesn't include an API key will return an error.

### Step 2. Install the SDK using SPM

We recommend Swift Package Manager to install our SDK.

```swift
import PackageDescription

let package = Package(
    name: "my-project",
    dependencies: [
        .package(url: "https://github.com/hyphen-at/hyphen-ios-sdk.git"),
        ...
    ],
    targets: [...]
)
```

## Demo app

The [HyphenSampleApp](https://github.com/hyphen-at/hyphen-ios-sdk/tree/main/HyphenSampleApp) folder contains a sample app that allows you to test all the features of the iOS SDK. Open Xcode project and run your real device.

Your Firebase `GoogleServices-Info.plist` file is required to build the project. Download config file from the Firebase Console and place the file it in the folder where the `AppDelegate.swift` resides.

## Documentation

See the [Official Hyphen Documentation](https://docs.hyphen.at/ios/quick-start) for more information.

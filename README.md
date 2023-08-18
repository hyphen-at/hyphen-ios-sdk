# hyphen-ios-sdk

Hyphen aims for Firebase Auth for Web3: non-custodial mobile wallet SDK utilizing user's mobile devices as cold-wallet.

<br>

## Quick Start
### Step 1. Get your API keys

Your API requests are authenticated using API keys. Any request that doesn't include an API key will return an error.

<br>

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

<br>

## Documentation

See the [Official Hyphen Documentation](https://docs.hyphen.at/ios/quick-start) for more information.

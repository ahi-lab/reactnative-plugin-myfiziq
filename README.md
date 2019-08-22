![MyFiziq Logo](https://www.myfiziq.com/assets/images/logo.svg)

# Installation

⚠️ **NOTE:** MyFiziq React Native plugin does not support v0.60 of React Native at this stage. This is due to React Native not allowing the use of dynamic libraries as part of Cocoapods installation at this time.

This guide assumes the React Native is installed and configured.

1. Create a new RN project:
```sh
react-native init MyFiziqExample --version react-native@0.59.10
cd MyFiziqExample
```
2. Install the MyFiziq RN plugin:
```sh
npm install MyFiziqApp/reactnative-plugin-myfiziq
```
3. Link the plugin to the project:
```sh
react-native link react-native-my-fiziq-sdk
```
4. Remove the duplicate RN package.json file (⚠️ **NOTE:** This workaround step will be removed in future once the fix is introduced. It is only relevant for iOS development.):
```sh
rm ios/Pods/React/package.json
```
5. Test that the project builds and runs (assuming iOS development):
```sh
react-native run-ios
```

# Use Example

```js
...
// Import MyFiziq plugin
import RNMyFiziqSdk from 'react-native-my-fiziq-sdk';
...
```
  
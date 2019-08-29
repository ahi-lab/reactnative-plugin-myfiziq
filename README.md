![MyFiziq Logo](https://www.myfiziq.com/assets/images/logo.svg)

React Native plugin of the MyFiziq SDK, allowing MyFiziq technology to be used in React Native applications.

# Installation

This guide assumes the React Native is installed and configured.

1. Create a new RN project (if not already done):
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
4. Test that the project builds and runs (assuming iOS development):
```sh
react-native run-ios
```

# Use Example

__App.js__

```js

...

import {Platform, StyleSheet, Text, View, NativeModules, NativeEventEmitter, Alert} from 'react-native';

// Import in the MyFiziq SDK plugin
var MyFiziq = NativeModules.RNMyFiziqSdk;
var MyFiziqEvent = new NativeEventEmitter(MyFiziq)

// Setup MyFiziq service
// NOTE: Replace the KEY, SECRET, and ENVIRONMENT strings with values given by MyFiziq
async function myfiziqSetup() {
  try {
    let result = await MyFiziq.mfzSdkSetup(
      "KEY", 
      "SECRET", 
      "ENVIRONMENT");
  } catch(e) {
    Alert.alert('Error', e,[{text: 'OK', onPress: () => console.log('OK Pressed')}],{cancelable: false});
  }
}

// Answer MyFiziq event requests
MyFiziqEvent.addListener('myfiziqGetAuthToken', (data) => {
  // Answer with idP service user authentication token, as per AWS Cognito OpenID mapping.
  // See: https://docs.aws.amazon.com/cognito/latest/developerguide/open-id.html
  // NOTE: null passed in this example, however OID token would be passed or null if user not logged in.
  MyFiziq.mfzSdkAnswerLogins(null, null);
});

...

type Props = {};
export default class App extends Component<Props> {

  // Initialize MyFiziq service on App startup via the App class Constructor.
  constructor(props) {
    super(props);
    myfiziqSetup();
  }

  render() {
    return (
      ...
    );
  }

  ...

}

...
```

## Example Project

An example React Native project is available for reference on how to integrate this plugin: [https://github.com/MyFiziqApp/reactnative-plugin-myfiziq-example](https://github.com/MyFiziqApp/reactnative-plugin-myfiziq-example)

## Custom styling with CSS

The MyFiziqSDK UI can be customised to a high degree of flexibility using CSS. The iOS SDK uses the [InterfaCSS](https://github.com/tolo/InterfaCSS) framework to bind the CSS stylings to the native UI. By simply distributing a custom CSS file with the APP and calling the `mfzSdkLoadCSS` method to declare the CSS file path will cause the MyFiziq Avatar Creation Process UI to be customised. For reference, the base CSS can be refered to [here](myfiziq-sdk.css).

## Author

MyFiziq iOS Dev, dev@myfiziq.com
  
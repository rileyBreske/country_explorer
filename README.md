# Country Explorer

Module 5 - added Firebase login to my country explorer app from module 4.

You have to sign up or log in with an email and password before you can see the countries. Once you're logged in it remembers you, so next time it skips the login screen. There's a logout button in the top right corner.

## Running it

The Firebase config files aren't in the repo since they have API keys in them, so do the Firebase setup steps below first. Then:

```
flutter pub get
flutter run
```

I tested it on the iPhone simulator.

## Test account

email: tester1795411132464@example.com
password: testpass123

This only works with my Firebase project. If you set up your own, just make a new account on the sign up screen.

## Firebase setup

1. Make a project at console.firebase.google.com
2. Go to Authentication and turn on Email/Password
3. Run `flutterfire configure` in this folder and pick your project (pick android and ios)

That makes `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`.

## Notes

- Country data comes from https://countries.trevorblades.com/
- Flags come from https://flagcdn.com/
- The original Module 4 version is under the `module-4` tag

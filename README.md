## trump installation and setup
1. `firebase init`
1. `add android`
    1. changed applicationId to `com.todd.trump`
    1. get sha1 from `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore` and password as `android`
    1. download `google-services.json` and add dependencies
1. `firebase auth android`
    1. add sign-in method from console.firebase.com
    1. flutter pub add `firebase_core, firebase_auth, google_sign_in`
    1. add `auth.repo.dart` code for googleSignIn and signOut
    1. add `WidgetsFlutterBinding.ensureInitialized();` and then `await Firebase.initializeApp();` in `main.dart`
1. `firebase auth web`
    1. register a web app on fireabase and add this code to `web/index.html`
    ```html
      <script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js"></script>
      <script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-auth.js"></script>   
      <script>
        var firebaseConfig = {
          apiKey: "AIzaSyCeJaWt61MWy3XGQ-8R_u4EOpRURJGwFfw",
          authDomain: "tr-ump.firebaseapp.com",
          projectId: "tr-ump",
          storageBucket: "tr-ump.appspot.com",
          messagingSenderId: "348708516832",
          appId: "1:348708516832:web:508c02fa79eff562747185"
        };
        firebase.initializeApp(firebaseConfig);
      </script>
    ```
    1. go to Authentication > google to get client ID and client secret
    1. any other domains can be added there only
    1. In your web/index.html file, add this meta tag, somewhere in the head of the document: `<meta name="google-signin-client_id" content="YOUR_GOOGLE_SIGN_IN_OAUTH_CLIENT_ID.apps.googleusercontent.com">`

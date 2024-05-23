### Steps to Set Up Firebase for a Flutter Project

#### 1. **Creating a Firebase Project**

1. **Go to the Firebase Console**:
   - Navigate to [Firebase Console](https://console.firebase.google.com/).
   - Click on "Add project" and follow the prompts to create a new Firebase project. Name it whatever you like.

2. **Add an Android App to Your Firebase Project**:
   - In the Firebase Console, select your project.
   - Click on the Android icon to add an Android app.
   - Register the app with the package name: `com.example.spoonsharemeals.spoonsharemeals`.

<img src="https://github.com/Saumya-28/SpoonShare/assets/98171392/6e6b1e8a-d2a9-4087-858c-c0e09172c147" width="500" height="500" />



#### 2. **Generating SHA-1 Key**

1. **Open Your Flutter Project**:
   - Open your Flutter project in your preferred IDE.

2. **Open Terminal**:
   - Locate the terminal at the bottom of your project.

3. **Navigate to the Android Directory**:
   - In the terminal, type the command:
     ```bash
     cd android
     ```

4. **Generate the SHA-1 Key**:
   - Run the command:
     ```bash
     ./gradlew signingReport
     ```
   - Locate the SHA-1 key in the output under the `Variant: debug` section.

5. **Add SHA-1 Key to Firebase**:
   - Copy the SHA-1 key from the terminal.
   - Go back to the Firebase Console, paste the SHA-1 key in the appropriate field under your Android app settings, and save it.

#### 3. **Installing Flutter CLI**

1. **Install Flutterfire CLI**:
   - Ensure you have the Firebase CLI installed. You can download it [here](https://firebase.google.com/docs/cli#install_the_firebase_cli).

2. **Activate Flutterfire CLI**:
   - In your Flutter project root directory, run:
     ```bash
     dart pub global activate flutterfire_cli
     ```

3. **Configure Firebase**:
   - Run the following command to configure Firebase for your Flutter project:
     ```bash
     flutterfire configure
     ```
   - Follow the prompts to select your Firebase project and configure the necessary files.

#### 4. **Enabling Cloud Firestore API**

1. **Go to Google Cloud Console**:
   - Navigate to [Google Cloud Console](https://console.cloud.google.com/).

2. **Select Your Project**:
   - From the project dropdown, select the Firebase project you created.

3. **Enable Cloud Firestore API**:
   - Go to the API & Services Dashboard.
   - Click on "Enable APIs and Services".
   - Search for "Cloud Firestore API" and enable it.

#### 5. **Ready to Use**

- With the above steps completed, your Firebase setup for the Flutter project is ready. You can now run your application.

#### Summary Commands

```bash
# Navigate to the android directory
cd android

# Generate SHA-1 key
./gradlew signingReport

# Activate Flutterfire CLI
dart pub global activate flutterfire_cli

# Configure Firebase in Flutter project
flutterfire configure
```



# Codelet - Your Python Compiler with Dark/Light Mode

**Codelet** is a user-friendly Python compiler built with **Flutter**, designed to provide a seamless coding experience. It features an intuitive UI, dark/light mode themes, and avatar customization, making it more than just a coding tool—it's a personalized environment for developers.

## Features

- **Dark/Light Mode**: Toggle between dark and light themes for a comfortable coding experience, regardless of your environment.
- **Avatar Selection**: Personalize your experience with the avatar selection feature.
- **Python Code Execution**: Write and execute Python code directly within the app.
- **Enhanced Output View**: View formatted outputs in a styled container that matches the selected theme.
- **Theme Toggle Button**: Switch themes conveniently from the app bar.
- **User Preferences**: Save selected avatars and theme settings for a consistent experience across sessions.
- **Real-time Feedback**: View output immediately after code execution.

## Technologies Used

- **Flutter**: A cross-platform framework used to build the app.
- **Dart**: The programming language for writing app logic and UI.
- **SharedPreferences**: To save and load user preferences like avatars and themes.
- **Flask**: For running the Python code execution backend.
- **HTTP**: For communication between the Flutter app and the Flask backend.

## Requirements

Before running **Codelet**, ensure you have the following:

- **Flutter SDK**: Version 3.0 or later.
- **Python**: Version 3.x installed on your system.
- **Internet Connection**: Required for communication with the backend.
- **USB Debugging**: Enabled on your device if testing on physical hardware.

## Installation

Follow these steps to set up and run **Codelet** locally:

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/Codelet.git
```
### 2. Navigate into the project directory:
```bash
cd Codelet
```
### 3. Install the dependencies:
```bash
flutter pub get
```
### 4. Set Up the Flask Backend
``` bash
cd backend
pip install flask
python3 main.py
```
### 5. Run the app on an emulator or physical device:
```bash
flutter run
```
Ensure your device/emulator is connected and set up properly before running the app.

# Usage

Once installed, Codelet allows you to:

1. **Write Python Code**  
   Use the editor screen to type Python code. The app provides a styled text field optimized for readability.

2. **Execute Code**  
   Press the Run button to execute the code. The output will display in a styled container matching the current theme.

3. **Customize Your Environment**  
   Toggle between dark/light mode using the theme toggle button in the app bar. Select your avatar for a personalized touch.

4. **Save Your Preferences**  
   Your selected avatar and theme settings are saved automatically and loaded during your next session.

## Contributing
I welcome contributions to improve **Codelet**. If you want to contribute, please follow these steps:

### 1. Fork the repository:
Go to the GitHub repository and click the **Fork** button.
### 2. Create a new branch:
After forking, create a new branch to work on your feature or bug fix.
```bash
git checkout -b feature-name
```
### 3. Make changes:
Make the necessary changes to the code and commit them.
```bash
git add .
git commit -m "Description of your changes"
```
### 4. Push to your fork:
```bash
git push origin feature-name
```
### 5. Create a Pull Request:
Submit a pull request on the original repository. Make sure to describe your changes and why they are necessary.

## <span style="color: #03A9F4; font-family: Arial, sans-serif;">🚀 About Me</span>
I'm a passionate tech enthusiast, always eager to explore new challenges and learn from them.

## <span style="color: #3F51B5; font-family: Arial, sans-serif;">Authors</span>
- [@Fahad](https://github.com/syedfahad7)

# GoCV

Build Resume on the Go

## Table of Contents

-   [Introduction](#introduction)
-   [Features](#features)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Dependencies](#dependencies)
-   [Contributing](#contributing)
-   [License](#license)
-   [Contact](#contact)

## Introduction

This Flutter project aims to enable the people to build resumes easily. It is developed using Flutter framework, which allows for cross-platform mobile app development.

## Features

### Feature List

-   [x] **Resume Management**:
    -   [x] Create, update, and delete resumes.
-   [x] **Personal Information**:
    -   [x] Update personal details like name, address, etc.
-   [x] **Contact Information**:
    -   [x] Update contact details such as email, phone number, etc.
-   [x] **Work Experience**:
    -   [x] Add new Work Experience
    -   [x] Update Work Experience
    -   [x] Delete Work Experience
-   [x] **Education**:
    -   [ ] Add new Education
    -   [ ] Update Education
    -   [ ] Delete Education
-   [ ] **Skills**:
    -   [ ] Add new Skills
    -   [ ] Update Skills
    -   [ ] Delete Skills
-   [ ] **Projects**:
    -   [ ] Add new Projects
    -   [ ] Update Projects
    -   [ ] Delete Projects
-   [ ] **Certifications**:
    -   [ ] Add new Certifications
    -   [ ] Update Certifications
    -   [ ] Delete Certifications
-   [ ] **Awards**:
    -   [ ] Add new Awards
    -   [ ] Update Awards
    -   [ ] Delete Awards
-   [ ] **Publications**:
    -   [ ] Add new Publications
    -   [ ] Update Publications
    -   [ ] Delete Publications
-   [ ] **References**:
    -   [ ] Add new References
    -   [ ] Update References
    -   [ ] Delete References
-   [ ] **Languages**
    -   [ ] Add new Languages
    -   [ ] Update Languages
    -   [ ] Delete Languages:
-   [ ] **Interests**:
    -   [ ] Add new Interests
    -   [ ] Update Interests
    -   [ ] Delete Interests
-   [x] **Preview Resume**:
    -   [x] View a preview of the resume layout.
-   [x] **Export Resume as PDF**:
    -   [x] Generate and export the resume as a PDF file.

### Additional Features

-   [x] **Multiple Language Support**:
    -   [x] Bengali
    -   [x] English
-   [x] **Theme Change**
-   [ ] **Customizable Templates**:
    -   [ ] Provide different resume templates for users to choose from.
-   [ ] **Integration with LinkedIn/GitHub**:
    -   [ ] Allow users to import data from their LinkedIn or GitHub profiles.
-   [ ] **Collaboration**:
    -   [ ] Enable collaboration features for multiple users to work on a resume together.
-   [ ] **Version Control**:
    -   [ ] Implement version control to track changes made to resumes over time.

## Installation

To run this project locally, follow these steps:

1. Make sure you have Flutter SDK installed on your machine. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up Flutter.
2. Clone this repository to your local machine using the following command:
    ```shell
    git clone https://github.com/MeherajUlMahmmud/GoCV.git
    ```
3. Navigate to the project directory:
    ```shell
    cd GoCV
    ```
4. Fetch the project dependencies by running the following command:
    ```shell
    flutter pub get
    ```
5. Connect your device or start an emulator.

6. Run the app using the following command:

    ```shell
    flutter gen-l10n
    flutter run
    ```

## Usage

Before using the Flutter app, please ensure that the [JobBoard REST API](https://github.com/MeherajUlMahmmud/JobBoardAPI) project is running and accessible. Follow these steps to set up the app correctly:

1. Start the REST API by running the appropriate command or script. Make sure the project is running on a server or local development environment.

2. Once the REST API is up and running, open the Flutter app's source code in your preferred code editor.

3. Locate the file or class responsible for making HTTP requests to the REST API. This is typically where the API client or services or URLs are defined.

4. Look for a variable or constant that represents the base URL of the API endpoints. It is usually defined as a string constant or assigned to a variable.

5. Update the value of the base URL to match the URL of your Django project's API. Ensure that you include the appropriate path and any necessary authentication or authorization headers if required by the REST API.

    Example:

    ```dart
    class URLS {
    	// static const String kBaseUrl = "http://192.168.0.108:8000/";
    	// static const String kBaseUrl = "http://10.0.2.2:8000/";
    	static const String kBaseUrl =
    		"http://127.0.0.1:8000/api/"; // for iOS simulator


    	// Rest of your API client code...
    }
    ```

    Replace `"http://127.0.0.1:8000/api/"` with the actual URL of your Django project's API.

6. Save the changes and ensure that the Flutter app's source code is updated with the correct base API URL.

7. Build and run the Flutter app on your device or emulator, and it should now be able to communicate with the REST API endpoints.

By following these steps and updating the base API URL in your Flutter app, you can successfully utilize the functionalities provided by the Django project. This ensures proper communication between the Flutter app and the Django backend.

## Dependencies

This project depends on the following packages:

1. `cupertino_icons: ^0.1.3`: This package provides the Cupertino Icons font, which includes a wide range of icons that follow the design principles of Apple's iOS platform. It allows you to easily include these icons in your Flutter app's UI.

2. `http: ^0.13.6`: The `http` package provides a set of high-level functions and classes for making HTTP requests in Flutter. It simplifies the process of sending HTTP requests and handling responses, enabling you to interact with web services and APIs.

3. `shared_preferences`: The `shared_preferences` package provides a simple way to store and retrieve key-value pairs on the device. It allows you to persist small amounts of data such as user preferences, settings, or cached data. The data is stored locally on the device using the platform's native storage mechanisms.

4. `permission_handler`: This package simplifies the process of requesting and managing permissions in a Flutter app. It provides a unified interface to handle various types of permissions, such as camera, microphone, location, and more. It helps you handle the permission request flow and provides convenient methods to check and request permissions.

5. `intl`: The `intl` package provides internationalization and localization support for Flutter apps. It allows you to localize your app's text, format dates, numbers, and currencies according to different locales. It provides tools to manage translations, pluralization, and other language-specific features.

6. `image_picker`: The `image_picker` package allows you to select images or videos from the device's gallery or capture them using the camera. It provides a simple interface to pick media files, allowing you to integrate image and video selection functionality into your app.

7. `image_cropper`: The `image_cropper` package provides a convenient way to crop images in a Flutter app. It allows users to select a portion of an image and crop it to the desired size or aspect ratio. It supports common image cropping features like rotation, zooming, and cropping aspect ratio customization.

8. `url_launcher: ^6.1.5`: The `url_launcher` package provides a simple way to launch external URLs or deep links from a Flutter app. It allows you to open web pages, email addresses, phone numbers, or launch other apps installed on the device by providing the corresponding URLs or deep links.

9. `printing: ^5.10.1`: The `printing` package provides utilities for printing documents and images from a Flutter app. It allows you to generate and print documents in various formats, such as PDF, and provides options for customizing the print output.

10. `flutter_typeahead: ^4.3.1`: The `flutter_typeahead` package provides an autocomplete or type-ahead feature for text input fields in a Flutter app. It suggests and displays a list of options based on the user's input, making it easier and faster for users to enter data.

For more details, see the pubspec.yaml file.

## Screenshots

-   [Include screenshots or gifs to demonstrate your app's functionality]

## Contributing

Contributions, bug reports, and feature requests are welcome! If you have any suggestions or improvements for the project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Implement your changes or additions.
4. Commit and push your changes to your forked repository.
5. Submit a pull request, describing the changes you made and the problem they solve.
6. Be prepared to address any feedback or questions during the review process.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

If you have any questions or need assistance, feel free to reach out to the project maintainer at `meherajmahmmd@gmail.com`. We appreciate your interest and support!

Feel free to customize the content, update the placeholders, and add/remove sections as needed to suit your specific Flutter project.

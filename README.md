# COCO
## A cross-platform mobile companion app for small business social media management

COCO is a Flutter app built for solo entrepreneurs and small business owners who want to get their brand out there without having to become a social media expert. The idea is simple: instead of jumping between platforms, you connect your accounts once and post everywhere from one place. Written a caption, picked a photo? Hit post, and COCO takes care of the rest across whichever platforms you have set up. You can also manage and keep track of your existing posts from within the app, so everything stays in one spot.

The app was built as a companion to the existing [COCO marketing platform](https://coco.one/) by The Digital Architects, which helps small businesses manage their digital presence across multiple channels from a single web interface. The goal of this project was to extend that experience into a mobile app aimed specifically at users with little to no marketing background, making it easier for them to start building visibility without needing to know what a content calendar is.

> Note: this is a university prototype and is not connected to live social media APIs. Some features are still in progress and the visual design is not finalized.

---

## Status

This is an ongoing prototype built for a university course, not a production release. Some screens and flows are still in progress and the visual design is not finalized.

The app is **not connected to live social media platforms.** This is due to legal and regulatory limitations: third-party apps that post on behalf of users require going through each platform's official API review process, including business verification and formal approval from Meta, TikTok, Google, and others before access is granted. These requirements make real integrations impossible within the scope of a university project. The app is built with the architecture and flows that would support them, but the actual platform connections are simulated rather than live.

---

## Features

- Connect multiple social media accounts in one place
- Create and publish posts across all connected platforms simultaneously
- View and manage previously published posts from within the app
- Firebase-backed authentication and data storage
- Cross-platform support (iOS and Android)

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore, Storage, App Check)
- **Media:** `image_picker` for selecting photos
- **UI:** Material Design with SVG asset support via `flutter_svg`

---

## Getting Started

Make sure you have Flutter installed. If not, follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).

Clone the repo and install dependencies:

```bash
git clone https://github.com/fannibarkanyi/COCO.git
cd COCO
flutter pub get
```

Then run the app:

```bash
flutter run
```

You will need a Firebase project connected to run the app locally. Set up a project at [firebase.google.com](https://firebase.google.com) and add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the appropriate directories.

---

## Project Context

This app was developed as a student cooperation project (BSDC-DEVDP-17A) at SRH University of Applied Sciences Berlin, under the guidance of Pascal Westmark and Prof. Dr.-Ing. David Linner, in cooperation with Yannic Tremmel from The Digital Architects.

The primary focus of the module was getting comfortable with Flutter and cross-platform mobile development, covering widgets, state management, navigation, Firebase integration, and device APIs. The COCO platform brief gave us a real-world context to design and build against.

The target user is a self-employed person or micro-business owner (think: electrician, freelance photographer, local baker) who knows their trade but has no experience with digital marketing. COCO aims to lower the barrier as much as possible, giving these users a way to show up online consistently without it taking over their day.

---

## Contributors

- Fanni Barkanyi
- Jane Doe

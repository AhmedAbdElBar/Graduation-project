# 🎨 Studio Color

**Studio Color** is a modern, color-focused mobile application built with **Flutter** that helps designers, developers, and creatives discover, extract, analyze, and work with colors and color palettes.

The application provides a collection of practical color tools, including palette generation, image color extraction, color analysis, accessibility checking, and color-blindness simulation.

---

## 📱 Project Overview

Studio Color was designed to provide an all-in-one workspace for working with colors without relying on multiple separate tools.

Users can explore different color palettes, extract dominant colors from images, analyze individual colors, check accessibility and contrast ratios, and simulate how colors may appear to people with different types of color vision deficiency.

The project focuses on combining **modern UI/UX**, **color theory**, **accessibility**, and **practical developer tools** into a single mobile experience.

---

## 📸 Screenshots

| Splash | Log In | Sign Up |
|--------|--------|---------|
| <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 05 PM (1)" src="https://github.com/user-attachments/assets/c8741485-344a-4b08-ae6d-d8b1df2ea2dc" />
| <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 05 PM" src="https://github.com/user-attachments/assets/25847ba9-b338-43f8-b959-c5deb1880030" />
| <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 06 PM (1)" src="https://github.com/user-attachments/assets/4b6313fb-24a5-4991-893e-2f2fefc2a7f6" />
|

| Palette Gallery | Palette Detail | Color Blind Simulation |
|------------------|----------------|--------------------------|
| <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 06 PM (2)" src="https://github.com/user-attachments/assets/567c309b-05fe-4d95-b035-65607403a537" />
 |<img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 04 PM (1)" src="https://github.com/user-attachments/assets/5dd94c80-53e9-4dac-b189-ecf91f1e4d62" />
 | <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 04 PM" src="https://github.com/user-attachments/assets/230258a9-4114-4eeb-9162-de4a8320e086" />
|

| Image Color Extraction | Favorites | WCAG Contrast Checker |
|--------------------------|-----------|--------------------------|
| <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 06 PM" src="https://github.com/user-attachments/assets/494e0eec-9970-4760-8ef3-98e60351a62f" />
 | <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 32 06 PM (3)" src="https://github.com/user-attachments/assets/aacac110-2dd6-4c0f-96a7-fd7e4543be0a" />

 | <img width="540" height="1200" alt="WhatsApp Image 2026-09-05 at 11 33 10 PM" src="https://github.com/user-attachments/assets/ae578d2d-6e42-4588-93e9-dfc7fed5b101" />
 |

---

## ✨ Key Features

### 🎨 Color Palette Generation

Generate and explore color palettes based on different color relationships and combinations.

Users can:

* Discover new color combinations.
* Explore multiple palette variations.
* View colors with their corresponding values.
* Save favorite palettes.
* Copy color values for use in other projects.

---

### 🖼️ Image Color Extraction

Studio Color allows users to select an image and extract its dominant colors.

The extraction process identifies important colors from the selected image and presents them as a usable color palette.

**Use cases:**

* Extracting brand colors from an image.
* Finding colors from photography.
* Creating UI palettes from visual references.
* Getting inspiration from existing designs.

---

### 🔬 Color Analysis

Users can analyze individual colors and inspect their different color representations.

The application provides useful color information such as:

* HEX
* RGB
* HSL
* Color values and properties
* Visual color preview

This makes it easier for designers and developers to work with colors across different design and development environments.

---

### ♿ Accessibility & WCAG

One of the main goals of Studio Color is helping developers and designers create more accessible interfaces.

The application can analyze color combinations and provide accessibility information based on **WCAG (Web Content Accessibility Guidelines)** principles.

Users can check:

* Foreground and background colors.
* Contrast ratio.
* Accessibility level.
* Whether a combination passes common WCAG requirements.

This helps identify color combinations that may be difficult for users to read.

---

### 👁️ Color Blindness Simulation

Studio Color includes color-blindness simulation tools that demonstrate how colors and images may appear under different types of color vision deficiency.

This feature can help designers understand how their color choices may affect users with different visual perception conditions.

The application provides simulations for common color vision deficiencies, allowing users to compare the original colors with simulated results.

---

### ⭐ Favorites

Users can save useful colors and palettes for later access.

The favorites system allows users to:

* Save palettes.
* Save important colors.
* Remove saved items.
* Access saved content quickly.

Favorite data is persisted locally so it can remain available between application sessions.

---

### 🔎 Search

Studio Color provides search functionality to make finding colors and palettes easier.

Users can search through available color-related content instead of manually browsing through the entire collection.

---

### 📋 Copy Color Values

Users can quickly copy color values such as HEX codes to the clipboard.

This makes it convenient to transfer colors from Studio Color directly into:

* Flutter projects
* Web projects
* Design tools
* UI/UX workflows
* Graphic design software

---

## 🛠️ Tech Stack

### Frontend

* **Flutter**
* **Dart**

### Backend & Services

* **Firebase**
* **Firebase Authentication**
* **Cloud Firestore**
* **Firebase Storage**

### APIs

* **REST API**
* Custom color-processing API

### State Management

* **BLoC / Cubit**
* Reactive state management

### Local Storage

* **SharedPreferences**

### Networking

* REST API integration
* HTTP requests
* JSON data handling

### Architecture

* Clean Architecture principles
* Separation of concerns
* Repository pattern
* Feature-based project structure

### Version Control

* **Git**
* **GitHub**

---

## 🏗️ Architecture

Studio Color follows a structured architecture designed to keep the codebase scalable and maintainable.

A simplified structure is:

```text
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── features/
│   │
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── palettes/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── color_analysis/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── image_extraction/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── accessibility/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── favorites/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

> The exact folder structure may vary depending on the current project implementation.

---

## 🔄 How the Application Works

The main workflow of Studio Color can be summarized as follows:

```text
User
 │
 ▼
Flutter UI
 │
 ▼
BLoC / Cubit
 │
 ▼
Repository
 │
 ├──────────────► Local Storage
 │
 ├──────────────► Firebase
 │
 └──────────────► REST API
                       │
                       ▼
                 Color Processing
                       │
                       ▼
                  JSON Response
                       │
                       ▼
                 Repository
                       │
                       ▼
                  BLoC / Cubit
                       │
                       ▼
                       UI
```

This separation makes the application easier to test, maintain, and extend.

---

## 🌐 Custom Color Processing API

Studio Color uses a custom API for some of its image and color-processing functionality.

The backend handles operations such as:

* Image processing.
* Dominant color extraction.
* Color clustering.
* Palette generation.
* Color analysis.

The API can process an uploaded image and return structured color information that the Flutter application can display.

---

## 🧠 Color Extraction Technology

The image-processing system can use techniques such as:

* **PIL (Python Imaging Library)** for image processing.
* **K-Means Clustering** for grouping similar colors.
* **ColorThief** for extracting dominant colors.

A simplified processing flow:

```text
Image
  │
  ▼
Image Processing
  │
  ▼
Resize / Normalize
  │
  ▼
Extract Pixel Colors
  │
  ▼
K-Means Clustering
  │
  ▼
Identify Dominant Colors
  │
  ▼
Generate Palette
  │
  ▼
Return Color Data
```

---

## 🔥 Firebase Integration

Firebase is used to provide cloud-based functionality.

Depending on the enabled application features, Firebase can handle:

### Authentication

User authentication and account management.

### Cloud Firestore

Stores application/user-related data such as:

* User information
* Favorite palettes
* Saved colors
* Application data

### Firebase Storage

Used for storing files and images when required by the application.

---

## 💾 Local Data Persistence

Studio Color uses local storage to improve the user experience and preserve important user data.

For example:

```text
User Action
    │
    ▼
Save Favorite
    │
    ▼
SharedPreferences
    │
    ▼
Persist Data Locally
    │
    ▼
Load Data on App Start
```

This allows selected data to remain available after closing and reopening the application.

---

## 🎯 Design Goals

Studio Color was built around several key principles:

### Simplicity

Color tools should be easy to understand and use without unnecessary complexity.

### Accessibility

Color selection should consider users with different visual abilities.

### Productivity

Common color-related tasks should be available in one application.

### Modern UI

The interface uses a clean, modern visual language with strong emphasis on color.

### Developer Friendly

Color values should be easy to inspect, copy, and reuse in development projects.

---

## 🎨 UI/UX

The UI was designed around the concept of color itself.

Key design considerations include:

* Minimal interface.
* Clear visual hierarchy.
* Color-focused components.
* Easy navigation.
* Responsive layouts.
* Clear interaction states.
* Consistent spacing and typography.
* Accessible contrast where appropriate.

The application avoids unnecessary visual elements so the colors remain the main focus of the interface.

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android SDK
* Git

Check your Flutter installation:

```bash
flutter doctor
```

---

## 📥 Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/studio-color.git
```

Navigate to the project:

```bash
cd studio-color
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## ⚙️ Environment Configuration

If the project requires API configuration, add the required API endpoint/configuration according to the project environment.

For example:

```text
API_BASE_URL=YOUR_API_URL
```

Do not commit private credentials, API keys, or Firebase configuration secrets to a public repository.

---

## 🧪 Testing

Run Flutter tests using:

```bash
flutter test
```

For static analysis:

```bash
flutter analyze
```

---

## 📦 Build

To generate an Android APK:

```bash
flutter build apk --release
```

To generate an Android App Bundle:

```bash
flutter build appbundle --release
```

---

## 🔐 Security Considerations

The project follows common application security practices, including:

* Avoiding hard-coded sensitive credentials.
* Separating API configuration from application logic.
* Using Firebase authentication where required.
* Validating data received from external APIs.
* Avoiding unnecessary exposure of backend credentials.

---

## 📈 Future Improvements

Potential future improvements include:

* Advanced palette generation algorithms.
* More color harmony modes.
* Additional accessibility tools.
* More color vision deficiency simulations.
* Export palettes as JSON, CSS, or other formats.
* Share palettes with other users.
* Cloud synchronization across devices.
* Advanced color history.
* Material Design color generation.
* Tailwind CSS color export.
* Adobe/Design-tool integration.
* Improved offline support.

---

## 💡 What I Learned

Building Studio Color provided practical experience in:

* Building production-style Flutter applications.
* REST API integration.
* Firebase integration.
* State management using BLoC/Cubit.
* Local data persistence.
* Image processing workflows.
* Color theory and color spaces.
* Accessibility and WCAG principles.
* Clean Architecture.
* Repository pattern.
* API/backend communication.
* Git and GitHub workflow.
* Designing user-focused mobile interfaces.

---

## 📊 Project Highlights

| Category         | Details                          |
| ---------------- | -------------------------------- |
| Platform         | Mobile                           |
| Framework        | Flutter                          |
| Language         | Dart                             |
| Backend          | Firebase + Custom REST API       |
| Database         | Cloud Firestore                  |
| Authentication   | Firebase Authentication          |
| Storage          | Firebase Storage / Local Storage |
| State Management | BLoC / Cubit                     |
| Architecture     | Clean Architecture               |
| Networking       | REST API                         |
| Image Processing | PIL / ColorThief / K-Means       |
| Local Storage    | SharedPreferences                |
| Version Control  | Git / GitHub                     |

---

## 👨‍💻 Developer

**Ahmed Abd Elbar**

Flutter Developer specialized in building modern, scalable, and user-focused mobile applications.

### Skills

* Flutter
* Dart
* Firebase
* REST APIs
* BLoC / Cubit
* Clean Architecture
* MVVM
* Git & GitHub
* UI/UX Implementation
* Mobile App Development

---

## 📬 Contact

If you're interested in collaborating, discussing a project, or working together, feel free to get in touch.

**Flutter Developer | Mobile App Developer**

---

## ⭐ Support

If you find this project useful or interesting, consider giving the repository a ⭐ on GitHub.

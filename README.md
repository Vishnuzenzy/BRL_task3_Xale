# 🎓 XALE — Campus Marketplace

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blueviolet?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)

XALE is an exclusive campus-driven mobile marketplace built to enable seamless student-to-student transactions inside **Ajay Kumar Garg Engineering College (AKGEC)**. It solves the friction of hostel and campus buy-and-sell groups through a clean, modern, and crash-proof mobile platform.

---

## ✨ Features

- **Campus-Centric Feed:** Real-time listings sorted with latest campus ads prioritized above mock showcases.
- **Categorized Browsing:** Quick filters for *Laptops, Mobiles, Books, Audio, Bikes, Watches, and Furniture*.
- **Post & Manage Ads:**
  - Fast ad upload with real-time CDN image hosting.
  - In-app **Edit & Delete** controls in the *My Ads* tab.
- **Cloud-Synced Wishlist:** Bookmark favorite items with instant, user-scoped persistence in Cloud Firestore.
- **Student Profile Hub:** Integrated student identity displaying Gmail profile picture, verified badge, branch, and college year.
- **Safe Campus Trading:** Built-in campus meetup guidelines for safe physical handoffs at hostel gates, canteen, or library.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter (Dart 3+)
- **Architecture:** MVVM (Model - View - ViewModel) + Services Layer
- **State Management:** Riverpod (`ChangeNotifierProvider`)
- **Backend & Database:** Firebase Authentication, Cloud Firestore
- **Media Storage:** Cloudinary REST API / Firebase Storage
- **Tooling:** Flutter Launcher Icons, Git version control

---

## 📁 Project Structure

```text
lib/
├── models/         # ListingModel, MockListing, Category configurations
├── services/       # FirebaseAuthService, Cloud Firestore real-time stream service
├── theme/          # App palette (AKGEC Navy Blue: #183661) & Typography
├── viewmodels/     # AuthViewModel, MarketplaceViewModel (Riverpod)
├── views/
│   ├── auth/       # LoginScreen, SafeArea-wrapped vanishing hero banner
│   └── home/       # HomeScreen, ListingScreen, ItemDetailScreen, AccountTab
└── widgets/        # ProductCard with Wishlist sync, Search bar, Category bubbles

## 🚀 Getting Started
# Prerequisites
• Flutter SDK (3.19+)

• Android Studio / VS Code with Flutter extension

• Android Device or Emulator with Internet connection

Installation
1. Clone the repository:
git clone https://github.com/your-username/xale.git
cd xale

2. Install dependencies:
flutter pub get

3. Configure Firebase:
Ensure google-services.json is placed inside android/app/.

4. Run the application:
flutter run

## 📦 Building Release APK
To generate the standalone production APK:
flutter build apk --release

The compiled APK will be available at:

build/app/outputs/flutter-apk/app-release.apk

## 🛡️ License
Built for campus innovation and academic project submission.


---

# AJ AI – Android Starter (Flutter)

यह शुरुआती Flutter project structure है। इसमें Chat UI और API connection का सुरक्षित placeholder है।
**APK इस ZIP में pre-built नहीं है**—APK बनाने के लिए Flutter SDK/Android build tools चाहिए।

## मोबाइल से शुरुआत
Android मोबाइल पर सीधे Flutter APK build करना सीमित/कठिन है। सबसे आसान विकल्प:
1. बाद में Windows PC या cloud build environment इस्तेमाल करें; या
2. Android पर Termux/Code editor से source देख/बदल सकते हैं, लेकिन Android SDK setup आसान नहीं है।

## Setup (PC / Cloud)
1. Flutter SDK और Android Studio install करें।
2. इस ZIP के `lib/main.dart` को Flutter project के `lib/main.dart` में रखें।
3. `flutter pub get`
4. `flutter run`
5. Release APK: `flutter build apk --release`
6. APK path: `build/app/outputs/flutter-apk/app-release.apk`

## AI API
`lib/main.dart` में API integration placeholder है। Production में API key ऐप में hardcode न करें।
Backend (FastAPI) बनाकर API key server पर रखें—अगले चरण में जोड़ेंगे।

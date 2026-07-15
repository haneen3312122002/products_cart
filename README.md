# Products Cart

تطبيق Flutter للتسوق الإلكتروني يعرض منتجات من API خارجي، مع دعم السلة (Cart) والمفضلة (Favorites) والتخزين المحلي، مبني على Clean Architecture.

## المعمارية (Architecture)

المشروع مبني على **Clean Architecture** مقسم إلى Features، وكل Feature مقسم إلى 3 طبقات:

- **Domain** — Entities, Repositories (abstract), Usecases — منطق العمل الصافي بدون أي اعتماد خارجي.
- **Data** — Models, Data Sources (Local/Remote), Repository implementations — تنفيذ فعلي لجلب وتخزين البيانات.
- **Presentation** — Cubit/State (BLoC), Screens, Widgets — واجهة المستخدم وإدارة الحالة.

```
lib/
├── app/                  # نقطة تجميع الشاشات (Root Screen)
├── core/                 # كود مشترك بين كل الـ Features
│   ├── constants/
│   ├── database/         # إعداد قاعدة بيانات SQLite
│   ├── di/               # حاوية حقن الاعتماديات (get_it)
│   ├── error/             # Exceptions / Failures
│   ├── network/           # إعداد Dio + فحص الاتصال
│   ├── theme/
│   ├── usecase/
│   └── widgets/
└── features/
    ├── product/          # عرض المنتجات وتفاصيلها
    ├── cart/             # سلة المشتريات
    └── favorite/         # المفضلة
```

## التقنيات والمكتبات المستخدمة (Tech Stack)

### الأساسيات
- **[Flutter](https://flutter.dev)** — إطار العمل الأساسي لبناء التطبيق (SDK ^3.11.5).
- **[Dart](https://dart.dev)** — لغة البرمجة.

### إدارة الحالة (State Management)
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** (`^9.0.0`) — نمط Cubit/BLoC لإدارة حالة كل Feature.
- **[equatable](https://pub.dev/packages/equatable)** (`^2.0.5`) — لمقارنة الكائنات (Value Equality) في الـ States والـ Entities.
- **[freezed_annotation](https://pub.dev/packages/freezed_annotation)** / **[freezed](https://pub.dev/packages/freezed)** (`^3.x`) — توليد كلاسات الـ States بشكل immutable باستخدام Code Generation.

### حقن الاعتماديات (Dependency Injection)
- **[get_it](https://pub.dev/packages/get_it)** (`^8.0.3`) — Service Locator لإدارة وحقن الاعتماديات (Repositories, Data Sources, Cubits...).

### الشبكة (Networking)
- **[dio](https://pub.dev/packages/dio)** (`^5.7.0`) — عميل HTTP للتواصل مع الـ API.
- **API خارجي**: [FakeStore API](https://fakestoreapi.com) — مصدر بيانات المنتجات.
- **[connectivity_plus](https://pub.dev/packages/connectivity_plus)** (`^7.2.0`) — للتحقق من توفر اتصال الإنترنت قبل تنفيذ الطلبات.

### معالجة الأخطاء الوظيفية (Functional Error Handling)
- **[dartz](https://pub.dev/packages/dartz)** (`^0.10.1`) — استخدام `Either<Failure, Success>` بدلاً من رمي الاستثناءات، لتدفق أخطاء واضح عبر طبقات Domain/Data.

### التخزين المحلي (Local Persistence)
- **[sqflite](https://pub.dev/packages/sqflite)** (`^2.4.1`) — قاعدة بيانات SQLite لتخزين عناصر السلة والمفضلة محلياً.
- **[path](https://pub.dev/packages/path)** (`^1.9.0`) — لبناء مسارات ملفات قاعدة البيانات.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** (`^2.3.4`) — لتخزين إعدادات/بيانات بسيطة (key-value).

### واجهة المستخدم (UI)
- **[flutter_screenutil](https://pub.dev/packages/flutter_screenutil)** (`^5.9.3`) — لتصميم واجهات متجاوبة (Responsive) عبر أحجام الشاشات المختلفة.
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** — أيقونات بنمط iOS.
- Material Design (عبر `AppTheme` المخصص).

### الاختبارات (Testing)
- **[flutter_test](https://docs.flutter.dev/testing)** — إطار الاختبار الأساسي في Flutter.
- **[bloc_test](https://pub.dev/packages/bloc_test)** (`^10.0.0`) — لاختبار الـ Cubits/BLoCs.
- **[mocktail](https://pub.dev/packages/mocktail)** (`^1.0.4`) — لعمل Mock للاعتماديات دون الحاجة لـ Code Generation.

### أدوات التطوير (Dev Tools)
- **[build_runner](https://pub.dev/packages/build_runner)** (`^2.15.1`) — لتشغيل توليد الكود (freezed).
- **[flutter_lints](https://pub.dev/packages/flutter_lints)** (`^6.0.0`) — قواعد Lint موصى بها لكود نظيف.

## المزايا (Features)

- 🛍️ **عرض المنتجات** — قائمة منتجات وتفاصيل كل منتج، مجلوبة من FakeStore API.
- 🛒 **السلة** — إضافة/إزالة منتجات، تعديل الكمية، محفوظة محلياً عبر SQLite.
- ❤️ **المفضلة** — تعليم المنتجات كمفضلة وحفظها محلياً.
- 📶 **دعم عدم الاتصال** — فحص حالة الشبكة قبل تنفيذ الطلبات عبر `connectivity_plus`.
- 📱 **تصميم متجاوب** — عبر `flutter_screenutil`.

## طريقة التشغيل

```bash
# تثبيت الحزم
flutter pub get

# توليد الكود (freezed) عند الحاجة
dart run build_runner build --delete-conflicting-outputs

# تشغيل التطبيق
flutter run

# تشغيل الاختبارات
flutter test
```

## المنصات المدعومة

يدعم المشروع: **Android, iOS, Web, Windows, macOS, Linux** (عبر بنية Flutter القياسية متعددة المنصات).

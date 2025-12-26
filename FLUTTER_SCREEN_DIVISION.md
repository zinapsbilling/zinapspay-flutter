# ZinapsPay Flutter - Screen Development Division

## Project Overview
Migrating ZinapsPay from Next.js to Flutter for cross-platform support (Web, Android, iOS, Windows, Mac, Linux).

**GitHub Repo:** https://github.com/zinapsbilling/zinapspay-flutter

---

## Completed Screens (4 of 29)

| Screen | Status | File |
|--------|--------|------|
| Login | ✅ Done | `lib/features/auth/presentation/screens/login_screen.dart` |
| Register | ✅ Done | `lib/features/auth/presentation/screens/register_screen.dart` |
| Forgot Password | ✅ Done | `lib/features/auth/presentation/screens/forgot_password_screen.dart` |
| Dashboard | ✅ Done | `lib/features/dashboard/presentation/screens/dashboard_screen.dart` |

---

## Shared Components (Do First)

| Component | Complexity | Status | Assigned To |
|-----------|------------|--------|-------------|
| **Sidebar/SideMenu** | HIGH | Pending | Person 1 |
| Dashboard Layout Shell | MEDIUM | Pending | Person 1 |
| Mobile Header | LOW | Pending | Flutter handles |
| Bottom Navigation | LOW | Pending | Flutter handles |

**Note:** The Sidebar must be completed first as all screens depend on it.

---

## Person 1 - Core Business Features (12 screens + Sidebar)

| # | Screen | Path | Complexity | Status |
|---|--------|------|------------|--------|
| 0 | **Sidebar (SideMenu)** | Shared component | **HIGH** | Pending |
| 1 | Customers | `/customers` | Medium | Pending |
| 2 | Orders | `/orders` | High | Pending |
| 3 | Billing | `/billing` | High | Pending |
| 4 | Shipments | `/shipments` | Medium | Pending |
| 5 | Inventory | `/inventory` | High | Pending |
| 6 | Storage | `/storage` | Medium | Pending |
| 7 | Duplicates | `/duplicates` | Medium | Pending |
| 8 | Pricing | `/pricing` | Medium | Pending |
| 9 | Templates | `/templates` | Low | Pending |
| 10 | Settings | `/settings` | Medium | Pending |
| 11 | Import Status | `/import-status` | Low | Pending |
| 12 | Product Login | `/product-login` | Low | Pending |

---

## Person 2 - Warehouse + AI Features (12 screens)

| # | Screen | Path | Complexity | Status |
|---|--------|------|------------|--------|
| 1 | Inbound | `/inbound` | High | Pending |
| 2 | Outbound | `/outbound` | High | Pending |
| 3 | Returns | `/returns` | Medium | Pending |
| 4 | Rules | `/rules` | Medium | Pending |
| 5 | Integrations | `/integrations` | Medium | Pending |
| 6 | ZinapsAI Dashboard | `/zinapsai` | Medium | Pending |
| 7 | ZinapsAI Analytics | `/zinapsai/analytics` | Medium | Pending |
| 8 | ZinapsAI Search | `/zinapsai/search` | Medium | Pending |
| 9 | ZinapsAI Training | `/zinapsai/training` | Medium | Pending |
| 10 | ZinapsAI Workflows | `/zinapsai/workflows` | Medium | Pending |
| 11 | ZinapsAI Collaboration | `/zinapsai/collaboration` | Medium | Pending |
| 12 | Legal Pages | `/legal/privacy`, `/legal/terms` | Low | Pending |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Color definitions
│   │   ├── app_sizes.dart       # Size constants
│   │   └── app_strings.dart     # String constants
│   ├── router/
│   │   └── app_router.dart      # GoRouter navigation
│   └── theme/
│       └── app_theme.dart       # Theme configuration
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           ├── register_screen.dart
│   │           └── forgot_password_screen.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       └── screens/
│   │           └── dashboard_screen.dart
│   ├── customers/               # Person 1
│   ├── orders/                  # Person 1
│   ├── billing/                 # Person 1
│   ├── inventory/               # Person 1
│   ├── inbound/                 # Person 2
│   ├── outbound/                # Person 2
│   ├── zinapsai/                # Person 2
│   └── ...
├── shared/
│   └── widgets/
│       ├── sidebar_nav.dart     # Sidebar (Person 1 - Do First!)
│       ├── app_logo.dart
│       ├── floating_orbs.dart
│       ├── glass_container.dart
│       └── gradient_background.dart
└── main.dart
```

---

## How to Create a New Screen

1. Create the feature folder:
```
lib/features/{feature_name}/
└── presentation/
    └── screens/
        └── {feature_name}_screen.dart
```

2. Add the route in `lib/core/router/app_router.dart`

3. Reference the Next.js source file at:
```
zinapspay-web/app/(dashboard)/{feature_name}/page.tsx
```

---

## Key Design Patterns

### Responsive Breakpoints (Match Next.js)
```dart
final screenWidth = MediaQuery.of(context).size.width;
final isDesktop = screenWidth >= 1024;  // lg:
final isTablet = screenWidth >= 640;    // sm:
```

### Tailwind to Flutter Conversion
| Tailwind | Flutter |
|----------|---------|
| `p-4` | `padding: EdgeInsets.all(16)` |
| `p-6` | `padding: EdgeInsets.all(24)` |
| `p-8` | `padding: EdgeInsets.all(32)` |
| `rounded-xl` | `BorderRadius.circular(12)` |
| `rounded-2xl` | `BorderRadius.circular(16)` |
| `rounded-3xl` | `BorderRadius.circular(24)` |
| `text-sm` | `fontSize: 14` |
| `text-base` | `fontSize: 16` |
| `text-lg` | `fontSize: 18` |
| `text-xl` | `fontSize: 20` |
| `text-2xl` | `fontSize: 24` |
| `text-3xl` | `fontSize: 30` |
| `gap-4` | `SizedBox(width/height: 16)` |

### Glass Effect Card
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
          left: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
          right: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),
      child: // Your content
    ),
  ),
)
```

---

## Development Commands

```bash
# Get dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Run on Android Emulator
flutter run -d emulator-5554

# Run on Windows
flutter run -d windows

# Analyze code
flutter analyze

# Build for production
flutter build web
flutter build apk
flutter build ios
```

---

## Git Workflow

```bash
# Pull latest changes
git pull origin master

# Create your feature branch
git checkout -b feature/{screen-name}

# After making changes
git add .
git commit -m "feat: Add {screen-name} screen"
git push origin feature/{screen-name}

# Create PR on GitHub
```

---

## Questions?

Contact the team or check the Next.js source code at:
- **Next.js Repo:** zinapspay-web
- **Flutter Repo:** zinapspay-flutter

---

*Last Updated: December 26, 2024*

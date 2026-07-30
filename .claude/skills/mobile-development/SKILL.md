---
name: mobile-development
description: Mobile Development — React Native (Expo), Flutter, cross-platform strategies, mobile UI/UX, testing, CI/CD, performance, security, app store deployment. Use when building mobile apps for iOS/Android.
---

# Mobile Development Skill

## React Native (Expo)

### Setup
```bash
npx create-expo-app@latest MyApp --template blank-typescript
npx expo install expo-router nativewind
```

### Navigation (Expo Router)
```tsx
// app/(tabs)/index.tsx
import { Link } from 'expo-router';
export default function Home() {
  return <Link href="/profile/123">View Profile</Link>;
}
```

### State (Zustand)
```tsx
import { create } from 'zustand';
export const useAuth = create<{user: any; login: (email: string, pw: string) => void}>((set) => ({
  user: null,
  login: async (email, pw) => set({ user: await api.login(email, pw) }),
}));
```

### Offline (WatermelonDB)
```tsx
import { Model } from '@nozbe/watermelondb';
import { field } from '@nozbe/watermelondb/decorators';
export default class Post extends Model {
  static table = 'posts';
  @field('title') title!: string;
  @field('body') body!: string;
}
```

### Push Notifications
```tsx
import * as Notifications from 'expo-notifications';
const token = (await Notifications.getExpoPushTokenAsync()).data;
```

## Flutter

### Setup
```dart
flutter create my_app
cd my_app && flutter pub add riverpod go_router
```

### State (Riverpod)
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
// Usage: ref.watch(counterProvider)
```

### Navigation (GoRouter)
```dart
final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, __) => HomeScreen()),
  GoRoute(path: '/profile/:id', builder: (_, state) => 
    ProfileScreen(id: state.pathParameters['id']!)),
]);
```

## Cross-Platform Best Practices
- **Code sharing**: Feature-based architecture, shared business logic
- **Platform-specific**: `.ios.tsx` / `.android.tsx` file extensions
- **Build**: EAS Build (Expo), Codemagic, Fastlane
- **Analytics**: Firebase Analytics, Amplitude, Mixpanel

## Mobile Testing
| Type | React Native | Flutter |
|------|-------------|---------|
| Unit | Jest + Testing Library | flutter_test |
| Component | React Native Testing Library | Widget tests |
| E2E | Detox, Maestro | integration_test |
| Visual | Percy (App) | Alchemist |

## Mobile CI/CD (EAS)
```yaml
# eas.json
{
  "build": {
    "production": {
      "android": { "buildType": "app-bundle" },
      "ios": { "autoIncrement": true }
    }
  },
  "submit": {
    "production": {
      "ios": { "appleId": "...", "ascAppId": "..." },
      "android": { "track": "production" }
    }
  }
}
```

## Performance Checklist
- [ ] App startup < 2s (lazy load non-critical modules)
- [ ] List virtualization (FlashList, FlatList windowing)
- [ ] Image optimization (WebP, resize on upload, progressive loading)
- [ ] Bundle size < 50MB (code splitting, asset optimization)
- [ ] Memory profiling (no leaks, proper cleanup)
- [ ] Network caching (react-native-mmkv, flutter_cache_store)

## Security (OWASP Mobile Top 10)
- **M1**: Improper platform usage — use OS APIs correctly
- **M2**: Insecure data storage — Keychain/Keystore, encrypted shared prefs
- **M3**: Insecure communication — SSL pinning, HTTPS only
- **M4**: Insecure auth — Biometric + device attestation
- **M5**: Insufficient cryptography — Use platform CryptoKit/ Security framework
- **M6**: Client code quality — Input validation, error handling
- **M7**: Code tampering — Code obfuscation, integrity checks
- **M8**: Reverse engineering — ProGuard/DexGuard (Android), obfuscation (iOS)
- **M9**: Extraneous functionality — Remove debug code, disable dev menus
- **M10**: Insecure WebView — No JavaScript if not needed, validate URLs

## App Store Deployment
- **iOS**: TestFlight → App Review → App Store Connect
- **Android**: Internal Testing → Closed/Open Track → Production
- **ASO**: Keywords, screenshots, ratings, reviews, app description
- **Versioning**: Semantic (iOS CFBundleVersion), versionCode increment (Android)

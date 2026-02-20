# Azim Shaikh — Flutter Portfolio

> **Mobile-app-style Flutter Web portfolio** for Azim Shaikh.  
> App-like navigation · 3D flip cards · Parallax hero · Animated skill meters · PWA-ready

---

## 🚀 Quick Start

```bash
# Prerequisites: Flutter 3.22+ (stable channel)
flutter --version

# 1. Clone
git clone https://github.com/Azim04/azim-portfolio.git
cd azim-portfolio

# 2. Install deps
flutter pub get

# 3. Run locally on Chrome
flutter run -d chrome

# Hot-restart with 'r', hot-reload with 'R'
```

---

## 🏗 Production Build

```bash
# Web — CanvasKit renderer for best animation fidelity
flutter build web \
  --release \
  --web-renderer canvaskit \
  --source-maps

# Output is in build/web/ — ready to deploy to any static host.
```

---

## ☁️ Deploy to Firebase Hosting

```bash
# One-time setup
npm install -g firebase-tools
firebase login
firebase init hosting   # set public dir to build/web, SPA: yes

# Build + deploy
flutter build web --release --web-renderer canvaskit
firebase deploy --only hosting
```

**Alternative hosts** — drag `build/web/` to:
- **Vercel**: `vercel --prod`
- **Netlify**: drag-drop or `netlify deploy --prod --dir=build/web`
- **GitHub Pages**: push `build/web` to a `gh-pages` branch

---

## 📱 PWA Enablement

PWA support is already wired up:
1. `web/manifest.json` — defines app name, icons, theme colour
2. `web/index.html` — registers the Flutter-generated service worker
3. Add app icons (192×192, 512×512 PNGs) to `web/icons/`

On Chrome/Edge: install prompt appears automatically when the `manifest.json` is detected and HTTPS is used.

---

## 🧪 Tests

```bash
# All widget tests
flutter test

# With coverage
flutter test --coverage

# View coverage (requires lcov installed)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Test coverage:**
| Test file | What it covers |
|---|---|
| `test/home_screen_test.dart` | HomeScreen renders, CTA buttons present, 4 stat tiles visible |
| `test/projects_screen_test.dart` | All 4 project cards render, GitHub sync states (loading/success), flip hint text |

All tests use Riverpod provider overrides — **zero network calls** from test runs.

---

## 🗂 Project Structure

```
lib/
├── main.dart                     # App entry point + ProviderScope
├── router/
│   └── app_router.dart           # GoRouter config with custom transitions
├── theme/
│   ├── colors.dart               # Single source of truth for all colour tokens
│   └── app_theme.dart            # Dark + Light ThemeData, typography
├── models/
│   ├── project_model.dart        # ProjectModel + static kProjects list
│   ├── experience_model.dart     # ExperienceModel + EducationModel + SkillCategory
│   └── github_repo.dart          # GitHubRepo ← GitHub REST API v3
├── services/
│   └── github_service.dart       # GitHub API with in-memory cache (15min TTL)
├── providers/
│   └── app_providers.dart        # Riverpod: themeProvider, navIndexProvider,
│                                 # githubReposProvider, repoMetaProvider,
│                                 # contactFormStateProvider
├── screens/
│   ├── splash_screen.dart        # 2.8s animated splash with progress bar
│   ├── main_shell.dart           # PageView shell + floating bottom nav + FAB
│   ├── home_screen.dart          # Hero, parallax, profile card, CTAs, stats
│   ├── projects_screen.dart      # 3D flip project cards + GitHub metadata
│   ├── about_screen.dart         # Timeline experience + education + skill meters
│   └── contact_screen.dart       # Social links + contact form + animated success
└── widgets/
    ├── section_header.dart       # Reusable tagged section header
    ├── tech_badge.dart           # Hoverable technology badge chip
    └── animated_shapes.dart      # Decorative parallax background orbs
```

---

## 🔧 Architecture Decisions

### State Management: Riverpod 2.x

Chosen over BLoC and Provider for this project because:
- **FutureProvider** gives async GitHub data fetching with zero boilerplate — no Cubit, no event classes
- **StateProvider** handles scalar toggle state (dark mode `bool`, nav index `int`) with a single line
- **Compile-time safety** — `ref.watch` and `ref.read` catch incorrect usage at compile time
- **Test ergonomics** — `ProviderScope(overrides: [...])` makes mocking trivial; see `test/`
- No code generation required at this app scale

### Navigation: GoRouter 13.x

- Declarative URL-based routing (browser back/forward works correctly)
- `CustomTransitionPage` for slide-up entry and fade transitions
- `builder:` in `MaterialApp.router` constrains width to 480dp — keeps mobile-first feel on desktop

### Rendering: CanvasKit

- Build flag `--web-renderer canvaskit` is mandatory for 60fps animation
- HTML renderer degrades animations to ~24fps on complex gradient scenes
- Fallback: `--web-renderer auto` uses HTML on mobile browsers, CanvasKit on desktop

---

## 🎨 Key Animations Implemented

| Animation | Where | Technique |
|---|---|---|
| Splash avatar scale-in | SplashScreen | `flutter_animate` `.scale()` with `elasticOut` |
| Hero profile card entrance | HomeScreen | `.fadeIn().slideY()` with stagger |
| Parallax background shapes | HomeScreen | `scrollOffset * 0.4` transform on `Positioned` |
| Orb "breathing" loop | SplashScreen, AnimatedShapes | `.animate(onPlay: repeat).scale()` |
| Bottom nav indicator slide | MainShell | `AnimatedAlign` with `easeInOutCubic` |
| Project card 3D flip | ProjectsScreen | `AnimationController` + `Matrix4.rotateY()` |
| Scroll-reveal entrance | ProjectsScreen, AboutScreen | `VisibilityDetector` → `AnimatedOpacity + AnimatedSlide` |
| Skill bar fill | AboutScreen | `AnimatedFractionallySizedBox` triggered on visibility |
| Theme mode toggle | MainShell top bar | `AnimatedAlign` pill + `AnimatedTheme` |
| Resume FAB morph | MainShell | `AnimatedSwitcher` icon + `AnimatedContainer` colour |
| Button hover scale | All CTAs | `MouseRegion` → `AnimatedContainer` transform |
| Success state bounce | ContactScreen | `.scale(elasticOut)` on checkmark card |

---

## 📋 Content Sources

> **"Content pulled from: resume, LinkedIn, GitHub"**

| Content piece | Source |
|---|---|
| Full name, email, phone, LinkedIn URL, GitHub URL | Resume (header) |
| Education: JSECE CGPA 9.43, HSC 93.17%, SSC 90.60% | Resume (Education section) |
| Experience: Evibe Solutions (Jun 2025–Present) | Resume (Experience section) |
| Experience: Protip / Pronion Fintech (Sep 2024–Jun 2025) | Resume (Experience section) |
| Experience: F13 Technologies AWS Intern (Dec 2023–Apr 2024) | Resume (Experience section) |
| Bullet points with metrics (98% crash-free, 40% CI/CD speed, etc.) | Resume verbatim |
| Projects: Protip, GoEV, Content Recommendation, PAW | Resume (Projects section) |
| Tech stack per project | Resume (Technologies listed per project) |
| Skills categories (Languages, Tools, Platforms) | Resume (Skills Summary) |
| Location: Bangalore, India | Resume + LinkedIn |
| Bio / elevator pitch copy | Synthesised from resume bullets (first-person) |
| GitHub repo live metadata (stars, language, last commit) | GitHub REST API v3 — `github.com/Azim04` |
| GitHub avatar (optional enhancement) | `https://github.com/Azim04.png` |
| LinkedIn profile URL | Resume header + prompt |

---

## ⚙️ Configuration Checklist

Before deploying:

- [ ] **Formspree form ID** — update `_kFormspreeId` in `lib/screens/contact_screen.dart`  
  (Sign up free at https://formspree.io, create a form, copy the ID)
- [ ] **Resume PDF** — place your PDF at `assets/resume/Azim_Resume.pdf` and update `pubspec.yaml`
- [ ] **App icons** — add `web/icons/Icon-192.png` and `web/icons/Icon-512.png` for PWA
- [ ] **Lottie animations** — download from LottieFiles and place at:
  - `assets/lottie/hero_bg.json`
  - `assets/lottie/success.json`
- [ ] **GitHub avatar** — optionally replace the `AS` initials badge with:
  ```dart
  CachedNetworkImage(
    imageUrl: 'https://github.com/Azim04.png',
    ...
  )
  ```

---

## 📦 Dependencies & Asset Licenses

| Package | Version | License |
|---|---|---|
| `flutter_animate` | 4.5.0 | MIT |
| `flutter_riverpod` | 2.5.1 | MIT |
| `go_router` | 13.2.0 | BSD-3 |
| `google_fonts` | 6.2.1 | Apache 2.0 (fonts per font license) |
| `lottie` | 3.1.0 | MIT |
| `cached_network_image` | 3.3.1 | MIT |
| `shimmer` | 3.0.0 | MIT |
| `url_launcher` | 6.2.5 | BSD-3 |
| `font_awesome_flutter` | 10.7.0 | MIT (icons: CC BY 4.0) |
| `visibility_detector` | 0.4.0 | BSD-3 |
| `http` | 1.2.1 | BSD-3 |
| `flutter_svg` | 2.0.10 | MIT |

**Google Fonts — Inter**: SIL Open Font License 1.1  
**Lottie JSON files**: Must be sourced with MIT/CC0 licence from LottieFiles.com  
**Font Awesome icons**: CC BY 4.0 (attribution provided in footer)

---

## 📝 Changelog

### v1.0.0 (2025-06)
- Initial release
- Mobile-first Flutter Web portfolio with app-like UX
- Dark / light mode toggle with animated transition
- 4-tab bottom navigation with sliding indicator + PageView swipe
- Animated splash screen
- Hero section with parallax shapes + profile card
- 3D flip project cards with live GitHub metadata
- Experience timeline with expandable bullet cards
- Animated skill progress bars (visibility-triggered)
- Contact form via Formspree + animated success state
- PWA manifest + service worker
- GitHub Actions CI (analyze + test + build)
- Widget tests: HomeScreen and ProjectsScreen

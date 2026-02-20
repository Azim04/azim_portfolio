# Design Tokens — Azim Portfolio

## Colour Palette

| Token            | Hex       | Usage                              |
|------------------|-----------|------------------------------------|
| `primary`        | `#6C63FF` | Buttons, active states, highlights |
| `primaryDark`    | `#4C46C8` | Hover press state                  |
| `secondary`      | `#00D9C5` | Gradient ends, accents             |
| `accent`         | `#FF6584` | Coral highlights, social icons     |
| `bgDark`         | `#0A0E1A` | Dark mode scaffold background      |
| `bgDark2`        | `#111526` | Layered dark surface               |
| `bgLight`        | `#F4F6FB` | Light mode scaffold background     |
| `surface`        | `#1A2035` | Cards, bottom nav (dark)           |
| `surfaceLight`   | `#FFFFFF` | Cards (light)                      |
| `success`        | `#2ECC71` | Status badges, skill meters high   |
| `warning`        | `#F39C12` | Caution states                     |
| `error`          | `#E74C3C` | Form validation, form error bar    |
| `textPrimary`    | `#F0F2FF` | Dark mode headings                 |
| `textSecondary`  | `#9BA3C5` | Dark mode body copy                |
| `textMuted`      | `#5A6282` | Placeholders, metadata             |
| `textDark`       | `#1A1A2E` | Light mode text                    |

## Typography Scale (Google Fonts — Inter)

| Style           | Size  | Weight | Letter Spacing | Line Height |
|-----------------|-------|--------|----------------|-------------|
| displayLarge    | 48sp  | 800    | −1.5           | 1.1         |
| displayMedium   | 36sp  | 700    | −1.0           | 1.2         |
| displaySmall    | 28sp  | 700    | −0.5           | 1.2         |
| headlineLarge   | 24sp  | 700    | −0.3           | —           |
| headlineMedium  | 20sp  | 600    | —              | —           |
| bodyLarge       | 15sp  | 400    | —              | 1.6         |
| bodyMedium      | 14sp  | 400    | —              | 1.5         |
| bodySmall       | 12sp  | 400    | —              | 1.5         |
| labelLarge      | 13sp  | 600    | 0.5            | —           |

Minimum body size for mobile readability: **14sp** ✓

## Spacing & Radius

| Token            | Value  | Usage                        |
|------------------|--------|------------------------------|
| radiusSmall      | 8dp    | Chips, small containers      |
| radiusMedium     | 14dp   | Buttons, input fields        |
| radiusLarge      | 20dp   | Cards                        |
| radiusXL         | 24–28dp| Feature cards                |
| radiusFull       | 32dp   | Bottom nav pill, avatar      |
| spacingXS        | 4dp    |                              |
| spacingS         | 8dp    |                              |
| spacingM         | 16dp   |                              |
| spacingL         | 24dp   |                              |
| spacingXL        | 32dp   |                              |
| spacingHero      | 48dp   | Section top padding          |

## Shadow Tokens

| Name           | Blur  | Y offset | Colour                                  |
|----------------|-------|----------|-----------------------------------------|
| cardElevation  | 16dp  | 4dp      | `primary.withOpacity(0.06)`             |
| cardHover      | 32dp  | 8dp      | `primary.withOpacity(0.25)`             |
| bottomNav      | 24dp  | 8dp      | `primary.withOpacity(0.25)` + black 30% |
| fabShadow      | 16dp  | 6dp      | `primary.withOpacity(0.35)`             |

## Animation Durations

| Motion           | Duration  | Curve                |
|------------------|-----------|----------------------|
| Micro-interaction | 180–200ms | easeOut              |
| Card hover        | 200–250ms | easeOut              |
| Nav indicator     | 300ms     | easeInOutCubic       |
| Card flip         | 500ms     | easeInOutBack        |
| Screen transition | 350ms     | easeOutCubic         |
| Skill bar fill    | 800–1200ms| easeOutCubic         |
| Stagger delta     | 80–150ms  | —                    |
| Splash avatar     | 700ms     | elasticOut            |
| Section reveal    | 500–700ms | easeOut              |
| Orb breathe loop  | 4000–7000ms| easeInOut (repeat)  |

## Lottie / SVG Assets

| File                        | Usage                            | Source / Notes               |
|-----------------------------|----------------------------------|------------------------------|
| `assets/lottie/hero_bg.json`| Hero section background loops   | LottieFiles (MIT / free)     |
| `assets/lottie/success.json`| Contact form success celebration | LottieFiles (MIT / free)     |

**Recommended free Lottie sources:**
- https://lottiefiles.com/animations/abstract-purple-gradient — hero bg
- https://lottiefiles.com/animations/success-checkmark — contact success

Download the `.json` files and place them in `assets/lottie/`.

## Recommended Replacements for Production

1. Replace `assets/lottie/hero_bg.json` placeholder with a real animated gradient Lottie.
2. Add a `assets/images/azim_avatar.jpg` (GitHub avatar or photo) and replace the `AS` initials badge in `_ProfileCard` with `CachedNetworkImage`.
3. Update `_kFormspreeId` in `contact_screen.dart` with your Formspree form ID.

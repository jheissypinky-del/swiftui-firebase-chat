---
name: Aura Chat
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#424656'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#727687'
  outline-variant: '#c2c6d8'
  surface-tint: '#0054d6'
  primary: '#0050cb'
  on-primary: '#ffffff'
  primary-container: '#0066ff'
  on-primary-container: '#f8f7ff'
  inverse-primary: '#b3c5ff'
  secondary: '#005ab3'
  on-secondary: '#ffffff'
  secondary-container: '#0073e0'
  on-secondary-container: '#fefcff'
  tertiary: '#006823'
  on-tertiary: '#ffffff'
  tertiary-container: '#00842f'
  on-tertiary-container: '#e6ffe0'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae1ff'
  primary-fixed-dim: '#b3c5ff'
  on-primary-fixed: '#001849'
  on-primary-fixed-variant: '#003fa4'
  secondary-fixed: '#d6e3ff'
  secondary-fixed-dim: '#aac7ff'
  on-secondary-fixed: '#001b3e'
  on-secondary-fixed-variant: '#00468d'
  tertiary-fixed: '#6cff82'
  tertiary-fixed-dim: '#47e266'
  on-tertiary-fixed: '#002106'
  on-tertiary-fixed-variant: '#00531a'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 41px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 25px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: -0.005em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system defines a high-end, tactile, and fluid iOS communication experience. The brand voice is crisp, intelligent, quiet, and hyper-responsive. Designed for discerning digital natives, professionals, and design-forward communicators, the interface evokes focus, privacy, and frictionless intimacy.

The visual direction merges **Minimalism** with tailored **iOS-native Glassmorphism**:
- Generous breathing room balances high information density in message streams.
- Optical depth is achieved through translucent frosted surfaces (`UIBlurEffect` / backdrop filters) layered over content, avoiding visual noise.
- Tactile feedback and elastic, fluid micro-interactions emulate natural physical dynamics under touch.
- High-contrast typography and precise alignment create an uncluttered, modern luxury feel.

## Colors

The color palette centers on an energetic sapphire blue that commands focus, supported by a system of frosted cool-gray foundations and deep ink contrasts.

- **Primary (`#0066FF`)**: Vibrant electric sapphire. Reserved strictly for key action points, active indicators, and outgoing message bubbles.
- **Secondary (`#0A84FF`)**: Lighter sapphire tint, deployed for subtle interactive states, link highlights, and media badges.
- **Tertiary (`#30D158`)**: High-visibility vitality green reserved for live availability statuses and subtle success feedback.
- **Neutral (`#0F172A`)**: Deep midnight slate. Serves as high-contrast primary typography rather than pure pitch black, preserving typographic softness.
- **Backgrounds & Tinted Surfaces**:
  - Base canvas: Pure `#FFFFFF` in standard views.
  - Secondary canvas: `#F5F7FB` for grouped tables, inactive bubble surfaces, and segmented controls.
  - Tertiary canvas: `#EEF2F8` for elevated utility panels, search bars, and swipe actions.

## Typography

The type system relies on **Plus Jakarta Sans** to echo the clean, friendly, yet rigorous geometry of Apple's modern rounded design language.

- **Scale & Hierarchy**: Navigation large titles use `headline-xl` (collapsing dynamically into `headline-sm` in inline navigation bars). Primary message content and user inputs strictly use `body-lg` (17px) to align directly with iOS standard legibility standards.
- **Numbers & Metadata**: Timestamps, read receipts, and micro badges leverage `label-sm` with slight positive tracking to ensure clarity at compact sizes.
- **Readability Rules**: All body text maintains optimized line heights (1.3× to 1.4×) to prevent dense text blocks inside conversation bubbles.

## Layout & Spacing

The layout philosophy mirrors native iOS ergonomics, prioritizing bottom-up thumb access, vertical content flow, and dynamic viewport accommodations.

- **Grid & Margins**: A single-column vertical layout bound by standard 16px (`1rem`) lateral screen margins. Larger iPad/tablet viewports switch to a fixed-width split-view pattern (sidebar 380px, thread pane dynamic).
- **Rhythm**: Spacing is calculated on a 4px/8px modular scale.
  - Consecutive messages from the same sender use tight grouping (`space-xs` / 4px).
  - Shifts in sender trigger wider spacing (`space-sm` / 8px to `space-md` / 12px).
  - New conversation clusters or date divisions employ `space-xl` (24px).
- **Safe Areas**: Strict adherence to the iOS Home Indicator and dynamic island/notch safe-area insets. Bottom action bars float with intrinsic margins or extend translucent materials seamlessly into the display edge.

## Elevation & Depth

Visual hierarchy is communicated through translucent optical layers, surface tiering, and hairline border separators rather than opaque drop shadows.

- **Level 0 (Canvas Base)**: Pure `#FFFFFF` or subtle backdrop `#F5F7FB`.
- **Level 1 (Incoming Content & Cells)**: Tonal resting surfaces using `#F5F7FB` with an imperceptible 0.5px border of `rgba(15, 23, 42, 0.04)`.
- **Level 2 (Glass Floating Shells - Navigation Bars, Tab Bars, Input Docks)**:
  - Background: `rgba(255, 255, 255, 0.78)` with `backdrop-filter: blur(24px) saturate(180%)`.
  - Border: 0.5px hairline stroke using `rgba(0, 0, 0, 0.08)` along edges meeting scrollable content.
- **Level 3 (Overlays, Modals, Action Sheets)**:
  - Background: `rgba(255, 255, 255, 0.92)` with `backdrop-filter: blur(36px)`.
  - Shadow: Ambient diffuse shadow `0 12px 32px -4px rgba(15, 23, 42, 0.08)`.
- **Active State Elevation**: Outgoing active sapphire bubbles carry a focused, colored glow: `0 4px 14px 0 rgba(0, 102, 255, 0.28)`.

## Shapes

The design system embraces deep organic curvature, fully rounded pill boundaries, and iOS continuous-corner squircles.

- **Pill Shapes (`roundedness: 3`)**: Applied to search fields, status indicators, counter badges, primary floating buttons, and standard outgoing/incoming conversation bubbles.
- **Chat Bubble Geometry**: 
  - Standard isolated bubbles adopt full 18px to 20px pill curvature.
  - Grouped consecutive bubbles employ asymmetric corner continuity: the contiguous corner collapses to a subtle 4px radius while exterior corners preserve full pill curvature.
- **Interactive Sheets & Floating Modals**: Top corners use a soft squircle radius of 24px (`rounded-lg`).

## Components

### Message Bubbles
- **Outgoing**: Tinted in primary `#0066FF` with white text. High contrast, sharp legibility, and pill corners. Trailing status markers (sending, sent, read) sit inline at `11px` with `0.8` opacity.
- **Incoming**: Background tinted `#EEF2F8` with `#0F172A` text. 0.5px inset border of `rgba(15, 23, 42, 0.03)`.
- **Reactions**: Pill badges hovering on bubble edges with a `backdrop-filter: blur(12px)`, subtle bounce animation upon interaction, and 1px border `rgba(255, 255, 255, 0.6)`.

### Input Accessory Dock
- **Container**: Anchored to keyboard top with a glassmorphic bar (`backdrop-filter: blur(20px)`), containing attachments, dynamic expanding text field, and voice/send action.
- **Text Field**: Encapsulated within an inner pill surface (`#F5F7FB`), padding 8px 16px, auto-expanding vertically up to 5 lines before activating internal scroll.
- **Send Trigger**: Collapsed into an animated micro-button; shifts from audio-record icon to an electric blue pill send-arrow when character count > 0.

### Navigation Bars & Headers
- Native iOS split design: starts as Large Title with back navigation and contact avatar, transitioning smoothly via scroll offset to an inline title with status subtitle (`Active Now`, `typing...`).

### Conversation List Items
- Clean single-line divider inset by 76px (aligning past avatar margin).
- Left: 52px circular avatar with subtle 1.5px ring for presence status (`#30D158`).
- Center: Title in `headline-sm`, truncated preview in `body-md` slate gray.
- Right: Timestamp in `label-sm` with unread count pill badge (`#0066FF`, white bold text).

### Chips & Context Filters
- 32px height pill containers with `#F5F7FB` background and 13px label weight.
- Selected state smoothly transitions to solid `#0066FF` background with pure white text and 0.2s spring scale feedback (`scale(0.96)` on touch-down).
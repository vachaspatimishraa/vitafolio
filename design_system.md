# Vitafolio Core Design System

**Name**: Vitafolio Core  
**ID**: `assets/824b173a0e9a44d8928a43c4b4a66b9e`  
**Color Mode**: LIGHT  
**Primary Color**: `#004ac6` (`#2563eb` container)  

---

## Brand & Style Guidelines

The brand identity is built on the pillars of **precision, transparency, and professional utility**. Targeted at high-performance individuals and organizations, the design system avoids decorative fluff in favor of functional elegance. 

The aesthetic is a synthesis of **Modern Minimalism and Systematic Design**, drawing inspiration from industry leaders like Linear and Stripe. It prioritizes information density without clutter, utilizing generous whitespace and a rigid grid to create a sense of calm authority. There are no gradients or blurs; instead, the UI relies on sharp contrast, meticulous typography, and subtle tonal shifts to guide the user. The emotional response should be one of "effortless productivity."

---

## Colors & Palette Tokens

```yaml
surface: '#f8f9fa'
surface-dim: '#d9dadb'
surface-bright: '#f8f9fa'
surface-container-lowest: '#ffffff'
surface-container-low: '#f3f4f5'
surface-container: '#edeeef'
surface-container-high: '#e7e8e9'
surface-container-highest: '#e1e3e4'
on-surface: '#191c1d'
on-surface-variant: '#434655'
inverse-surface: '#2e3132'
inverse-on-surface: '#f0f1f2'
outline: '#737686'
outline-variant: '#c3c6d7'
surface-tint: '#0053db'
primary: '#004ac6'
on-primary: '#ffffff'
primary-container: '#2563eb'
on-primary-container: '#eeefff'
inverse-primary: '#b4c5ff'
secondary: '#575e70'
on-secondary: '#ffffff'
secondary-container: '#d9dff5'
on-secondary-container: '#5c6274'
tertiary: '#4e5562'
on-tertiary: '#ffffff'
tertiary-container: '#666d7b'
on-tertiary-container: '#eaf0ff'
error: '#ba1a1a'
on-error: '#ffffff'
error-container: '#ffdad6'
on-error-container: '#93000a'
background: '#f8f9fa'
on-background: '#191c1d'
surface-variant: '#e1e3e4'
```

---

## Typography

- **Font Family**: Inter (Primary), JetBrains Mono (Technical/Utility)
- **display-lg**: 30px / 700 / line-height: 36px / letter-spacing: -0.02em
- **display-lg-mobile**: 26px / 700 / line-height: 32px / letter-spacing: -0.01em
- **headline-md**: 20px / 600 / line-height: 28px / letter-spacing: -0.01em
- **tagline**: 16px / 500 / line-height: 24px
- **body-base**: 14px / 400 / line-height: 20px
- **label-sm**: 12px / 500 / line-height: 16px / letter-spacing: 0.01em
- **mono-label**: JetBrains Mono 11px / 500 / line-height: 14px

---

## Layout, Spacing & Border Radius

- **Grid Unit**: 4px
- **Spacing**:
  - `xs`: 4px
  - `sm`: 8px
  - `md`: 16px
  - `lg`: 24px
  - `xl`: 32px
  - `gutter`: 16px
  - `margin-mobile`: 16px
  - `margin-desktop`: 48px
- **Border Radius**:
  - `sm`: 2px (0.125rem)
  - `DEFAULT`: 4px (0.25rem)
  - `md`: 6px (0.375rem)
  - `lg`: 8px (0.5rem)
  - `xl`: 12px (0.75rem)
  - `full`: 9999px

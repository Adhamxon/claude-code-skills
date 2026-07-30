---
name: web-accessibility
description: Web Accessibility (a11y) — WCAG 2.1/2.2 standards, ARIA, semantic HTML, keyboard navigation, screen readers, color contrast, focus management, testing. Use when building accessible web applications or auditing existing ones.
---

# Web Accessibility Skill

## WCAG 2.1/2.2 Levels

| Level | Description | Target |
|-------|-------------|--------|
| **A** | Minimum: keyboard nav, alt text, color contrast | Must pass |
| **AA** | Acceptable: focus order, resize text, consistent nav | Should pass |
| **AAA** | Optimal: sign language, extended descriptions | Best effort |

## Semantic HTML (Foundation)

```html
<!-- ❌ Bad: div soup -->
<div class="header">
  <div class="nav">
    <div onclick="..." tabindex="0">Home</div>
  </div>
</div>

<!-- ✅ Good: Semantic -->
<header>
  <nav aria-label="Main">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>
<main>
  <article>
    <h1>Page Title</h1>
    <section aria-labelledby="section-heading">
      <h2 id="section-heading">Section Title</h2>
    </section>
  </article>
</main>
<footer>...</footer>
```

### Landmarks
```html
<header role="banner">
<nav role="navigation" aria-label="Main navigation">
<main role="main">
<aside role="complementary">
<footer role="contentinfo">
<form role="search">
<section aria-labelledby="section-title">
```

## ARIA (Accessible Rich Internet Applications)

### ARIA Rules (No ARIA is better than Bad ARIA)
1. Don't use ARIA if native HTML works: `<button>` not `<div role="button">`
2. Don't override native semantics: `<h1 role="button">` is wrong
3. All interactive ARIA elements must be keyboard accessible
4. ARIA labels must be concise and meaningful

### Common ARIA Patterns
```html
<!-- Button with tooltip -->
<button aria-describedby="tooltip-1">Save</button>
<div id="tooltip-1" role="tooltip" hidden>Save the current document</div>

<!-- Tabs -->
<div role="tablist" aria-label="Settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1">General</button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2">Advanced</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">...</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>...</div>

<!-- Modal Dialog -->
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Confirm Delete</h2>
  <p id="dialog-desc">Are you sure you want to delete this item?</p>
  <button autofocus>Cancel</button>
  <button>Delete</button>
</div>

<!-- Live Region (dynamic updates) -->
<div aria-live="polite" aria-atomic="true">
  Cart updated: 3 items
</div>
<div role="alert">Error: Connection lost</div>
```

## Keyboard Accessibility

### Focus Management
```tsx
// Focus trap for modals
const Modal: React.FC<{ isOpen: boolean; onClose: () => void }> = ({ isOpen, onClose }) => {
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!isOpen) return;
    const previousFocus = document.activeElement as HTMLElement;
    modalRef.current?.focus();

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
      if (e.key === 'Tab') {
        // Focus trap logic
        const focusable = modalRef.current?.querySelectorAll<HTMLElement>(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );
        if (!focusable || focusable.length === 0) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (e.shiftKey && document.activeElement === first) { last.focus(); e.preventDefault(); }
        else if (!e.shiftKey && document.activeElement === last) { first.focus(); e.preventDefault(); }
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
      previousFocus?.focus();
    };
  }, [isOpen, onClose]);

  return (
    <div ref={modalRef} tabIndex={-1} role="dialog" aria-modal="true">
      ...
    </div>
  );
};
```

### Skip Link
```html
<!-- First focusable element on page -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px;
  z-index: 100;
}
.skip-link:focus {
  top: 0;
}
</style>
```

## Color & Contrast

### Contrast Ratios
```css
/* AA (minimum) */
.normal-text { color: #4a4a4a; }           /* #4a4a4a on white = 5.1:1 ✓ */
.large-text  { color: #6b6b6b; }           /* ≥18px bold or ≥24px, 3:1 ✓ */

/* AAA (enhanced) */
.normal-text-aaa { color: #333; }          /* #333 on white = 9.6:1 ✓ */

/* Tools: WebAIM Contrast Checker, axe DevTools, Stark plugin */
```

### Don't Rely on Color Alone
```html
<!-- ❌ Bad: Only color indicates error -->
<span style="color: red;">Invalid email</span>

<!-- ✅ Good: Icon + text + color -->
<span style="color: red;">
  <span aria-hidden="true">⚠️</span>
  <span>Invalid email address</span>
</span>
```

## Screen Reader Testing

### Testing Checklist
```html
<!-- Alt text for images -->
<img src="chart.png" alt="Revenue grew 20% in Q2 2025, reaching $1.2M" />

<!-- Context for links (don't use "click here") -->
<!-- ❌ Bad --> <a href="/report">Click here</a> for the full report
<!-- ✅ Good --> <a href="/report">View full report</a>

<!-- Hidden but accessible labels -->
<button aria-label="Close dialog">✕</button>

<!-- Form labels (every input needs a label) -->
<label for="search">Search</label>
<input id="search" type="search" aria-describedby="search-hint" />
<span id="search-hint">Search by name, email, or phone number</span>

<!-- Error association -->
<input aria-invalid="true" aria-describedby="email-error" />
<span id="email-error" role="alert">Please enter a valid email</span>
```

## Accessible Forms
```tsx
interface FormFieldProps {
  label: string;
  error?: string;
  required?: boolean;
  hint?: string;
}

const FormField: React.FC<FormFieldProps & InputHTMLAttributes<HTMLInputElement>> = ({
  label, error, required, hint, id = crypto.randomUUID(), ...props
}) => (
  <div>
    <label htmlFor={id}>
      {label}
      {required && <span aria-hidden="true"> *</span>}
    </label>
    {hint && <span id={`${id}-hint`}>{hint}</span>}
    <input
      id={id}
      aria-required={required}
      aria-invalid={!!error}
      aria-describedby={[hint && `${id}-hint`, error && `${id}-error`].filter(Boolean).join(' ')}
      {...props}
    />
    {error && <span id={`${id}-error`} role="alert">{error}</span>}
  </div>
);
```

## Automated Accessibility Testing
```typescript
// axe-core with Playwright
import { injectAxe, checkA11y } from 'axe-playwright';

test('main page should be accessible', async ({ page }) => {
  await page.goto('/');
  await injectAxe(page);
  
  const results = await checkA11y(page, null, {
    includedImpacts: ['critical', 'serious'],
    rules: { 'color-contrast': { enabled: true } },
  });
  
  expect(results.violations).toHaveLength(0);
});

// CI integration
// npx axe --exit --chrome-flags="--headless" https://example.com
```

## Reduced Motion
```css
/* Respect user preferences */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

/* Conditional animation */
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
if (!prefersReducedMotion) {
  element.animate(keyframes, { duration: 300 });
}
```

## Accessibility Checklist
- [ ] Semantic HTML (header, nav, main, article, footer)
- [ ] Alt text for all images (informative, functional, decorative)
- [ ] Proper heading hierarchy (h1 → h6, no skipping)
- [ ] All interactive elements keyboard accessible (Tab, Enter, Space, Escape)
- [ ] Focus indicators visible (outline: 2px, not outline: none)
- [ ] Color contrast ≥ 4.5:1 (AA) for normal text
- [ ] Form inputs have labels (explicit/implicit)
- [ ] Error messages associated with inputs (aria-describedby)
- [ ] Live regions for dynamic content (aria-live)
- [ ] Skip link available
- [ ] Touch targets ≥ 44x44px (mobile)
- [ ] Zoom to 200% without loss of content

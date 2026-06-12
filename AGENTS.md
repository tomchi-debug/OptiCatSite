# OptiCat — Digital Product Catalog

## Overview
OptiCat is a modern, fast, searchable digital product catalog built for Swedish HVAC (VVS) and refrigeration wholesalers. It replaces static PDF catalogs and Excel spreadsheets with a responsive web application.

## Tech Stack
- **Framework:** Astro v4.10+ (static site generation with SSR via `hybrid` output mode)
- **Hosting:** Netlify (deployed via `@astrojs/netlify` adapter)
- **Styling:** Vanilla CSS with CSS custom properties (design tokens)
- **Payment:** Stripe (prepared for Checkout integration)
- **Language:** TypeScript (strict mode)
- **Content:** Swedish (sv)

## Project Structure
```
src/
├── layouts/
│   └── Layout.astro          # Global layout: head, fonts, navigation, footer, scroll-reveal
├── components/
│   ├── Header.astro           # Sticky nav with logo, links, CTA button
│   ├── Hero.astro             # Landing hero with animated search mockup + feature band
│   ├── PainPoints.astro       # Three-column pain-point section
│   ├── Features.astro         # Six-feature grid (F-01 through F-06)
│   ├── Steps.astro            # Three-step "how it works" section
│   ├── CTA.astro              # Call-to-action section with demo booking
│   ├── Footer.astro           # Simple footer with copyright
│   └── Modal.astro            # Reusable dialog modal component
├── pages/
│   ├── index.astro            # Home page (Hero + PainPoints + CTA)
│   ├── funktioner.astro       # Features page (page header + Features + CTA)
│   ├── om-oss.astro           # About page (values: speed, simplicity, precision)
│   └── butik.astro            # Shop/pricing page (3 tiers: Starter, Pro, Enterprise)
├── env.d.ts                   # TypeScript environment declarations
```

## Design System
- **CSS Custom Properties** in global layout:
  - Colors: `--stal` (dark), `--frost` (bg), `--vit` (white), `--plat` (border), `--kyla` (blue), `--varme` (orange)
  - Gradient: `--gradient` (blue → orange)
  - Layout: `--max` (1140px), `--radius` (10px)
- **Typography:** Archivo (headings), IBM Plex Sans (body), IBM Plex Mono (code/technical data)
- **Responsive:** Mobile-first with breakpoints at 768px, 900px, 1000px
- **Motion:** `prefers-reduced-motion` respected; scroll-reveal via IntersectionObserver
- **Accessibility:** `focus-visible` outlines, semantic HTML, `aria-hidden` on decorative elements

## Pages
| Route | Title | Key Content |
|-------|-------|-------------|
| `/` | Home | Hero with search mockup, PainPoints, CTA |
| `/funktioner` | Features | Feature list + extra features section |
| `/om-oss` | About | Team info + values cards |
| `/butik` | Shop/Pricing | 3-tier pricing cards with Stripe button stub |

## Development
- `npm run dev` / `npm start` — Start dev server (opens browser at localhost:4321)
- `npm run build` — Build for production (output to `dist/`)
- `npm run preview` — Preview production build
- Deployment: Netlify auto-deploys from `main` branch

## Environment Variables
- `STRIPE_PUBLIC_KEY` — Stripe publishable key (frontend)
- `STRIPE_SECRET_KEY` — Stripe secret key (backend)
- `STRIPE_SUCCESS_URL` — Post-checkout redirect
- `STRIPE_CANCEL_URL` — Cancel checkout redirect

## Patterns & Conventions
- Astro islands architecture: no client-side framework (vanilla JS for interactivity)
- Components use `---` frontmatter for data, `client:load` or inline `<script>` for JS
- Sections use `.wrap` container for max-width constraint
- Reusable patterns: `.eyebrow` label, `.btn` / `.btn-primary` / `.btn-ghost` buttons
- Components use `reveal` class for scroll-triggered animations

## Future Scope (from README)
- RSK number search and product filtering
- Customer-specific pricing with login
- Product documents (datasheets, certificates)
- Statistics & insights dashboard
- Quote export to ERP systems

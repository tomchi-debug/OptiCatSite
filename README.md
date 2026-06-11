# OptiCat – Digital Produktkatalog

OptiCat är en modern, snabb och sökbar digital produktkatalog byggd specifikt för svenska VVS- och kylgrossister. Den ersätter tunga PDF-kataloger och statiska Excel-listor med ett levande arbetsverktyg som fungerar på alla enheter.

## 🚀 Teknikstack

- **Ramverk:** [Astro](https://astro.build/) (v4.10+)
- **Hosting:** [Netlify](https://www.netlify.com/)
- **Styling:** Vanilla CSS (Modulariserad)
- **E-handel:** [Stripe](https://stripe.com/) (Förberedd för Checkout)

## 📁 Projektstruktur

Projektet följer en modulär multi-page-arkitektur:

- `src/layouts/` - Global layout med gemensam head, styling och navigering.
- `src/components/` - Återanvändbara UI-komponenter (Hero, Features, Modals, etc.).
- `src/pages/` - Alla undersidor (Hem, Funktioner, Om oss, Butik).
- `public/` - Statiska tillgångar som bilder och favicon.

## 🛠 Installation & Utveckling

För att köra projektet lokalt:

1. **Klona repot:**
   ```bash
   git clone https://github.com/tomchi-debug/OptiCatSite.git
   cd OptiCatSite
   ```

2. **Installera beroenden:**
   ```bash
   npm install
   ```

3. **Konfigurera miljövariabler:**
   Kopiera `.env.example` till `.env` och fyll i dina Stripe-nycklar:
   ```bash
   cp .env.example .env
   ```

4. **Starta utvecklingsservern:**
   ```bash
   npm run dev
   ```
   *Webbläsaren öppnas automatiskt på http://localhost:4321*

## 🚢 Deployment

Projektet är förkonfigurerat för Netlify via `netlify.toml`. Vid push till `main`-branchen kommer Netlify automatiskt att bygga och publicera webbplatsen.

## 💳 Stripe-integration

För att aktivera full funktionalitet i butiken:
1. Skapa ett konto på [Stripe](https://dashboard.stripe.com/).
2. Lägg till din `STRIPE_PUBLIC_KEY` och `STRIPE_SECRET_KEY` i Netlifys miljövariabler eller i din lokala `.env`.

---

© 2026 OptiCat · Malmö, Sverige

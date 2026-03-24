# Website Implementation Results

## What was created in `src/website/`

| Area | Files |
|------|-------|
| **Project config** | `package.json`, `tsconfig.json`, `vite.config.ts`, `.env`, `.env.example` |
| **Entry points** | `index.html`, `src/main.tsx`, `src/App.tsx` |
| **Components** | `Header`, `Footer`, `HandoutsList`, `HandoutItem`, `Loader`, `ErrorMessage` (each with CSS modules) |
| **Services** | `src/utils/handouts-service.ts` — fetches from local manifest or Azure Storage |
| **Styles** | `src/styles/global.css` — CSS variables with light/dark theme via `prefers-color-scheme` |
| **Build script** | `scripts/generate-manifest.mjs` — generates `handouts.json` from the `handouts/` folder |

## Key features

- **Dual data source**: Local `handouts.json` manifest for dev; Azure Blob Storage REST API for production
- **Responsive & accessible**: Semantic HTML, ARIA attributes, skip links, keyboard navigation, mobile-friendly
- **Light/dark theme**: Automatic via CSS variables and `prefers-color-scheme`
- **File icons**: Auto-detected by extension (PDF, Word, Excel, images, etc.)

## Run locally

```bash
cd src/website
npm run dev       # starts dev server on port 3000
npm run build     # generates manifest + production build
```

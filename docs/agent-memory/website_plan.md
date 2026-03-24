# Website Plan for Lyle's Handouts Website

## 1. Project Structure

- Create the React application in `src/website`.
- Use TypeScript for all code.
- Organize files by feature (e.g., components, pages, utils, styles).
- Use a modular folder structure for scalability.

### Example Structure
- src/website/
  - components/
  - pages/
  - utils/
  - styles/
  - App.tsx
  - main.tsx
  - index.html

---

## 2. Application Features

### a. Dynamic Handout Listing
- Automatically list all files in the handouts folder.
- No manual code changes required when new files are added.
- Support for both local handouts folder and Azure Storage blob container as sources.

### b. Responsive UI
- Use CSS (with CSS modules or styled-components) for styling.
- Ensure the site is mobile-friendly and looks good on all devices.

### c. Accessibility
- Use semantic HTML and ARIA attributes for accessibility.

---

## 3. Handouts Data Source

### a. Local Development
- Read the contents of the local handouts/ folder at build or runtime.
- For static hosting, use a build script to generate a manifest (e.g., handouts.json) listing all files.

### b. Production (Azure)
- List files from an Azure Storage blob container using the Azure Storage REST API or SDK.
- Ensure the website can read the blob container (public access or via SAS token).

---

## 4. Core Components

- HandoutsList: Displays the list of handout files as links.
- HandoutItem: Represents a single handout file.
- Header/Footer: Basic site layout.
- Loader/Error: For loading and error states.

---

## 5. Routing

- Use React Router (or similar) for navigation if multiple pages are needed (e.g., About, Contact).
- For a single-page site, keep navigation simple.

---

## 6. Styling

- Use CSS modules or scoped CSS for component styles.
- Ensure consistent spacing, colors, and typography.
- Test light/dark mode if desired.

---

## 7. Azure Integration

- Prepare for deployment to Azure Static Web Apps.
- Ensure the app can read from the Azure Storage blob container.
- Store configuration (e.g., storage URL, SAS token) in environment variables.

---

## 8. Deployment

- Use Bicep files in `infra/bicep` to:
  - Create Azure Storage account for handouts.
  - Create Azure Static Web App for the website.
  - Set up permissions for the Static Web App to read from Storage.
- Follow the structure and conventions from the dadabase.demo repo.

---

## 9. CI/CD

- Provide GitHub Actions and Azure DevOps pipeline templates for:
  - Building the React app.
  - Deploying to Azure Static Web Apps.
  - Deploying Bicep infrastructure.
- Pipelines should be manual trigger only.

---

## 10. Documentation

- Document setup, configuration, and deployment steps in the repo.
- Include instructions for adding new handouts and updating the site.

---

## 11. Testing

- Add basic tests for core components (optional, as per requirements).
- Ensure the handouts listing works with both local and Azure sources.

---

This plan provides a clear roadmap for building the application, ensuring it meets all requirements for static hosting, dynamic handout listing, Azure deployment, and maintainability.
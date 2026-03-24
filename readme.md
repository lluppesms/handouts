<div align="center">
  <h1>Lyle's Handouts Website</h1>
  <p><strong>Dynamic, cloud-ready handout distribution for educators</strong></p>
  <img src="https://img.shields.io/badge/React-19-blue?logo=react" alt="React 19" />
  <img src="https://img.shields.io/badge/TypeScript-5.7-blue?logo=typescript" alt="TypeScript 5.7" />
  <img src="https://img.shields.io/badge/Azure%20Static%20Web%20Apps-blue?logo=microsoftazure" alt="Azure Static Web Apps" />
  <img src="https://img.shields.io/badge/Bicep-infra-blue?logo=microsoftazure" alt="Bicep" />
</div>

---

## ✨ Overview

Lyle's Handouts Website is a modern, static web app for distributing class handouts and reference files. Designed for educators, it automatically lists all files in your handouts folder—no code changes required when you add new files! Host locally or in the cloud (Azure), with a responsive, accessible UI built in React + TypeScript.

---

## 🚀 Features

- **Automatic handout listing**: Drop files in the `handouts/` folder—links appear instantly on the site
- **Dual-source support**: Serve handouts from local folder (dev) or Azure Blob Storage (prod)
- **Responsive & accessible**: Mobile-friendly, semantic HTML, ARIA, keyboard navigation
- **Light/dark theme**: Adapts to user preference
- **File icons & metadata**: Auto-detects file type, shows size and last modified date
- **No backend required**: 100% static, deploy anywhere

---

## 🏗️ Project Structure

```
├── handouts/           # Place your handout files here
├── src/website/        # React + TypeScript app
│   ├── components/     # UI components
│   ├── utils/          # Handout fetching logic
│   ├── styles/         # Global and modular CSS
│   ├── scripts/        # Manifest generator for dev
│   └── ...
├── infra/bicep/        # Azure Bicep IaC modules
├── .github/workflows/  # GitHub Actions CI/CD
├── .azure/pipelines/   # Azure DevOps pipelines
└── docs/               # Architecture & deployment docs
```

---

## 🖥️ Local Development

1. Clone the repo and install dependencies:
   ```bash
   cd src/website
   npm install
   npm run dev
   ```
2. Add files to `handouts/` and refresh—links appear automatically!

---

## ☁️ Cloud Deployment

- **Azure Static Web Apps** + **Azure Storage** (Blob):
  - Infrastructure as Code with Bicep (`infra/bicep/`)
  - Deploy via GitHub Actions, Azure DevOps, or `azd up`
  - See [infra/bicep/workflows-readme.md](infra/bicep/workflows-readme.md) for pipeline details

---

## 🛠️ Infrastructure Highlights

- Modular Bicep: Storage Account, Static Web App, RBAC
- Secure: OIDC for GitHub Actions, no stored secrets
- Follows [dadabase.demo](https://github.com/lluppesms/dadabase.demo/) best practices

---

## 📄 Example Handouts

- [Getting-Started-Guide.md](handouts/Getting-Started-Guide.md)
- [Sample-Handout.txt](handouts/Sample-Handout.txt)

---

## 📚 Documentation

- [Website Plan](docs/agent-memory/website_plan.md)
- [Bicep Implementation](docs/agent-memory/bicep_implementation.md)
- [Deployment Pipelines](docs/agent-memory/deployment_pipelines_plan.md)

---

## 🤝 Contributing

Pull requests welcome! See [dadabase.demo](https://github.com/lluppesms/dadabase.demo/) for code style and workflow conventions.

---

## 📝 License

MIT License. See [LICENSE](LICENSE) if present.

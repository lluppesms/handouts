# Prompts to create Lyle's Handouts Website

---

# Planning Prompts

I used these first three prompts with agent modes to create the plans for the website, infrastructure, and deployment pipelines. The plans were stored in the `docs/agent-memory` folder for future reference.

---

### Plan for the website

Select the Expert React Frontend Engineer Agent Mode:

> Using the instructions in #readme.md, come up with a plan for creating the React application for Lyle's Handouts Website. Do not write any code yet, just create a plan for how to build the application. Include enough details that an agent or developer could follow the plan to build the application.
Store the plan in a markdown file called `website_plan.md` in the `docs/agent-memory` folder for future reference.

---

### Plan for the infrastructure

Select the Bicep Planning expert

> Using the instructions in #readme.md, come up with a plan for creating the Bicep files for Lyle's Handouts Website. Do not write any code yet, just create a plan for how to build the infrastructure. Include enough details that an agent or developer could follow the plan to build the infrastructure.
Store the plan in a markdown file called `infrastructure_plan.md` in the `docs/agent-memory` folder for future reference.

---

### Plan for deployment pipelines

Select the DevOps Pipeline Planning expert

> Using the instructions in #readme.md, come up with a plan for creating the deployment pipelines for Lyle's Handouts Website. Do not write any code yet, just create a plan for how to build the deployment pipelines. Include enough details that an agent or developer could follow the plan to build the deployment pipelines.
Store the plan in a markdown file called `deployment_pipelines_plan.md` in the `docs/agent-memory` folder for future reference.

---

# Implementation Prompts

I switched over to GHCP in Command line mode, then used these next three prompts to read plans for the website, infrastructure, and deployment pipelines and do the implementation. The results summary files were stored in the `docs/agent-memory` folder for future reference.

---

### Implement the website plan

Select Autopilot mode

> Look at the `website_plan.md` file and implement the plan for creating the React application for Lyle's Handouts Website. Put the code for the React application in the `src/website` folder.
Store the summary output in the `docs/agent-memory/website_implementation_results.md` file.

---

### Implement the infrastructure plan

Select Autopilot mode

> Look at the `infrastructure_plan.md` file and implement the plan for creating the Bicep files for Lyle's Handouts Website. Put the code for the Bicep files in the `infra/bicep` folder.
Store the summary output in the `docs/agent-memory/infrastructure_implementation_results.md` file.

---

### Implement the deployment pipelines plan

Select Autopilot mode

> Look at the `deployment_pipelines_plan.md` file and implement the plan for creating the deployment pipelines for Lyle's Handouts Website. Put the code for the deployment pipelines in the `.azure/pipelines` folder and the `.github/workflows` folder.
Store the summary output in the `docs/agent-memory/deployment_pipelines_implementation_results.md` file.

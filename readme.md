# Lyle's Handouts Website

## Purpose

I want to build a website that will contain handout and reference files to give to students in the classes that I teach.

I would like to have this is as a static website if possible, so that I can host it anywhere, and not have to worry about server-side code or databases.  The app will use JavaScript to dynamically generate the links to the handout files.

Handouts will be placed in a `handouts` folder, and the website will automatically and dynamically generate links to these files.  If I put new files in the folder, then they will automatically appear on the website without needing to change any code.  

The handouts folder could live inside the website, or it could be an Azure Storage blob container. The website will be able to read the contents of the handouts folder and generate links to the files.

## Application Architecture

The application should be created as a React application, and should be built using TypeScript.  The website should be styled using CSS, and should be responsive so that it looks good on both desktop and mobile devices.

The application files should live in the src/website folder.

## Deployment

The application should be deployed to Azure using Bicep files.  The bicep files should live in the infra/bicep folder. The bicep files should create an Azure Storage account to host the handouts, and should also create an Azure Static Web App to host the website.  The bicep files should also set up the necessary permissions for the Static Web App to read from the Storage account.

The user should be able to deploy the application using Azure DevOps Pipelines or GitHub Actions or an `azd up` command.  The pipelines should be set to run only when triggered manually by the user..

## References

Refer to the [dadabase.demo](https://github.com/lluppesms/dadabase.demo/) repository and use that as an example for structuring the Azure Bicep Files, Azure DevOps Pipelines, GitHub Actions, and AZD. That repo should be treated as the golden code for how to create the deployment files in this repository.

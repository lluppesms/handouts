# More Notes / TODO List

## TODO

I need to make FOLDERS for each client in this application, and then put the handouts for each client in their respective folders.  The website should then generate links to the handouts for each client, organized by folder.  So there will be a folder for Client A, and a folder for Client B, and the website will show the handouts for each client under their respective sections, but **NOT** show the folder structure itself.  The folder structure is just for organizational purposes on the backend, but the website will present a clean list of handouts organized by client.  Security by Obsucurity: The folder names will not be shown on the website, so it will be harder for someone to guess the URLs of the handouts if they don't know the folder structure.  The website will just show the handout names as links, without showing the folder structure.

## ⚠️ Important WARNING FROM CP

> One important caveat: The managed identity is used by the SWA's serverless API functions (if any). The browser-side React app running client-side cannot use managed identity directly — it would need to call a backend API/function that uses the identity to fetch/proxy blobs from storage. If your app is purely a static React frontend with no API functions, you'll need to generate SAS tokens server-side for file downloads.

I may need to rethink the architecture if I want to use managed identity, since the React app won't be able to use it directly.  I may need to create an API function that uses the managed identity to generate SAS tokens for the React app to use when accessing the blob storage. Or -- switch to storing internally and create an upload page.
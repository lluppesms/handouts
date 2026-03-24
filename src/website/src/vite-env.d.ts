/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_HANDOUTS_SOURCE: 'local' | 'azure';
  readonly VITE_AZURE_STORAGE_URL: string;
  readonly VITE_AZURE_CONTAINER_NAME: string;
  readonly VITE_AZURE_SAS_TOKEN: string;
  readonly VITE_MANIFEST_URL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

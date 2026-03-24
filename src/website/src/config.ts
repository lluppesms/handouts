import type { AppConfig } from './types';

export const config: AppConfig = {
  source: (import.meta.env.VITE_HANDOUTS_SOURCE as 'local' | 'azure') || 'local',
  azureStorageUrl: import.meta.env.VITE_AZURE_STORAGE_URL || '',
  azureContainerName: import.meta.env.VITE_AZURE_CONTAINER_NAME || 'handouts',
  azureSasToken: import.meta.env.VITE_AZURE_SAS_TOKEN || '',
  manifestUrl: import.meta.env.VITE_MANIFEST_URL || '/handouts.json',
};

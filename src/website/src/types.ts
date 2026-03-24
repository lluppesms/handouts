export interface HandoutFile {
  name: string;
  url: string;
  size?: number;
  lastModified?: string;
}

export interface AppConfig {
  source: 'local' | 'azure';
  azureStorageUrl?: string;
  azureContainerName?: string;
  azureSasToken?: string;
  manifestUrl: string;
}

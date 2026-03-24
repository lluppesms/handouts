import type { HandoutFile } from '../types';
import { config } from '../config';

/**
 * Fetches handout files from the local manifest (handouts.json).
 */
async function fetchLocalHandouts(): Promise<HandoutFile[]> {
  var response = await fetch(config.manifestUrl);
  if (!response.ok) {
    throw new Error(`Failed to load handouts manifest: ${response.statusText}`);
  }
  var files: HandoutFile[] = await response.json();
  return files;
}

/**
 * Fetches handout files from an Azure Storage blob container.
 * Uses the Azure Blob Storage REST API to list blobs.
 */
async function fetchAzureHandouts(): Promise<HandoutFile[]> {
  var baseUrl = config.azureStorageUrl?.replace(/\/$/, '');
  var container = config.azureContainerName || 'handouts';
  var sasToken = config.azureSasToken || '';

  var separator = sasToken.startsWith('?') ? '' : '?';
  var listUrl = `${baseUrl}/${container}?restype=container&comp=list${sasToken ? `&${sasToken.replace(/^\?/, '')}` : ''}`;

  var response = await fetch(listUrl);
  if (!response.ok) {
    throw new Error(`Failed to list Azure blobs: ${response.statusText}`);
  }

  var xmlText = await response.text();
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(xmlText, 'application/xml');
  var blobs = xmlDoc.querySelectorAll('Blob');

  var files: HandoutFile[] = [];
  blobs.forEach((blob) => {
    var name = blob.querySelector('Name')?.textContent;
    if (name) {
      var blobUrl = `${baseUrl}/${container}/${encodeURIComponent(name)}${separator}${sasToken.replace(/^\?/, '')}`;
      var size = blob.querySelector('Content-Length')?.textContent;
      var lastModified = blob.querySelector('Last-Modified')?.textContent;
      files.push({
        name,
        url: blobUrl,
        size: size ? parseInt(size, 10) : undefined,
        lastModified: lastModified || undefined,
      });
    }
  });

  return files;
}

/**
 * Fetches handout files from the configured source (local or Azure).
 */
export async function fetchHandouts(): Promise<HandoutFile[]> {
  if (config.source === 'azure') {
    return fetchAzureHandouts();
  }
  return fetchLocalHandouts();
}

/**
 * Returns a human-readable file size string.
 */
export function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

/**
 * Returns the file extension from a filename.
 */
export function getFileExtension(filename: string): string {
  var ext = filename.split('.').pop()?.toLowerCase() || '';
  return ext;
}

/**
 * Returns an appropriate icon character based on file extension.
 */
export function getFileIcon(filename: string): string {
  var ext = getFileExtension(filename);
  switch (ext) {
    case 'pdf':
      return '📄';
    case 'doc':
    case 'docx':
      return '📝';
    case 'xls':
    case 'xlsx':
      return '📊';
    case 'ppt':
    case 'pptx':
      return '📽️';
    case 'zip':
    case 'rar':
    case '7z':
      return '📦';
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'svg':
      return '🖼️';
    case 'txt':
    case 'md':
      return '📃';
    default:
      return '📎';
  }
}

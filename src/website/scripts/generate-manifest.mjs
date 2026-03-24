/**
 * Build script to generate a handouts.json manifest file from the local handouts/ folder.
 * Run with: node scripts/generate-manifest.mjs
 *
 * This scans ../../handouts/ (relative to src/website) and writes a JSON manifest
 * to public/handouts.json for use in local development.
 */

import { readdirSync, statSync, mkdirSync, writeFileSync, existsSync } from 'fs';
import { join, resolve } from 'path';
import { fileURLToPath } from 'url';

var __dirname = fileURLToPath(new URL('.', import.meta.url));
var handoutsDir = resolve(__dirname, '..', '..', '..', 'handouts');
var outputDir = resolve(__dirname, '..', 'public');
var outputFile = join(outputDir, 'handouts.json');

function generateManifest() {
  if (!existsSync(outputDir)) {
    mkdirSync(outputDir, { recursive: true });
  }

  var files = [];

  if (existsSync(handoutsDir)) {
    var entries = readdirSync(handoutsDir);
    for (var entry of entries) {
      var fullPath = join(handoutsDir, entry);
      var stats = statSync(fullPath);
      if (stats.isFile()) {
        files.push({
          name: entry,
          url: `/handouts/${encodeURIComponent(entry)}`,
          size: stats.size,
          lastModified: stats.mtime.toISOString(),
        });
      }
    }
  }

  files.sort((a, b) => a.name.localeCompare(b.name));
  writeFileSync(outputFile, JSON.stringify(files, null, 2), 'utf-8');
  console.log(`Generated handouts manifest: ${files.length} file(s) written to ${outputFile}`);
}

generateManifest();

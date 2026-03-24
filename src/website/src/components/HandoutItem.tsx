import type { HandoutFile } from '../types';
import { formatFileSize, getFileIcon } from '../utils/handouts-service';
import styles from './HandoutItem.module.css';

interface HandoutItemProps {
  file: HandoutFile;
}

export function HandoutItem({ file }: HandoutItemProps) {
  var icon = getFileIcon(file.name);
  var displayName = decodeURIComponent(file.name);

  return (
    <li className={styles.item}>
      <span className={styles.icon} aria-hidden="true">{icon}</span>
      <div className={styles.info}>
        <a
          href={file.url}
          className={styles.name}
          target="_blank"
          rel="noopener noreferrer"
          aria-label={`Open ${displayName}`}
        >
          {displayName}
        </a>
        <div className={styles.meta}>
          {file.size != null && <span>{formatFileSize(file.size)}</span>}
          {file.lastModified && (
            <span>Modified: {new Date(file.lastModified).toLocaleDateString()}</span>
          )}
        </div>
      </div>
      <a
        href={file.url}
        className={styles.downloadBtn}
        download={file.name}
        aria-label={`Download ${displayName}`}
      >
        ⬇ Download
      </a>
    </li>
  );
}

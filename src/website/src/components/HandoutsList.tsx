import type { HandoutFile } from '../types';
import { HandoutItem } from './HandoutItem';
import styles from './HandoutsList.module.css';

interface HandoutsListProps {
  files: HandoutFile[];
}

export function HandoutsList({ files }: HandoutsListProps) {
  if (files.length === 0) {
    return (
      <section className={styles.container} aria-label="Handouts">
        <div className={styles.empty} role="status">
          <p>📭</p>
          <p>No handouts available at this time.</p>
        </div>
      </section>
    );
  }

  return (
    <section className={styles.container} aria-label="Handouts">
      <h2 className={styles.title}>
        Available Handouts
        <span className={styles.count}>({files.length})</span>
      </h2>
      <ul className={styles.list} role="list">
        {files.map((file) => (
          <HandoutItem key={file.name} file={file} />
        ))}
      </ul>
    </section>
  );
}

import styles from './Loader.module.css';

export function Loader() {
  return (
    <div className={styles.loader} role="status" aria-live="polite">
      <div className={styles.spinner} aria-hidden="true"></div>
      <p>Loading handouts…</p>
    </div>
  );
}

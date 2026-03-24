import styles from './Header.module.css';

export function Header() {
  return (
    <header className={styles.header} role="banner">
      <h1>📄 Lyle's Handouts</h1>
      <p>Browse and download available handout documents</p>
    </header>
  );
}

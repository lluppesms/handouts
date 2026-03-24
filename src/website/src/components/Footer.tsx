import styles from './Footer.module.css';

export function Footer() {
  var year = new Date().getFullYear();
  return (
    <footer className={styles.footer} role="contentinfo">
      <p>&copy; {year} Lyle's Handouts. All rights reserved.</p>
    </footer>
  );
}

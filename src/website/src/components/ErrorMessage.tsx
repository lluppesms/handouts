import styles from './ErrorMessage.module.css';

interface ErrorMessageProps {
  message: string;
  onRetry?: () => void;
}

export function ErrorMessage({ message, onRetry }: ErrorMessageProps) {
  return (
    <div className={styles.error} role="alert" aria-live="assertive">
      <h2>⚠️ Something went wrong</h2>
      <p>{message}</p>
      {onRetry && (
        <button className={styles.retryBtn} onClick={onRetry} type="button">
          Try Again
        </button>
      )}
    </div>
  );
}

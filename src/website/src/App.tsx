import { useEffect, useState, useCallback } from 'react';
import type { HandoutFile } from './types';
import { fetchHandouts } from './utils/handouts-service';
import { Header } from './components/Header';
import { Footer } from './components/Footer';
import { HandoutsList } from './components/HandoutsList';
import { Loader } from './components/Loader';
import { ErrorMessage } from './components/ErrorMessage';
import './styles/global.css';

function App() {
  var [files, setFiles] = useState<HandoutFile[]>([]);
  var [loading, setLoading] = useState(true);
  var [error, setError] = useState<string | null>(null);

  var loadHandouts = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      var handouts = await fetchHandouts();
      handouts.sort((a, b) => a.name.localeCompare(b.name));
      setFiles(handouts);
    } catch (err) {
      var message = err instanceof Error ? err.message : 'An unexpected error occurred.';
      setError(message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadHandouts();
  }, [loadHandouts]);

  return (
    <>
      <a href="#main" className="skip-link">Skip to main content</a>
      <Header />
      <main id="main" role="main">
        {loading && <Loader />}
        {error && <ErrorMessage message={error} onRetry={loadHandouts} />}
        {!loading && !error && <HandoutsList files={files} />}
      </main>
      <Footer />
    </>
  );
}

export default App;

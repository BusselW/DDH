<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Digitale Handhaving</title>
    
    <!-- SharePoint CSS (indien nodig) -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <!-- Eigen CSS -->
    <style>
        /* Basis styling voor DDH applicatie */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .ddh-app {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header styling */
        .ddh-header {
            background-color: #0078d4;
            color: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .ddh-header h1 {
            margin: 0 0 10px 0;
            font-size: 28px;
        }

        .ddh-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 14px;
        }

        /* Lijst selector */
        .lijst-selector {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }

        .lijst-selector button {
            padding: 10px 20px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
            border-radius: 3px;
            transition: all 0.3s ease;
        }

        .lijst-selector button:hover {
            background-color: #f0f0f0;
        }

        .lijst-selector button.actief {
            background-color: #0078d4;
            color: white;
            border-color: #0078d4;
        }

        /* Content area */
        .ddh-content {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            min-height: 400px;
        }

        .ddh-content h2 {
            margin-top: 0;
            color: #333;
        }

        /* Laad status */
        .laden, .fout {
            text-align: center;
            padding: 50px;
            font-size: 18px;
        }

        .fout {
            color: #d83b01;
        }

        .fout button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #0078d4;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .fout button:hover {
            background-color: #106ebe;
        }

        /* Data tabel */
        .data-tabel {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .data-tabel th,
        .data-tabel td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .data-tabel th {
            background-color: #f8f8f8;
            font-weight: 600;
            color: #333;
            position: sticky;
            top: 0;
        }

        .data-tabel tr:hover {
            background-color: #f5f5f5;
        }

        /* Status badges */
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-aangemeld {
            background-color: #fff4ce;
            color: #855e00;
        }

        .status-in-behandeling {
            background-color: #cce5ff;
            color: #004085;
        }

        .status-uitgezet-bij-oi {
            background-color: #d4edda;
            color: #155724;
        }

        .status-opgelost {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-aangevraagd {
            background-color: #fff4ce;
            color: #855e00;
        }

        .status-instemming-verleend {
            background-color: #d4edda;
            color: #155724;
        }

        /* Button styling */
        .btn-detail {
            padding: 6px 12px;
            background-color: #0078d4;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s ease;
        }

        .btn-detail:hover {
            background-color: #106ebe;
        }

        /* Geen data melding */
        .geen-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        /* Footer */
        .ddh-footer {
            margin-top: 40px;
            padding: 20px;
            text-align: center;
            color: #666;
            font-size: 14px;
        }

        /* Loading spinner */
        .laden::after {
            content: '';
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-left: 10px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #0078d4;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .ddh-app {
                padding: 10px;
            }

            .data-tabel {
                font-size: 14px;
            }

            .data-tabel th,
            .data-tabel td {
                padding: 8px;
            }

            .lijst-selector {
                flex-direction: column;
            }

            .lijst-selector button {
                width: 100%;
            }

            /* Maak tabel scrollbaar op mobile */
            .data-tabel-container {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
        }

        /* Error container voor development */
        .error-container {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 20px;
            margin: 20px;
            border-radius: 5px;
        }

        .error-container h3 {
            margin-top: 0;
        }

        .error-container pre {
            background-color: rgba(0,0,0,0.1);
            padding: 10px;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <!-- Root element voor React applicatie -->
    <div id="ddh-root">
        <div class="ddh-app">
            <div class="laden">DDH applicatie wordt geladen...</div>
        </div>
    </div>

    <!-- Error container voor development -->
    <div id="error-container" style="display: none;"></div>

    <!-- React en ReactDOM (development versies voor betere error messages) -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <!-- 
        Voor productie, gebruik:
        <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
        <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
    -->

    <!-- Module loader script -->
    <script type="module">
        // Error handling voor development
        window.addEventListener('error', (event) => {
            console.error('Global error:', event.error);
            const errorContainer = document.getElementById('error-container');
            if (errorContainer) {
                errorContainer.style.display = 'block';
                errorContainer.innerHTML = `
                    <div class="error-container">
                        <h3>Er is een fout opgetreden</h3>
                        <p><strong>Bericht:</strong> ${event.message}</p>
                        <p><strong>Bestand:</strong> ${event.filename}</p>
                        <p><strong>Regel:</strong> ${event.lineno}, Kolom: ${event.colno}</p>
                        <pre>${event.error?.stack || 'Geen stack trace beschikbaar'}</pre>
                    </div>
                `;
            }
        });

        // Module loading error handling
        window.addEventListener('unhandledrejection', (event) => {
            console.error('Unhandled promise rejection:', event.reason);
        });

        // Controleer of React geladen is
        const checkReactLoaded = () => {
            return new Promise((resolve) => {
                const check = () => {
                    if (window.React && window.ReactDOM) {
                        resolve();
                    } else {
                        setTimeout(check, 100);
                    }
                };
                check();
            });
        };

        // Hoofdfunctie om de app te laden
        async function laadApplicatie() {
            try {
                console.log('Wachten tot React geladen is...');
                await checkReactLoaded();
                console.log('React is geladen, app wordt gestart...');
                
                // Import de hoofdmodule
                const module = await import('./js/index.js');
                console.log('DDH module succesvol geladen');
                
            } catch (error) {
                console.error('Fout bij laden DDH applicatie:', error);
                
                // Toon gebruiksvriendelijke foutmelding
                const rootElement = document.getElementById('ddh-root');
                if (rootElement) {
                    rootElement.innerHTML = `
                        <div class="ddh-app">
                            <div class="error-container">
                                <h3>De applicatie kon niet worden geladen</h3>
                                <p>Er is een probleem opgetreden bij het laden van de DDH applicatie.</p>
                                <p><strong>Fout:</strong> ${error.message}</p>
                                <details>
                                    <summary>Technische details</summary>
                                    <pre>${error.stack || error.toString()}</pre>
                                </details>
                                <p style="margin-top: 20px;">
                                    <strong>Mogelijke oplossingen:</strong>
                                </p>
                                <ul>
                                    <li>Controleer of alle JavaScript bestanden correct zijn geüpload</li>
                                    <li>Verifieer dat het pad naar js/index.js correct is</li>
                                    <li>Controleer de browser console voor meer details</li>
                                    <li>Zorg ervoor dat je browser ES6 modules ondersteunt</li>
                                </ul>
                            </div>
                        </div>
                    `;
                }
            }
        }

        // Start de applicatie
        laadApplicatie();
    </script>

    <!-- Fallback voor browsers zonder module support -->
    <script nomodule>
        document.getElementById('ddh-root').innerHTML = `
            <div class="ddh-app">
                <div class="error-container">
                    <h3>Browser niet ondersteund</h3>
                    <p>Deze applicatie vereist een moderne browser die ES6 modules ondersteunt.</p>
                    <p>Overweeg een update naar een recentere versie van:</p>
                    <ul>
                        <li>Microsoft Edge</li>
                        <li>Google Chrome</li>
                        <li>Mozilla Firefox</li>
                        <li>Safari</li>
                    </ul>
                </div>
            </div>
        `;
    </script>

    <!-- Noscript fallback -->
    <noscript>
        <div style="padding: 20px; background-color: #fff3cd; border: 1px solid #ffeaa7; margin: 20px;">
            <h2>JavaScript is vereist</h2>
            <p>Deze applicatie vereist JavaScript om te functioneren. Schakel JavaScript in je browser in.</p>
        </div>
    </noscript>
</body>
</html>
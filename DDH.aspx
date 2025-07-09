<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Digitale Handhaving</title>
    
    <!-- SharePoint CSS (indien nodig) -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <!-- DDH Dashboard CSS -->
    <link rel="stylesheet" type="text/css" href="css/ddh-dashboard.css" />
</head>
<body>
    <!-- Root element voor React applicatie -->
    <div id="ddh-root">
        <div class="ddh-app">
            <div class="loading-overlay">DDH applicatie wordt geladen...</div>
        </div>
    </div>

    <!-- Error container voor development -->
    <div id="error-container" style="display: none;"></div>

    <!-- React en ReactDOM (development versies voor betere error messages) -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

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
                
                // Import de configuratie en start de applicatie
                const { DDH_CONFIG } = await import('./js/config/index.js');
                
                // Valideer configuratie
                const { valideerConfiguratie } = await import('./js/config/index.js');
                const validatie = valideerConfiguratie();
                if (!validatie.isGeldig) {
                    throw new Error('Configuratie validatie gefaald: ' + validatie.fouten.join(', '));
                }
                
                // Start de applicatie
                await startDashboardApp(DDH_CONFIG);
                console.log('DDH Dashboard succesvol geladen');
                
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
                                    <li>Verifieer dat het pad naar js/config/index.js correct is</li>
                                    <li>Controleer de browser console voor meer details</li>
                                    <li>Zorg ervoor dat je browser ES6 modules ondersteunt</li>
                                </ul>
                            </div>
                        </div>
                    `;
                }
            }
        }

        // Dashboard applicatie functie
        async function startDashboardApp(DDH_CONFIG) {
            // Import modular components
            const { initDDHApp } = await import('./js/app.js');
            
            // Initialize the application with configuration
            await initDDHApp(DDH_CONFIG);
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
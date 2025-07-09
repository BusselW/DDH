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
            background-color: #f0f2f5;
            color: #333;
        }

        .ddh-app {
            width: 100%;
            padding: 10px 15px;
            margin: 0;
        }

        /* Header styling */
        .ddh-header {
            background-color: #005a9e;
            color: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .ddh-header h1 {
            margin: 0 0 5px 0;
            font-size: 26px;
        }

        .ddh-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 14px;
        }

        /* Actie Knoppen Boven */
        .top-actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: #0078d4;
            color: white;
        }

        .btn-primary:hover {
            background-color: #005a9e;
        }

        .btn-secondary {
            background-color: #e1e1e1;
            color: #333;
            border: 1px solid #ccc;
        }

        .btn-secondary:hover {
            background-color: #d1d1d1;
        }

        /* Content area */
        .ddh-content {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .ddh-content h2 {
            margin: 0;
            padding: 20px;
            font-size: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .ddh-content h2 .hint {
            font-size: 14px;
            font-style: italic;
            font-weight: normal;
            color: #666;
        }

        /* Data tabel */
        .data-tabel-container {
            overflow-x: auto;
            width: 100%;
        }

        .data-tabel {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
        }

        .data-tabel th,
        .data-tabel td {
            padding: 12px 8px;
            text-align: left;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }

        .data-tabel th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #555;
            position: sticky;
            top: 0;
            font-size: 13px;
            white-space: nowrap;
        }

        .data-tabel td {
            font-size: 14px;
        }

        .data-tabel tr.dh-row.expandable:hover {
            background-color: #e9f5ff;
            cursor: pointer;
        }

        /* Child item styling - completely redesigned */
        .child-row {
            background-color: #f8f9fb !important;
        }

        .child-content {
            padding: 0 !important;
        }

        .child-container {
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fb 0%, #ffffff 100%);
            border-left: 4px solid #0078d4;
            margin: 0;
        }

        .problems-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }

        .problem-card {
            background: white;
            border-radius: 8px;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 4px solid #28a745;
            transition: all 0.2s ease;
        }

        .problem-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transform: translateY(-1px);
        }

        .problem-card.status-aangemeld {
            border-left-color: #ffc107;
        }

        .problem-card.status-in-behandeling {
            border-left-color: #007bff;
        }

        .problem-card.status-uitgezet-bij-oi {
            border-left-color: #28a745;
        }

        .problem-card.status-opgelost {
            border-left-color: #6c757d;
        }

        .problem-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .problem-title {
            font-weight: 600;
            color: #333;
            font-size: 14px;
            margin: 0;
            flex: 1;
        }

        .problem-date {
            font-size: 12px;
            color: #666;
            white-space: nowrap;
            margin-left: 12px;
        }

        .problem-description {
            color: #555;
            font-size: 13px;
            line-height: 1.4;
            margin: 8px 0;
            max-height: 60px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .problem-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid #eee;
        }

        .problem-category {
            background: #e9ecef;
            color: #495057;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
        }

        /* Location info header for child items */
        .location-info {
            background: white;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
            border: 1px solid #e9ecef;
        }

        .location-info h3 {
            margin: 0 0 12px 0;
            color: #005a9e;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .location-info h3 svg {
            width: 16px;
            height: 16px;
            flex-shrink: 0;
        }

        .location-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .location-detail {
            display: flex;
            flex-direction: column;
        }

        .location-detail-label {
            font-size: 11px;
            color: #666;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .location-detail-value {
            font-size: 13px;
            color: #333;
            font-weight: 500;
        }

        .location-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .location-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: #f8f9fa;
            color: #0078d4;
            text-decoration: none;
            border-radius: 16px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid #dee2e6;
            transition: all 0.2s ease;
        }

        .location-link:hover {
            background: #0078d4;
            color: white;
            text-decoration: none;
        }

        .location-link svg {
            width: 14px;
            height: 14px;
            flex-shrink: 0;
        }

        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title svg {
            width: 16px;
            height: 16px;
            flex-shrink: 0;
        }

        /* Expander Icoon */
        .expander {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 20px;
            height: 20px;
            margin-right: 10px;
            transition: transform 0.2s ease;
        }

        .expander svg {
            width: 16px;
            height: 16px;
        }

        .expander.expanded {
            transform: rotate(0deg);
        }

        /* Status badges */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
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
            background-color: #e2e3e5;
            color: #383d41;
        }

        .status-aangevraagd {
            background-color: #fff4ce;
            color: #855e00;
        }

        .status-instemming-verleend {
            background-color: #d4edda;
            color: #155724;
        }

        /* Modal styling */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 22px;
        }

        .modal-close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #888;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 5px;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }

        /* Loading en error overlays */
        .loading-overlay,
        .error-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .loading-overlay {
            color: #0078d4;
        }

        .error-overlay {
            color: #d83b01;
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

        /* Loading spinner */
        .loading-overlay::after {
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
        @media (max-width: 1200px) {
            .problems-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            }

            .location-details {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .ddh-app {
                padding: 5px;
            }

            .data-tabel {
                font-size: 13px;
            }

            .data-tabel th,
            .data-tabel td {
                padding: 6px 4px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .top-actions {
                flex-direction: column;
                margin-bottom: 10px;
            }

            .btn {
                width: 100%;
                justify-content: center;
                padding: 8px 16px;
            }

            .ddh-header {
                padding: 15px;
                margin-bottom: 15px;
            }

            .ddh-header h1 {
                font-size: 22px;
            }

            .problems-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .child-container {
                padding: 12px;
            }

            .location-details {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .location-links {
                flex-direction: column;
                gap: 8px;
            }

            .location-link {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .ddh-app {
                padding: 2px;
            }

            .data-tabel th,
            .data-tabel td {
                padding: 4px 2px;
                font-size: 12px;
            }

            .btn {
                padding: 6px 12px;
                font-size: 13px;
            }
        }
    </style>
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
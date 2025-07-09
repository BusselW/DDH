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
            min-height: 100vh;
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
            width: 100%;
            height: 100%;
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
            const { createElement: h, useState, useEffect, useCallback } = window.React;
            const { createRoot } = window.ReactDOM;

            // --- ICONEN ---
            const IconExpand = () => h('svg', { viewBox: '0 0 24 24', style: { color: '#0078d4' } }, 
                h('path', { d: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z', fill: 'currentColor' })
            );

            const IconCollapse = () => h('svg', { viewBox: '0 0 24 24', style: { color: '#d83b01' } }, 
                h('path', { d: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11H7v-2h10v2z', fill: 'currentColor' })
            );

            const IconDocument = () => h('svg', { viewBox: '0 0 24 24', fill: 'currentColor' },
                h('path', { d: 'M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z' })
            );

            const IconReport = () => h('svg', { viewBox: '0 0 24 24', fill: 'currentColor' },
                h('path', { d: 'M13,9H18.5L13,3.5V9M6,2H14L20,8V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V4C4,2.89 4.89,2 6,2M15,18V16H6V18H15M18,14V12H6V14H18Z' })
            );

            const IconLocation = () => h('svg', { viewBox: '0 0 24 24', fill: 'currentColor' },
                h('path', { d: 'M12,11.5A2.5,2.5 0 0,1 9.5,9A2.5,2.5 0 0,1 12,6.5A2.5,2.5 0 0,1 14.5,9A2.5,2.5 0 0,1 12,11.5M12,2A7,7 0 0,0 5,9C5,14.25 12,22 12,22C12,22 19,14.25 19,9A7,7 0 0,0 12,2Z' })
            );

            const IconProblem = () => h('svg', { viewBox: '0 0 24 24', fill: 'currentColor' },
                h('path', { d: 'M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,17A1.5,1.5 0 0,1 10.5,15.5A1.5,1.5 0 0,1 12,14A1.5,1.5 0 0,1 13.5,15.5A1.5,1.5 0 0,1 12,17M12,10.5C10.9,10.5 10,9.6 10,8.5C10,7.4 10.9,6.5 12,6.5C13.1,6.5 14,7.4 14,8.5C14,9.6 13.1,10.5 12,10.5Z' })
            );

            // --- REAL DATA SERVICE ---
            const ddhDataService = {
                // Haal alle data op met relaties
                fetchAll: async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        return result;
                    } catch (error) {
                        console.error('Fout bij ophalen data:', error);
                        throw error;
                    }
                },

                // Maak nieuwe DH locatie aan
                addDH: async (item) => {
                    try {
                        // Voeg metadata toe voor SharePoint
                        const body = {
                            __metadata: { type: 'SP.Data.Digitale_x0020_handhavingListItem' },
                            Title: item.Title,
                            Gemeente: item.Gemeente,
                            Feitcodegroep: item.Feitcodegroep,
                            Status_x0020_B_x0026_S: 'Aangevraagd',
                            Waarschuwingsperiode: 'Ja'
                        };

                        const digest = await DDH_CONFIG.helpers.haalRequestDigestOp();
                        const response = await fetch(DDH_CONFIG.lijsten.digitaleHandhaving.endpoints.aanmaken(), {
                            method: 'POST',
                            headers: DDH_CONFIG.headers.post(digest),
                            body: JSON.stringify(body)
                        });

                        if (!response.ok) {
                            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                        }

                        const data = await response.json();
                        return data.d;
                    } catch (error) {
                        console.error('Fout bij aanmaken DH locatie:', error);
                        throw error;
                    }
                },

                // Maak nieuw probleem aan
                addProblem: async (item) => {
                    try {
                        // Voeg metadata toe voor SharePoint
                        const body = {
                            __metadata: { type: 'SP.Data.Problemen_x0020_pleeglocatiesListItem' },
                            Title: item.Title,
                            Gemeente: item.Gemeente,
                            Probleembeschrijving: item.Probleembeschrijving,
                            Feitcodegroep: item.Feitcodegroep,
                            Opgelost_x003f_: 'Aangemeld',
                            Actie_x0020_Beoordelaars: 'Geen actie nodig',
                            Aanmaakdatum: new Date().toISOString()
                        };

                        const digest = await DDH_CONFIG.helpers.haalRequestDigestOp();
                        const response = await fetch(DDH_CONFIG.lijsten.problemenPleeglocaties.endpoints.aanmaken(), {
                            method: 'POST',
                            headers: DDH_CONFIG.headers.post(digest),
                            body: JSON.stringify(body)
                        });

                        if (!response.ok) {
                            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                        }

                        const data = await response.json();
                        return data.d;
                    } catch (error) {
                        console.error('Fout bij aanmaken probleem:', error);
                        throw error;
                    }
                }
            };

            // Request Digest helper
            DDH_CONFIG.helpers.haalRequestDigestOp = async () => {
                try {
                    const response = await fetch(DDH_CONFIG.helpers.maakApiUrl('/contextinfo'), {
                        method: 'POST',
                        headers: DDH_CONFIG.headers.get
                    });
                    
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                    }
                    
                    const data = await response.json();
                    return data.d.GetContextWebInformation.FormDigestValue;
                } catch (error) {
                    console.error('Fout bij ophalen Request Digest:', error);
                    throw error;
                }
            };

            // --- REACT COMPONENTEN ---
            const SubmissionModal = ({ modalConfig, closeModal, onFormSubmit }) => {
                if (!modalConfig) return null;

                const { type, data } = modalConfig;
                const isDH = type === 'dh';
                const title = isDH ? 'Nieuwe Handhavingslocatie' : `Nieuw Probleem voor ${data.Title}`;

                const handleSubmit = (e) => {
                    e.preventDefault();
                    const formData = new FormData(e.target);
                    const submissionData = Object.fromEntries(formData.entries());
                    onFormSubmit(type, submissionData);
                };

                return h('div', { className: 'modal-overlay' },
                    h('div', { className: 'modal-content' },
                        h('form', { onSubmit: handleSubmit },
                            h('div', { className: 'modal-header' },
                                h('h2', null, title),
                                h('button', { type: 'button', className: 'modal-close-btn', onClick: closeModal }, '×')
                            ),
                            isDH ? h(DHFormFields) : h(ProbleemFormFields, { dhData: data }),
                            h('div', { className: 'modal-footer' },
                                h('button', { type: 'button', className: 'btn btn-secondary', onClick: closeModal }, 'Annuleren'),
                                h('button', { type: 'submit', className: 'btn btn-primary' }, 'Opslaan')
                            )
                        )
                    )
                );
            };

            const DHFormFields = () => {
                const feitcodegroepen = DDH_CONFIG.constanten.FEITCODEGROEPEN;
                
                return h('div', { className: 'form-grid' },
                    h('div', { className: 'form-group full-width' },
                        h('label', { htmlFor: 'Title' }, 'Titel / Locatie'),
                        h('input', { type: 'text', id: 'Title', name: 'Title', required: true })
                    ),
                    h('div', { className: 'form-group' },
                        h('label', { htmlFor: 'Gemeente' }, 'Gemeente'),
                        h('input', { type: 'text', id: 'Gemeente', name: 'Gemeente', required: true })
                    ),
                    h('div', { className: 'form-group' },
                        h('label', { htmlFor: 'Feitcodegroep' }, 'Feitcodegroep'),
                        h('select', { id: 'Feitcodegroep', name: 'Feitcodegroep' },
                            Object.values(feitcodegroepen).map(groep => 
                                h('option', { key: groep.waarde, value: groep.waarde }, groep.waarde)
                            )
                        )
                    )
                );
            };

            const ProbleemFormFields = ({ dhData }) => {
                const feitcodegroepen = DDH_CONFIG.constanten.FEITCODEGROEPEN;
                
                return h('div', { className: 'form-grid' },
                    h('div', { className: 'form-group' },
                        h('label', { htmlFor: 'Title' }, 'Pleeglocatie'),
                        h('input', { type: 'text', id: 'Title', name: 'Title', readOnly: true, value: dhData.Title })
                    ),
                    h('div', { className: 'form-group' },
                        h('label', { htmlFor: 'Gemeente' }, 'Gemeente'),
                        h('input', { type: 'text', id: 'Gemeente', name: 'Gemeente', readOnly: true, value: dhData.Gemeente })
                    ),
                    h('div', { className: 'form-group full-width' },
                        h('label', { htmlFor: 'Probleembeschrijving' }, 'Probleembeschrijving'),
                        h('textarea', { id: 'Probleembeschrijving', name: 'Probleembeschrijving', required: true })
                    ),
                    h('div', { className: 'form-group' },
                        h('label', { htmlFor: 'Feitcodegroep' }, 'Feitcodegroep'),
                        h('select', { id: 'Feitcodegroep', name: 'Feitcodegroep' },
                            Object.values(feitcodegroepen).map(groep => 
                                h('option', { key: groep.waarde, value: groep.waarde }, groep.waarde)
                            )
                        )
                    )
                );
            };

            const DashboardApp = () => {
                const [data, setData] = useState([]);
                const [loading, setLoading] = useState(true);
                const [error, setError] = useState(null);
                const [expandedRows, setExpandedRows] = useState(new Set());
                const [modalConfig, setModalConfig] = useState(null);

                const fetchData = useCallback(async () => {
                    setLoading(true);
                    setError(null);
                    try {
                        const result = await ddhDataService.fetchAll();
                        setData(result);
                    } catch (err) {
                        console.error("Fout bij ophalen data:", err);
                        setError(err.message || 'Kon data niet laden.');
                    } finally {
                        setLoading(false);
                    }
                }, []);

                useEffect(() => {
                    fetchData();
                }, [fetchData]);

                const handleFormSubmit = async (type, submissionData) => {
                    console.log("Submitting:", type, submissionData);
                    try {
                        if (type === 'dh') {
                            await ddhDataService.addDH(submissionData);
                        } else {
                            await ddhDataService.addProblem(submissionData);
                        }
                        setModalConfig(null);
                        fetchData(); // Refresh data after submission
                    } catch (err) {
                        console.error("Fout bij opslaan data:", err);
                        alert(`Fout bij opslaan: ${err.message}`);
                    }
                };

                const toggleRow = (id) => {
                    const newExpandedRows = new Set(expandedRows);
                    if (newExpandedRows.has(id)) {
                        newExpandedRows.delete(id);
                    } else {
                        newExpandedRows.add(id);
                    }
                    setExpandedRows(newExpandedRows);
                };

                const renderStatusBadge = (status) => {
                    const className = `status-badge status-${(status || '').toLowerCase().replace(/\s+/g, '-')}`;
                    return h('span', { className }, status || '-');
                };

                const formatDate = (dateString) => {
                    if (!dateString) return '-';
                    return new Date(dateString).toLocaleDateString('nl-NL', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric'
                    });
                };

                const renderLocationInfo = (dh) => {
                    const links = [];
                    
                    // Add links if they exist
                    if (dh.Link_x0020_Algemeen_x0020_PV?.Url) {
                        links.push(h('a', {
                            key: 'algemeen-pv',
                            href: dh.Link_x0020_Algemeen_x0020_PV.Url,
                            target: '_blank',
                            className: 'location-link'
                        }, h(IconDocument), 'Algemeen PV'));
                    }
                    
                    if (dh.Link_x0020_Schouwrapporten?.Url) {
                        links.push(h('a', {
                            key: 'schouwrapporten',
                            href: dh.Link_x0020_Schouwrapporten.Url,
                            target: '_blank',
                            className: 'location-link'
                        }, h(IconReport), 'Schouwrapporten'));
                    }
                    
                    if (dh.Instemmingsbesluit?.Url) {
                        links.push(h('a', {
                            key: 'instemmingsbesluit',
                            href: dh.Instemmingsbesluit.Url,
                            target: '_blank',
                            className: 'location-link'
                        }, h(IconDocument), 'Instemmingsbesluit'));
                    }

                    return h('div', { className: 'location-info' },
                        h('h3', null, h(IconLocation), dh.Title, ' - ', dh.Gemeente),
                        h('div', { className: 'location-details' },
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Status B&S'),
                                h('div', { className: 'location-detail-value' }, renderStatusBadge(dh.Status_x0020_B_x0026_S))
                            ),
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Feitcodegroep'),
                                h('div', { className: 'location-detail-value' }, dh.Feitcodegroep || '-')
                            ),
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Waarschuwingsperiode'),
                                h('div', { className: 'location-detail-value' }, dh.Waarschuwingsperiode || '-')
                            ),
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Start Waarschuwing'),
                                h('div', { className: 'location-detail-value' }, formatDate(dh.Start_x0020_Waarschuwingsperiode))
                            ),
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Einde Waarschuwing'),
                                h('div', { className: 'location-detail-value' }, formatDate(dh.Einde_x0020_Waarschuwingsperiode))
                            ),
                            h('div', { className: 'location-detail' },
                                h('div', { className: 'location-detail-label' }, 'Laatste Schouw'),
                                h('div', { className: 'location-detail-value' }, formatDate(dh.Laatste_x0020_schouw))
                            )
                        ),
                        links.length > 0 && h('div', { className: 'location-links' }, ...links)
                    );
                };

                const renderProblemCard = (problem) => {
                    const statusClass = `problem-card status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`;
                    
                    return h('div', { key: problem.Id, className: statusClass },
                        h('div', { className: 'problem-header' },
                            h('div', { className: 'problem-title' }, problem.Feitcodegroep || 'Algemeen'),
                            h('div', { className: 'problem-date' }, formatDate(problem.Aanmaakdatum))
                        ),
                        h('div', { className: 'problem-description' }, problem.Probleembeschrijving || 'Geen beschrijving'),
                        h('div', { className: 'problem-meta' },
                            h('div', { className: 'problem-category' }, renderStatusBadge(problem.Opgelost_x003f_)),
                            problem.Actie_x0020_Beoordelaars && h('div', { className: 'problem-category' }, problem.Actie_x0020_Beoordelaars)
                        )
                    );
                };

                const renderTableRows = () => {
                    const rows = [];
                    data.forEach(dh => {
                        const isExpanded = expandedRows.has(dh.Id);
                        const hasProblemen = dh.problemen && dh.problemen.length > 0;

                        rows.push(h('tr', { key: dh.Id, className: `dh-row ${hasProblemen ? 'expandable' : ''}`, onClick: () => hasProblemen && toggleRow(dh.Id) },
                            h('td', { style: { display: 'flex', alignItems: 'center' } }, 
                                h('span', { className: `expander ${isExpanded ? 'expanded' : ''}` }, 
                                    hasProblemen ? (isExpanded ? h(IconCollapse) : h(IconExpand)) : null
                                ),
                                h('span', { style: { fontWeight: hasProblemen ? '600' : 'normal' } }, dh.Title)
                            ),
                            h('td', null, dh.Gemeente),
                            h('td', null, renderStatusBadge(dh.Status_x0020_B_x0026_S)),
                            h('td', null, dh.Waarschuwingsperiode),
                            h('td', null, 
                                h('span', { 
                                    style: { 
                                        color: hasProblemen ? '#d83b01' : '#666',
                                        fontWeight: hasProblemen ? '600' : 'normal'
                                    } 
                                }, dh.problemen?.length || 0)
                            ),
                            h('td', null, 
                                h('button', { 
                                    className: 'btn btn-secondary', 
                                    onClick: (e) => {
                                        e.stopPropagation();
                                        setModalConfig({ type: 'probleem', data: dh });
                                    }
                                }, 'Nieuw Probleem')
                            )
                        ));

                        if (isExpanded && hasProblemen) {
                            rows.push(h('tr', { key: `child-${dh.Id}`, className: 'child-row' },
                                h('td', { colSpan: 6, className: 'child-content' },
                                    h('div', { className: 'child-container' },
                                        renderLocationInfo(dh),
                                        h('div', { className: 'section-title' },
                                            h(IconProblem),
                                            `Gemelde Problemen (${dh.problemen.length})`
                                        ),
                                        h('div', { className: 'problems-grid' },
                                            ...dh.problemen.map(renderProblemCard)
                                        )
                                    )
                                )
                            ));
                        }
                    });
                    return rows;
                };

                if (loading) {
                    return h('div', { className: 'loading-overlay' }, 'Data wordt geladen...');
                }

                if (error) {
                    return h('div', { className: 'error-overlay' }, `Fout: ${error}`);
                }

                return h('div', { className: 'ddh-app' },
                    h(SubmissionModal, { modalConfig, closeModal: () => setModalConfig(null), onFormSubmit: handleFormSubmit }),
                    h('header', { className: 'ddh-header' },
                        h('h1', null, 'DDH Unified Dashboard'),
                        h('p', null, 'Overzicht van handhavingslocaties en gerelateerde problemen')
                    ),
                    h('div', { className: 'top-actions' },
                        h('button', { 
                            className: 'btn btn-primary',
                            onClick: () => setModalConfig({ type: 'dh', data: {} })
                        }, 'Nieuwe Handhavingslocatie')
                    ),
                    h('main', { className: 'ddh-content' },
                        h('h2', null, 
                            'Handhavingslocaties',
                            h('span', { className: 'hint' }, '(klik op een rij om problemen te tonen)')
                        ),
                        h('div', { className: 'data-tabel-container' },
                            h('table', { className: 'data-tabel' },
                                h('thead', null, h('tr', null,
                                    h('th', null, 'Locatie'),
                                    h('th', null, 'Gemeente'),
                                    h('th', null, 'Status B&S'),
                                    h('th', null, 'Waarschuwing'),
                                    h('th', null, 'Problemen'),
                                    h('th', null, 'Acties')
                                )),
                                h('tbody', null, renderTableRows())
                            )
                        )
                    )
                );
            };

            const rootElement = document.getElementById('ddh-root');
            const root = createRoot(rootElement);
            root.render(h(DashboardApp));
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
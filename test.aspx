<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Module Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .test-section {
            background: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .info {
            color: blue;
        }
        pre {
            background: #f0f0f0;
            padding: 10px;
            overflow-x: auto;
            border-radius: 3px;
        }
        button {
            padding: 10px 20px;
            margin: 5px;
            cursor: pointer;
            background: #0078d4;
            color: white;
            border: none;
            border-radius: 3px;
        }
        button:hover {
            background: #106ebe;
        }
        .results {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>DDH Module Test Pagina</h1>
    <p>Deze pagina test of alle modules correct laden zonder React complexiteit.</p>

    <div class="test-section">
        <h2>1. Module Import Test</h2>
        <button onclick="testModuleImport()">Test Module Import</button>
        <div id="module-test-result" class="results"></div>
    </div>

    <div class="test-section">
        <h2>2. SharePoint Configuratie Test</h2>
        <button onclick="testSharePointConfig()">Test Configuratie</button>
        <div id="config-test-result" class="results"></div>
    </div>

    <div class="test-section">
        <h2>3. API Endpoint Test</h2>
        <button onclick="testAPIEndpoints()">Test API Endpoints</button>
        <div id="api-test-result" class="results"></div>
    </div>

    <div class="test-section">
        <h2>4. Lijst Data Test</h2>
        <button onclick="testListData()">Test Lijst Data</button>
        <div id="data-test-result" class="results"></div>
    </div>

    <div class="test-section">
        <h2>5. React Beschikbaarheid Test</h2>
        <button onclick="testReact()">Test React</button>
        <div id="react-test-result" class="results"></div>
    </div>

    <!-- React scripts voor test 5 -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        // Maak test functies globaal beschikbaar
        window.testModuleImport = async function() {
            const resultDiv = document.getElementById('module-test-result');
            resultDiv.innerHTML = '<p class="info">Module import wordt getest...</p>';
            
            try {
                // Test basis module import
                const lijstenModule = await import('./js/config/lijsten.js');
                
                let html = '<p class="success">✓ Module succesvol geïmporteerd!</p>';
                html += '<h4>Geëxporteerde functies en objecten:</h4>';
                html += '<ul>';
                
                for (const [key, value] of Object.entries(lijstenModule)) {
                    html += `<li><strong>${key}</strong>: ${typeof value}</li>`;
                }
                html += '</ul>';
                
                // Test of belangrijke exports aanwezig zijn
                const requiredExports = ['SHAREPOINT_CONFIG', 'LIJSTEN', 'SHAREPOINT_HEADERS'];
                const missingExports = requiredExports.filter(exp => !lijstenModule[exp]);
                
                if (missingExports.length === 0) {
                    html += '<p class="success">✓ Alle vereiste exports gevonden!</p>';
                } else {
                    html += `<p class="error">✗ Ontbrekende exports: ${missingExports.join(', ')}</p>`;
                }
                
                resultDiv.innerHTML = html;
                
                // Maak module globaal beschikbaar voor andere tests
                window.lijstenModule = lijstenModule;
                
            } catch (error) {
                resultDiv.innerHTML = `
                    <p class="error">✗ Module import mislukt!</p>
                    <p><strong>Error:</strong> ${error.message}</p>
                    <pre>${error.stack}</pre>
                    <p><strong>Mogelijke oorzaken:</strong></p>
                    <ul>
                        <li>Bestand niet gevonden op verwachte locatie</li>
                        <li>Syntax error in module</li>
                        <li>Browser ondersteunt geen ES6 modules</li>
                    </ul>
                `;
            }
        };

        window.testSharePointConfig = function() {
            const resultDiv = document.getElementById('config-test-result');
            
            if (!window.lijstenModule) {
                resultDiv.innerHTML = '<p class="error">✗ Voer eerst de Module Import Test uit!</p>';
                return;
            }
            
            try {
                const { SHAREPOINT_CONFIG, LIJSTEN } = window.lijstenModule;
                
                let html = '<h4>SharePoint Configuratie:</h4>';
                html += '<pre>' + JSON.stringify(SHAREPOINT_CONFIG, null, 2) + '</pre>';
                
                html += '<h4>Geconfigureerde Lijsten:</h4>';
                html += '<ul>';
                for (const [key, lijst] of Object.entries(LIJSTEN)) {
                    html += `<li>
                        <strong>${key}</strong>: ${lijst.lijstTitel} 
                        (ID: ${lijst.lijstId})
                    </li>`;
                }
                html += '</ul>';
                
                html += '<p class="success">✓ Configuratie succesvol geladen!</p>';
                
                resultDiv.innerHTML = html;
                
            } catch (error) {
                resultDiv.innerHTML = `
                    <p class="error">✗ Configuratie test mislukt!</p>
                    <p><strong>Error:</strong> ${error.message}</p>
                `;
            }
        };

        window.testAPIEndpoints = function() {
            const resultDiv = document.getElementById('api-test-result');
            
            if (!window.lijstenModule) {
                resultDiv.innerHTML = '<p class="error">✗ Voer eerst de Module Import Test uit!</p>';
                return;
            }
            
            try {
                const { LIJSTEN } = window.lijstenModule;
                
                let html = '<h4>API Endpoints voor Problemen Pleeglocaties:</h4>';
                html += '<ul>';
                html += `<li>Alle items: <code>${LIJSTEN.problemenPleeglocaties.endpoints.alleItems()}</code></li>`;
                html += `<li>Specifiek item: <code>${LIJSTEN.problemenPleeglocaties.endpoints.specifiekItem(1)}</code></li>`;
                html += `<li>Context info: <code>${LIJSTEN.problemenPleeglocaties.endpoints.contextInfo()}</code></li>`;
                html += '</ul>';
                
                html += '<h4>API Endpoints voor Digitale Handhaving:</h4>';
                html += '<ul>';
                html += `<li>Alle items: <code>${LIJSTEN.digitaleHandhaving.endpoints.alleItems()}</code></li>`;
                html += `<li>Specifiek item: <code>${LIJSTEN.digitaleHandhaving.endpoints.specifiekItem(1)}</code></li>`;
                html += '</ul>';
                
                html += '<p class="success">✓ API endpoints correct gegenereerd!</p>';
                
                resultDiv.innerHTML = html;
                
            } catch (error) {
                resultDiv.innerHTML = `
                    <p class="error">✗ API endpoint test mislukt!</p>
                    <p><strong>Error:</strong> ${error.message}</p>
                `;
            }
        };

        window.testListData = async function() {
            const resultDiv = document.getElementById('data-test-result');
            
            if (!window.lijstenModule) {
                resultDiv.innerHTML = '<p class="error">✗ Voer eerst de Module Import Test uit!</p>';
                return;
            }
            
            resultDiv.innerHTML = '<p class="info">Data wordt opgehaald...</p>';
            
            try {
                const { LIJSTEN, SHAREPOINT_HEADERS } = window.lijstenModule;
                
                // Test Problemen Pleeglocaties
                const problemenUrl = LIJSTEN.problemenPleeglocaties.endpoints.alleItems() + '?$top=5';
                console.log('Fetching:', problemenUrl);
                
                const problemenResponse = await fetch(problemenUrl, {
                    headers: SHAREPOINT_HEADERS.get
                });
                
                let html = '<h4>Problemen Pleeglocaties Test:</h4>';
                
                if (problemenResponse.ok) {
                    const problemenData = await problemenResponse.json();
                    html += `<p class="success">✓ Status: ${problemenResponse.status} OK</p>`;
                    html += `<p>Aantal items: ${problemenData.d.results?.length || 0}</p>`;
                    if (problemenData.d.results?.length > 0) {
                        html += '<p>Eerste item:</p>';
                        html += '<pre>' + JSON.stringify(problemenData.d.results[0], null, 2) + '</pre>';
                    }
                } else {
                    html += `<p class="error">✗ Status: ${problemenResponse.status} ${problemenResponse.statusText}</p>`;
                }
                
                // Test Digitale Handhaving
                const dhUrl = LIJSTEN.digitaleHandhaving.endpoints.alleItems() + '?$top=5';
                console.log('Fetching:', dhUrl);
                
                const dhResponse = await fetch(dhUrl, {
                    headers: SHAREPOINT_HEADERS.get
                });
                
                html += '<h4>Digitale Handhaving Test:</h4>';
                
                if (dhResponse.ok) {
                    const dhData = await dhResponse.json();
                    html += `<p class="success">✓ Status: ${dhResponse.status} OK</p>`;
                    html += `<p>Aantal items: ${dhData.d.results?.length || 0}</p>`;
                    if (dhData.d.results?.length > 0) {
                        html += '<p>Eerste item:</p>';
                        html += '<pre>' + JSON.stringify(dhData.d.results[0], null, 2) + '</pre>';
                    }
                } else {
                    html += `<p class="error">✗ Status: ${dhResponse.status} ${dhResponse.statusText}</p>`;
                }
                
                resultDiv.innerHTML = html;
                
            } catch (error) {
                resultDiv.innerHTML = `
                    <p class="error">✗ Data test mislukt!</p>
                    <p><strong>Error:</strong> ${error.message}</p>
                    <pre>${error.stack}</pre>
                    <p><strong>Mogelijke oorzaken:</strong></p>
                    <ul>
                        <li>Geen toegang tot SharePoint lijsten</li>
                        <li>Onjuiste lijst namen of URLs</li>
                        <li>CORS problemen</li>
                        <li>Authenticatie problemen</li>
                    </ul>
                `;
            }
        };

        window.testReact = function() {
            const resultDiv = document.getElementById('react-test-result');
            
            let html = '<h4>React Status:</h4>';
            
            if (window.React) {
                html += '<p class="success">✓ React is geladen!</p>';
                html += `<p>React versie: ${window.React.version}</p>`;
            } else {
                html += '<p class="error">✗ React is niet geladen!</p>';
            }
            
            if (window.ReactDOM) {
                html += '<p class="success">✓ ReactDOM is geladen!</p>';
                html += `<p>ReactDOM versie: ${window.ReactDOM.version}</p>`;
            } else {
                html += '<p class="error">✗ ReactDOM is niet geladen!</p>';
            }
            
            // Test createElement als 'h'
            if (window.React?.createElement) {
                const testElement = window.React.createElement('div', null, 'Test');
                html += '<p class="success">✓ React.createElement werkt!</p>';
                html += '<p>Test element: ' + JSON.stringify(testElement.type) + '</p>';
            }
            
            resultDiv.innerHTML = html;
        };

        // Auto-run module test bij laden
        window.addEventListener('DOMContentLoaded', () => {
            console.log('Test pagina geladen. Klik op de knoppen om tests uit te voeren.');
        });
    </script>
</body>
</html>
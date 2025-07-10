<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Dashboard</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <!-- Custom CSS (copied from shadowfile) -->
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
            color: #333;
        }
        .ddh-app {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }
        .ddh-header {
            background-color: #005a9e;
            color: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .ddh-header h1 { margin: 0 0 5px 0; font-size: 26px; }
        .ddh-header p { margin: 0; opacity: 0.9; font-size: 14px; }
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
        .btn-primary { background-color: #0078d4; color: white; }
        .btn-primary:hover { background-color: #005a9e; }
        .btn-secondary { background-color: #e1e1e1; color: #333; border: 1px solid #ccc; }
        .btn-secondary:hover { background-color: #d1d1d1; }
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
        .data-tabel-container { overflow-x: auto; }
        .data-tabel { width: 100%; border-collapse: collapse; }
        .data-tabel th, .data-tabel td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; white-space: nowrap; }
        .data-tabel th { background-color: #f8f9fa; font-weight: 600; color: #555; position: sticky; top: 0; }
        .data-tabel tr.dh-row.expandable:hover { background-color: #e9f5ff; cursor: pointer; }
        .data-tabel tr.probleem-row { background-color: #fafafa; }
        .data-tabel tr.probleem-row td { padding-left: 40px; border-color: #f0f0f0; border-left: 4px solid #0078d4; }
        .data-tabel tr.probleem-row:hover { background-color: #f0f0f0; }
        .probleem-header-row { background-color: #f2f2f2; font-weight: bold; color: #444; }
        .probleem-header-row td { padding-top: 10px; padding-bottom: 10px; padding-left: 25px !important; border-left: 4px solid #0078d4; }
        .expander { display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; margin-right: 10px; transition: transform 0.2s ease; }
        .expander svg { width: 100%; height: 100%; }
        .expander.expanded { transform: rotate(0deg); }
        .status-badge { display: inline-block; padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: 600; text-transform: capitalize; }
        .status-aangemeld { background-color: #fff4ce; color: #855e00; }
        .status-in-behandeling { background-color: #cce5ff; color: #004085; }
        .status-uitgezet-bij-oi { background-color: #d4edda; color: #155724; }
        .status-opgelost { background-color: #e2e3e5; color: #383d41; }
        .status-aangevraagd { background-color: #fff4ce; color: #855e00; }
        .status-instemming-verleend { background-color: #d4edda; color: #155724; }
        .modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.6); display: flex; align-items: center; justify-content: center; z-index: 1000; }
        .modal-content { background: white; padding: 30px; border-radius: 8px; width: 90%; max-width: 600px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h2 { margin: 0; font-size: 22px; }
        .modal-close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #888; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { margin-bottom: 5px; font-weight: 600; font-size: 14px; }
        .form-group input, .form-group select, .form-group textarea { padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
        .loading-overlay, .error-overlay { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.8); display: flex; align-items: center; justify-content: center; font-size: 18px; }
    </style>
</head>
<body>
    <div id="ddh-dashboard-root">
        <div class="loading-overlay">DDH Dashboard wordt geladen...</div>
    </div>

    <!-- Error container voor development -->
    <div id="error-container" style="display: none;"></div>

    <!-- Dashboard Application Script -->
    <script>
        // Since React CDN is blocked, let's use a pure JavaScript implementation
        // that mimics the same structure but without React
        
        // Mock data service
        const dataService = {
            fetchAll: async function() {
                await new Promise(resolve => setTimeout(resolve, 500));
                return [
                    {
                        Id: 1,
                        Title: "Hoofdstraat 123",
                        Gemeente: "Amsterdam",
                        Status_x0020_B_x0026_S: "Aangevraagd",
                        Waarschuwingsperiode: "Ja",
                        problemen: [
                            {
                                Id: 101,
                                Probleembeschrijving: "Verkeersbord niet zichtbaar door begroeiing",
                                Opgelost_x003f_: "Aangemeld",
                                Aanmaakdatum: "2024-01-12T10:30:00Z",
                                Feitcodegroep: "Verkeersborden"
                            },
                            {
                                Id: 102,
                                Probleembeschrijving: "Verkeersbord beschadigd door vandalisme",
                                Opgelost_x003f_: "In behandeling",
                                Aanmaakdatum: "2024-01-14T14:15:00Z",
                                Feitcodegroep: "Verkeersborden"
                            }
                        ]
                    },
                    {
                        Id: 2,
                        Title: "Kerkstraat 45",
                        Gemeente: "Utrecht",
                        Status_x0020_B_x0026_S: "In behandeling",
                        Waarschuwingsperiode: "Nee",
                        problemen: [
                            {
                                Id: 103,
                                Probleembeschrijving: "Onjuiste parkeertijd op bord",
                                Opgelost_x003f_: "Uitgezet bij OI",
                                Aanmaakdatum: "2024-01-08T09:00:00Z",
                                Feitcodegroep: "Parkeren"
                            }
                        ]
                    },
                    {
                        Id: 3,
                        Title: "Marktplein 8",
                        Gemeente: "Den Haag",
                        Status_x0020_B_x0026_S: "Instemming verleend",
                        Waarschuwingsperiode: "Ja",
                        problemen: [
                            {
                                Id: 104,
                                Probleembeschrijving: "Snelheidsbeperking niet duidelijk aangegeven",
                                Opgelost_x003f_: "Opgelost",
                                Aanmaakdatum: "2024-01-16T11:45:00Z",
                                Feitcodegroep: "Rijgedrag"
                            }
                        ]
                    }
                ];
            },
            addDH: async function(item) {
                console.log('Adding DH:', item);
                alert('DH locatie toegevoegd: ' + item.Title);
                return { success: true, ...item };
            },
            addProblem: async function(item) {
                console.log('Adding problem:', item);
                alert('Probleem toegevoegd: ' + item.Probleembeschrijving);
                return { success: true, ...item };
            }
        };

        // Dashboard state
        let dashboardState = {
            data: [],
            loading: true,
            error: null,
            expandedRows: new Set(),
            modalConfig: null
        };

        // Helper functions
        function renderStatusBadge(status) {
            const className = `status-badge status-${(status || '').toLowerCase().replace(/\s+/g, '-')}`;
            return `<span class="${className}">${status || '-'}</span>`;
        }

        function formatDate(dateString) {
            return new Date(dateString).toLocaleDateString('nl-NL');
        }

        function createExpandIcon(isExpanded) {
            if (isExpanded) {
                return `<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M4 6L8 10L12 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>`;
            } else {
                return `<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M6 12L10 8L6 4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>`;
            }
        }

        // Render functions
        function renderDashboard() {
            const rootElement = document.getElementById('ddh-dashboard-root');
            
            if (dashboardState.loading) {
                rootElement.innerHTML = '<div class="loading-overlay">Data wordt geladen...</div>';
                return;
            }

            if (dashboardState.error) {
                rootElement.innerHTML = `<div class="error-overlay">Fout: ${dashboardState.error}</div>`;
                return;
            }

            const modalHtml = dashboardState.modalConfig ? renderModal() : '';
            
            rootElement.innerHTML = `
                <div class="ddh-app">
                    ${modalHtml}
                    <header class="ddh-header">
                        <h1>DDH Dashboard</h1>
                        <p>Overzicht van handhavingslocaties en gerelateerde problemen</p>
                    </header>
                    <div class="top-actions">
                        <button class="btn btn-primary" onclick="openModal('dh', {})">Nieuwe Handhavingslocatie</button>
                    </div>
                    <main class="ddh-content">
                        <h2>Handhavingslocaties</h2>
                        <div class="data-tabel-container">
                            <table class="data-tabel">
                                <thead>
                                    <tr>
                                        <th>Locatie</th>
                                        <th>Gemeente</th>
                                        <th>Status B&S</th>
                                        <th>Waarschuwing</th>
                                        <th>Problemen</th>
                                        <th>Acties</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${renderTableRows()}
                                </tbody>
                            </table>
                        </div>
                    </main>
                </div>
            `;
        }

        function renderTableRows() {
            let html = '';
            
            dashboardState.data.forEach(dh => {
                const isExpanded = dashboardState.expandedRows.has(dh.Id);
                const hasProblemen = dh.problemen && dh.problemen.length > 0;
                
                html += `
                    <tr class="dh-row ${hasProblemen ? 'expandable' : ''}" ${hasProblemen ? `onclick="toggleRow(${dh.Id})"` : ''}>
                        <td style="display: flex; align-items: center;">
                            <span class="expander ${isExpanded ? 'expanded' : ''}">
                                ${hasProblemen ? createExpandIcon(isExpanded) : ''}
                            </span>
                            ${dh.Title}
                        </td>
                        <td>${dh.Gemeente}</td>
                        <td>${renderStatusBadge(dh.Status_x0020_B_x0026_S)}</td>
                        <td>${dh.Waarschuwingsperiode}</td>
                        <td>${dh.problemen?.length || 0}</td>
                        <td>
                            <button class="btn btn-secondary" onclick="openModal('probleem', ${JSON.stringify(dh).replace(/"/g, '&quot;')})">
                                Nieuw Probleem
                            </button>
                        </td>
                    </tr>
                `;
                
                if (isExpanded && hasProblemen) {
                    html += `
                        <tr class="probleem-header-row">
                            <td colspan="6">Gemelde Problemen</td>
                        </tr>
                    `;
                    
                    dh.problemen.forEach(p => {
                        html += `
                            <tr class="probleem-row">
                                <td>${p.Probleembeschrijving}</td>
                                <td>${p.Feitcodegroep}</td>
                                <td>${renderStatusBadge(p.Opgelost_x003f_)}</td>
                                <td>${formatDate(p.Aanmaakdatum)}</td>
                                <td colspan="2"></td>
                            </tr>
                        `;
                    });
                }
            });
            
            return html;
        }

        function renderModal() {
            const { type, data } = dashboardState.modalConfig;
            const isDH = type === 'dh';
            const title = isDH ? 'Nieuwe Handhavingslocatie' : `Nieuw Probleem voor ${data.Title}`;
            
            return `
                <div class="modal-overlay">
                    <div class="modal-content">
                        <form onsubmit="handleFormSubmit(event)">
                            <div class="modal-header">
                                <h2>${title}</h2>
                                <button type="button" class="modal-close-btn" onclick="closeModal()">×</button>
                            </div>
                            ${isDH ? renderDHFormFields() : renderProbleemFormFields(data)}
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeModal()">Annuleren</button>
                                <button type="submit" class="btn btn-primary">Opslaan</button>
                            </div>
                        </form>
                    </div>
                </div>
            `;
        }

        function renderDHFormFields() {
            return `
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="Title">Titel / Locatie</label>
                        <input type="text" id="Title" name="Title" required>
                    </div>
                    <div class="form-group">
                        <label for="Gemeente">Gemeente</label>
                        <input type="text" id="Gemeente" name="Gemeente" required>
                    </div>
                    <div class="form-group">
                        <label for="Feitcodegroep">Feitcodegroep</label>
                        <select id="Feitcodegroep" name="Feitcodegroep">
                            <option value="Verkeersborden">Verkeersborden</option>
                            <option value="Parkeren">Parkeren</option>
                            <option value="Rijgedrag">Rijgedrag</option>
                        </select>
                    </div>
                </div>
            `;
        }

        function renderProbleemFormFields(dhData) {
            return `
                <div class="form-grid">
                    <div class="form-group">
                        <label for="Title">Pleeglocatie</label>
                        <input type="text" id="Title" name="Title" readonly value="${dhData.Title}">
                    </div>
                    <div class="form-group">
                        <label for="Gemeente">Gemeente</label>
                        <input type="text" id="Gemeente" name="Gemeente" readonly value="${dhData.Gemeente}">
                    </div>
                    <div class="form-group full-width">
                        <label for="Probleembeschrijving">Probleembeschrijving</label>
                        <textarea id="Probleembeschrijving" name="Probleembeschrijving" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="Feitcodegroep">Feitcodegroep</label>
                        <select id="Feitcodegroep" name="Feitcodegroep">
                            <option value="Verkeersborden">Verkeersborden</option>
                            <option value="Parkeren">Parkeren</option>
                            <option value="Rijgedrag">Rijgedrag</option>
                        </select>
                    </div>
                </div>
            `;
        }

        // Event handlers
        function toggleRow(id) {
            if (dashboardState.expandedRows.has(id)) {
                dashboardState.expandedRows.delete(id);
            } else {
                dashboardState.expandedRows.add(id);
            }
            renderDashboard();
        }

        function openModal(type, data) {
            dashboardState.modalConfig = { type, data };
            renderDashboard();
        }

        function closeModal() {
            dashboardState.modalConfig = null;
            renderDashboard();
        }

        async function handleFormSubmit(event) {
            event.preventDefault();
            
            const formData = new FormData(event.target);
            const submissionData = Object.fromEntries(formData.entries());
            
            try {
                if (dashboardState.modalConfig.type === 'dh') {
                    await dataService.addDH(submissionData);
                } else {
                    await dataService.addProblem(submissionData);
                }
                closeModal();
                await fetchData(); // Refresh data
            } catch (error) {
                alert(`Fout bij opslaan: ${error.message}`);
            }
        }

        // Data fetching
        async function fetchData() {
            dashboardState.loading = true;
            dashboardState.error = null;
            renderDashboard();
            
            try {
                const result = await dataService.fetchAll();
                dashboardState.data = result;
                dashboardState.loading = false;
            } catch (error) {
                dashboardState.error = error.message || 'Kon data niet laden.';
                dashboardState.loading = false;
            }
            
            renderDashboard();
        }

        // Initialize the dashboard
        function initDashboard() {
            console.log('Initializing DDH Dashboard...');
            fetchData();
        }

        // Start when DOM is ready
        document.addEventListener('DOMContentLoaded', initDashboard);
    </script>
    
    <noscript>
        <p>JavaScript is vereist om deze applicatie te gebruiken.</p>
    </noscript>
</body>
</html>

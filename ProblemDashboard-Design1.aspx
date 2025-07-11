<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 1: Interactieve Kaart)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <!-- Custom CSS -->
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333; min-height: 100vh;
        }
        .dashboard-container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
            min-height: 100vh; display: flex; flex-direction: column;
        }
        .dashboard-header {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);
            border-radius: 16px; padding: 24px; margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .dashboard-header h1 {
            margin: 0 0 8px 0; font-size: 32px; color: #2c3e50;
            background: linear-gradient(45deg, #667eea, #764ba2); -webkit-background-clip: text;
            -webkit-text-fill-color: transparent; background-clip: text;
        }
        .dashboard-header p { margin: 0; font-size: 16px; color: #7f8c8d; }
        
        .main-content {
            display: grid; grid-template-columns: 1fr 400px; gap: 24px; flex: 1;
        }
        
        /* Interactive Map Section */
        .map-section {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1); overflow: hidden;
        }
        .map-header {
            padding: 20px; border-bottom: 1px solid #e9ecef;
            display: flex; justify-content: space-between; align-items: center;
        }
        .map-header h2 { margin: 0; color: #2c3e50; font-size: 20px; }
        .filter-controls {
            display: flex; gap: 12px; align-items: center;
        }
        .filter-select {
            padding: 8px 16px; border: 1px solid #ddd; border-radius: 8px;
            font-size: 14px; background: white;
        }
        
        .gemeente-grid {
            padding: 20px; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 16px; max-height: 70vh; overflow-y: auto;
        }
        
        .gemeente-card {
            background: white; border-radius: 12px; padding: 20px;
            border: 2px solid #e9ecef; transition: all 0.3s ease;
            cursor: pointer; position: relative; overflow: hidden;
        }
        .gemeente-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 4px; background: linear-gradient(90deg, #28a745, #20c997);
            transform: scaleX(0); transition: transform 0.3s ease;
        }
        .gemeente-card:hover::before { transform: scaleX(1); }
        .gemeente-card:hover {
            border-color: #28a745; box-shadow: 0 8px 24px rgba(40, 167, 69, 0.15);
        }
        .gemeente-card.has-problems::before {
            background: linear-gradient(90deg, #dc3545, #fd7e14); transform: scaleX(1);
        }
        .gemeente-card.has-problems { border-color: #dc3545; }
        
        .gemeente-name {
            font-size: 18px; font-weight: 600; color: #2c3e50; margin-bottom: 12px;
        }
        .gemeente-stats {
            display: flex; justify-content: space-between; align-items: center;
        }
        .total-locations {
            font-size: 14px; color: #6c757d;
        }
        .problem-indicator {
            display: flex; align-items: center; gap: 8px;
        }
        .problem-count {
            background: linear-gradient(45deg, #dc3545, #fd7e14);
            color: white; padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600;
        }
        .problem-count.zero {
            background: #28a745;
        }
        
        /* Sidebar */
        .sidebar {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1); overflow: hidden;
        }
        .sidebar-header {
            padding: 20px; border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        .sidebar-header h3 { margin: 0; font-size: 18px; }
        .sidebar-content { padding: 20px; max-height: 70vh; overflow-y: auto; }
        
        .location-detail {
            margin-bottom: 24px; padding: 16px; background: #f8f9fa;
            border-radius: 8px; border-left: 4px solid #667eea;
        }
        .location-name {
            font-size: 16px; font-weight: 600; color: #2c3e50; margin-bottom: 8px;
        }
        .location-info {
            font-size: 14px; color: #6c757d; margin-bottom: 12px;
        }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 8px;
        }
        .problem-item {
            background: white; padding: 12px; border-radius: 6px;
            border-left: 3px solid transparent; transition: all 0.2s ease;
        }
        .problem-item:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .problem-item.status-aangemeld { border-left-color: #ffc107; }
        .problem-item.status-in-behandeling { border-left-color: #007bff; }
        .problem-item.status-opgelost { border-left-color: #28a745; }
        
        .problem-description {
            font-size: 13px; color: #495057; margin-bottom: 4px;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .problem-meta {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 11px; color: #6c757d;
        }
        
        .status-badge {
            padding: 2px 8px; border-radius: 12px; font-size: 10px;
            font-weight: 600; text-transform: uppercase;
        }
        .status-aangemeld { background: #fff3cd; color: #856404; }
        .status-in-behandeling { background: #cce5ff; color: #004085; }
        .status-opgelost { background: #d4edda; color: #155724; }
        
        .loading-state, .empty-state {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; padding: 40px; text-align: center;
        }
        .loading-spinner {
            width: 40px; height: 40px; border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea; border-radius: 50%;
            animation: spin 1s linear infinite; margin-bottom: 16px;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        
        @media (max-width: 1200px) {
            .main-content { grid-template-columns: 1fr; }
            .gemeente-grid { grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="dashboard-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Dashboard wordt geladen...</p>
        </div>
    </div>

    <!-- React -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        const { createElement: h, useState, useEffect } = window.React;
        const { createRoot } = window.ReactDOM;

        // Import configuration and navigation
        const { DDH_CONFIG } = await import('./js/config/index.js');
        const { TEMP_PLACEHOLDER_DATA } = await import('./js/components/pageNavigation.js');
        const FooterNavigation = (await import('./js/components/FooterNavigation.js')).default;

        const ProblemDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [filterStatus, setFilterStatus] = useState('all');

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                    } catch (error) {
                        console.error('Data loading error, using placeholder data:', error);
                        // Use placeholder data if SharePoint is not available
                        setData(TEMP_PLACEHOLDER_DATA);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();
            }, []);

            // Group data by gemeente
            const gemeenteData = data.reduce((acc, location) => {
                const gemeente = location.Gemeente;
                if (!acc[gemeente]) {
                    acc[gemeente] = { locations: [], totalProblems: 0, activeProblems: 0 };
                }
                acc[gemeente].locations.push(location);
                acc[gemeente].totalProblems += location.problemen?.length || 0;
                acc[gemeente].activeProblems += location.problemen?.filter(p => 
                    p.Opgelost_x003f_ !== 'Opgelost'
                ).length || 0;
                return acc;
            }, {});

            const filteredLocations = selectedGemeente 
                ? gemeenteData[selectedGemeente]?.locations || []
                : [];

            if (loading) {
                return h('div', { className: 'loading-state' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Dashboard wordt geladen...')
                );
            }

            return h('div', null,
                h('header', { className: 'dashboard-header' },
                    h('h1', null, 'Problemen Dashboard'),
                    h('p', null, 'Interactieve kaart weergave - Selecteer een gemeente om problemen per locatie te bekijken')
                ),
                h('div', { className: 'main-content' },
                    h('div', { className: 'map-section' },
                        h('div', { className: 'map-header' },
                            h('h2', null, 'Gemeenten Overzicht'),
                            h('div', { className: 'filter-controls' },
                                h('select', {
                                    className: 'filter-select',
                                    value: filterStatus,
                                    onChange: (e) => setFilterStatus(e.target.value)
                                },
                                    h('option', { value: 'all' }, 'Alle statussen'),
                                    h('option', { value: 'active' }, 'Alleen actieve problemen'),
                                    h('option', { value: 'resolved' }, 'Alleen opgeloste problemen')
                                )
                            )
                        ),
                        h('div', { className: 'gemeente-grid' },
                            Object.entries(gemeenteData).map(([gemeente, info]) =>
                                h('div', {
                                    key: gemeente,
                                    className: `gemeente-card ${info.activeProblems > 0 ? 'has-problems' : ''}`,
                                    onClick: () => setSelectedGemeente(gemeente)
                                },
                                    h('div', { className: 'gemeente-name' }, gemeente),
                                    h('div', { className: 'gemeente-stats' },
                                        h('div', { className: 'total-locations' },
                                            `${info.locations.length} locaties`
                                        ),
                                        h('div', { className: 'problem-indicator' },
                                            h('span', {
                                                className: `problem-count ${info.activeProblems === 0 ? 'zero' : ''}`
                                            }, info.activeProblems),
                                            h('span', null, 'actieve problemen')
                                        )
                                    )
                                )
                            )
                        )
                    ),
                    h('div', { className: 'sidebar' },
                        h('div', { className: 'sidebar-header' },
                            h('h3', null, selectedGemeente ? `${selectedGemeente} - Locaties` : 'Selecteer gemeente')
                        ),
                        h('div', { className: 'sidebar-content' },
                            selectedGemeente ? (
                                filteredLocations.length > 0 ? (
                                    filteredLocations.map(location =>
                                        h('div', { key: location.Id, className: 'location-detail' },
                                            h('div', { className: 'location-name' }, location.Title),
                                            h('div', { className: 'location-info' },
                                                `${location.problemen?.length || 0} problemen • ${location.Status_x0020_B_x0026_S}`
                                            ),
                                            location.problemen?.length > 0 && h('div', { className: 'problems-list' },
                                                location.problemen.map(problem =>
                                                    h('div', {
                                                        key: problem.Id,
                                                        className: `problem-item status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                    },
                                                        h('div', { className: 'problem-description' },
                                                            problem.Probleembeschrijving
                                                        ),
                                                        h('div', { className: 'problem-meta' },
                                                            h('span', { className: `status-badge status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}` },
                                                                problem.Opgelost_x003f_
                                                            ),
                                                            h('span', null,
                                                                new Date(problem.Aanmaakdatum).toLocaleDateString('nl-NL')
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ) : (
                                    h('div', { className: 'empty-state' },
                                        h('p', null, 'Geen locaties gevonden voor deze gemeente')
                                    )
                                )
                            ) : (
                                h('div', { className: 'empty-state' },
                                    h('p', null, 'Klik op een gemeente om locaties en problemen te bekijken')
                                )
                            )
                        )
                    )
                ),
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('dashboard-root');
        const root = createRoot(rootElement);
        root.render(h(ProblemDashboard));
    </script>
</body>
</html>
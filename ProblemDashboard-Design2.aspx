<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 2: Card Explorer)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0; background: #f5f7fa; color: #333;
        }
        .dashboard-wrapper {
            max-width: 1600px; margin: 0 auto; padding: 20px;
        }
        
        /* Header with search and filters */
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 32px; border-radius: 16px; margin-bottom: 24px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 20px;
        }
        .header-title h1 {
            margin: 0 0 8px 0; font-size: 28px; font-weight: 700;
        }
        .header-title p { margin: 0; opacity: 0.9; font-size: 16px; }
        
        .search-controls {
            display: flex; gap: 12px; align-items: center; flex-wrap: wrap;
        }
        .search-input {
            padding: 12px 16px; border: none; border-radius: 12px;
            font-size: 14px; width: 280px; box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        .filter-select {
            padding: 12px 16px; border: none; border-radius: 12px;
            font-size: 14px; background: white; cursor: pointer;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        
        /* Stats bar */
        .stats-bar {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 24px;
        }
        .stat-card {
            background: white; padding: 20px; border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); text-align: center;
            border-left: 4px solid #667eea; transition: all 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(0,0,0,0.12); }
        .stat-number {
            font-size: 32px; font-weight: 700; color: #2c3e50; margin-bottom: 4px;
        }
        .stat-label { font-size: 14px; color: #7f8c8d; text-transform: uppercase; }
        .stat-card.problems { border-left-color: #e74c3c; }
        .stat-card.active { border-left-color: #f39c12; }
        .stat-card.resolved { border-left-color: #27ae60; }
        
        /* Main content area */
        .content-grid {
            display: grid; grid-template-columns: 350px 1fr; gap: 24px;
        }
        
        /* Location sidebar */
        .locations-sidebar {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); max-height: 80vh; overflow-y: auto;
        }
        .sidebar-header {
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f3f4;
        }
        .sidebar-header h3 {
            margin: 0; font-size: 18px; color: #2c3e50;
        }
        
        .location-list {
            display: flex; flex-direction: column; gap: 8px;
        }
        .location-item {
            padding: 16px; border-radius: 12px; cursor: pointer;
            transition: all 0.3s ease; background: #f8f9fa;
            border: 2px solid transparent; position: relative;
        }
        .location-item:hover { background: #e9ecef; }
        .location-item.selected {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border-color: #667eea;
        }
        .location-item.has-active-problems::before {
            content: ''; position: absolute; top: 8px; right: 8px;
            width: 8px; height: 8px; background: #e74c3c;
            border-radius: 50%; animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .location-name {
            font-weight: 600; font-size: 14px; margin-bottom: 4px;
        }
        .location-meta {
            font-size: 12px; opacity: 0.8; display: flex;
            justify-content: space-between; align-items: center;
        }
        .problem-badge {
            background: rgba(255,255,255,0.2); padding: 2px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .location-item.selected .problem-badge {
            background: rgba(255,255,255,0.3);
        }
        
        /* Problems display */
        .problems-area {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        .problems-header {
            margin-bottom: 24px; padding-bottom: 16px; border-bottom: 2px solid #f1f3f4;
            display: flex; justify-content: space-between; align-items: center;
        }
        .problems-header h3 {
            margin: 0; font-size: 20px; color: #2c3e50;
        }
        .view-toggle {
            display: flex; gap: 8px;
        }
        .toggle-btn {
            padding: 8px 16px; border: 2px solid #e9ecef; background: white;
            border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 600;
            transition: all 0.2s ease;
        }
        .toggle-btn.active {
            background: #667eea; color: white; border-color: #667eea;
        }
        
        /* Card view */
        .problems-cards {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .problem-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border-radius: 16px; padding: 20px; transition: all 0.3s ease;
            border: 2px solid #e9ecef; position: relative; overflow: hidden;
        }
        .problem-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 4px; background: linear-gradient(90deg, #667eea, #764ba2);
        }
        .problem-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.15);
        }
        .problem-card.urgent::before { background: linear-gradient(90deg, #e74c3c, #f39c12); }
        .problem-card.resolved::before { background: linear-gradient(90deg, #27ae60, #2ecc71); }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 12px;
        }
        .problem-id {
            font-size: 12px; color: #7f8c8d; font-weight: 600;
        }
        .problem-date {
            font-size: 11px; color: #bdc3c7;
        }
        
        .problem-description {
            font-size: 14px; line-height: 1.5; color: #2c3e50;
            margin-bottom: 16px; display: -webkit-box;
            -webkit-line-clamp: 3; -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 12px; border-top: 1px solid #ecf0f1;
        }
        .category-tag {
            background: #667eea; color: white; padding: 4px 12px;
            border-radius: 16px; font-size: 11px; font-weight: 600;
        }
        .status-indicator {
            padding: 6px 12px; border-radius: 20px; font-size: 11px;
            font-weight: 600; text-transform: uppercase;
        }
        .status-aangemeld { background: #fff3cd; color: #856404; }
        .status-in-behandeling { background: #cce5ff; color: #004085; }
        .status-opgelost { background: #d4edda; color: #155724; }
        
        /* List view */
        .problems-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .problem-list-item {
            background: #f8f9fa; border-radius: 12px; padding: 16px;
            border-left: 4px solid #667eea; transition: all 0.2s ease;
        }
        .problem-list-item:hover {
            background: #e9ecef; box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        .list-item-header {
            display: flex; justify-content: between; align-items: center;
            margin-bottom: 8px;
        }
        .list-item-description {
            font-size: 13px; color: #495057; margin-bottom: 8px;
        }
        .list-item-meta {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 11px; color: #6c757d;
        }
        
        .empty-state {
            text-align: center; padding: 60px 20px; color: #7f8c8d;
        }
        .empty-state-icon {
            font-size: 48px; margin-bottom: 16px; opacity: 0.5;
        }
        
        @media (max-width: 1200px) {
            .content-grid { grid-template-columns: 1fr; }
            .locations-sidebar { max-height: none; }
            .problems-cards { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); }
        }
        
        @media (max-width: 768px) {
            .header-content { flex-direction: column; text-align: center; }
            .search-controls { flex-direction: column; width: 100%; }
            .search-input { width: 100%; }
            .stats-bar { grid-template-columns: repeat(2, 1fr); }
            .problems-cards { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="dashboard-wrapper">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Dashboard wordt geladen...</p>
            </div>
        </div>
    </div>

    <!-- React -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        const { createElement: h, useState, useEffect, useMemo } = window.React;
        const { createRoot } = window.ReactDOM;

        // Import configuration
        const { DDH_CONFIG } = await import('./js/config/index.js');

        const ProblemCardDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [selectedLocation, setSelectedLocation] = useState(null);
            const [searchTerm, setSearchTerm] = useState('');
            const [statusFilter, setStatusFilter] = useState('all');
            const [viewMode, setViewMode] = useState('cards');

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                        if (result.length > 0) setSelectedLocation(result[0]);
                    } catch (error) {
                        console.error('Data loading error:', error);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();
            }, []);

            const filteredData = useMemo(() => {
                return data.filter(location => {
                    const matchesSearch = location.Title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                        location.Gemeente.toLowerCase().includes(searchTerm.toLowerCase());
                    return matchesSearch;
                });
            }, [data, searchTerm]);

            const filteredProblems = useMemo(() => {
                if (!selectedLocation) return [];
                let problems = selectedLocation.problemen || [];
                
                if (statusFilter !== 'all') {
                    if (statusFilter === 'active') {
                        problems = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                    } else if (statusFilter === 'resolved') {
                        problems = problems.filter(p => p.Opgelost_x003f_ === 'Opgelost');
                    }
                }
                return problems;
            }, [selectedLocation, statusFilter]);

            const stats = useMemo(() => {
                const totalLocations = data.length;
                const totalProblems = data.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                const activeProblems = data.reduce((sum, loc) => 
                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                const resolvedProblems = totalProblems - activeProblems;
                return { totalLocations, totalProblems, activeProblems, resolvedProblems };
            }, [data]);

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #667eea', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Dashboard wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'dashboard-header' },
                    h('div', { className: 'header-content' },
                        h('div', { className: 'header-title' },
                            h('h1', null, 'Problemen Explorer'),
                            h('p', null, 'Uitgebreide kaartweergave voor probleem beheer per locatie')
                        ),
                        h('div', { className: 'search-controls' },
                            h('input', {
                                type: 'text',
                                className: 'search-input',
                                placeholder: 'Zoek locaties of gemeenten...',
                                value: searchTerm,
                                onChange: (e) => setSearchTerm(e.target.value)
                            }),
                            h('select', {
                                className: 'filter-select',
                                value: statusFilter,
                                onChange: (e) => setStatusFilter(e.target.value)
                            },
                                h('option', { value: 'all' }, 'Alle problemen'),
                                h('option', { value: 'active' }, 'Alleen actief'),
                                h('option', { value: 'resolved' }, 'Alleen opgelost')
                            )
                        )
                    )
                ),

                // Stats bar
                h('div', { className: 'stats-bar' },
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalLocations),
                        h('div', { className: 'stat-label' }, 'Locaties')
                    ),
                    h('div', { className: 'stat-card problems' },
                        h('div', { className: 'stat-number' }, stats.totalProblems),
                        h('div', { className: 'stat-label' }, 'Totaal Problemen')
                    ),
                    h('div', { className: 'stat-card active' },
                        h('div', { className: 'stat-number' }, stats.activeProblems),
                        h('div', { className: 'stat-label' }, 'Actieve Problemen')
                    ),
                    h('div', { className: 'stat-card resolved' },
                        h('div', { className: 'stat-number' }, stats.resolvedProblems),
                        h('div', { className: 'stat-label' }, 'Opgeloste Problemen')
                    )
                ),

                // Main content
                h('div', { className: 'content-grid' },
                    // Locations sidebar
                    h('div', { className: 'locations-sidebar' },
                        h('div', { className: 'sidebar-header' },
                            h('h3', null, 'Locaties')
                        ),
                        h('div', { className: 'location-list' },
                            filteredData.map(location => {
                                const hasActiveProblems = (location.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost');
                                return h('div', {
                                    key: location.Id,
                                    className: `location-item ${selectedLocation?.Id === location.Id ? 'selected' : ''} ${hasActiveProblems ? 'has-active-problems' : ''}`,
                                    onClick: () => setSelectedLocation(location)
                                },
                                    h('div', { className: 'location-name' }, location.Title),
                                    h('div', { className: 'location-meta' },
                                        h('span', null, location.Gemeente),
                                        h('span', { className: 'problem-badge' }, 
                                            `${location.problemen?.length || 0} problemen`
                                        )
                                    )
                                );
                            })
                        )
                    ),

                    // Problems area
                    h('div', { className: 'problems-area' },
                        h('div', { className: 'problems-header' },
                            h('h3', null, selectedLocation ? 
                                `${selectedLocation.Title} - ${selectedLocation.Gemeente}` : 
                                'Selecteer een locatie'
                            ),
                            h('div', { className: 'view-toggle' },
                                h('button', {
                                    className: `toggle-btn ${viewMode === 'cards' ? 'active' : ''}`,
                                    onClick: () => setViewMode('cards')
                                }, 'Kaarten'),
                                h('button', {
                                    className: `toggle-btn ${viewMode === 'list' ? 'active' : ''}`,
                                    onClick: () => setViewMode('list')
                                }, 'Lijst')
                            )
                        ),

                        selectedLocation ? (
                            filteredProblems.length > 0 ? (
                                viewMode === 'cards' ? (
                                    h('div', { className: 'problems-cards' },
                                        filteredProblems.map(problem => {
                                            const isUrgent = problem.Opgelost_x003f_ === 'Aangemeld';
                                            const isResolved = problem.Opgelost_x003f_ === 'Opgelost';
                                            return h('div', {
                                                key: problem.Id,
                                                className: `problem-card ${isUrgent ? 'urgent' : ''} ${isResolved ? 'resolved' : ''}`
                                            },
                                                h('div', { className: 'problem-header' },
                                                    h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                                    h('div', { className: 'problem-date' },
                                                        new Date(problem.Aanmaakdatum).toLocaleDateString('nl-NL')
                                                    )
                                                ),
                                                h('div', { className: 'problem-description' },
                                                    problem.Probleembeschrijving
                                                ),
                                                h('div', { className: 'problem-footer' },
                                                    h('div', { className: 'category-tag' }, problem.Feitcodegroep),
                                                    h('div', {
                                                        className: `status-indicator status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                    }, problem.Opgelost_x003f_)
                                                )
                                            );
                                        })
                                    )
                                ) : (
                                    h('div', { className: 'problems-list' },
                                        filteredProblems.map(problem =>
                                            h('div', { key: problem.Id, className: 'problem-list-item' },
                                                h('div', { className: 'list-item-header' },
                                                    h('strong', null, `Probleem #${problem.Id}`)
                                                ),
                                                h('div', { className: 'list-item-description' },
                                                    problem.Probleembeschrijving
                                                ),
                                                h('div', { className: 'list-item-meta' },
                                                    h('span', null, problem.Feitcodegroep),
                                                    h('span', {
                                                        className: `status-indicator status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                    }, problem.Opgelost_x003f_),
                                                    h('span', null, new Date(problem.Aanmaakdatum).toLocaleDateString('nl-NL'))
                                                )
                                            )
                                        )
                                    )
                                )
                            ) : (
                                h('div', { className: 'empty-state' },
                                    h('div', { className: 'empty-state-icon' }, '📋'),
                                    h('h4', null, 'Geen problemen gevonden'),
                                    h('p', null, 'Deze locatie heeft geen problemen die voldoen aan uw filters.')
                                )
                            )
                        ) : (
                            h('div', { className: 'empty-state' },
                                h('div', { className: 'empty-state-icon' }, '👈'),
                                h('h4', null, 'Selecteer een locatie'),
                                h('p', null, 'Kies een locatie uit de lijst om problemen te bekijken.')
                            )
                        )
                    )
                )
            );
        };

        const rootElement = document.getElementById('dashboard-root');
        const root = createRoot(rootElement);
        root.render(h(ProblemCardDashboard));
    </script>
</body>
</html>
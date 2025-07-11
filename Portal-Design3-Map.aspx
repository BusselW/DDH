<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 3: Geographic Map View</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #1a202c; color: #f7fafc;
        }
        .portal-container {
            min-height: 100vh; display: flex; flex-direction: column;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #2d3748 0%, #4a5568 100%);
            color: white; padding: 16px 24px; box-shadow: 0 4px 16px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            max-width: 1600px; margin: 0 auto;
        }
        .portal-title {
            font-size: 24px; font-weight: 800; margin: 0;
            background: linear-gradient(135deg, #4fd1c7, #81e6d9);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .header-controls {
            display: flex; gap: 12px; align-items: center;
        }
        .search-input {
            padding: 8px 12px; border: 2px solid #4a5568; background: #2d3748;
            border-radius: 8px; font-size: 14px; color: white; width: 250px;
        }
        .search-input:focus {
            outline: none; border-color: #4fd1c7; box-shadow: 0 0 0 3px rgba(79, 209, 199, 0.1);
        }
        .header-btn {
            padding: 8px 16px; border: 2px solid #4a5568; background: #2d3748;
            border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600;
            color: white; transition: all 0.2s ease;
        }
        .header-btn.active { background: #4fd1c7; color: #1a202c; border-color: #4fd1c7; }
        .header-btn:hover:not(.active) { background: #4a5568; }
        
        /* Main Content */
        .main-content {
            flex: 1; display: flex; position: relative;
        }
        
        /* Map Area */
        .map-container {
            flex: 1; background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%);
            position: relative; overflow: hidden;
        }
        .map-grid {
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px; padding: 20px; overflow-y: auto;
        }
        
        /* Gemeente Cards on Map */
        .gemeente-marker {
            background: rgba(45, 55, 72, 0.95); border: 2px solid #4a5568;
            border-radius: 16px; padding: 20px; backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3); transition: all 0.3s ease;
            cursor: pointer; position: relative; overflow: hidden;
        }
        .gemeente-marker::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 4px; background: linear-gradient(90deg, #4fd1c7, #81e6d9);
        }
        .gemeente-marker:hover {
            transform: translateY(-4px) scale(1.02);
            box-shadow: 0 16px 48px rgba(79, 209, 199, 0.2);
            border-color: #4fd1c7;
        }
        .gemeente-marker.has-problems {
            border-color: #f56565; background: rgba(45, 55, 72, 0.98);
        }
        .gemeente-marker.has-problems::before {
            background: linear-gradient(90deg, #f56565, #fc8181);
        }
        .gemeente-marker.has-problems:hover {
            box-shadow: 0 16px 48px rgba(245, 101, 101, 0.2);
            border-color: #fc8181;
        }
        
        .marker-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 20px; font-weight: 700; color: #f7fafc; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #4fd1c7, #81e6d9); color: #1a202c;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .gemeente-badge.problems {
            background: linear-gradient(135deg, #f56565, #fc8181);
            color: white;
        }
        
        .locaties-grid {
            display: grid; gap: 8px; margin-bottom: 16px;
        }
        .locatie-pin {
            background: rgba(74, 85, 104, 0.6); border-radius: 8px; padding: 12px;
            border-left: 3px solid #4a5568; transition: all 0.2s ease;
            cursor: pointer;
        }
        .locatie-pin:hover { background: rgba(74, 85, 104, 0.8); }
        .locatie-pin.has-active-problems {
            border-left-color: #f56565; background: rgba(245, 101, 101, 0.1);
        }
        .locatie-pin.has-active-problems:hover {
            background: rgba(245, 101, 101, 0.2);
        }
        
        .locatie-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 4px;
        }
        .locatie-name {
            font-size: 14px; font-weight: 600; color: #e2e8f0;
        }
        .locatie-status {
            display: flex; gap: 4px;
        }
        .status-dot {
            width: 8px; height: 8px; border-radius: 50%;
        }
        .status-dot.active { background: #f56565; box-shadow: 0 0 8px #f56565; }
        .status-dot.resolved { background: #48bb78; }
        .status-dot.none { background: #4a5568; }
        
        .locatie-meta {
            font-size: 12px; color: #a0aec0;
        }
        
        .gemeente-summary {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 12px; border-top: 1px solid #4a5568;
        }
        .summary-stats {
            font-size: 12px; color: #a0aec0;
        }
        .expand-btn {
            background: linear-gradient(135deg, #4fd1c7, #81e6d9); color: #1a202c;
            border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer;
            font-size: 11px; font-weight: 700; transition: all 0.2s ease;
        }
        .expand-btn:hover { transform: scale(1.05); }
        
        /* Sidebar Panel */
        .sidebar-panel {
            width: 400px; background: rgba(26, 32, 44, 0.95); backdrop-filter: blur(10px);
            box-shadow: -4px 0 16px rgba(0,0,0,0.3); z-index: 100;
            transform: translateX(100%); transition: transform 0.3s ease;
            overflow-y: auto;
        }
        .sidebar-panel.open {
            transform: translateX(0);
        }
        
        .sidebar-header {
            padding: 24px; border-bottom: 1px solid #4a5568;
        }
        .sidebar-title {
            font-size: 20px; font-weight: 700; margin: 0 0 8px 0; color: #f7fafc;
        }
        .sidebar-subtitle {
            font-size: 14px; color: #a0aec0; margin: 0;
        }
        .close-btn {
            position: absolute; top: 20px; right: 20px;
            background: none; border: none; color: #a0aec0; cursor: pointer;
            font-size: 20px; padding: 4px;
        }
        
        .sidebar-content {
            padding: 24px;
        }
        .detail-section {
            margin-bottom: 32px;
        }
        .section-title {
            font-size: 16px; font-weight: 600; margin: 0 0 16px 0; color: #e2e8f0;
            display: flex; align-items: center; gap: 8px;
        }
        
        .stats-grid {
            display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;
            margin-bottom: 20px;
        }
        .stat-item {
            background: rgba(45, 55, 72, 0.6); border-radius: 8px; padding: 16px;
            text-align: center; border: 1px solid #4a5568;
        }
        .stat-number {
            font-size: 24px; font-weight: 800; color: #4fd1c7; margin-bottom: 4px;
        }
        .stat-label {
            font-size: 12px; color: #a0aec0; text-transform: uppercase; font-weight: 600;
        }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .problem-card {
            background: rgba(45, 55, 72, 0.6); border-radius: 12px; padding: 16px;
            border-left: 4px solid #4a5568; transition: all 0.2s ease;
        }
        .problem-card:hover { background: rgba(45, 55, 72, 0.8); }
        .problem-card.active {
            border-left-color: #f56565; background: rgba(245, 101, 101, 0.1);
        }
        .problem-card.resolved {
            border-left-color: #48bb78; opacity: 0.7;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #a0aec0; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #718096;
        }
        .problem-description {
            font-size: 14px; color: #e2e8f0; line-height: 1.4; margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #4fd1c7; color: #1a202c; padding: 4px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: rgba(245, 101, 101, 0.2); color: #fc8181; }
        .problem-status.behandeling { background: rgba(79, 209, 199, 0.2); color: #4fd1c7; }
        .problem-status.uitgezet { background: rgba(237, 137, 54, 0.2); color: #ed8936; }
        .problem-status.opgelost { background: rgba(72, 187, 120, 0.2); color: #68d391; }
        
        /* Legend */
        .legend {
            position: absolute; bottom: 20px; left: 20px; z-index: 1000;
            background: rgba(26, 32, 44, 0.9); backdrop-filter: blur(10px);
            border-radius: 12px; padding: 16px; border: 1px solid #4a5568;
        }
        .legend-title {
            font-size: 14px; font-weight: 600; margin: 0 0 8px 0; color: #e2e8f0;
        }
        .legend-item {
            display: flex; align-items: center; gap: 8px; margin-bottom: 4px;
            font-size: 12px; color: #a0aec0;
        }
        .legend-color {
            width: 12px; height: 12px; border-radius: 50%;
        }
        
        /* Loading and Empty States */
        .loading-overlay {
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(26, 32, 44, 0.9); display: flex; align-items: center;
            justify-content: center; flex-direction: column; gap: 16px;
        }
        .loading-spinner {
            width: 50px; height: 50px; border: 4px solid #2d3748;
            border-top: 4px solid #4fd1c7; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .map-grid { grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }
            .sidebar-panel { width: 100%; }
        }
        @media (max-width: 768px) {
            .header-content { flex-direction: column; gap: 12px; }
            .header-controls { width: 100%; justify-content: space-between; }
            .search-input { width: 200px; }
            .map-grid { grid-template-columns: 1fr; padding: 12px; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-overlay">
            <div class="loading-spinner"></div>
            <p>Geographic Portal wordt geladen...</p>
        </div>
    </div>

    <!-- React -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        const { createElement: h, useState, useEffect, useMemo } = window.React;
        const { createRoot } = window.ReactDOM;

        // Import configuration and navigation
        const { DDH_CONFIG } = await import('./js/config/index.js');
        const { TEMP_PLACEHOLDER_DATA } = await import('./js/components/pageNavigation.js');
        const FooterNavigation = (await import('./js/components/FooterNavigation.js')).default;

        const MapPortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [activeFilter, setActiveFilter] = useState('all');
            const [selectedItem, setSelectedItem] = useState(null);
            const [sidebarOpen, setSidebarOpen] = useState(false);

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
            const groupedData = useMemo(() => {
                const grouped = {};
                data.forEach(location => {
                    const gemeente = location.Gemeente;
                    if (!grouped[gemeente]) {
                        grouped[gemeente] = [];
                    }
                    grouped[gemeente].push(location);
                });
                return grouped;
            }, [data]);

            const filteredData = useMemo(() => {
                let filtered = { ...groupedData };
                
                if (searchTerm) {
                    filtered = {};
                    Object.entries(groupedData).forEach(([gemeente, locations]) => {
                        const searchMatch = gemeente.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                          locations.some(loc => loc.Title.toLowerCase().includes(searchTerm.toLowerCase()));
                        if (searchMatch) {
                            filtered[gemeente] = locations;
                        }
                    });
                }
                
                if (activeFilter !== 'all') {
                    const newFiltered = {};
                    Object.entries(filtered).forEach(([gemeente, locations]) => {
                        if (activeFilter === 'problems') {
                            const hasProblems = locations.some(loc => 
                                (loc.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost')
                            );
                            if (hasProblems) newFiltered[gemeente] = locations;
                        } else if (activeFilter === 'resolved') {
                            const hasResolved = locations.some(loc => 
                                (loc.problemen || []).some(p => p.Opgelost_x003f_ === 'Opgelost')
                            );
                            if (hasResolved) newFiltered[gemeente] = locations;
                        } else if (activeFilter === 'clean') {
                            const isClean = locations.every(loc => 
                                (loc.problemen || []).every(p => p.Opgelost_x003f_ === 'Opgelost')
                            );
                            if (isClean) newFiltered[gemeente] = locations;
                        }
                    });
                    filtered = newFiltered;
                }
                
                return filtered;
            }, [groupedData, searchTerm, activeFilter]);

            const openDetails = (type, data) => {
                setSelectedItem({ type, data });
                setSidebarOpen(true);
            };

            const closeSidebar = () => {
                setSidebarOpen(false);
                setTimeout(() => setSelectedItem(null), 300);
            };

            const renderSidebarContent = () => {
                if (!selectedItem) return null;

                const { type, data: itemData } = selectedItem;

                if (type === 'gemeente') {
                    const locations = groupedData[itemData] || [];
                    const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                    const activeProblems = locations.reduce((sum, loc) => 
                        sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);

                    return h('div', null,
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, '📊 Gemeente Overzicht'),
                            h('div', { className: 'stats-grid' },
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, locations.length),
                                    h('div', { className: 'stat-label' }, 'Locaties')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, totalProblems),
                                    h('div', { className: 'stat-label' }, 'Problemen')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, activeProblems),
                                    h('div', { className: 'stat-label' }, 'Actief')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, totalProblems - activeProblems),
                                    h('div', { className: 'stat-label' }, 'Opgelost')
                                )
                            )
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, '📍 Handhavingslocaties'),
                            h('div', { className: 'problems-list' },
                                locations.map(location => {
                                    const problems = location.problemen || [];
                                    const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                                    
                                    return h('div', {
                                        key: location.Id,
                                        className: `problem-card ${activeProbs.length > 0 ? 'active' : ''}`,
                                        onClick: () => openDetails('locatie', location)
                                    },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, location.Title),
                                            h('div', { className: 'problem-age' }, `${problems.length} problemen`)
                                        ),
                                        h('div', { className: 'problem-description' },
                                            `Status: ${location.Status_x0020_B_x0026_S || 'Onbekend'} • `,
                                            `Feitcode: ${location.Feitcodegroep}`
                                        ),
                                        h('div', { className: 'problem-footer' },
                                            h('div', { className: 'problem-category' }, 'Locatie'),
                                            activeProbs.length > 0 && h('div', { className: 'problem-status aangemeld' }, 
                                                `${activeProbs.length} actief`)
                                        )
                                    );
                                })
                            )
                        )
                    );
                }

                if (type === 'locatie') {
                    const problems = itemData.problemen || [];
                    const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                    const resolvedProbs = problems.filter(p => p.Opgelost_x003f_ === 'Opgelost');

                    return h('div', null,
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, '📊 Locatie Statistieken'),
                            h('div', { className: 'stats-grid' },
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, problems.length),
                                    h('div', { className: 'stat-label' }, 'Totaal')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, activeProbs.length),
                                    h('div', { className: 'stat-label' }, 'Actief')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, resolvedProbs.length),
                                    h('div', { className: 'stat-label' }, 'Opgelost')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, 
                                        problems.length > 0 ? Math.round((resolvedProbs.length / problems.length) * 100) : 100
                                    ),
                                    h('div', { className: 'stat-label' }, '% Opgelost')
                                )
                            )
                        ),
                        activeProbs.length > 0 && h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, '🔥 Actieve Problemen'),
                            h('div', { className: 'problems-list' },
                                activeProbs.map(problem => {
                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                    return h('div', { key: problem.Id, className: 'problem-card active' },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                            h('div', { className: 'problem-age' }, `${daysSince}d geleden`)
                                        ),
                                        h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                        h('div', { className: 'problem-footer' },
                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                            h('div', {
                                                className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                            }, problem.Opgelost_x003f_)
                                        )
                                    );
                                })
                            )
                        ),
                        resolvedProbs.length > 0 && h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, '✅ Opgeloste Problemen'),
                            h('div', { className: 'problems-list' },
                                resolvedProbs.slice(0, 5).map(problem => {
                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                    return h('div', { key: problem.Id, className: 'problem-card resolved' },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                            h('div', { className: 'problem-age' }, `${daysSince}d geleden`)
                                        ),
                                        h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                        h('div', { className: 'problem-footer' },
                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                            h('div', { className: 'problem-status opgelost' }, 'Opgelost')
                                        )
                                    );
                                }),
                                resolvedProbs.length > 5 && h('div', { style: { textAlign: 'center', padding: '12px', color: '#a0aec0', fontSize: '12px' } },
                                    `+${resolvedProbs.length - 5} meer opgeloste problemen`
                                )
                            )
                        )
                    );
                }

                return null;
            };

            if (loading) {
                return h('div', { className: 'loading-overlay' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Geographic Portal wordt geladen...')
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Geographic Portal'),
                        h('div', { className: 'header-controls' },
                            h('input', {
                                type: 'text',
                                className: 'search-input',
                                placeholder: 'Zoek gemeente of locatie...',
                                value: searchTerm,
                                onChange: (e) => setSearchTerm(e.target.value)
                            }),
                            h('button', {
                                className: `header-btn ${activeFilter === 'all' ? 'active' : ''}`,
                                onClick: () => setActiveFilter('all')
                            }, 'Alle'),
                            h('button', {
                                className: `header-btn ${activeFilter === 'problems' ? 'active' : ''}`,
                                onClick: () => setActiveFilter('problems')
                            }, 'Problemen'),
                            h('button', {
                                className: `header-btn ${activeFilter === 'clean' ? 'active' : ''}`,
                                onClick: () => setActiveFilter('clean')
                            }, 'Schoon')
                        )
                    )
                ),

                // Main Content
                h('div', { className: 'main-content' },
                    // Map Container
                    h('div', { className: 'map-container' },
                        h('div', { className: 'map-grid' },
                            Object.entries(filteredData).map(([gemeente, locations]) => {
                                const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                                const activeProblems = locations.reduce((sum, loc) => 
                                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                                const hasActiveProblems = activeProblems > 0;

                                return h('div', {
                                    key: gemeente,
                                    className: `gemeente-marker ${hasActiveProblems ? 'has-problems' : ''}`,
                                    onClick: () => openDetails('gemeente', gemeente)
                                },
                                    h('div', { className: 'marker-header' },
                                        h('h3', { className: 'gemeente-name' }, gemeente),
                                        h('div', { 
                                            className: `gemeente-badge ${hasActiveProblems ? 'problems' : ''}`
                                        }, `${locations.length} locaties`)
                                    ),
                                    
                                    h('div', { className: 'locaties-grid' },
                                        locations.slice(0, 4).map(location => {
                                            const problems = location.problemen || [];
                                            const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                                            const hasProbs = activeProbs.length > 0;

                                            return h('div', {
                                                key: location.Id,
                                                className: `locatie-pin ${hasProbs ? 'has-active-problems' : ''}`,
                                                onClick: (e) => {
                                                    e.stopPropagation();
                                                    openDetails('locatie', location);
                                                }
                                            },
                                                h('div', { className: 'locatie-header' },
                                                    h('div', { className: 'locatie-name' }, location.Title),
                                                    h('div', { className: 'locatie-status' },
                                                        h('div', {
                                                            className: `status-dot ${hasProbs ? 'active' : problems.length > 0 ? 'resolved' : 'none'}`
                                                        })
                                                    )
                                                ),
                                                h('div', { className: 'locatie-meta' },
                                                    `${problems.length} problemen • ${location.Feitcodegroep}`
                                                )
                                            );
                                        }),
                                        locations.length > 4 && h('div', {
                                            className: 'locatie-pin',
                                            style: { textAlign: 'center', color: '#a0aec0', fontSize: '12px' }
                                        }, `+${locations.length - 4} meer locaties`)
                                    ),
                                    
                                    h('div', { className: 'gemeente-summary' },
                                        h('div', { className: 'summary-stats' },
                                            `${totalProblems} problemen (${activeProblems} actief)`
                                        ),
                                        h('button', {
                                            className: 'expand-btn',
                                            onClick: (e) => {
                                                e.stopPropagation();
                                                openDetails('gemeente', gemeente);
                                            }
                                        }, 'Details')
                                    )
                                );
                            })
                        ),
                        
                        // Legend
                        h('div', { className: 'legend' },
                            h('div', { className: 'legend-title' }, 'Legenda'),
                            h('div', { className: 'legend-item' },
                                h('div', { className: 'legend-color', style: { background: '#f56565' } }),
                                h('span', null, 'Actieve problemen')
                            ),
                            h('div', { className: 'legend-item' },
                                h('div', { className: 'legend-color', style: { background: '#48bb78' } }),
                                h('span', null, 'Opgeloste problemen')
                            ),
                            h('div', { className: 'legend-item' },
                                h('div', { className: 'legend-color', style: { background: '#4a5568' } }),
                                h('span', null, 'Geen problemen')
                            )
                        )
                    ),
                    
                    // Sidebar Panel
                    h('div', { className: `sidebar-panel ${sidebarOpen ? 'open' : ''}` },
                        h('div', { className: 'sidebar-header' },
                            h('button', { className: 'close-btn', onClick: closeSidebar }, '×'),
                            selectedItem && h('div', null,
                                h('h2', { className: 'sidebar-title' }, 
                                    selectedItem.type === 'gemeente' ? selectedItem.data : selectedItem.data?.Title
                                ),
                                h('p', { className: 'sidebar-subtitle' }, 
                                    selectedItem.type === 'gemeente' ? 'Gemeente Details' : 
                                    `${selectedItem.data?.Gemeente} • Handhavingslocatie`
                                )
                            )
                        ),
                        h('div', { className: 'sidebar-content' }, renderSidebarContent())
                    )
                ),
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(MapPortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
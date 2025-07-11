<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 1: Card Layout</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #f8fafc; color: #1a202c;
        }
        .portal-container {
            max-width: 1400px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 32px; border-radius: 16px; margin-bottom: 32px;
            text-align: center;
        }
        .portal-title {
            font-size: 36px; font-weight: 800; margin: 0 0 8px 0;
        }
        .portal-subtitle {
            font-size: 18px; opacity: 0.9; margin: 0;
        }
        
        /* Search and Filter */
        .controls-section {
            margin-bottom: 32px; display: flex; gap: 16px; align-items: center;
            flex-wrap: wrap;
        }
        .search-input {
            flex: 1; min-width: 300px; padding: 12px 16px; border: 2px solid #e2e8f0;
            border-radius: 12px; font-size: 16px; background: white;
        }
        .search-input:focus {
            outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .filter-btn {
            padding: 12px 20px; border: 2px solid #e2e8f0; background: white;
            border-radius: 12px; cursor: pointer; font-weight: 600;
            transition: all 0.2s ease;
        }
        .filter-btn.active { background: #667eea; color: white; border-color: #667eea; }
        .filter-btn:hover:not(.active) { background: #f7fafc; border-color: #cbd5e0; }
        
        /* Statistics Bar */
        .stats-bar {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 32px;
        }
        .stat-card {
            background: white; padding: 20px; border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); text-align: center;
        }
        .stat-number {
            font-size: 32px; font-weight: 800; color: #1a202c; margin-bottom: 4px;
        }
        .stat-label {
            font-size: 14px; color: #718096; font-weight: 600; text-transform: uppercase;
        }
        
        /* Gemeente Cards Grid */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 24px;
        }
        .gemeente-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08); transition: all 0.3s ease;
            cursor: pointer; border: 2px solid transparent;
        }
        .gemeente-card:hover {
            transform: translateY(-4px); box-shadow: 0 16px 48px rgba(0,0,0,0.12);
            border-color: #667eea;
        }
        .gemeente-card.expanded {
            border-color: #667eea; box-shadow: 0 16px 48px rgba(102, 126, 234, 0.15);
        }
        
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 24px; font-weight: 700; color: #1a202c; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        
        .locaties-preview {
            margin-bottom: 16px;
        }
        .locatie-chip {
            display: inline-block; background: #f7fafc; color: #4a5568;
            padding: 6px 12px; border-radius: 16px; margin: 4px 8px 4px 0;
            font-size: 12px; font-weight: 500;
        }
        .locatie-chip.has-problems {
            background: #fed7d7; color: #c53030;
        }
        .locatie-chip.active {
            background: #667eea; color: white; cursor: pointer;
        }
        
        .gemeente-summary {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 16px; border-top: 1px solid #e2e8f0;
        }
        .summary-text {
            font-size: 14px; color: #718096;
        }
        .expand-btn {
            background: #667eea; color: white; border: none;
            padding: 8px 16px; border-radius: 8px; cursor: pointer;
            font-size: 12px; font-weight: 600; transition: all 0.2s ease;
        }
        .expand-btn:hover { background: #5a67d8; }
        
        /* Expanded Content */
        .gemeente-expanded {
            margin-top: 20px; padding-top: 20px; border-top: 2px solid #e2e8f0;
        }
        .locaties-section {
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 18px; font-weight: 600; margin-bottom: 16px;
            color: #2d3748; display: flex; align-items: center; gap: 8px;
        }
        
        .locatie-item {
            background: #f7fafc; border-radius: 12px; padding: 16px;
            margin-bottom: 12px; cursor: pointer; transition: all 0.2s ease;
            border-left: 4px solid #cbd5e0;
        }
        .locatie-item:hover { background: #edf2f7; }
        .locatie-item.has-active-problems {
            border-left-color: #f56565; background: #fef5e7;
        }
        .locatie-item.has-active-problems:hover { background: #fed7d7; }
        
        .locatie-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .locatie-name {
            font-size: 16px; font-weight: 600; color: #2d3748;
        }
        .locatie-status {
            display: flex; gap: 8px; align-items: center;
        }
        .status-badge {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .status-active { background: #fed7d7; color: #c53030; }
        .status-resolved { background: #c6f6d5; color: #2f855a; }
        
        /* Problems Section */
        .problems-section {
            margin-top: 12px;
        }
        .problem-item {
            background: white; border-radius: 8px; padding: 16px;
            margin-bottom: 8px; border-left: 4px solid #cbd5e0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .problem-item.active {
            border-left-color: #f56565; background: #fffaf0;
        }
        .problem-item.resolved {
            border-left-color: #48bb78; opacity: 0.7;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #718096; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #a0aec0;
        }
        .problem-description {
            font-size: 14px; color: #2d3748; line-height: 1.5;
            margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #667eea; color: white;
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #fed7d7; color: #c53030; }
        .problem-status.behandeling { background: #bee3f8; color: #2b6cb0; }
        .problem-status.uitgezet { background: #d6f5d6; color: #2f855a; }
        .problem-status.opgelost { background: #c6f6d5; color: #2f855a; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .gemeente-grid { grid-template-columns: 1fr; }
            .controls-section { flex-direction: column; align-items: stretch; }
            .search-input { min-width: auto; }
            .stats-bar { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Portal wordt geladen...</p>
            </div>
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

        const CardPortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [activeFilter, setActiveFilter] = useState('all');
            const [expandedGemeentes, setExpandedGemeentes] = useState(new Set());
            const [expandedLocaties, setExpandedLocaties] = useState(new Set());

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
                const filtered = {};
                Object.entries(groupedData).forEach(([gemeente, locations]) => {
                    const searchMatch = gemeente.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                      locations.some(loc => loc.Title.toLowerCase().includes(searchTerm.toLowerCase()));
                    
                    if (!searchMatch) return;
                    
                    let filteredLocations = locations;
                    if (activeFilter === 'problems') {
                        filteredLocations = locations.filter(loc => 
                            (loc.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost')
                        );
                    } else if (activeFilter === 'resolved') {
                        filteredLocations = locations.filter(loc => 
                            (loc.problemen || []).length > 0 && 
                            (loc.problemen || []).every(p => p.Opgelost_x003f_ === 'Opgelost')
                        );
                    }
                    
                    if (filteredLocations.length > 0) {
                        filtered[gemeente] = filteredLocations;
                    }
                });
                return filtered;
            }, [groupedData, searchTerm, activeFilter]);

            const stats = useMemo(() => {
                const totalGemeentes = Object.keys(groupedData).length;
                const totalLocations = data.length;
                const totalProblems = data.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                const activeProblems = data.reduce((sum, loc) => 
                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                
                return { totalGemeentes, totalLocations, totalProblems, activeProblems };
            }, [data, groupedData]);

            const toggleGemeente = (gemeente) => {
                const newExpanded = new Set(expandedGemeentes);
                if (newExpanded.has(gemeente)) {
                    newExpanded.delete(gemeente);
                } else {
                    newExpanded.add(gemeente);
                }
                setExpandedGemeentes(newExpanded);
            };

            const toggleLocatie = (locationId) => {
                const newExpanded = new Set(expandedLocaties);
                if (newExpanded.has(locationId)) {
                    newExpanded.delete(locationId);
                } else {
                    newExpanded.add(locationId);
                }
                setExpandedLocaties(newExpanded);
            };

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #667eea', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Portal wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('h1', { className: 'portal-title' }, 'DDH Handhavingsportaal'),
                    h('p', { className: 'portal-subtitle' }, 'Overzicht van gemeentes, locaties en gemelde problemen')
                ),

                // Controls
                h('div', { className: 'controls-section' },
                    h('input', {
                        type: 'text',
                        className: 'search-input',
                        placeholder: 'Zoek gemeente of locatie...',
                        value: searchTerm,
                        onChange: (e) => setSearchTerm(e.target.value)
                    }),
                    h('button', {
                        className: `filter-btn ${activeFilter === 'all' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('all')
                    }, 'Alle'),
                    h('button', {
                        className: `filter-btn ${activeFilter === 'problems' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('problems')
                    }, 'Met Problemen'),
                    h('button', {
                        className: `filter-btn ${activeFilter === 'resolved' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('resolved')
                    }, 'Opgelost')
                ),

                // Statistics
                h('div', { className: 'stats-bar' },
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalGemeentes),
                        h('div', { className: 'stat-label' }, 'Gemeentes')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalLocations),
                        h('div', { className: 'stat-label' }, 'Locaties')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalProblems),
                        h('div', { className: 'stat-label' }, 'Totaal Problemen')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.activeProblems),
                        h('div', { className: 'stat-label' }, 'Actieve Problemen')
                    )
                ),

                // Gemeente Cards Grid
                h('div', { className: 'gemeente-grid' },
                    Object.entries(filteredData).map(([gemeente, locations]) => {
                        const isExpanded = expandedGemeentes.has(gemeente);
                        const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                        const activeProblems = locations.reduce((sum, loc) => 
                            sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);

                        return h('div', {
                            key: gemeente,
                            className: `gemeente-card ${isExpanded ? 'expanded' : ''}`,
                            onClick: () => toggleGemeente(gemeente)
                        },
                            h('div', { className: 'gemeente-header' },
                                h('h2', { className: 'gemeente-name' }, gemeente),
                                h('div', { className: 'gemeente-badge' }, `${locations.length} locaties`)
                            ),

                            h('div', { className: 'locaties-preview' },
                                locations.slice(0, 3).map(location => {
                                    const hasProblems = (location.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost');
                                    return h('span', {
                                        key: location.Id,
                                        className: `locatie-chip ${hasProblems ? 'has-problems' : ''}`
                                    }, location.Title);
                                }),
                                locations.length > 3 && h('span', { className: 'locatie-chip' }, `+${locations.length - 3} meer`)
                            ),

                            h('div', { className: 'gemeente-summary' },
                                h('div', { className: 'summary-text' },
                                    `${totalProblems} problemen (${activeProblems} actief)`
                                ),
                                h('button', { 
                                    className: 'expand-btn',
                                    onClick: (e) => { e.stopPropagation(); toggleGemeente(gemeente); }
                                }, isExpanded ? 'Inklappen' : 'Uitklappen')
                            ),

                            // Expanded content
                            isExpanded && h('div', { className: 'gemeente-expanded' },
                                h('div', { className: 'locaties-section' },
                                    h('h3', { className: 'section-title' }, '📍 Handhavingslocaties'),
                                    locations.map(location => {
                                        const problems = location.problemen || [];
                                        const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                                        const isLocExpanded = expandedLocaties.has(location.Id);

                                        return h('div', { key: location.Id },
                                            h('div', {
                                                className: `locatie-item ${activeProbs.length > 0 ? 'has-active-problems' : ''}`,
                                                onClick: (e) => { e.stopPropagation(); toggleLocatie(location.Id); }
                                            },
                                                h('div', { className: 'locatie-header' },
                                                    h('div', { className: 'locatie-name' }, location.Title),
                                                    h('div', { className: 'locatie-status' },
                                                        activeProbs.length > 0 && h('span', { className: 'status-badge status-active' }, 
                                                            `${activeProbs.length} actief`
                                                        ),
                                                        problems.length - activeProbs.length > 0 && h('span', { className: 'status-badge status-resolved' }, 
                                                            `${problems.length - activeProbs.length} opgelost`
                                                        )
                                                    )
                                                )
                                            ),

                                            // Problems for this location
                                            isLocExpanded && problems.length > 0 && h('div', { className: 'problems-section' },
                                                // Active problems first (big and prominent)
                                                activeProbs.map(problem => {
                                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                                    return h('div', {
                                                        key: problem.Id,
                                                        className: 'problem-item active'
                                                    },
                                                        h('div', { className: 'problem-header' },
                                                            h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                                            h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                                        ),
                                                        h('div', { className: 'problem-description' },
                                                            problem.Probleembeschrijving
                                                        ),
                                                        h('div', { className: 'problem-footer' },
                                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                                            h('div', {
                                                                className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                            }, problem.Opgelost_x003f_)
                                                        )
                                                    );
                                                }),
                                                
                                                // Resolved problems (smaller, less prominent)
                                                problems.filter(p => p.Opgelost_x003f_ === 'Opgelost').map(problem => {
                                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                                    return h('div', {
                                                        key: problem.Id,
                                                        className: 'problem-item resolved'
                                                    },
                                                        h('div', { className: 'problem-header' },
                                                            h('div', { className: 'problem-id' }, `#${problem.Id} (Opgelost)`),
                                                            h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                                        ),
                                                        h('div', { className: 'problem-description' },
                                                            problem.Probleembeschrijving
                                                        ),
                                                        h('div', { className: 'problem-footer' },
                                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                                            h('div', { className: 'problem-status opgelost' }, 'Opgelost')
                                                        )
                                                    );
                                                })
                                            )
                                        );
                                    })
                                )
                            )
                        );
                    })
                ),
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(CardPortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
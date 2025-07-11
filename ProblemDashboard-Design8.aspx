<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 8: Minimalist Clean)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #fafbfc; color: #24292f;
            -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;
            line-height: 1.5;
        }
        .clean-container {
            max-width: 1200px; margin: 0 auto; padding: 40px 20px;
        }
        
        /* Minimal Header */
        .clean-header {
            margin-bottom: 48px; text-align: center;
        }
        .header-title {
            font-size: 32px; font-weight: 300; color: #24292f;
            margin-bottom: 8px; letter-spacing: -0.5px;
        }
        .header-subtitle {
            font-size: 16px; color: #656d76; font-weight: 400;
            margin-bottom: 32px;
        }
        .header-meta {
            display: flex; justify-content: center; gap: 24px;
            font-size: 14px; color: #8b949e;
        }
        .meta-item {
            display: flex; align-items: center; gap: 6px;
        }
        .meta-dot {
            width: 6px; height: 6px; border-radius: 50%; background: #0969da;
        }
        
        /* Clean Stats */
        .stats-row {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 24px; margin-bottom: 48px;
        }
        .stat-card {
            background: white; border: 1px solid #d0d7de; border-radius: 6px;
            padding: 24px; text-align: center; transition: all 0.2s ease;
        }
        .stat-card:hover {
            border-color: #0969da; box-shadow: 0 1px 3px rgba(9, 105, 218, 0.12);
        }
        .stat-number {
            font-size: 36px; font-weight: 600; color: #24292f;
            margin-bottom: 4px; line-height: 1;
        }
        .stat-label {
            font-size: 14px; color: #656d76; font-weight: 500;
        }
        .stat-change {
            font-size: 12px; margin-top: 8px; font-weight: 500;
        }
        .change-positive { color: #1a7f37; }
        .change-negative { color: #cf222e; }
        .change-neutral { color: #656d76; }
        
        /* Search and Filter */
        .controls-section {
            margin-bottom: 32px;
        }
        .search-container {
            position: relative; max-width: 400px; margin: 0 auto;
        }
        .search-input {
            width: 100%; padding: 12px 16px 12px 40px; border: 1px solid #d0d7de;
            border-radius: 6px; font-size: 16px; background: white;
            transition: border-color 0.2s ease;
        }
        .search-input:focus {
            outline: none; border-color: #0969da; box-shadow: 0 0 0 3px rgba(9, 105, 218, 0.3);
        }
        .search-icon {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: #8b949e; font-size: 16px;
        }
        
        .filter-tabs {
            display: flex; justify-content: center; gap: 4px; margin-top: 16px;
        }
        .filter-tab {
            padding: 8px 16px; border: 1px solid #d0d7de; background: white;
            color: #656d76; border-radius: 6px; cursor: pointer;
            font-size: 14px; font-weight: 500; transition: all 0.2s ease;
        }
        .filter-tab:hover { background: #f6f8fa; }
        .filter-tab.active {
            background: #0969da; color: white; border-color: #0969da;
        }
        
        /* Clean List */
        .locations-list {
            display: flex; flex-direction: column; gap: 16px;
        }
        .location-item {
            background: white; border: 1px solid #d0d7de; border-radius: 6px;
            padding: 24px; transition: all 0.2s ease; cursor: pointer;
        }
        .location-item:hover {
            border-color: #0969da; box-shadow: 0 2px 8px rgba(9, 105, 218, 0.12);
        }
        
        .location-header {
            display: flex; justify-content: between; align-items: flex-start;
            margin-bottom: 16px;
        }
        .location-title {
            font-size: 18px; font-weight: 600; color: #24292f;
            margin-bottom: 4px;
        }
        .location-gemeente {
            font-size: 14px; color: #656d76;
        }
        .location-meta {
            display: flex; align-items: center; gap: 16px;
            margin-left: auto; flex-shrink: 0;
        }
        .problem-count {
            display: flex; align-items: center; gap: 6px;
            font-size: 14px; color: #656d76;
        }
        .count-number {
            background: #f6f8fa; border: 1px solid #d0d7de;
            padding: 2px 8px; border-radius: 12px; font-size: 12px;
            font-weight: 600; color: #24292f;
        }
        .count-number.has-problems {
            background: #ffebe9; border-color: #ffcccb; color: #cf222e;
        }
        
        .status-indicator {
            width: 8px; height: 8px; border-radius: 50%;
        }
        .status-good { background: #1a7f37; }
        .status-warning { background: #bf8700; }
        .status-error { background: #cf222e; }
        
        .problems-section {
            margin-top: 16px; padding-top: 16px; border-top: 1px solid #f6f8fa;
        }
        .problems-toggle {
            background: none; border: none; color: #0969da;
            font-size: 14px; cursor: pointer; font-weight: 500;
            margin-bottom: 12px; padding: 0;
        }
        .problems-toggle:hover { text-decoration: underline; }
        
        .problems-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 12px;
        }
        .problem-card {
            background: #f6f8fa; border: 1px solid #d0d7de; border-radius: 6px;
            padding: 16px; transition: all 0.2s ease;
        }
        .problem-card:hover {
            background: #eef4ff; border-color: #0969da;
        }
        
        .problem-header {
            display: flex; justify-content: between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #8b949e; font-weight: 500;
        }
        .problem-age {
            font-size: 11px; color: #8b949e;
        }
        .problem-description {
            font-size: 14px; color: #24292f; line-height: 1.4;
            margin-bottom: 12px; display: -webkit-box;
            -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            font-size: 11px; color: #0969da; background: #dbeafe;
            padding: 2px 6px; border-radius: 4px; font-weight: 500;
        }
        .problem-status {
            font-size: 11px; padding: 2px 6px; border-radius: 4px;
            font-weight: 500; text-transform: capitalize;
        }
        .status-aangemeld { background: #ffebe9; color: #cf222e; }
        .status-behandeling { background: #dbeafe; color: #0969da; }
        .status-uitgezet { background: #eef4ff; color: #0969da; }
        .status-opgelost { background: #dafbe1; color: #1a7f37; }
        
        /* Empty State */
        .empty-state {
            text-align: center; padding: 80px 20px; color: #656d76;
        }
        .empty-icon {
            font-size: 48px; margin-bottom: 16px; opacity: 0.6;
        }
        .empty-title {
            font-size: 20px; font-weight: 500; margin-bottom: 8px;
        }
        .empty-subtitle {
            font-size: 14px; line-height: 1.5; max-width: 400px; margin: 0 auto;
        }
        
        /* Loading State */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 300px; flex-direction: column; gap: 16px;
        }
        .loading-dots {
            display: flex; gap: 4px;
        }
        .loading-dot {
            width: 8px; height: 8px; border-radius: 50%; background: #0969da;
            animation: loading 1.4s infinite ease-in-out;
        }
        .loading-dot:nth-child(1) { animation-delay: -0.32s; }
        .loading-dot:nth-child(2) { animation-delay: -0.16s; }
        .loading-dot:nth-child(3) { animation-delay: 0s; }
        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .clean-container { padding: 20px 16px; }
            .header-title { font-size: 24px; }
            .stats-row { grid-template-columns: repeat(2, 1fr); gap: 16px; }
            .stat-card { padding: 16px; }
            .stat-number { font-size: 28px; }
            .location-header { flex-direction: column; align-items: flex-start; gap: 8px; }
            .location-meta { margin-left: 0; }
            .problems-grid { grid-template-columns: 1fr; }
            .header-meta { flex-direction: column; gap: 8px; }
        }
        
        @media (max-width: 480px) {
            .stats-row { grid-template-columns: 1fr; }
            .filter-tabs { flex-wrap: wrap; }
            .search-container { max-width: none; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="clean-container">
        <div class="loading-state">
            <div class="loading-dots">
                <div class="loading-dot"></div>
                <div class="loading-dot"></div>
                <div class="loading-dot"></div>
            </div>
            <p>Loading dashboard...</p>
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

        const MinimalistDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [activeFilter, setActiveFilter] = useState('all');
            const [expandedLocations, setExpandedLocations] = useState(new Set());

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

            const filteredData = useMemo(() => {
                let filtered = data.filter(location => {
                    const searchMatch = location.Title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                      location.Gemeente.toLowerCase().includes(searchTerm.toLowerCase());
                    
                    if (activeFilter === 'all') return searchMatch;
                    if (activeFilter === 'active') {
                        return searchMatch && (location.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost');
                    }
                    if (activeFilter === 'resolved') {
                        return searchMatch && (location.problemen || []).every(p => p.Opgelost_x003f_ === 'Opgelost');
                    }
                    if (activeFilter === 'empty') {
                        return searchMatch && (location.problemen || []).length === 0;
                    }
                    return searchMatch;
                });

                return filtered.sort((a, b) => {
                    const aActive = (a.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    const bActive = (b.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    
                    if (aActive !== bActive) return bActive - aActive;
                    return a.Title.localeCompare(b.Title);
                });
            }, [data, searchTerm, activeFilter]);

            const stats = useMemo(() => {
                const totalLocations = data.length;
                const totalProblems = data.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                const activeProblems = data.reduce((sum, loc) => 
                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                const locationsWithProblems = data.filter(loc => 
                    (loc.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost')).length;
                
                return { totalLocations, totalProblems, activeProblems, locationsWithProblems };
            }, [data]);

            const toggleLocationExpansion = (locationId) => {
                const newExpanded = new Set(expandedLocations);
                if (newExpanded.has(locationId)) {
                    newExpanded.delete(locationId);
                } else {
                    newExpanded.add(locationId);
                }
                setExpandedLocations(newExpanded);
            };

            if (loading) {
                return h('div', { className: 'loading-state' },
                    h('div', { className: 'loading-dots' },
                        h('div', { className: 'loading-dot' }),
                        h('div', { className: 'loading-dot' }),
                        h('div', { className: 'loading-dot' })
                    ),
                    h('p', null, 'Loading dashboard...')
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'clean-header' },
                    h('h1', { className: 'header-title' }, 'DDH Problem Dashboard'),
                    h('p', { className: 'header-subtitle' }, 
                        'Clean and minimal overview of digital enforcement locations and their issues'
                    ),
                    h('div', { className: 'header-meta' },
                        h('div', { className: 'meta-item' },
                            h('div', { className: 'meta-dot' }),
                            h('span', null, `${data.length} locations monitored`)
                        ),
                        h('div', { className: 'meta-item' },
                            h('div', { className: 'meta-dot' }),
                            h('span', null, 'Updated in real-time')
                        ),
                        h('div', { className: 'meta-item' },
                            h('div', { className: 'meta-dot' }),
                            h('span', null, new Date().toLocaleDateString('nl-NL'))
                        )
                    )
                ),

                // Stats Row
                h('div', { className: 'stats-row' },
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalLocations),
                        h('div', { className: 'stat-label' }, 'Total Locations'),
                        h('div', { className: 'stat-change change-neutral' }, 'Monitoring active')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.totalProblems),
                        h('div', { className: 'stat-label' }, 'Total Problems'),
                        h('div', { className: 'stat-change change-neutral' }, 'All time')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.activeProblems),
                        h('div', { className: 'stat-label' }, 'Active Problems'),
                        h('div', { className: 'stat-change change-negative' }, 'Require attention')
                    ),
                    h('div', { className: 'stat-card' },
                        h('div', { className: 'stat-number' }, stats.locationsWithProblems),
                        h('div', { className: 'stat-label' }, 'Affected Locations'),
                        h('div', { className: 'stat-change change-positive' }, 'Under management')
                    )
                ),

                // Controls
                h('div', { className: 'controls-section' },
                    h('div', { className: 'search-container' },
                        h('span', { className: 'search-icon' }, '🔍'),
                        h('input', {
                            type: 'text',
                            className: 'search-input',
                            placeholder: 'Search locations or municipalities...',
                            value: searchTerm,
                            onChange: (e) => setSearchTerm(e.target.value)
                        })
                    ),
                    h('div', { className: 'filter-tabs' },
                        h('button', {
                            className: `filter-tab ${activeFilter === 'all' ? 'active' : ''}`,
                            onClick: () => setActiveFilter('all')
                        }, 'All'),
                        h('button', {
                            className: `filter-tab ${activeFilter === 'active' ? 'active' : ''}`,
                            onClick: () => setActiveFilter('active')
                        }, 'With Problems'),
                        h('button', {
                            className: `filter-tab ${activeFilter === 'resolved' ? 'active' : ''}`,
                            onClick: () => setActiveFilter('resolved')
                        }, 'Resolved'),
                        h('button', {
                            className: `filter-tab ${activeFilter === 'empty' ? 'active' : ''}`,
                            onClick: () => setActiveFilter('empty')
                        }, 'No Issues')
                    )
                ),

                // Locations List
                h('div', { className: 'locations-list' },
                    filteredData.length > 0 ? (
                        filteredData.map(location => {
                            const problems = location.problemen || [];
                            const activeProblems = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                            const isExpanded = expandedLocations.has(location.Id);
                            
                            let statusClass = 'status-good';
                            if (activeProblems.length > 5) statusClass = 'status-error';
                            else if (activeProblems.length > 0) statusClass = 'status-warning';

                            return h('div', {
                                key: location.Id,
                                className: 'location-item'
                            },
                                h('div', { className: 'location-header' },
                                    h('div', null,
                                        h('div', { className: 'location-title' }, location.Title),
                                        h('div', { className: 'location-gemeente' }, location.Gemeente)
                                    ),
                                    h('div', { className: 'location-meta' },
                                        h('div', { className: 'problem-count' },
                                            h('span', null, 'Problems:'),
                                            h('span', {
                                                className: `count-number ${activeProblems.length > 0 ? 'has-problems' : ''}`
                                            }, activeProblems.length)
                                        ),
                                        h('div', { className: `status-indicator ${statusClass}` })
                                    )
                                ),

                                problems.length > 0 && h('div', { className: 'problems-section' },
                                    h('button', {
                                        className: 'problems-toggle',
                                        onClick: () => toggleLocationExpansion(location.Id)
                                    }, isExpanded ? 
                                        `Hide ${problems.length} problems` : 
                                        `Show ${problems.length} problems`
                                    ),

                                    isExpanded && h('div', { className: 'problems-grid' },
                                        problems.map(problem => {
                                            const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                            return h('div', {
                                                key: problem.Id,
                                                className: 'problem-card'
                                            },
                                                h('div', { className: 'problem-header' },
                                                    h('span', { className: 'problem-id' }, `#${problem.Id}`),
                                                    h('span', { className: 'problem-age' }, `${daysSince} days ago`)
                                                ),
                                                h('div', { className: 'problem-description' },
                                                    problem.Probleembeschrijving
                                                ),
                                                h('div', { className: 'problem-footer' },
                                                    h('span', { className: 'problem-category' },
                                                        problem.Feitcodegroep
                                                    ),
                                                    h('span', {
                                                        className: `problem-status status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                    }, problem.Opgelost_x003f_)
                                                )
                                            );
                                        })
                                    )
                                )
                            );
                        })
                    ) : (
                        h('div', { className: 'empty-state' },
                            h('div', { className: 'empty-icon' }, '🔍'),
                            h('div', { className: 'empty-title' }, 'No locations found'),
                            h('div', { className: 'empty-subtitle' }, 
                                searchTerm ? 
                                'Try adjusting your search terms or filters to find what you\'re looking for.' :
                                'There are no locations available to display at this time.'
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
        root.render(h(MinimalistDashboard));
    </script>
</body>
</html>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>DDH - Problemen Dashboard (Design 6: Mobile First)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            margin: 0; padding: 0; background: #f5f7fa; color: #2c3e50;
            -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;
        }
        .mobile-container {
            max-width: 100%; margin: 0 auto; padding: 0;
            min-height: 100vh; display: flex; flex-direction: column;
        }
        
        /* Mobile-First Header */
        .mobile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 16px; position: sticky; top: 0;
            z-index: 100; box-shadow: 0 2px 20px rgba(0,0,0,0.15);
        }
        .header-top {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 12px;
        }
        .header-title {
            font-size: 20px; font-weight: 700; margin: 0;
        }
        .header-menu {
            background: none; border: none; color: white;
            font-size: 24px; cursor: pointer; padding: 4px;
        }
        .header-stats {
            display: flex; justify-content: space-between; gap: 8px;
        }
        .stat-mini {
            flex: 1; text-align: center; padding: 8px; background: rgba(255,255,255,0.15);
            border-radius: 8px; backdrop-filter: blur(10px);
        }
        .stat-mini-number {
            font-size: 18px; font-weight: 700; margin-bottom: 2px;
        }
        .stat-mini-label {
            font-size: 10px; opacity: 0.9; text-transform: uppercase;
        }
        
        /* Quick Actions Bar */
        .quick-actions-bar {
            background: white; padding: 16px; border-bottom: 1px solid #e9ecef;
            display: flex; gap: 8px; overflow-x: auto; -webkit-overflow-scrolling: touch;
        }
        .quick-action {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border: none; border-radius: 12px; padding: 12px 16px;
            font-size: 14px; font-weight: 600; cursor: pointer;
            white-space: nowrap; transition: all 0.2s ease;
            display: flex; align-items: center; gap: 8px;
        }
        .quick-action.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        .quick-action:not(.active):hover {
            background: linear-gradient(135deg, #e9ecef, #dee2e6);
        }
        
        /* Mobile Cards */
        .cards-container {
            flex: 1; padding: 16px; display: flex; flex-direction: column;
            gap: 12px; overflow-y: auto; -webkit-overflow-scrolling: touch;
        }
        .mobile-card {
            background: white; border-radius: 16px; padding: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); border: 1px solid #f1f3f4;
            transition: all 0.3s ease; position: relative; overflow: hidden;
        }
        .mobile-card:active {
            transform: scale(0.98); box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        }
        .mobile-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 3px; background: linear-gradient(90deg, #667eea, #764ba2);
        }
        .mobile-card.status-aangemeld::before { background: linear-gradient(90deg, #ff6b6b, #ee5a52); }
        .mobile-card.status-behandeling::before { background: linear-gradient(90deg, #4ecdc4, #44b3a9); }
        .mobile-card.status-uitgezet::before { background: linear-gradient(90deg, #45b7d1, #3a9bc1); }
        .mobile-card.status-opgelost::before { background: linear-gradient(90deg, #96ceb4, #7bb99a); }
        
        .card-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 12px;
        }
        .card-location {
            flex: 1;
        }
        .location-name {
            font-size: 16px; font-weight: 700; color: #2c3e50;
            margin-bottom: 2px; line-height: 1.2;
        }
        .location-gemeente {
            font-size: 12px; color: #7f8c8d; font-weight: 500;
        }
        .card-meta {
            text-align: right; flex-shrink: 0; margin-left: 12px;
        }
        .problem-count {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 4px 8px; border-radius: 12px;
            font-size: 11px; font-weight: 600; margin-bottom: 4px;
        }
        .card-status {
            font-size: 10px; color: #95a5a6; text-transform: uppercase;
        }
        
        .problems-preview {
            margin-top: 12px;
        }
        .problems-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px; padding-bottom: 4px; border-bottom: 1px solid #f1f3f4;
        }
        .problems-title {
            font-size: 12px; font-weight: 600; color: #7f8c8d;
            text-transform: uppercase;
        }
        .expand-toggle {
            background: none; border: none; color: #667eea;
            font-size: 12px; cursor: pointer; font-weight: 600;
        }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 8px;
        }
        .problem-item {
            background: #f8f9fa; border-radius: 8px; padding: 12px;
            border-left: 3px solid #e9ecef;
        }
        .problem-item.status-aangemeld { border-left-color: #ff6b6b; }
        .problem-item.status-behandeling { border-left-color: #4ecdc4; }
        .problem-item.status-uitgezet { border-left-color: #45b7d1; }
        .problem-item.status-opgelost { border-left-color: #96ceb4; }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 6px;
        }
        .problem-id {
            font-size: 11px; color: #95a5a6; font-weight: 600;
        }
        .problem-age {
            font-size: 10px; color: #bdc3c7;
        }
        .problem-description {
            font-size: 13px; color: #2c3e50; line-height: 1.3;
            margin-bottom: 6px; display: -webkit-box;
            -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #667eea; color: white; padding: 2px 6px;
            border-radius: 8px; font-size: 10px; font-weight: 600;
        }
        .problem-status {
            font-size: 10px; padding: 2px 6px; border-radius: 6px;
            font-weight: 600; text-transform: uppercase;
        }
        .status-aangemeld { background: #fff5f5; color: #c53030; }
        .status-behandeling { background: #e6fffa; color: #00695c; }
        .status-uitgezet { background: #e6f7ff; color: #1565c0; }
        .status-opgelost { background: #f0fff4; color: #2f855a; }
        
        /* Search Bar */
        .search-container {
            background: white; padding: 16px; border-bottom: 1px solid #e9ecef;
            position: sticky; top: 80px; z-index: 99;
        }
        .search-input {
            width: 100%; padding: 12px 16px 12px 40px; border: 2px solid #e9ecef;
            border-radius: 12px; font-size: 16px; background: #f8f9fa;
            position: relative;
        }
        .search-input:focus {
            outline: none; border-color: #667eea; background: white;
        }
        .search-icon {
            position: absolute; left: 28px; top: 28px; color: #95a5a6;
            font-size: 16px; pointer-events: none;
        }
        
        /* Floating Action Button */
        .fab {
            position: fixed; bottom: 20px; right: 20px; z-index: 1000;
            width: 56px; height: 56px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border: none; font-size: 24px;
            cursor: pointer; box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
            transition: all 0.3s ease;
        }
        .fab:hover { transform: scale(1.1); }
        .fab:active { transform: scale(0.95); }
        
        /* Bottom Navigation */
        .bottom-nav {
            background: white; border-top: 1px solid #e9ecef;
            padding: 8px 0; display: flex; justify-content: space-around;
            position: sticky; bottom: 0; z-index: 100;
        }
        .nav-item {
            flex: 1; text-align: center; padding: 8px;
            color: #95a5a6; text-decoration: none; font-size: 12px;
            display: flex; flex-direction: column; align-items: center; gap: 4px;
        }
        .nav-item.active { color: #667eea; }
        .nav-icon {
            font-size: 20px; margin-bottom: 2px;
        }
        
        /* Pull to Refresh */
        .pull-refresh {
            text-align: center; padding: 16px; color: #95a5a6;
            font-size: 14px; background: #f8f9fa;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center; padding: 60px 20px; color: #95a5a6;
        }
        .empty-icon {
            font-size: 48px; margin-bottom: 16px; opacity: 0.6;
        }
        .empty-title {
            font-size: 18px; font-weight: 600; margin-bottom: 8px;
        }
        .empty-subtitle {
            font-size: 14px; line-height: 1.4;
        }
        
        /* Loading State */
        .loading-container {
            display: flex; justify-content: center; align-items: center;
            height: 50vh; flex-direction: column; gap: 16px;
        }
        .loading-spinner {
            width: 40px; height: 40px; border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        
        /* Tablet Adaptations */
        @media (min-width: 768px) {
            .mobile-container { padding: 16px; }
            .mobile-header { border-radius: 16px; position: static; }
            .search-container { border-radius: 12px; margin-bottom: 16px; position: static; }
            .cards-container { padding: 0; }
            .mobile-card { margin-bottom: 8px; }
            .bottom-nav { display: none; }
            .fab { bottom: 40px; right: 40px; }
        }
        
        /* Desktop Adaptations */
        @media (min-width: 1024px) {
            .mobile-container { max-width: 800px; }
            .cards-container {
                display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 16px;
            }
            .mobile-card { margin-bottom: 0; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="mobile-container">
        <div class="loading-container">
            <div class="loading-spinner"></div>
            <p>Mobile Dashboard wordt geladen...</p>
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

        const MobileDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [activeFilter, setActiveFilter] = useState('all');
            const [expandedCards, setExpandedCards] = useState(new Set());

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                    } catch (error) {
                        console.error('Data loading error:', error);
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
                    if (activeFilter === 'problems') {
                        return searchMatch && (location.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost');
                    }
                    if (activeFilter === 'resolved') {
                        return searchMatch && (location.problemen || []).every(p => p.Opgelost_x003f_ === 'Opgelost');
                    }
                    return searchMatch;
                });

                return filtered.sort((a, b) => {
                    const aActiveProblems = (a.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    const bActiveProblems = (b.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    return bActiveProblems - aActiveProblems;
                });
            }, [data, searchTerm, activeFilter]);

            const stats = useMemo(() => {
                const totalLocations = data.length;
                const totalProblems = data.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                const activeProblems = data.reduce((sum, loc) => 
                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                const resolvedProblems = totalProblems - activeProblems;
                
                return { totalLocations, totalProblems, activeProblems, resolvedProblems };
            }, [data]);

            const toggleCardExpansion = (locationId) => {
                const newExpanded = new Set(expandedCards);
                if (newExpanded.has(locationId)) {
                    newExpanded.delete(locationId);
                } else {
                    newExpanded.add(locationId);
                }
                setExpandedCards(newExpanded);
            };

            if (loading) {
                return h('div', { className: 'loading-container' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Mobile Dashboard wordt geladen...')
                );
            }

            return h('div', null,
                // Mobile Header
                h('div', { className: 'mobile-header' },
                    h('div', { className: 'header-top' },
                        h('h1', { className: 'header-title' }, 'DDH Mobile'),
                        h('button', { className: 'header-menu' }, '☰')
                    ),
                    h('div', { className: 'header-stats' },
                        h('div', { className: 'stat-mini' },
                            h('div', { className: 'stat-mini-number' }, stats.totalLocations),
                            h('div', { className: 'stat-mini-label' }, 'Locaties')
                        ),
                        h('div', { className: 'stat-mini' },
                            h('div', { className: 'stat-mini-number' }, stats.totalProblems),
                            h('div', { className: 'stat-mini-label' }, 'Problemen')
                        ),
                        h('div', { className: 'stat-mini' },
                            h('div', { className: 'stat-mini-number' }, stats.activeProblems),
                            h('div', { className: 'stat-mini-label' }, 'Actief')
                        ),
                        h('div', { className: 'stat-mini' },
                            h('div', { className: 'stat-mini-number' }, stats.resolvedProblems),
                            h('div', { className: 'stat-mini-label' }, 'Opgelost')
                        )
                    )
                ),

                // Search Bar
                h('div', { className: 'search-container' },
                    h('div', { style: { position: 'relative' } },
                        h('span', { className: 'search-icon' }, '🔍'),
                        h('input', {
                            type: 'text',
                            className: 'search-input',
                            placeholder: 'Zoek locaties of gemeenten...',
                            value: searchTerm,
                            onChange: (e) => setSearchTerm(e.target.value)
                        })
                    )
                ),

                // Quick Actions Bar
                h('div', { className: 'quick-actions-bar' },
                    h('button', {
                        className: `quick-action ${activeFilter === 'all' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('all')
                    }, '📋 Alle'),
                    h('button', {
                        className: `quick-action ${activeFilter === 'problems' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('problems')
                    }, '🔴 Met Problemen'),
                    h('button', {
                        className: `quick-action ${activeFilter === 'resolved' ? 'active' : ''}`,
                        onClick: () => setActiveFilter('resolved')
                    }, '✅ Opgelost'),
                    h('button', { className: 'quick-action' }, '📊 Statistieken'),
                    h('button', { className: 'quick-action' }, '⚙️ Instellingen')
                ),

                // Cards Container
                h('div', { className: 'cards-container' },
                    filteredData.length > 0 ? (
                        filteredData.map(location => {
                            const problems = location.problemen || [];
                            const activeProblems = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                            const isExpanded = expandedCards.has(location.Id);
                            const statusClass = activeProblems > 0 ? 'status-aangemeld' : 'status-opgelost';

                            return h('div', {
                                key: location.Id,
                                className: `mobile-card ${statusClass}`
                            },
                                h('div', { className: 'card-header' },
                                    h('div', { className: 'card-location' },
                                        h('div', { className: 'location-name' }, location.Title),
                                        h('div', { className: 'location-gemeente' }, location.Gemeente)
                                    ),
                                    h('div', { className: 'card-meta' },
                                        h('div', { className: 'problem-count' }, 
                                            `${problems.length} ${problems.length === 1 ? 'probleem' : 'problemen'}`
                                        ),
                                        h('div', { className: 'card-status' }, location.Status_x0020_B_x0026_S)
                                    )
                                ),

                                problems.length > 0 && h('div', { className: 'problems-preview' },
                                    h('div', { className: 'problems-header' },
                                        h('div', { className: 'problems-title' }, 
                                            `${activeProblems} actieve problemen`
                                        ),
                                        h('button', {
                                            className: 'expand-toggle',
                                            onClick: () => toggleCardExpansion(location.Id)
                                        }, isExpanded ? 'Minder' : 'Meer')
                                    ),

                                    h('div', { className: 'problems-list' },
                                        (isExpanded ? problems : problems.slice(0, 2)).map(problem => {
                                            const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                            return h('div', {
                                                key: problem.Id,
                                                className: `problem-item status-${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                            },
                                                h('div', { className: 'problem-header' },
                                                    h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                                    h('div', { className: 'problem-age' }, `${daysSince}d geleden`)
                                                ),
                                                h('div', { className: 'problem-description' },
                                                    problem.Probleembeschrijving
                                                ),
                                                h('div', { className: 'problem-footer' },
                                                    h('div', { className: 'problem-category' },
                                                        problem.Feitcodegroep
                                                    ),
                                                    h('div', {
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
                            h('div', { className: 'empty-icon' }, '📱'),
                            h('div', { className: 'empty-title' }, 'Geen resultaten'),
                            h('div', { className: 'empty-subtitle' }, 
                                searchTerm ? 
                                'Geen locaties gevonden voor je zoekopdracht.' :
                                'Er zijn geen locaties beschikbaar.'
                            )
                        )
                    )
                ),

                // Floating Action Button
                h('button', { className: 'fab' }, '+'),

                // Bottom Navigation
                h('div', { className: 'bottom-nav' },
                    h('a', { href: '#', className: 'nav-item active' },
                        h('div', { className: 'nav-icon' }, '🏠'),
                        h('div', null, 'Dashboard')
                    ),
                    h('a', { href: '#', className: 'nav-item' },
                        h('div', { className: 'nav-icon' }, '📊'),
                        h('div', null, 'Statistieken')
                    ),
                    h('a', { href: '#', className: 'nav-item' },
                        h('div', { className: 'nav-icon' }, '🔍'),
                        h('div', null, 'Zoeken')
                    ),
                    h('a', { href: '#', className: 'nav-item' },
                        h('div', { className: 'nav-icon' }, '⚙️'),
                        h('div', null, 'Instellingen')
                    )
                )
            );
        };

        const rootElement = document.getElementById('dashboard-root');
        const root = createRoot(rootElement);
        root.render(h(MobileDashboard));
    </script>
</body>
</html>
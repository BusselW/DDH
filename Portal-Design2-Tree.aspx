<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 2: Tree View</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #f1f5f9; color: #1e293b;
        }
        .portal-container {
            max-width: 1600px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
            color: white; padding: 32px; border-radius: 16px; margin-bottom: 32px;
        }
        .portal-title {
            font-size: 32px; font-weight: 800; margin: 0 0 8px 0;
        }
        .portal-subtitle {
            font-size: 16px; opacity: 0.8; margin: 0;
        }
        
        /* Sidebar and Main Layout */
        .main-layout {
            display: grid; grid-template-columns: 320px 1fr; gap: 24px;
        }
        
        /* Sidebar with Tree */
        .sidebar {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); height: fit-content;
            position: sticky; top: 20px;
        }
        .sidebar-header {
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #e2e8f0;
        }
        .sidebar-title {
            font-size: 18px; font-weight: 700; margin: 0 0 8px 0; color: #1e293b;
        }
        .search-input {
            width: 100%; padding: 10px 12px; border: 2px solid #e2e8f0;
            border-radius: 8px; font-size: 14px;
        }
        .search-input:focus {
            outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        /* Tree Structure */
        .tree-container {
            max-height: 70vh; overflow-y: auto;
        }
        .tree-node {
            margin-bottom: 4px;
        }
        .tree-item {
            display: flex; align-items: center; gap: 8px; padding: 8px 12px;
            border-radius: 8px; cursor: pointer; transition: all 0.2s ease;
            font-size: 14px;
        }
        .tree-item:hover { background: #f1f5f9; }
        .tree-item.active { background: #3b82f6; color: white; }
        .tree-item.gemeente {
            font-weight: 600; background: #f8fafc; border: 1px solid #e2e8f0;
        }
        .tree-item.gemeente.active { background: #1e40af; }
        .tree-item.locatie {
            margin-left: 20px; font-size: 13px;
        }
        .tree-item.problem {
            margin-left: 40px; font-size: 12px;
        }
        .tree-item.problem.active-problem {
            background: #fef2f2; color: #dc2626; border-left: 3px solid #dc2626;
        }
        .tree-item.problem.resolved-problem {
            background: #f0fdf4; color: #16a34a; opacity: 0.7;
        }
        
        .tree-icon {
            width: 16px; height: 16px; display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .tree-text {
            flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        .tree-badge {
            background: #e2e8f0; color: #64748b; padding: 2px 6px;
            border-radius: 10px; font-size: 10px; font-weight: 600;
        }
        .tree-badge.problems { background: #fee2e2; color: #dc2626; }
        .tree-badge.resolved { background: #dcfce7; color: #16a34a; }
        
        /* Main Content Area */
        .content-area {
            background: white; border-radius: 16px; padding: 32px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); min-height: 600px;
        }
        .content-header {
            margin-bottom: 24px; padding-bottom: 16px; border-bottom: 2px solid #e2e8f0;
        }
        .content-title {
            font-size: 24px; font-weight: 700; margin: 0 0 8px 0; color: #1e293b;
        }
        .content-subtitle {
            font-size: 14px; color: #64748b; margin: 0;
        }
        
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; margin-bottom: 24px;
            font-size: 14px; color: #64748b;
        }
        .breadcrumb-item {
            display: flex; align-items: center; gap: 4px;
        }
        .breadcrumb-separator {
            color: #cbd5e1;
        }
        
        /* Detail Views */
        .detail-section {
            margin-bottom: 32px;
        }
        .detail-title {
            font-size: 18px; font-weight: 600; margin: 0 0 16px 0; color: #1e293b;
            display: flex; align-items: center; gap: 8px;
        }
        
        .gemeente-detail {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;
        }
        .detail-card {
            background: #f8fafc; border-radius: 12px; padding: 20px;
            border-left: 4px solid #3b82f6;
        }
        .detail-card.warning { border-left-color: #f59e0b; background: #fffbeb; }
        .detail-card.danger { border-left-color: #dc2626; background: #fef2f2; }
        .detail-card.success { border-left-color: #16a34a; background: #f0fdf4; }
        
        .card-metric {
            font-size: 28px; font-weight: 800; margin-bottom: 4px; color: #1e293b;
        }
        .card-label {
            font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 600;
        }
        .card-description {
            font-size: 14px; color: #64748b; margin-top: 8px;
        }
        
        .locatie-detail {
            background: #f8fafc; border-radius: 12px; padding: 24px; margin-bottom: 16px;
        }
        .locatie-info {
            display: grid; grid-template-columns: 1fr auto; gap: 16px; align-items: start;
        }
        .locatie-name {
            font-size: 20px; font-weight: 600; margin: 0 0 8px 0; color: #1e293b;
        }
        .locatie-meta {
            font-size: 14px; color: #64748b;
        }
        .locatie-status-grid {
            display: flex; gap: 8px; flex-wrap: wrap;
        }
        .status-chip {
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .status-chip.active { background: #fee2e2; color: #dc2626; }
        .status-chip.resolved { background: #dcfce7; color: #16a34a; }
        .status-chip.warning { background: #fef3c7; color: #d97706; }
        
        .problems-grid {
            display: grid; gap: 12px; margin-top: 20px;
        }
        .problem-card {
            background: white; border-radius: 8px; padding: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04); border-left: 4px solid #e2e8f0;
        }
        .problem-card.active {
            border-left-color: #dc2626; background: #fffbfb;
        }
        .problem-card.resolved {
            border-left-color: #16a34a; opacity: 0.6;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #64748b; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #9ca3af;
        }
        .problem-description {
            font-size: 14px; color: #374151; line-height: 1.5; margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #3b82f6; color: white; padding: 4px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #fee2e2; color: #dc2626; }
        .problem-status.behandeling { background: #dbeafe; color: #2563eb; }
        .problem-status.uitgezet { background: #fef3c7; color: #d97706; }
        .problem-status.opgelost { background: #dcfce7; color: #16a34a; }
        
        .empty-state {
            text-align: center; padding: 60px 20px; color: #64748b;
        }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: 0.5; }
        .empty-title { font-size: 18px; font-weight: 600; margin-bottom: 8px; }
        .empty-subtitle { font-size: 14px; line-height: 1.5; }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .main-layout { grid-template-columns: 1fr; }
            .sidebar { position: static; }
        }
        @media (max-width: 768px) {
            .gemeente-detail { grid-template-columns: 1fr; }
            .locatie-info { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #3b82f6; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Tree Portal wordt geladen...</p>
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

        const TreePortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [selectedItem, setSelectedItem] = useState({ type: 'overview', data: null });
            const [expandedNodes, setExpandedNodes] = useState(new Set());

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
                if (!searchTerm) return groupedData;
                
                const filtered = {};
                Object.entries(groupedData).forEach(([gemeente, locations]) => {
                    const searchMatch = gemeente.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                      locations.some(loc => 
                                          loc.Title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                          (loc.problemen || []).some(p => 
                                              p.Probleembeschrijving.toLowerCase().includes(searchTerm.toLowerCase())
                                          )
                                      );
                    
                    if (searchMatch) {
                        filtered[gemeente] = locations;
                    }
                });
                return filtered;
            }, [groupedData, searchTerm]);

            const toggleNode = (nodeId) => {
                const newExpanded = new Set(expandedNodes);
                if (newExpanded.has(nodeId)) {
                    newExpanded.delete(nodeId);
                } else {
                    newExpanded.add(nodeId);
                }
                setExpandedNodes(newExpanded);
            };

            const selectItem = (type, data) => {
                setSelectedItem({ type, data });
            };

            const renderContent = () => {
                const { type, data: itemData } = selectedItem;

                if (type === 'overview') {
                    const stats = {
                        totalGemeentes: Object.keys(groupedData).length,
                        totalLocations: data.length,
                        totalProblems: data.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0),
                        activeProblems: data.reduce((sum, loc) => 
                            sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0)
                    };

                    return h('div', null,
                        h('div', { className: 'content-header' },
                            h('h2', { className: 'content-title' }, 'DDH Handhavingsoverzicht'),
                            h('p', { className: 'content-subtitle' }, 'Algemene statistieken en overzicht')
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'detail-title' }, '📊 Statistieken'),
                            h('div', { className: 'gemeente-detail' },
                                h('div', { className: 'detail-card' },
                                    h('div', { className: 'card-metric' }, stats.totalGemeentes),
                                    h('div', { className: 'card-label' }, 'Gemeentes'),
                                    h('div', { className: 'card-description' }, 'Totaal aantal gemeentes in systeem')
                                ),
                                h('div', { className: 'detail-card' },
                                    h('div', { className: 'card-metric' }, stats.totalLocations),
                                    h('div', { className: 'card-label' }, 'Handhavingslocaties'),
                                    h('div', { className: 'card-description' }, 'Actieve locaties voor digitale handhaving')
                                ),
                                h('div', { className: 'detail-card warning' },
                                    h('div', { className: 'card-metric' }, stats.activeProblems),
                                    h('div', { className: 'card-label' }, 'Actieve Problemen'),
                                    h('div', { className: 'card-description' }, 'Problemen die aandacht vereisen')
                                ),
                                h('div', { className: 'detail-card success' },
                                    h('div', { className: 'card-metric' }, stats.totalProblems - stats.activeProblems),
                                    h('div', { className: 'card-label' }, 'Opgeloste Problemen'),
                                    h('div', { className: 'card-description' }, 'Succesvol afgehandelde meldingen')
                                )
                            )
                        )
                    );
                }

                if (type === 'gemeente') {
                    const locations = groupedData[itemData] || [];
                    const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                    const activeProblems = locations.reduce((sum, loc) => 
                        sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);

                    return h('div', null,
                        h('div', { className: 'breadcrumb' },
                            h('span', { className: 'breadcrumb-item', onClick: () => selectItem('overview', null) }, 
                                '🏠 Overzicht'
                            ),
                            h('span', { className: 'breadcrumb-separator' }, '>'),
                            h('span', { className: 'breadcrumb-item' }, `🏛️ ${itemData}`)
                        ),
                        h('div', { className: 'content-header' },
                            h('h2', { className: 'content-title' }, itemData),
                            h('p', { className: 'content-subtitle' }, `${locations.length} handhavingslocaties`)
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'detail-title' }, '📊 Gemeente Statistieken'),
                            h('div', { className: 'gemeente-detail' },
                                h('div', { className: 'detail-card' },
                                    h('div', { className: 'card-metric' }, locations.length),
                                    h('div', { className: 'card-label' }, 'Locaties'),
                                    h('div', { className: 'card-description' }, 'Handhavingslocaties in deze gemeente')
                                ),
                                h('div', { className: 'detail-card warning' },
                                    h('div', { className: 'card-metric' }, activeProblems),
                                    h('div', { className: 'card-label' }, 'Actieve Problemen'),
                                    h('div', { className: 'card-description' }, 'Vereisen directe aandacht')
                                ),
                                h('div', { className: 'detail-card success' },
                                    h('div', { className: 'card-metric' }, totalProblems - activeProblems),
                                    h('div', { className: 'card-label' }, 'Opgelost'),
                                    h('div', { className: 'card-description' }, 'Succesvol afgehandeld')
                                )
                            )
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'detail-title' }, '📍 Handhavingslocaties'),
                            locations.map(location => {
                                const problems = location.problemen || [];
                                const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                                
                                return h('div', { key: location.Id, className: 'locatie-detail' },
                                    h('div', { className: 'locatie-info' },
                                        h('div', null,
                                            h('h4', { className: 'locatie-name' }, location.Title),
                                            h('div', { className: 'locatie-meta' },
                                                `Status: ${location.Status_x0020_B_x0026_S || 'Onbekend'} • `,
                                                `Feitcodegroep: ${location.Feitcodegroep}`
                                            )
                                        ),
                                        h('div', { className: 'locatie-status-grid' },
                                            activeProbs.length > 0 && h('div', { className: 'status-chip active' }, 
                                                `${activeProbs.length} actief`
                                            ),
                                            problems.length - activeProbs.length > 0 && h('div', { className: 'status-chip resolved' }, 
                                                `${problems.length - activeProbs.length} opgelost`
                                            ),
                                            problems.length === 0 && h('div', { className: 'status-chip' }, 'Geen problemen')
                                        )
                                    )
                                );
                            })
                        )
                    );
                }

                if (type === 'locatie') {
                    const problems = itemData.problemen || [];
                    const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                    const resolvedProbs = problems.filter(p => p.Opgelost_x003f_ === 'Opgelost');

                    return h('div', null,
                        h('div', { className: 'breadcrumb' },
                            h('span', { className: 'breadcrumb-item', onClick: () => selectItem('overview', null) }, 
                                '🏠 Overzicht'
                            ),
                            h('span', { className: 'breadcrumb-separator' }, '>'),
                            h('span', { className: 'breadcrumb-item', onClick: () => selectItem('gemeente', itemData.Gemeente) }, 
                                `🏛️ ${itemData.Gemeente}`
                            ),
                            h('span', { className: 'breadcrumb-separator' }, '>'),
                            h('span', { className: 'breadcrumb-item' }, `📍 ${itemData.Title}`)
                        ),
                        h('div', { className: 'content-header' },
                            h('h2', { className: 'content-title' }, itemData.Title),
                            h('p', { className: 'content-subtitle' }, `${itemData.Gemeente} • ${problems.length} problemen`)
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'detail-title' }, '🔥 Actieve Problemen'),
                            activeProbs.length > 0 ? h('div', { className: 'problems-grid' },
                                activeProbs.map(problem => {
                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                    return h('div', { key: problem.Id, className: 'problem-card active' },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                            h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
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
                            ) : h('div', { className: 'empty-state' },
                                h('div', { className: 'empty-icon' }, '✅'),
                                h('div', { className: 'empty-title' }, 'Geen actieve problemen'),
                                h('div', { className: 'empty-subtitle' }, 'Alle problemen voor deze locatie zijn opgelost.')
                            )
                        ),
                        resolvedProbs.length > 0 && h('div', { className: 'detail-section' },
                            h('h3', { className: 'detail-title' }, '✅ Opgeloste Problemen'),
                            h('div', { className: 'problems-grid' },
                                resolvedProbs.map(problem => {
                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                    return h('div', { key: problem.Id, className: 'problem-card resolved' },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, `Probleem #${problem.Id} (Opgelost)`),
                                            h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                        ),
                                        h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                        h('div', { className: 'problem-footer' },
                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                            h('div', { className: 'problem-status opgelost' }, 'Opgelost')
                                        )
                                    );
                                })
                            )
                        )
                    );
                }

                return h('div', { className: 'empty-state' },
                    h('div', { className: 'empty-icon' }, '📂'),
                    h('div', { className: 'empty-title' }, 'Selecteer een item'),
                    h('div', { className: 'empty-subtitle' }, 'Kies een gemeente of locatie uit de boom om details te bekijken.')
                );
            };

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #3b82f6', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Tree Portal wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('h1', { className: 'portal-title' }, 'DDH Tree Navigator'),
                    h('p', { className: 'portal-subtitle' }, 'Hiërarchische weergave van gemeentes, locaties en problemen')
                ),

                // Main Layout
                h('div', { className: 'main-layout' },
                    // Sidebar with Tree
                    h('div', { className: 'sidebar' },
                        h('div', { className: 'sidebar-header' },
                            h('h3', { className: 'sidebar-title' }, 'Navigatie'),
                            h('input', {
                                type: 'text',
                                className: 'search-input',
                                placeholder: 'Zoeken...',
                                value: searchTerm,
                                onChange: (e) => setSearchTerm(e.target.value)
                            })
                        ),
                        h('div', { className: 'tree-container' },
                            // Overview node
                            h('div', { className: 'tree-node' },
                                h('div', {
                                    className: `tree-item ${selectedItem.type === 'overview' ? 'active' : ''}`,
                                    onClick: () => selectItem('overview', null)
                                },
                                    h('div', { className: 'tree-icon' }, '🏠'),
                                    h('div', { className: 'tree-text' }, 'Overzicht'),
                                    h('div', { className: 'tree-badge' }, Object.keys(filteredData).length)
                                )
                            ),
                            
                            // Gemeente nodes
                            Object.entries(filteredData).map(([gemeente, locations]) => {
                                const isExpanded = expandedNodes.has(gemeente);
                                const activeProblems = locations.reduce((sum, loc) => 
                                    sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                                
                                return h('div', { key: gemeente, className: 'tree-node' },
                                    h('div', {
                                        className: `tree-item gemeente ${selectedItem.type === 'gemeente' && selectedItem.data === gemeente ? 'active' : ''}`,
                                        onClick: () => {
                                            selectItem('gemeente', gemeente);
                                            toggleNode(gemeente);
                                        }
                                    },
                                        h('div', { className: 'tree-icon' }, isExpanded ? '📂' : '📁'),
                                        h('div', { className: 'tree-text' }, gemeente),
                                        activeProblems > 0 && h('div', { className: 'tree-badge problems' }, activeProblems)
                                    ),
                                    
                                    // Location nodes
                                    isExpanded && locations.map(location => {
                                        const problems = location.problemen || [];
                                        const activeProbs = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost');
                                        const isLocExpanded = expandedNodes.has(location.Id);
                                        
                                        return h('div', { key: location.Id },
                                            h('div', {
                                                className: `tree-item locatie ${selectedItem.type === 'locatie' && selectedItem.data?.Id === location.Id ? 'active' : ''}`,
                                                onClick: () => {
                                                    selectItem('locatie', location);
                                                    toggleNode(location.Id);
                                                }
                                            },
                                                h('div', { className: 'tree-icon' }, isLocExpanded ? '📍' : '📌'),
                                                h('div', { className: 'tree-text' }, location.Title),
                                                activeProbs.length > 0 && h('div', { className: 'tree-badge problems' }, activeProbs.length)
                                            ),
                                            
                                            // Problem nodes
                                            isLocExpanded && problems.map(problem => {
                                                const isActive = problem.Opgelost_x003f_ !== 'Opgelost';
                                                return h('div', {
                                                    key: problem.Id,
                                                    className: `tree-item problem ${isActive ? 'active-problem' : 'resolved-problem'}`
                                                },
                                                    h('div', { className: 'tree-icon' }, isActive ? '🔥' : '✅'),
                                                    h('div', { className: 'tree-text' }, `#${problem.Id}`)
                                                );
                                            })
                                        );
                                    })
                                );
                            })
                        )
                    ),
                    
                    // Content Area
                    h('div', { className: 'content-area' }, renderContent())
                ),
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(TreePortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
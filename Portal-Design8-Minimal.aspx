<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 8: Minimal Layered</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #fafafa;
            min-height: 100vh; color: #1a1a1a;
        }
        .portal-container {
            max-width: 1400px; margin: 0 auto; padding: 20px; min-height: 100vh;
        }
        
        /* Minimal Header */
        .portal-header {
            background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e1e5e9;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .portal-title {
            font-size: 24px; font-weight: 600; margin: 0; color: #1a1a1a;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 14px; color: #666;
        }
        .breadcrumb-item {
            cursor: pointer; transition: color 0.2s ease;
        }
        .breadcrumb-item:hover { color: #0066cc; }
        .breadcrumb-separator { margin: 0 4px; color: #ccc; }
        
        /* Minimal Container */
        .layer-container {
            background: white; border-radius: 8px; padding: 24px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e1e5e9;
        }
        
        /* Gemeente Grid - Minimal */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 16px;
        }
        .gemeente-card {
            background: #fafafa; border-radius: 6px; padding: 20px;
            border: 1px solid #e1e5e9; cursor: pointer;
            transition: all 0.2s ease;
        }
        .gemeente-card:hover {
            background: #f0f0f0; border-color: #0066cc;
        }
        .gemeente-header {
            margin-bottom: 12px;
        }
        .gemeente-name {
            font-size: 18px; font-weight: 500; color: #1a1a1a; margin: 0 0 4px 0;
        }
        .gemeente-badge {
            background: #0066cc; color: white;
            padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 500;
            display: inline-block;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px;
            margin-bottom: 12px;
        }
        .stat-item {
            text-align: center; padding: 8px; background: white; border-radius: 4px;
            border: 1px solid #e1e5e9;
        }
        .stat-number {
            font-size: 16px; font-weight: 600; color: #1a1a1a;
        }
        .stat-label {
            font-size: 10px; color: #666; text-transform: uppercase; font-weight: 500;
        }
        .gemeente-preview {
            font-size: 13px; color: #666; line-height: 1.4;
        }
        
        /* Pleeglocatie Grid - Minimal */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 12px;
        }
        .pleeglocatie-card {
            background: #fafafa; border-radius: 6px; padding: 16px;
            border: 1px solid #e1e5e9; cursor: pointer;
            transition: all 0.2s ease;
        }
        .pleeglocatie-card:hover {
            background: #f0f0f0; border-color: #0066cc;
        }
        .pleeglocatie-card.has-problems { border-left: 3px solid #dc3545; }
        .pleeglocatie-card.all-resolved { border-left: 3px solid #28a745; }
        
        .pleeglocatie-header {
            margin-bottom: 8px;
        }
        .pleeglocatie-name {
            font-size: 15px; font-weight: 500; color: #1a1a1a; margin: 0 0 4px 0;
        }
        .pleeglocatie-status {
            font-size: 12px; color: #666;
        }
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin: 8px 0; padding: 6px; background: white; border-radius: 4px;
            border: 1px solid #e1e5e9;
        }
        .problem-count {
            font-size: 13px; font-weight: 500;
        }
        .problem-count.active { color: #dc3545; }
        .problem-count.resolved { color: #28a745; }
        
        /* Detail View - Minimal */
        .detail-view {
            display: grid; grid-template-columns: 1fr 280px; gap: 20px;
        }
        .detail-main {
            background: #fafafa; border-radius: 6px; padding: 20px;
            border: 1px solid #e1e5e9;
        }
        .detail-sidebar {
            background: #fafafa; border-radius: 6px; padding: 20px;
            border: 1px solid #e1e5e9; height: fit-content;
        }
        
        .detail-header {
            margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid #e1e5e9;
        }
        .detail-title {
            font-size: 20px; font-weight: 500; color: #1a1a1a; margin: 0 0 4px 0;
        }
        .detail-subtitle {
            font-size: 13px; color: #666;
        }
        
        .info-section {
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 14px; font-weight: 500; color: #1a1a1a; margin: 0 0 8px 0;
            display: flex; align-items: center; gap: 6px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 8px;
        }
        .info-item {
            padding: 8px; background: white; border-radius: 4px;
            border: 1px solid #e1e5e9;
        }
        .info-label {
            font-size: 11px; color: #666; text-transform: uppercase;
            font-weight: 500; margin-bottom: 2px;
        }
        .info-value {
            font-size: 13px; color: #1a1a1a; font-weight: 400;
        }
        .info-link {
            color: #0066cc; text-decoration: none;
        }
        .info-link:hover { text-decoration: underline; }
        
        /* Problem Filtering - Minimal */
        .problem-filters {
            display: flex; gap: 6px; margin-bottom: 12px;
        }
        .filter-btn {
            padding: 6px 12px; border: 1px solid #e1e5e9; background: white;
            border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 500;
            transition: all 0.2s ease;
        }
        .filter-btn.active { background: #0066cc; color: white; border-color: #0066cc; }
        .filter-btn:hover:not(.active) { background: #f0f0f0; }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 8px;
        }
        .problem-card {
            background: white; border-radius: 4px; padding: 12px;
            border: 1px solid #e1e5e9; transition: all 0.2s ease;
        }
        .problem-card:hover { border-color: #ccc; }
        .problem-card.active {
            border-left: 3px solid #dc3545; background: #fef5f5;
        }
        .problem-card.resolved {
            border-left: 3px solid #28a745; background: #f0f8f0; opacity: 0.8;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 6px;
        }
        .problem-id {
            font-size: 11px; color: #666; font-weight: 500;
        }
        .problem-age {
            font-size: 10px; color: #999;
        }
        .problem-description {
            font-size: 13px; color: #1a1a1a; line-height: 1.3; margin-bottom: 8px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #0066cc; color: white; padding: 2px 6px;
            border-radius: 4px; font-size: 10px; font-weight: 500;
        }
        .problem-status {
            padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: 500;
            border: 1px solid;
        }
        .problem-status.aangemeld { background: #fef5f5; color: #dc3545; border-color: #fecaca; }
        .problem-status.behandeling { background: #eff6ff; color: #2563eb; border-color: #bfdbfe; }
        .problem-status.uitgezet { background: #fffbeb; color: #d97706; border-color: #fed7aa; }
        .problem-status.opgelost { background: #f0f8f0; color: #16a34a; border-color: #bbf7d0; }
        
        /* Back Button - Minimal */
        .back-btn {
            background: #0066cc; color: white; border: none;
            padding: 8px 16px; border-radius: 4px; cursor: pointer;
            font-size: 13px; font-weight: 500; display: flex; align-items: center; gap: 6px;
            transition: all 0.2s ease; margin-bottom: 16px;
        }
        .back-btn:hover { background: #0052a3; }
        
        /* Loading States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 200px; flex-direction: column; gap: 12px;
        }
        .loading-spinner {
            width: 32px; height: 32px; border: 3px solid #f3f4f6;
            border-top: 3px solid #0066cc; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .detail-view { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 12px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .header-content { flex-direction: column; gap: 8px; }
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Minimal Portal wordt geladen...</p>
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

        // Simple SVG Icons for minimal design
        const BackIcon = () => h('svg', { width: 14, height: 14, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );

        const MinimalPortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [currentLayer, setCurrentLayer] = useState('gemeente');
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);
            const [problemFilter, setProblemFilter] = useState('all');

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                    } catch (error) {
                        console.error('Data loading error, using placeholder data:', error);
                        setData(TEMP_PLACEHOLDER_DATA);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();
            }, []);

            const getStatusBadgeColor = (status) => {
                switch(status) {
                    case 'Instemming verleend': return '#28a745';
                    case 'In behandeling': return '#ffc107';  
                    case 'Aangevraagd': return '#dc3545';
                    default: return '#6c757d';
                }
            };

            const getWaarschuwingsperiodeColor = (hasWarning) => {
                return hasWarning === 'Ja' ? '#28a745' : '#dc3545';
            };

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

            const handleGemeenteClick = (gemeente) => {
                setSelectedGemeente(gemeente);
                setCurrentLayer('pleeglocatie');
            };

            const handlePleeglocatieClick = (location) => {
                setSelectedPleeglocatie(location);
                setCurrentLayer('detail');
            };

            const goBack = () => {
                if (currentLayer === 'detail') {
                    setCurrentLayer('pleeglocatie');
                    setSelectedPleeglocatie(null);
                } else if (currentLayer === 'pleeglocatie') {
                    setCurrentLayer('gemeente');
                    setSelectedGemeente(null);
                }
            };

            const getBreadcrumb = () => {
                const items = [{ label: 'Gemeentes', action: () => { setCurrentLayer('gemeente'); setSelectedGemeente(null); setSelectedPleeglocatie(null); } }];
                
                if (selectedGemeente) {
                    items.push({ label: selectedGemeente, action: () => { setCurrentLayer('pleeglocatie'); setSelectedPleeglocatie(null); } });
                }
                
                if (selectedPleeglocatie) {
                    items.push({ label: selectedPleeglocatie.Title, action: null });
                }
                
                return items;
            };

            const renderGemeenteLayer = () => {
                return h('div', { className: 'gemeente-grid' },
                    Object.entries(groupedData).map(([gemeente, locations]) => {
                        const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
                        const activeProblems = locations.reduce((sum, loc) => 
                            sum + (loc.problemen?.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length || 0), 0);
                        const resolvedProblems = totalProblems - activeProblems;

                        return h('div', {
                            key: gemeente,
                            className: 'gemeente-card',
                            onClick: () => handleGemeenteClick(gemeente)
                        },
                            h('div', { className: 'gemeente-header' },
                                h('h3', { className: 'gemeente-name' }, gemeente),
                                h('div', { className: 'gemeente-badge' }, 'Digitale Handhaving')
                            ),
                            h('div', { className: 'gemeente-stats' },
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, totalProblems),
                                    h('div', { className: 'stat-label' }, 'Problemen')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, activeProblems),
                                    h('div', { className: 'stat-label' }, 'Actief')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, resolvedProblems),
                                    h('div', { className: 'stat-label' }, 'Opgelost')
                                )
                            ),
                            h('div', { className: 'gemeente-preview' },
                                `${locations.length} handhavingslocaties met ${activeProblems} actieve problemen. `,
                                `${Math.round((resolvedProblems / Math.max(totalProblems, 1)) * 100)}% opgelost.`
                            )
                        );
                    })
                );
            };

            // Include the same renderPleeglocatieLayer and renderDetailLayer logic but with minimal styling
            const renderPleeglocatieLayer = () => {
                const locations = groupedData[selectedGemeente] || [];
                
                return h('div', null,
                    h('button', { className: 'back-btn', onClick: goBack },
                        h(BackIcon), 'Terug'
                    ),
                    h('div', { className: 'pleeglocatie-grid' },
                        locations.map(location => {
                            const problems = location.problemen || [];
                            const activeProblems = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                            const resolvedProblems = problems.length - activeProblems;
                            const hasProblems = activeProblems > 0;

                            return h('div', {
                                key: location.Id,
                                className: `pleeglocatie-card ${hasProblems ? 'has-problems' : resolvedProblems > 0 ? 'all-resolved' : ''}`,
                                onClick: () => handlePleeglocatieClick(location)
                            },
                                h('div', { className: 'pleeglocatie-header' },
                                    h('h4', { className: 'pleeglocatie-name' }, location.Title),
                                    h('div', { className: 'pleeglocatie-status' }, 
                                        `Status: ${location.Status_x0020_B_x0026_S || 'Onbekend'}`
                                    )
                                ),
                                h('div', { className: 'problem-summary' },
                                    h('div', null,
                                        h('span', { className: `problem-count ${activeProblems > 0 ? 'active' : 'resolved'}` },
                                            `${activeProblems} actief`
                                        ),
                                        ' / ',
                                        h('span', { className: 'problem-count resolved' },
                                            `${resolvedProblems} opgelost`
                                        )
                                    )
                                )
                            );
                        })
                    )
                );
            };

            const renderDetailLayer = () => {
                if (!selectedPleeglocatie) return null;
                const problems = selectedPleeglocatie.problemen || [];
                
                return h('div', null,
                    h('button', { className: 'back-btn', onClick: goBack },
                        h(BackIcon), 'Terug'
                    ),
                    h('div', { className: 'detail-view' },
                        h('div', { className: 'detail-main' },
                            h('div', { className: 'detail-header' },
                                h('h2', { className: 'detail-title' }, selectedPleeglocatie.Title),
                                h('div', { className: 'detail-subtitle' }, 
                                    `${selectedGemeente} • ${selectedPleeglocatie.Feitcodegroep}`
                                )
                            ),
                            h('div', { className: 'problems-list' },
                                problems.map(problem => h('div', {
                                    key: problem.Id,
                                    className: `problem-card ${problem.Opgelost_x003f_ !== 'Opgelost' ? 'active' : 'resolved'}`
                                },
                                    h('div', { className: 'problem-header' },
                                        h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                        h('div', { className: 'problem-age' }, 
                                            `${Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24))} dagen`
                                        )
                                    ),
                                    h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                    h('div', { className: 'problem-footer' },
                                        h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                        h('div', {
                                            className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                        }, problem.Opgelost_x003f_ || 'Aangemeld')
                                    )
                                ))
                            )
                        ),
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' }, 'Statistieken'),
                            h('div', { className: 'info-item' },
                                h('div', { className: 'info-label' }, 'Totaal'),
                                h('div', { className: 'info-value' }, problems.length)
                            )
                        )
                    )
                );
            };

            if (loading) {
                return h('div', { className: 'loading-state' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Minimal Portal wordt geladen...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Minimal Portal'),
                        h('div', { className: 'breadcrumb' },
                            getBreadcrumb().map((item, index) => [
                                h('span', {
                                    key: `item-${index}`,
                                    className: 'breadcrumb-item',
                                    onClick: item.action,
                                    style: { cursor: item.action ? 'pointer' : 'default' }
                                }, item.label),
                                index < getBreadcrumb().length - 1 && h('span', {
                                    key: `sep-${index}`,
                                    className: 'breadcrumb-separator'
                                }, '>')
                            ]).flat().filter(Boolean)
                        )
                    )
                ),
                
                h('div', { className: 'layer-container' },
                    currentLayer === 'gemeente' && renderGemeenteLayer(),
                    currentLayer === 'pleeglocatie' && renderPleeglocatieLayer(),
                    currentLayer === 'detail' && renderDetailLayer()
                ),
                
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(MinimalPortal));
    </script>
</body>
</html>
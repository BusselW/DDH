<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 6: Layered Navigation</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; color: #1a202c;
        }
        .portal-container {
            max-width: 1600px; margin: 0 auto; padding: 20px; min-height: 100vh;
        }
        
        /* Header */
        .portal-header {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);
            border-radius: 20px; padding: 24px; margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .portal-title {
            font-size: 28px; font-weight: 800; margin: 0;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 14px; color: #64748b;
        }
        .breadcrumb-item {
            cursor: pointer; transition: color 0.2s ease;
        }
        .breadcrumb-item:hover { color: #667eea; }
        .breadcrumb-separator { margin: 0 4px; }
        
        /* Navigation Layers */
        .layer-container {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);
            border-radius: 20px; padding: 32px; box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        
        /* Layer 1: Gemeente Grid */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .gemeente-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border: 2px solid transparent;
        }
        .gemeente-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.15);
            border-color: #667eea;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 20px; font-weight: 700; color: #1a202c; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-bottom: 16px;
        }
        .stat-item {
            text-align: center; padding: 12px; background: #f8fafc; border-radius: 8px;
        }
        .stat-number {
            font-size: 18px; font-weight: 700; color: #1a202c;
        }
        .stat-label {
            font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 600;
        }
        .gemeente-preview {
            font-size: 14px; color: #64748b; line-height: 1.5;
        }
        
        /* Layer 2: Pleeglocatie Grid */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        .pleeglocatie-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border-left: 4px solid #e2e8f0;
        }
        .pleeglocatie-card:hover {
            transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        .pleeglocatie-card.has-problems { border-left-color: #ef4444; }
        .pleeglocatie-card.all-resolved { border-left-color: #22c55e; }
        
        .pleeglocatie-header {
            margin-bottom: 12px;
        }
        .pleeglocatie-name {
            font-size: 16px; font-weight: 600; color: #1a202c; margin: 0 0 4px 0;
        }
        .pleeglocatie-status {
            font-size: 13px; color: #64748b;
        }
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 12px; padding: 8px; background: #f8fafc; border-radius: 6px;
        }
        .problem-count {
            font-size: 14px; font-weight: 600;
        }
        .problem-count.active { color: #ef4444; }
        .problem-count.resolved { color: #22c55e; }
        
        .pleeglocatie-meta {
            font-size: 12px; color: #94a3b8;
        }
        
        /* Layer 3: Detail View */
        .detail-view {
            display: grid; grid-template-columns: 1fr 300px; gap: 24px;
        }
        .detail-main {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .detail-sidebar {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); height: fit-content;
        }
        
        .detail-header {
            margin-bottom: 24px; padding-bottom: 16px; border-bottom: 2px solid #f1f5f9;
        }
        .detail-title {
            font-size: 24px; font-weight: 700; color: #1a202c; margin: 0 0 8px 0;
        }
        .detail-subtitle {
            font-size: 14px; color: #64748b;
        }
        
        .info-section {
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 16px; font-weight: 600; color: #374151; margin: 0 0 12px 0;
            display: flex; align-items: center; gap: 8px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .info-item {
            padding: 12px; background: #f8fafc; border-radius: 8px;
        }
        .info-label {
            font-size: 12px; color: #64748b; text-transform: uppercase;
            font-weight: 600; margin-bottom: 4px;
        }
        .info-value {
            font-size: 14px; color: #1a202c; font-weight: 500;
        }
        .info-link {
            color: #667eea; text-decoration: none;
        }
        .info-link:hover { text-decoration: underline; }
        
        /* Problem Filtering */
        .problem-filters {
            display: flex; gap: 8px; margin-bottom: 16px;
        }
        .filter-btn {
            padding: 8px 16px; border: 2px solid #e2e8f0; background: white;
            border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600;
            transition: all 0.2s ease;
        }
        .filter-btn.active { background: #667eea; color: white; border-color: #667eea; }
        .filter-btn:hover:not(.active) { background: #f8fafc; border-color: #cbd5e0; }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .problem-card {
            background: #f8fafc; border-radius: 12px; padding: 16px;
            border-left: 4px solid #e2e8f0; transition: all 0.2s ease;
        }
        .problem-card:hover { background: #f1f5f9; }
        .problem-card.active {
            border-left-color: #ef4444; background: #fef2f2;
        }
        .problem-card.resolved {
            border-left-color: #22c55e; background: #f0fdf4; opacity: 0.8;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #64748b; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #94a3b8;
        }
        .problem-description {
            font-size: 14px; color: #374151; line-height: 1.4; margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #667eea; color: white; padding: 4px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #fef2f2; color: #dc2626; }
        .problem-status.behandeling { background: #eff6ff; color: #2563eb; }
        .problem-status.uitgezet { background: #fffbeb; color: #d97706; }
        .problem-status.opgelost { background: #f0fdf4; color: #16a34a; }
        
        /* Back Button */
        .back-btn {
            background: #667eea; color: white; border: none;
            padding: 12px 20px; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px;
            transition: all 0.2s ease; margin-bottom: 20px;
        }
        .back-btn:hover { background: #5b21b6; transform: translateX(-2px); }
        
        /* Loading and Empty States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 300px; flex-direction: column; gap: 16px;
        }
        .loading-spinner {
            width: 40px; height: 40px; border: 4px solid #f3f4f6;
            border-top: 4px solid #667eea; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .detail-view { grid-template-columns: 1fr; }
            .gemeente-grid { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 12px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .header-content { flex-direction: column; gap: 12px; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Layered Portal wordt geladen...</p>
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

        // SVG Icons
        const HomeIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z' })
        );
        const LocationIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z' })
        );
        const BackIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );
        const BuildingIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10zm-2-8h-2v2h2v-2zm0 4h-2v2h2v-2z' })
        );
        const DocumentIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z' })
        );
        const ContactIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z' })
        );

        const LayeredPortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [currentLayer, setCurrentLayer] = useState('gemeente'); // 'gemeente', 'pleeglocatie', 'detail'
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);
            const [problemFilter, setProblemFilter] = useState('all'); // 'all', 'active', 'resolved'

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
                                h('div', { className: 'gemeente-badge' }, `${locations.length} locaties`)
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

            const renderPleeglocatieLayer = () => {
                const locations = groupedData[selectedGemeente] || [];
                
                return h('div', null,
                    h('button', { className: 'back-btn', onClick: goBack },
                        h(BackIcon), 'Terug naar gemeentes'
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
                                    ),
                                    h('div', { style: { fontSize: '12px', color: '#94a3b8' } },
                                        `${problems.length} totaal`
                                    )
                                ),
                                h('div', { className: 'pleeglocatie-meta' },
                                    `Feitcodegroep: ${location.Feitcodegroep} • `,
                                    `Waarschuwingsperiode: ${location.Waarschuwingsperiode || 'Onbekend'}`
                                )
                            );
                        })
                    )
                );
            };

            const renderDetailLayer = () => {
                if (!selectedPleeglocatie) return null;

                const problems = selectedPleeglocatie.problemen || [];
                const filteredProblems = problems.filter(problem => {
                    if (problemFilter === 'active') return problem.Opgelost_x003f_ !== 'Opgelost';
                    if (problemFilter === 'resolved') return problem.Opgelost_x003f_ === 'Opgelost';
                    return true;
                });

                return h('div', null,
                    h('button', { className: 'back-btn', onClick: goBack },
                        h(BackIcon), `Terug naar ${selectedGemeente}`
                    ),
                    h('div', { className: 'detail-view' },
                        h('div', { className: 'detail-main' },
                            h('div', { className: 'detail-header' },
                                h('h2', { className: 'detail-title' }, selectedPleeglocatie.Title),
                                h('div', { className: 'detail-subtitle' }, 
                                    `${selectedGemeente} • ${selectedPleeglocatie.Feitcodegroep}`
                                )
                            ),
                            
                            h('div', { className: 'info-section' },
                                h('h3', { className: 'section-title' },
                                    h(BuildingIcon), 'Locatie Informatie'
                                ),
                                h('div', { className: 'info-grid' },
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Status B&S'),
                                        h('div', { className: 'info-value' }, selectedPleeglocatie.Status_x0020_B_x0026_S || 'Onbekend')
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Waarschuwingsperiode'),
                                        h('div', { className: 'info-value' }, selectedPleeglocatie.Waarschuwingsperiode || 'Onbekend')
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Laatste Schouw'),
                                        h('div', { className: 'info-value' }, 
                                            selectedPleeglocatie.Laatste_x0020_schouw ? 
                                                new Date(selectedPleeglocatie.Laatste_x0020_schouw).toLocaleDateString('nl-NL') : 
                                                'Niet uitgevoerd'
                                        )
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Start Waarschuwingsperiode'),
                                        h('div', { className: 'info-value' }, 
                                            selectedPleeglocatie.Start_x0020_Waarschuwingsperiode ? 
                                                new Date(selectedPleeglocatie.Start_x0020_Waarschuwingsperiode).toLocaleDateString('nl-NL') : 
                                                'Niet gestart'
                                        )
                                    )
                                )
                            ),
                            
                            h('div', { className: 'info-section' },
                                h('h3', { className: 'section-title' },
                                    h(DocumentIcon), 'Documenten & Links'
                                ),
                                h('div', { className: 'info-grid' },
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Algemeen PV'),
                                        h('div', { className: 'info-value' },
                                            selectedPleeglocatie.Link_x0020_Algemeen_x0020_PV?.Url ?
                                                h('a', { 
                                                    href: selectedPleeglocatie.Link_x0020_Algemeen_x0020_PV.Url,
                                                    className: 'info-link',
                                                    target: '_blank'
                                                }, selectedPleeglocatie.Link_x0020_Algemeen_x0020_PV.Description || 'Bekijk document') :
                                                'Niet beschikbaar'
                                        )
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Schouwrapporten'),
                                        h('div', { className: 'info-value' },
                                            selectedPleeglocatie.Link_x0020_Schouwrapporten?.Url ?
                                                h('a', { 
                                                    href: selectedPleeglocatie.Link_x0020_Schouwrapporten.Url,
                                                    className: 'info-link',
                                                    target: '_blank'
                                                }, selectedPleeglocatie.Link_x0020_Schouwrapporten.Description || 'Bekijk rapporten') :
                                                'Niet beschikbaar'
                                        )
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Instemmingsbesluit'),
                                        h('div', { className: 'info-value' },
                                            selectedPleeglocatie.Instemmingsbesluit?.Url ?
                                                h('a', { 
                                                    href: selectedPleeglocatie.Instemmingsbesluit.Url,
                                                    className: 'info-link',
                                                    target: '_blank'
                                                }, selectedPleeglocatie.Instemmingsbesluit.Description || 'Bekijk besluit') :
                                                'Niet beschikbaar'
                                        )
                                    ),
                                    h('div', { className: 'info-item' },
                                        h('div', { className: 'info-label' }, 'Contactpersoon'),
                                        h('div', { className: 'info-value' },
                                            selectedPleeglocatie.E_x002d_mailadres_x0020_contactp ?
                                                h('a', { 
                                                    href: `mailto:${selectedPleeglocatie.E_x002d_mailadres_x0020_contactp}`,
                                                    className: 'info-link'
                                                }, selectedPleeglocatie.E_x002d_mailadres_x0020_contactp) :
                                                'Niet beschikbaar'
                                        )
                                    )
                                )
                            ),
                            
                            h('div', { className: 'info-section' },
                                h('h3', { className: 'section-title' },
                                    h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
                                        h('path', { d: 'M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z' })
                                    ), 
                                    'Problemen'
                                ),
                                h('div', { className: 'problem-filters' },
                                    h('button', {
                                        className: `filter-btn ${problemFilter === 'all' ? 'active' : ''}`,
                                        onClick: () => setProblemFilter('all')
                                    }, `Alle (${problems.length})`),
                                    h('button', {
                                        className: `filter-btn ${problemFilter === 'active' ? 'active' : ''}`,
                                        onClick: () => setProblemFilter('active')
                                    }, `Actief (${problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length})`),
                                    h('button', {
                                        className: `filter-btn ${problemFilter === 'resolved' ? 'active' : ''}`,
                                        onClick: () => setProblemFilter('resolved')
                                    }, `Opgelost (${problems.filter(p => p.Opgelost_x003f_ === 'Opgelost').length})`)
                                ),
                                h('div', { className: 'problems-list' },
                                    filteredProblems.length > 0 ? filteredProblems.map(problem => {
                                        const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                        const isActive = problem.Opgelost_x003f_ !== 'Opgelost';
                                        
                                        return h('div', {
                                            key: problem.Id,
                                            className: `problem-card ${isActive ? 'active' : 'resolved'}`
                                        },
                                            h('div', { className: 'problem-header' },
                                                h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                                h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                            ),
                                            h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                            h('div', { className: 'problem-footer' },
                                                h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                                h('div', {
                                                    className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                }, problem.Opgelost_x003f_ || 'Aangemeld')
                                            )
                                        );
                                    }) : h('div', { 
                                        style: { 
                                            textAlign: 'center', 
                                            padding: '40px', 
                                            color: '#64748b' 
                                        } 
                                    }, `Geen ${problemFilter === 'all' ? '' : problemFilter === 'active' ? 'actieve' : 'opgeloste'} problemen gevonden.`)
                                )
                            )
                        ),
                        
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' },
                                h(ContactIcon), 'Contact Info'
                            ),
                            h('div', { className: 'info-item' },
                                h('div', { className: 'info-label' }, 'E-mail'),
                                h('div', { className: 'info-value' },
                                    selectedPleeglocatie.E_x002d_mailadres_x0020_contactp || 'Niet beschikbaar'
                                )
                            ),
                            
                            h('h3', { className: 'section-title', style: { marginTop: '24px' } },
                                h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
                                    h('path', { d: 'M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z' })
                                ), 
                                'Statistieken'
                            ),
                            h('div', { style: { display: 'flex', flexDirection: 'column', gap: '8px' } },
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Totaal Problemen'),
                                    h('div', { className: 'info-value' }, problems.length)
                                ),
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Actieve Problemen'),
                                    h('div', { className: 'info-value' }, problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length)
                                ),
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Oplossingsratio'),
                                    h('div', { className: 'info-value' }, 
                                        `${problems.length > 0 ? Math.round(((problems.length - problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length) / problems.length) * 100) : 100}%`
                                    )
                                )
                            )
                        )
                    )
                );
            };

            if (loading) {
                return h('div', { className: 'loading-state' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Layered Portal wordt geladen...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Layered Portal'),
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
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(LayeredPortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
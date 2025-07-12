<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 12: Compact Layered</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 50px 0; background: #f8f9fa;
            min-height: 100vh; color: #212529; font-size: 14px;
        }
        .portal-container {
            max-width: 1400px; margin: 0 auto; padding: 15px; min-height: 100vh;
        }
        
        /* Compact Header */
        .portal-header {
            background: white; border-radius: 6px; padding: 16px; margin-bottom: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #dee2e6;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .portal-title {
            font-size: 20px; font-weight: 600; margin: 0; color: #212529;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 6px; font-size: 12px; 
            color: #6c757d; font-weight: 500;
        }
        .breadcrumb-item {
            cursor: pointer; transition: color 0.2s ease; padding: 2px 6px;
            border-radius: 3px;
        }
        .breadcrumb-item:hover { color: #0d6efd; background: #e7f1ff; }
        .breadcrumb-separator { margin: 0 2px; }
        
        /* Compact Container */
        .layer-container {
            background: white; border-radius: 6px; padding: 20px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #dee2e6;
        }
        
        /* Gemeente Grid - Compact */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 12px;
        }
        .gemeente-card {
            background: #f8f9fa; border-radius: 4px; padding: 16px;
            border: 1px solid #dee2e6; cursor: pointer;
            transition: all 0.2s ease;
        }
        .gemeente-card:hover {
            background: #e9ecef; border-color: #0d6efd;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 10px;
        }
        .gemeente-name {
            font-size: 16px; font-weight: 600; color: #212529; margin: 0;
        }
        .gemeente-badge {
            background: #0d6efd; color: white; padding: 2px 6px; 
            border-radius: 3px; font-size: 10px; font-weight: 600;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px;
            margin-bottom: 10px;
        }
        .stat-item {
            text-align: center; padding: 8px; background: white; 
            border-radius: 3px; border: 1px solid #dee2e6;
        }
        .stat-number {
            font-size: 14px; font-weight: 600; color: #212529;
        }
        .stat-label {
            font-size: 9px; color: #6c757d; text-transform: uppercase; font-weight: 600;
        }
        .gemeente-preview {
            font-size: 12px; color: #6c757d; line-height: 1.3;
        }
        
        /* Pleeglocatie Grid - Compact */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 10px;
        }
        .pleeglocatie-card {
            background: #f8f9fa; border-radius: 4px; padding: 14px;
            border: 1px solid #dee2e6; cursor: pointer;
            transition: all 0.2s ease; border-left: 3px solid #dee2e6;
        }
        .pleeglocatie-card:hover {
            background: #e9ecef; border-color: #0d6efd;
        }
        .pleeglocatie-card.has-problems { border-left-color: #dc3545; }
        .pleeglocatie-card.all-resolved { border-left-color: #198754; }
        
        .pleeglocatie-header { margin-bottom: 8px; }
        .pleeglocatie-name {
            font-size: 14px; font-weight: 600; color: #212529; margin: 0 0 3px 0;
        }
        .pleeglocatie-status { font-size: 11px; color: #6c757d; }
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin: 6px 0; padding: 6px; background: white; border-radius: 3px;
            border: 1px solid #dee2e6;
        }
        .problem-count { font-size: 12px; font-weight: 600; }
        .problem-count.active { color: #dc3545; }
        .problem-count.resolved { color: #198754; }
        
        /* Detail View - Compact */
        .detail-view {
            display: grid; grid-template-columns: 2fr 1fr; gap: 16px;
        }
        .detail-main {
            background: #f8f9fa; border-radius: 4px; padding: 16px;
            border: 1px solid #dee2e6;
        }
        .detail-sidebar {
            background: #f8f9fa; border-radius: 4px; padding: 16px; height: fit-content;
            border: 1px solid #dee2e6;
        }
        
        .detail-header {
            margin-bottom: 16px; padding-bottom: 10px; border-bottom: 1px solid #dee2e6;
        }
        .detail-title {
            font-size: 18px; font-weight: 600; color: #212529; margin: 0 0 4px 0;
        }
        .detail-subtitle {
            font-size: 12px; color: #6c757d;
        }
        
        .info-section { margin-bottom: 16px; }
        .section-title {
            font-size: 14px; font-weight: 600; color: #212529; margin: 0 0 8px 0;
            display: flex; align-items: center; gap: 6px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 8px;
        }
        .info-item {
            padding: 8px; background: white; border-radius: 3px;
            border: 1px solid #dee2e6;
        }
        .info-label {
            font-size: 9px; color: #6c757d; text-transform: uppercase;
            font-weight: 600; margin-bottom: 2px;
        }
        .info-value {
            font-size: 12px; color: #212529; font-weight: 500;
        }
        .info-link {
            color: #0d6efd; text-decoration: none;
        }
        .info-link:hover { text-decoration: underline; }
        
        /* Problem Filtering - Compact */
        .problem-filters {
            display: flex; gap: 6px; margin-bottom: 12px;
        }
        .filter-btn {
            padding: 6px 10px; border: 1px solid #dee2e6; background: white;
            border-radius: 3px; cursor: pointer; font-size: 11px; font-weight: 600;
            transition: all 0.2s ease;
        }
        .filter-btn.active { background: #0d6efd; color: white; border-color: #0d6efd; }
        .filter-btn:hover:not(.active) { background: #e9ecef; }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 8px;
        }
        .problem-card {
            background: white; border-radius: 4px; padding: 12px;
            border: 1px solid #dee2e6; transition: all 0.2s ease;
            border-left: 3px solid #dee2e6;
        }
        .problem-card:hover { background: #f8f9fa; }
        .problem-card.active {
            border-left-color: #dc3545; background: #fff5f5;
        }
        .problem-card.resolved {
            border-left-color: #198754; background: #f0fff4; opacity: 0.85;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 6px;
        }
        .problem-id {
            font-size: 10px; color: #6c757d; font-weight: 600;
        }
        .problem-age {
            font-size: 9px; color: #adb5bd;
        }
        .problem-description {
            font-size: 12px; color: #212529; line-height: 1.3; margin-bottom: 8px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #0d6efd; color: white; padding: 2px 6px;
            border-radius: 3px; font-size: 9px; font-weight: 600;
        }
        .problem-status {
            padding: 2px 6px; border-radius: 3px; font-size: 9px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #f8d7da; color: #721c24; }
        .problem-status.behandeling { background: #d1ecf1; color: #0c5460; }
        .problem-status.uitgezet { background: #fff3cd; color: #856404; }
        .problem-status.opgelost { background: #d1e7dd; color: #0f5132; }
        
        /* Back Button - Compact */
        .back-btn {
            background: #0d6efd; color: white; border: none;
            padding: 8px 12px; border-radius: 3px; cursor: pointer;
            font-size: 12px; font-weight: 600; display: flex; align-items: center; gap: 4px;
            transition: all 0.2s ease; margin-bottom: 12px;
        }
        .back-btn:hover { background: #0b5ed7; }
        
        /* Loading States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 200px; flex-direction: column; gap: 10px;
        }
        .loading-spinner {
            width: 24px; height: 24px; border: 2px solid #f3f4f6;
            border-top: 2px solid #0d6efd; border-radius: 50%;
            animation: compact-spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .detail-view { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 10px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .header-content { flex-direction: column; gap: 8px; }
        }
        @keyframes compact-spin { 
            0% { transform: rotate(0deg); } 
            100% { transform: rotate(360deg); } 
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Compact Portal wordt geladen...</p>
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

        // Compact SVG Icons
        const BackIcon = () => h('svg', { width: 12, height: 12, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );

        const CompactPortal = () => {
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
                    case 'Instemming verleend': return '#198754';
                    case 'In behandeling': return '#ffc107';  
                    case 'Aangevraagd': return '#dc3545';
                    default: return '#6c757d';
                }
            };

            const getWaarschuwingsperiodeColor = (hasWarning) => {
                return hasWarning === 'Ja' ? '#198754' : '#dc3545';
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
                                h('div', { className: 'gemeente-badge' }, 'DDH')
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
                                `${locations.length} locaties, ${activeProblems} actieve problemen`
                            )
                        );
                    })
                );
            };

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
                            
                            const statusBS = location.Status_x0020_B_x0026_S || 'Onbekend';
                            const statusColor = getStatusBadgeColor(statusBS);
                            const waarschuwingsperiode = location.Waarschuwingsperiode === 'Ja';
                            const waarschuwingColor = getWaarschuwingsperiodeColor(location.Waarschuwingsperiode);

                            return h('div', {
                                key: location.Id,
                                className: `pleeglocatie-card ${hasProblems ? 'has-problems' : resolvedProblems > 0 ? 'all-resolved' : ''}`,
                                onClick: () => handlePleeglocatieClick(location)
                            },
                                h('div', { className: 'pleeglocatie-header' },
                                    h('h4', { className: 'pleeglocatie-name' }, location.Title),
                                    h('div', { 
                                        className: 'pleeglocatie-status',
                                        style: { 
                                            display: 'flex', 
                                            alignItems: 'center', 
                                            gap: '4px'
                                        }
                                    }, 
                                        h('span', { 
                                            style: { 
                                                width: '6px', 
                                                height: '6px', 
                                                backgroundColor: statusColor, 
                                                borderRadius: '50%' 
                                            } 
                                        }),
                                        statusBS
                                    )
                                ),
                                h('div', { style: { marginBottom: '6px' } },
                                    h('span', {
                                        style: {
                                            fontSize: '9px',
                                            backgroundColor: waarschuwingColor,
                                            color: 'white',
                                            padding: '2px 4px',
                                            borderRadius: '3px',
                                            fontWeight: '600',
                                            textTransform: 'uppercase'
                                        }
                                    }, 
                                        location.Waarschuwingsperiode || 'Onbekend'
                                    )
                                ),
                                h('div', { style: { marginBottom: '6px' } },
                                    h('span', {
                                        style: {
                                            fontSize: '9px',
                                            background: 'white',
                                            color: '#6c757d',
                                            padding: '1px 4px',
                                            borderRadius: '3px',
                                            border: '1px solid #dee2e6'
                                        }
                                    }, location.Feitcodegroep)
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
                const filteredProblems = problems.filter(problem => {
                    if (problemFilter === 'active') return problem.Opgelost_x003f_ !== 'Opgelost';
                    if (problemFilter === 'resolved') return problem.Opgelost_x003f_ === 'Opgelost';
                    return true;
                });

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
                            
                            h('div', { className: 'info-section' },
                                h('h3', { className: 'section-title' }, 'Problemen'),
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
                                                h('div', { className: 'problem-id' }, `#${problem.Id}`),
                                                h('div', { className: 'problem-age' }, `${daysSince}d`)
                                            ),
                                            h('div', { 
                                                className: 'problem-description',
                                                style: {
                                                    background: 'white',
                                                    border: '1px solid #dee2e6',
                                                    borderLeft: '3px solid #0d6efd',
                                                    borderRadius: '3px',
                                                    padding: '8px',
                                                    margin: '6px 0',
                                                    fontSize: '11px',
                                                    lineHeight: '1.3'
                                                }
                                            }, problem.Probleembeschrijving),
                                            h('div', { style: { fontSize: '10px', color: '#6c757d', marginBottom: '6px' } },
                                                problem.Startdatum && `${new Date(problem.Startdatum).toLocaleDateString('nl-NL')}`,
                                                problem.Startdatum && problem.Einddatum && ' - ',
                                                problem.Einddatum && `${new Date(problem.Einddatum).toLocaleDateString('nl-NL')}`
                                            ),
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
                                            padding: '20px', 
                                            color: '#6c757d',
                                            fontSize: '11px'
                                        } 
                                    }, `Geen problemen`)
                                )
                            )
                        ),
                        
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' }, 'Stats'),
                            h('div', { style: { display: 'flex', flexDirection: 'column', gap: '8px' } },
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Totaal'),
                                    h('div', { className: 'info-value' }, problems.length)
                                ),
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Actief'),
                                    h('div', { className: 'info-value' }, problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length)
                                ),
                                h('div', { className: 'info-item' },
                                    h('div', { className: 'info-label' }, 'Opgelost'),
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
                    h('p', { style: { fontSize: '12px' } }, 'Laden...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Compact'),
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
        root.render(h(CompactPortal));
    </script>
</body>
</html>
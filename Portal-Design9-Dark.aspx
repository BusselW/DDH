<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 9: Dark Layered</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #0f172a;
            min-height: 100vh; color: #e2e8f0;
        }
        .portal-container {
            max-width: 1600px; margin: 0 auto; padding: 20px; min-height: 100vh;
        }
        
        /* Dark Header */
        .portal-header {
            background: #1e293b; border-radius: 16px; padding: 24px; margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3); border: 1px solid #334155;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .portal-title {
            font-size: 28px; font-weight: 700; margin: 0;
            background: linear-gradient(135deg, #60a5fa, #a78bfa);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 14px; color: #94a3b8;
        }
        .breadcrumb-item {
            cursor: pointer; transition: color 0.2s ease;
        }
        .breadcrumb-item:hover { color: #60a5fa; }
        .breadcrumb-separator { margin: 0 4px; }
        
        /* Dark Container */
        .layer-container {
            background: #1e293b; border-radius: 16px; padding: 32px; 
            box-shadow: 0 8px 32px rgba(0,0,0,0.3); border: 1px solid #334155;
        }
        
        /* Gemeente Grid - Dark */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .gemeente-card {
            background: #374151; border-radius: 12px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2); cursor: pointer;
            transition: all 0.3s ease; border: 2px solid transparent;
        }
        .gemeente-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.4);
            border-color: #60a5fa; background: #4b5563;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 20px; font-weight: 600; color: #f1f5f9; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #60a5fa, #a78bfa); color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-bottom: 16px;
        }
        .stat-item {
            text-align: center; padding: 12px; background: #4b5563; border-radius: 8px;
            border: 1px solid #6b7280;
        }
        .stat-number {
            font-size: 18px; font-weight: 700; color: #f1f5f9;
        }
        .stat-label {
            font-size: 11px; color: #94a3b8; text-transform: uppercase; font-weight: 600;
        }
        .gemeente-preview {
            font-size: 14px; color: #cbd5e1; line-height: 1.5;
        }
        
        /* Pleeglocatie Grid - Dark */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        .pleeglocatie-card {
            background: #374151; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.2); cursor: pointer;
            transition: all 0.3s ease; border-left: 4px solid #64748b;
        }
        .pleeglocatie-card:hover {
            transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.3);
            background: #4b5563;
        }
        .pleeglocatie-card.has-problems { border-left-color: #ef4444; }
        .pleeglocatie-card.all-resolved { border-left-color: #22c55e; }
        
        .pleeglocatie-header {
            margin-bottom: 12px;
        }
        .pleeglocatie-name {
            font-size: 16px; font-weight: 600; color: #f1f5f9; margin: 0 0 4px 0;
        }
        .pleeglocatie-status {
            font-size: 13px; color: #94a3b8;
        }
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 12px; padding: 8px; background: #4b5563; border-radius: 6px;
            border: 1px solid #6b7280;
        }
        .problem-count {
            font-size: 14px; font-weight: 600;
        }
        .problem-count.active { color: #f87171; }
        .problem-count.resolved { color: #4ade80; }
        
        /* Detail View - Dark */
        .detail-view {
            display: grid; grid-template-columns: 1fr 300px; gap: 24px;
        }
        .detail-main {
            background: #374151; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2); border: 1px solid #4b5563;
        }
        .detail-sidebar {
            background: #374151; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2); height: fit-content;
            border: 1px solid #4b5563;
        }
        
        .detail-header {
            margin-bottom: 24px; padding-bottom: 16px; border-bottom: 2px solid #4b5563;
        }
        .detail-title {
            font-size: 24px; font-weight: 700; color: #f1f5f9; margin: 0 0 8px 0;
        }
        .detail-subtitle {
            font-size: 14px; color: #94a3b8;
        }
        
        .info-section {
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 16px; font-weight: 600; color: #e2e8f0; margin: 0 0 12px 0;
            display: flex; align-items: center; gap: 8px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .info-item {
            padding: 12px; background: #4b5563; border-radius: 8px;
            border: 1px solid #6b7280;
        }
        .info-label {
            font-size: 12px; color: #94a3b8; text-transform: uppercase;
            font-weight: 600; margin-bottom: 4px;
        }
        .info-value {
            font-size: 14px; color: #f1f5f9; font-weight: 500;
        }
        .info-link {
            color: #60a5fa; text-decoration: none;
        }
        .info-link:hover { text-decoration: underline; }
        
        /* Problem Filtering - Dark */
        .problem-filters {
            display: flex; gap: 8px; margin-bottom: 16px;
        }
        .filter-btn {
            padding: 8px 16px; border: 2px solid #4b5563; background: #374151;
            border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600;
            transition: all 0.2s ease; color: #e2e8f0;
        }
        .filter-btn.active { background: #60a5fa; color: white; border-color: #60a5fa; }
        .filter-btn:hover:not(.active) { background: #4b5563; border-color: #6b7280; }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .problem-card {
            background: #4b5563; border-radius: 12px; padding: 16px;
            border-left: 4px solid #64748b; transition: all 0.2s ease;
            border: 1px solid #6b7280;
        }
        .problem-card:hover { background: #374151; }
        .problem-card.active {
            border-left-color: #ef4444; background: #450a0a;
            border-color: #7f1d1d;
        }
        .problem-card.resolved {
            border-left-color: #22c55e; background: #052e16; opacity: 0.8;
            border-color: #166534;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #94a3b8; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #64748b;
        }
        .problem-description {
            font-size: 14px; color: #e2e8f0; line-height: 1.4; margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #60a5fa; color: white; padding: 4px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #450a0a; color: #f87171; }
        .problem-status.behandeling { background: #1e3a8a; color: #93c5fd; }
        .problem-status.uitgezet { background: #451a03; color: #fbbf24; }
        .problem-status.opgelost { background: #052e16; color: #4ade80; }
        
        /* Back Button - Dark */
        .back-btn {
            background: #60a5fa; color: white; border: none;
            padding: 12px 20px; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px;
            transition: all 0.2s ease; margin-bottom: 20px;
        }
        .back-btn:hover { background: #3b82f6; transform: translateX(-2px); }
        
        /* Loading States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 300px; flex-direction: column; gap: 16px;
        }
        .loading-spinner {
            width: 40px; height: 40px; border: 4px solid #4b5563;
            border-top: 4px solid #60a5fa; border-radius: 50%;
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
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Dark Portal wordt geladen...</p>
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

        // SVG Icons for dark theme
        const BackIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );

        const DarkPortal = () => {
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
                    case 'Instemming verleend': return '#22c55e';
                    case 'In behandeling': return '#f59e0b';  
                    case 'Aangevraagd': return '#ef4444';
                    default: return '#6b7280';
                }
            };

            const getWaarschuwingsperiodeColor = (hasWarning) => {
                return hasWarning === 'Ja' ? '#22c55e' : '#ef4444';
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
                                            gap: '8px',
                                            marginBottom: '8px'
                                        }
                                    }, 
                                        h('span', { 
                                            style: { 
                                                width: '8px', 
                                                height: '8px', 
                                                backgroundColor: statusColor, 
                                                borderRadius: '50%' 
                                            } 
                                        }),
                                        `Status B&S: ${statusBS}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '12px' } },
                                    h('div', {
                                        style: {
                                            display: 'inline-flex',
                                            alignItems: 'center',
                                            gap: '6px',
                                            padding: '4px 8px',
                                            backgroundColor: waarschuwingColor,
                                            color: 'white',
                                            borderRadius: '12px',
                                            fontSize: '12px',
                                            fontWeight: '600'
                                        }
                                    }, 
                                        `Waarschuwingsperiode: ${location.Waarschuwingsperiode || 'Onbekend'}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '8px' } },
                                    h('span', {
                                        style: {
                                            fontSize: '11px',
                                            backgroundColor: '#4b5563',
                                            color: '#94a3b8',
                                            padding: '2px 6px',
                                            borderRadius: '8px'
                                        }
                                    }, location.Feitcodegroep)
                                ),
                                location.E_x002d_mailadres_x0020_contactp && h('div', { style: { fontSize: '12px', marginBottom: '8px' } },
                                    h('a', {
                                        href: `mailto:${location.E_x002d_mailadres_x0020_contactp}`,
                                        style: { color: '#60a5fa', textDecoration: 'none' },
                                        onClick: (e) => e.stopPropagation()
                                    }, location.E_x002d_mailadres_x0020_contactp)
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
                                    h('div', { style: { fontSize: '12px', color: '#64748b' } },
                                        `${problems.length} totaal`
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
                                                h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                                h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                            ),
                                            h('div', { 
                                                className: 'problem-description',
                                                style: {
                                                    backgroundColor: '#4b5563',
                                                    border: '2px solid #6b7280',
                                                    borderRadius: '8px',
                                                    padding: '12px',
                                                    margin: '8px 0',
                                                    fontStyle: 'italic',
                                                    lineHeight: '1.5'
                                                }
                                            }, problem.Probleembeschrijving),
                                            h('div', { style: { fontSize: '12px', color: '#94a3b8', marginBottom: '8px' } },
                                                problem.Startdatum && `Start: ${new Date(problem.Startdatum).toLocaleDateString('nl-NL')}`,
                                                problem.Startdatum && problem.Einddatum && ' | ',
                                                problem.Einddatum && `Einde: ${new Date(problem.Einddatum).toLocaleDateString('nl-NL')}`
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
                                            padding: '40px', 
                                            color: '#94a3b8' 
                                        } 
                                    }, `Geen ${problemFilter === 'all' ? '' : problemFilter === 'active' ? 'actieve' : 'opgeloste'} problemen gevonden.`)
                                )
                            )
                        ),
                        
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' }, 'Statistieken'),
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
                    h('p', null, 'Dark Portal wordt geladen...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Dark Portal'),
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
        root.render(h(DarkPortal));
    </script>
</body>
</html>
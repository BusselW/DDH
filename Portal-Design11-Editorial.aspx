<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 11: Editorial Layered</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Georgia', 'Times New Roman', serif;
            margin: 0; padding: 0 0 60px 0; background: #fefefe;
            min-height: 100vh; color: #2c2c2c; line-height: 1.6;
        }
        .portal-container {
            max-width: 1200px; margin: 0 auto; padding: 40px 20px; min-height: 100vh;
        }
        
        /* Editorial Header */
        .portal-header {
            background: white; border-radius: 4px; padding: 40px; margin-bottom: 40px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.05); 
            border-top: 4px solid #8b5a3c;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid #e8e8e8; padding-bottom: 20px;
        }
        .portal-title {
            font-size: 42px; font-weight: 400; margin: 0; color: #2c2c2c;
            font-family: 'Georgia', serif; letter-spacing: -1px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        .portal-subtitle {
            font-size: 16px; color: #666; font-style: italic; margin: 8px 0 0 0;
            font-weight: 300;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 12px; font-size: 14px; 
            color: #8b5a3c; font-weight: 500; font-family: sans-serif;
        }
        .breadcrumb-item {
            cursor: pointer; transition: color 0.2s ease; padding: 4px 8px;
            border-radius: 3px;
        }
        .breadcrumb-item:hover { color: #654321; background: #f5f5f5; }
        .breadcrumb-separator { margin: 0 4px; color: #bbb; }
        
        /* Editorial Container */
        .layer-container {
            background: white; border-radius: 4px; padding: 50px; 
            box-shadow: 0 2px 20px rgba(0,0,0,0.05);
            border-left: 6px solid #8b5a3c;
        }
        
        /* Gemeente Grid - Editorial */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
        }
        .gemeente-card {
            background: #fefefe; border-radius: 4px; padding: 30px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border: 1px solid #e8e8e8;
            position: relative;
        }
        .gemeente-card::before {
            content: ''; position: absolute; top: 0; left: 0; 
            width: 4px; height: 100%; background: #8b5a3c;
            transform: scaleY(0); transition: transform 0.3s ease;
        }
        .gemeente-card:hover {
            transform: translateY(-3px); box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .gemeente-card:hover::before { transform: scaleY(1); }
        .gemeente-header {
            margin-bottom: 20px; border-bottom: 1px solid #f0f0f0; padding-bottom: 15px;
        }
        .gemeente-name {
            font-size: 26px; font-weight: 400; color: #2c2c2c; margin: 0 0 8px 0;
            font-family: 'Georgia', serif; letter-spacing: -0.5px;
        }
        .gemeente-badge {
            background: #8b5a3c; color: white; padding: 6px 14px; 
            border-radius: 3px; font-size: 12px; font-weight: 500;
            font-family: sans-serif; letter-spacing: 0.5px; text-transform: uppercase;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;
            margin-bottom: 20px;
        }
        .stat-item {
            text-align: center; padding: 15px; background: #f9f9f9; 
            border-radius: 3px; border: 1px solid #f0f0f0;
        }
        .stat-number {
            font-size: 24px; font-weight: 400; color: #2c2c2c;
            font-family: 'Georgia', serif;
        }
        .stat-label {
            font-size: 11px; color: #8b5a3c; text-transform: uppercase;
            font-weight: 600; letter-spacing: 1px; font-family: sans-serif;
        }
        .gemeente-preview {
            font-size: 16px; color: #555; line-height: 1.7; font-style: italic;
            font-family: 'Georgia', serif;
        }
        
        /* Pleeglocatie Grid - Editorial */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
        }
        .pleeglocatie-card {
            background: #fefefe; border-radius: 4px; padding: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border: 1px solid #e8e8e8;
            border-left: 5px solid #e8e8e8;
        }
        .pleeglocatie-card:hover {
            transform: translateY(-2px); box-shadow: 0 6px 25px rgba(0,0,0,0.1);
        }
        .pleeglocatie-card.has-problems { border-left-color: #d73527; }
        .pleeglocatie-card.all-resolved { border-left-color: #2d5016; }
        
        .pleeglocatie-header { margin-bottom: 15px; }
        .pleeglocatie-name {
            font-size: 20px; font-weight: 400; color: #2c2c2c; margin: 0 0 6px 0;
            font-family: 'Georgia', serif;
        }
        .pleeglocatie-status { 
            font-size: 14px; color: #666; font-family: sans-serif; 
        }
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 15px; padding: 12px; background: #f9f9f9; 
            border-radius: 3px; border: 1px solid #f0f0f0;
        }
        .problem-count { font-size: 15px; font-weight: 500; font-family: sans-serif; }
        .problem-count.active { color: #d73527; }
        .problem-count.resolved { color: #2d5016; }
        
        /* Detail View - Editorial */
        .detail-view {
            display: grid; grid-template-columns: 2fr 1fr; gap: 40px;
        }
        .detail-main {
            background: #fefefe; border-radius: 4px; padding: 40px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08); border: 1px solid #e8e8e8;
        }
        .detail-sidebar {
            background: #fefefe; border-radius: 4px; padding: 30px; height: fit-content;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08); border: 1px solid #e8e8e8;
        }
        
        .detail-header {
            margin-bottom: 35px; padding-bottom: 20px; 
            border-bottom: 2px solid #f0f0f0;
        }
        .detail-title {
            font-size: 32px; font-weight: 400; color: #2c2c2c; margin: 0 0 10px 0;
            font-family: 'Georgia', serif; letter-spacing: -0.5px;
        }
        .detail-subtitle {
            font-size: 16px; color: #8b5a3c; font-style: italic;
            font-family: 'Georgia', serif;
        }
        
        .info-section { margin-bottom: 35px; }
        .section-title {
            font-size: 20px; font-weight: 400; color: #2c2c2c; margin: 0 0 20px 0;
            font-family: 'Georgia', serif; border-bottom: 1px solid #f0f0f0;
            padding-bottom: 10px; display: flex; align-items: center; gap: 10px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
        }
        .info-item {
            padding: 15px; background: #f9f9f9; border-radius: 3px;
            border: 1px solid #f0f0f0;
        }
        .info-label {
            font-size: 12px; color: #8b5a3c; text-transform: uppercase;
            font-weight: 600; margin-bottom: 5px; letter-spacing: 1px;
            font-family: sans-serif;
        }
        .info-value {
            font-size: 15px; color: #2c2c2c; font-weight: 400;
            font-family: 'Georgia', serif;
        }
        .info-link {
            color: #8b5a3c; text-decoration: none; border-bottom: 1px dotted #8b5a3c;
        }
        .info-link:hover { border-bottom-style: solid; }
        
        /* Problem Filtering - Editorial */
        .problem-filters {
            display: flex; gap: 10px; margin-bottom: 25px;
        }
        .filter-btn {
            padding: 10px 18px; border: 2px solid #e8e8e8; background: white;
            border-radius: 3px; cursor: pointer; font-size: 14px; font-weight: 500;
            transition: all 0.2s ease; font-family: sans-serif;
        }
        .filter-btn.active { 
            background: #8b5a3c; color: white; border-color: #8b5a3c; 
        }
        .filter-btn:hover:not(.active) { 
            background: #f5f5f5; border-color: #ddd; 
        }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 20px;
        }
        .problem-card {
            background: #f9f9f9; border-radius: 4px; padding: 25px;
            border-left: 5px solid #e8e8e8; transition: all 0.2s ease;
            border: 1px solid #f0f0f0;
        }
        .problem-card:hover { background: #f5f5f5; }
        .problem-card.active {
            border-left-color: #d73527; background: #fdf5f5;
        }
        .problem-card.resolved {
            border-left-color: #2d5016; background: #f5f8f2; opacity: 0.9;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 15px;
        }
        .problem-id {
            font-size: 13px; color: #8b5a3c; font-weight: 600;
            font-family: sans-serif; letter-spacing: 0.5px;
        }
        .problem-age {
            font-size: 12px; color: #999; font-style: italic;
            font-family: 'Georgia', serif;
        }
        .problem-description {
            font-size: 16px; color: #2c2c2c; line-height: 1.7; margin-bottom: 20px;
            font-family: 'Georgia', serif; font-style: italic;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #8b5a3c; color: white; padding: 5px 12px;
            border-radius: 3px; font-size: 11px; font-weight: 600;
            font-family: sans-serif; letter-spacing: 0.5px; text-transform: uppercase;
        }
        .problem-status {
            padding: 5px 12px; border-radius: 3px; font-size: 11px; font-weight: 600;
            font-family: sans-serif; letter-spacing: 0.5px; text-transform: uppercase;
            border: 1px solid;
        }
        .problem-status.aangemeld { background: #fdf5f5; color: #d73527; border-color: #f5c6cb; }
        .problem-status.behandeling { background: #f0f4ff; color: #1f4788; border-color: #b3c6ff; }
        .problem-status.uitgezet { background: #fffcf0; color: #b8860b; border-color: #ffe699; }
        .problem-status.opgelost { background: #f5f8f2; color: #2d5016; border-color: #c3e6c3; }
        
        /* Back Button - Editorial */
        .back-btn {
            background: #8b5a3c; color: white; border: none;
            padding: 12px 24px; border-radius: 3px; cursor: pointer;
            font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 8px;
            transition: all 0.2s ease; margin-bottom: 25px;
            font-family: sans-serif; letter-spacing: 0.5px;
        }
        .back-btn:hover { background: #654321; }
        
        /* Loading States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 400px; flex-direction: column; gap: 20px;
        }
        .loading-spinner {
            width: 40px; height: 40px; border: 4px solid #f0f0f0;
            border-top: 4px solid #8b5a3c; border-radius: 50%;
            animation: editorial-spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .detail-view { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 20px 15px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .header-content { flex-direction: column; gap: 15px; }
            .portal-title { font-size: 32px; }
        }
        @keyframes editorial-spin { 
            0% { transform: rotate(0deg); } 
            100% { transform: rotate(360deg); } 
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Editorial Portal wordt geladen...</p>
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

        // Editorial SVG Icons
        const BackIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );

        const EditorialPortal = () => {
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
                    case 'Instemming verleend': return '#2d5016';
                    case 'In behandeling': return '#b8860b';  
                    case 'Aangevraagd': return '#d73527';
                    default: return '#8b5a3c';
                }
            };

            const getWaarschuwingsperiodeColor = (hasWarning) => {
                return hasWarning === 'Ja' ? '#2d5016' : '#d73527';
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
                                `"Een gemeente met ${locations.length} handhavingslocaties, waarvan ${activeProblems} actieve problemen. `,
                                `Ongeveer ${Math.round((resolvedProblems / Math.max(totalProblems, 1)) * 100)}% van alle gemelde problemen is succesvol opgelost."`
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
                                            gap: '10px',
                                            marginBottom: '12px'
                                        }
                                    }, 
                                        h('span', { 
                                            style: { 
                                                width: '10px', 
                                                height: '10px', 
                                                backgroundColor: statusColor, 
                                                borderRadius: '50%'
                                            } 
                                        }),
                                        `Status B&S: ${statusBS}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '15px' } },
                                    h('span', {
                                        style: {
                                            display: 'inline-block',
                                            padding: '5px 12px',
                                            backgroundColor: waarschuwingColor,
                                            color: 'white',
                                            borderRadius: '3px',
                                            fontSize: '12px',
                                            fontWeight: '600',
                                            fontFamily: 'sans-serif',
                                            letterSpacing: '0.5px',
                                            textTransform: 'uppercase'
                                        }
                                    }, 
                                        `Waarschuwingsperiode: ${location.Waarschuwingsperiode || 'Onbekend'}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '12px' } },
                                    h('span', {
                                        style: {
                                            fontSize: '12px',
                                            background: '#f9f9f9',
                                            color: '#8b5a3c',
                                            padding: '3px 8px',
                                            borderRadius: '3px',
                                            fontWeight: '600',
                                            fontFamily: 'sans-serif',
                                            letterSpacing: '0.5px',
                                            textTransform: 'uppercase'
                                        }
                                    }, location.Feitcodegroep)
                                ),
                                location.E_x002d_mailadres_x0020_contactp && h('div', { style: { fontSize: '14px', marginBottom: '12px' } },
                                    h('a', {
                                        href: `mailto:${location.E_x002d_mailadres_x0020_contactp}`,
                                        style: { color: '#8b5a3c', textDecoration: 'none', borderBottom: '1px dotted #8b5a3c' },
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
                                    h('div', { style: { fontSize: '13px', color: '#999', fontStyle: 'italic' } },
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
                                    `"Handhavingslocatie in ${selectedGemeente}, categorie ${selectedPleeglocatie.Feitcodegroep}"`
                                )
                            ),
                            
                            h('div', { className: 'info-section' },
                                h('h3', { className: 'section-title' }, 'Gemelde Problemen'),
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
                                                h('div', { className: 'problem-id' }, `Zaak #${problem.Id}`),
                                                h('div', { className: 'problem-age' }, `${daysSince} dagen geleden`)
                                            ),
                                            h('div', { 
                                                className: 'problem-description',
                                                style: {
                                                    background: '#f9f9f9',
                                                    border: '2px solid #f0f0f0',
                                                    borderLeft: '5px solid #8b5a3c',
                                                    borderRadius: '4px',
                                                    padding: '20px',
                                                    margin: '15px 0',
                                                    fontStyle: 'italic',
                                                    lineHeight: '1.7',
                                                    fontSize: '16px',
                                                    fontFamily: 'Georgia, serif'
                                                }
                                            }, `"${problem.Probleembeschrijving}"`),
                                            h('div', { style: { fontSize: '14px', color: '#666', marginBottom: '15px', fontFamily: 'sans-serif' } },
                                                problem.Startdatum && `Startdatum: ${new Date(problem.Startdatum).toLocaleDateString('nl-NL')}`,
                                                problem.Startdatum && problem.Einddatum && ' | ',
                                                problem.Einddatum && `Einddatum: ${new Date(problem.Einddatum).toLocaleDateString('nl-NL')}`
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
                                            padding: '60px', 
                                            color: '#999',
                                            fontStyle: 'italic',
                                            fontSize: '16px',
                                            fontFamily: 'Georgia, serif'
                                        } 
                                    }, `"Er zijn momenteel geen ${problemFilter === 'active' ? 'actieve' : problemFilter === 'resolved' ? 'opgeloste' : ''} problemen te tonen."`)
                                )
                            )
                        ),
                        
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' }, 'Statistieken'),
                            h('div', { style: { display: 'flex', flexDirection: 'column', gap: '15px' } },
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
                    h('p', null, 'Editorial Portal wordt geladen...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('div', null,
                            h('h1', { className: 'portal-title' }, 'DDH Editorial Portal'),
                            h('p', { className: 'portal-subtitle' }, 'Een uitgebreide kijk op digitale handhaving')
                        ),
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
                                }, '/')
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
        root.render(h(EditorialPortal));
    </script>
</body>
</html>
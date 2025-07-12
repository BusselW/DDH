<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 10: Vibrant Layered</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; 
            background: linear-gradient(135deg, #ff6b6b 0%, #4ecdc4 25%, #45b7d1 50%, #96ceb4 75%, #feca57 100%);
            min-height: 100vh; color: #2c3e50;
        }
        .portal-container {
            max-width: 1600px; margin: 0 auto; padding: 20px; min-height: 100vh;
        }
        
        /* Vibrant Header */
        .portal-header {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(20px);
            border-radius: 24px; padding: 28px; margin-bottom: 28px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            border: 3px solid rgba(255,255,255,0.3);
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .portal-title {
            font-size: 32px; font-weight: 900; margin: 0;
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4, #45b7d1);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            text-shadow: 0 0 30px rgba(255,107,107,0.3);
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 12px; font-size: 16px; 
            color: #34495e; font-weight: 600;
        }
        .breadcrumb-item {
            cursor: pointer; transition: all 0.3s ease; padding: 6px 12px;
            border-radius: 20px; background: rgba(255,255,255,0.7);
        }
        .breadcrumb-item:hover { 
            background: #ff6b6b; color: white; transform: translateY(-2px);
        }
        .breadcrumb-separator { margin: 0 8px; font-size: 18px; }
        
        /* Vibrant Container */
        .layer-container {
            background: rgba(255,255,255,0.9); backdrop-filter: blur(20px);
            border-radius: 24px; padding: 36px; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            border: 3px solid rgba(255,255,255,0.5);
        }
        
        /* Gemeente Grid - Vibrant */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 24px;
        }
        .gemeente-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(255,255,255,0.7));
            border-radius: 20px; padding: 28px; cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 3px solid transparent;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            position: relative; overflow: hidden;
        }
        .gemeente-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4);
            opacity: 0; transition: opacity 0.3s ease; z-index: -1;
        }
        .gemeente-card:hover {
            transform: translateY(-8px) scale(1.02); 
            box-shadow: 0 25px 60px rgba(0,0,0,0.2);
            border-color: #ff6b6b;
        }
        .gemeente-card:hover::before { opacity: 0.1; }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px;
        }
        .gemeente-name {
            font-size: 22px; font-weight: 800; color: #2c3e50; margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4); color: white;
            padding: 8px 16px; border-radius: 25px; font-size: 13px; font-weight: 700;
            box-shadow: 0 4px 15px rgba(255,107,107,0.3);
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
            margin-bottom: 20px;
        }
        .stat-item {
            text-align: center; padding: 16px; 
            background: linear-gradient(135deg, rgba(255,255,255,0.8), rgba(255,255,255,0.6));
            border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 2px solid rgba(255,255,255,0.5);
        }
        .stat-number {
            font-size: 24px; font-weight: 900; color: #2c3e50;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-label {
            font-size: 12px; color: #7f8c8d; text-transform: uppercase; 
            font-weight: 700; letter-spacing: 1px;
        }
        .gemeente-preview {
            font-size: 15px; color: #34495e; line-height: 1.6; font-weight: 500;
        }
        
        /* Pleeglocatie Grid - Vibrant */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .pleeglocatie-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(255,255,255,0.8));
            border-radius: 18px; padding: 24px; cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 12px 35px rgba(0,0,0,0.1);
            border-left: 6px solid #ecf0f1; position: relative;
        }
        .pleeglocatie-card:hover {
            transform: translateY(-6px) scale(1.02); 
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }
        .pleeglocatie-card.has-problems { 
            border-left-color: #e74c3c; 
            background: linear-gradient(135deg, rgba(231,76,60,0.1), rgba(255,255,255,0.9));
        }
        .pleeglocatie-card.all-resolved { 
            border-left-color: #27ae60;
            background: linear-gradient(135deg, rgba(39,174,96,0.1), rgba(255,255,255,0.9));
        }
        
        .pleeglocatie-header { margin-bottom: 16px; }
        .pleeglocatie-name {
            font-size: 18px; font-weight: 700; color: #2c3e50; margin: 0 0 6px 0;
            text-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .pleeglocatie-status { font-size: 14px; color: #7f8c8d; font-weight: 600; }
        
        .problem-summary {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; padding: 12px; 
            background: linear-gradient(135deg, rgba(255,255,255,0.8), rgba(255,255,255,0.6));
            border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .problem-count { font-size: 15px; font-weight: 700; }
        .problem-count.active { color: #e74c3c; }
        .problem-count.resolved { color: #27ae60; }
        
        /* Detail View - Vibrant */
        .detail-view {
            display: grid; grid-template-columns: 1fr 320px; gap: 28px;
        }
        .detail-main {
            background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(255,255,255,0.8));
            border-radius: 20px; padding: 28px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 2px solid rgba(255,255,255,0.5);
        }
        .detail-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(255,255,255,0.8));
            border-radius: 20px; padding: 28px; height: fit-content;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 2px solid rgba(255,255,255,0.5);
        }
        
        .detail-header {
            margin-bottom: 28px; padding-bottom: 20px; 
            border-bottom: 3px solid rgba(255,107,107,0.2);
        }
        .detail-title {
            font-size: 28px; font-weight: 800; color: #2c3e50; margin: 0 0 8px 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .detail-subtitle {
            font-size: 16px; color: #7f8c8d; font-weight: 600;
        }
        
        .info-section { margin-bottom: 28px; }
        .section-title {
            font-size: 18px; font-weight: 700; color: #34495e; margin: 0 0 16px 0;
            display: flex; align-items: center; gap: 10px;
        }
        .info-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
        }
        .info-item {
            padding: 16px; 
            background: linear-gradient(135deg, rgba(255,255,255,0.8), rgba(255,255,255,0.6));
            border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            border: 2px solid rgba(255,255,255,0.5);
        }
        .info-label {
            font-size: 13px; color: #7f8c8d; text-transform: uppercase;
            font-weight: 700; margin-bottom: 6px; letter-spacing: 1px;
        }
        .info-value {
            font-size: 15px; color: #2c3e50; font-weight: 600;
        }
        .info-link {
            color: #3498db; text-decoration: none; font-weight: 600;
        }
        .info-link:hover { text-decoration: underline; color: #2980b9; }
        
        /* Problem Filtering - Vibrant */
        .problem-filters {
            display: flex; gap: 12px; margin-bottom: 20px;
        }
        .filter-btn {
            padding: 12px 20px; border: 3px solid rgba(255,255,255,0.5); 
            background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(255,255,255,0.7));
            border-radius: 25px; cursor: pointer; font-size: 15px; font-weight: 700;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .filter-btn.active { 
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4); color: white; 
            border-color: #ff6b6b; transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255,107,107,0.3);
        }
        .filter-btn:hover:not(.active) { 
            background: linear-gradient(135deg, rgba(255,255,255,1), rgba(255,255,255,0.8));
            transform: translateY(-2px); border-color: #bdc3c7;
        }
        
        .problems-list {
            display: flex; flex-direction: column; gap: 16px;
        }
        .problem-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(255,255,255,0.7));
            border-radius: 16px; padding: 20px; transition: all 0.3s ease;
            border-left: 6px solid #ecf0f1; box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .problem-card:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
        }
        .problem-card.active {
            border-left-color: #e74c3c; 
            background: linear-gradient(135deg, rgba(231,76,60,0.1), rgba(255,255,255,0.9));
        }
        .problem-card.resolved {
            border-left-color: #27ae60; 
            background: linear-gradient(135deg, rgba(39,174,96,0.1), rgba(255,255,255,0.9));
            opacity: 0.85;
        }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 10px;
        }
        .problem-id {
            font-size: 13px; color: #7f8c8d; font-weight: 700;
        }
        .problem-age {
            font-size: 12px; color: #95a5a6;
        }
        .problem-description {
            font-size: 15px; color: #34495e; line-height: 1.5; margin-bottom: 16px;
            font-weight: 500;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: linear-gradient(135deg, #3498db, #2980b9); color: white; 
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;
            box-shadow: 0 4px 15px rgba(52,152,219,0.3);
        }
        .problem-status {
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .problem-status.aangemeld { background: #fadbd8; color: #c0392b; }
        .problem-status.behandeling { background: #d6eaf8; color: #1f618d; }
        .problem-status.uitgezet { background: #fdeaa7; color: #b7950b; }
        .problem-status.opgelost { background: #d5f4e6; color: #196f3d; }
        
        /* Back Button - Vibrant */
        .back-btn {
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4); color: white; border: none;
            padding: 14px 24px; border-radius: 25px; cursor: pointer;
            font-size: 16px; font-weight: 700; display: flex; align-items: center; gap: 10px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            margin-bottom: 24px; box-shadow: 0 8px 25px rgba(255,107,107,0.3);
        }
        .back-btn:hover { 
            transform: translateY(-3px) scale(1.05); 
            box-shadow: 0 12px 35px rgba(255,107,107,0.4);
        }
        
        /* Loading States */
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 350px; flex-direction: column; gap: 20px;
        }
        .loading-spinner {
            width: 50px; height: 50px; border: 5px solid rgba(255,255,255,0.3);
            border-top: 5px solid #ff6b6b; border-radius: 50%;
            animation: vibrant-spin 1s linear infinite;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .detail-view { grid-template-columns: 1fr; }
            .gemeente-grid { grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 16px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .header-content { flex-direction: column; gap: 16px; }
        }
        @keyframes vibrant-spin { 
            0% { transform: rotate(0deg); } 
            100% { transform: rotate(360deg); } 
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Vibrant Portal wordt geladen...</p>
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

        // Vibrant SVG Icons
        const BackIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'currentColor' },
            h('path', { d: 'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z' })
        );

        const VibrantPortal = () => {
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
                    case 'Instemming verleend': return '#27ae60';
                    case 'In behandeling': return '#f39c12';  
                    case 'Aangevraagd': return '#e74c3c';
                    default: return '#95a5a6';
                }
            };

            const getWaarschuwingsperiodeColor = (hasWarning) => {
                return hasWarning === 'Ja' ? '#27ae60' : '#e74c3c';
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
                                            gap: '10px',
                                            marginBottom: '12px'
                                        }
                                    }, 
                                        h('span', { 
                                            style: { 
                                                width: '12px', 
                                                height: '12px', 
                                                backgroundColor: statusColor, 
                                                borderRadius: '50%',
                                                boxShadow: `0 0 10px ${statusColor}50`
                                            } 
                                        }),
                                        `Status B&S: ${statusBS}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '16px' } },
                                    h('div', {
                                        style: {
                                            display: 'inline-flex',
                                            alignItems: 'center',
                                            gap: '8px',
                                            padding: '6px 12px',
                                            backgroundColor: waarschuwingColor,
                                            color: 'white',
                                            borderRadius: '20px',
                                            fontSize: '13px',
                                            fontWeight: '700',
                                            boxShadow: `0 4px 15px ${waarschuwingColor}40`
                                        }
                                    }, 
                                        `Waarschuwingsperiode: ${location.Waarschuwingsperiode || 'Onbekend'}`
                                    )
                                ),
                                h('div', { style: { marginBottom: '12px' } },
                                    h('span', {
                                        style: {
                                            fontSize: '12px',
                                            background: 'linear-gradient(135deg, rgba(255,255,255,0.8), rgba(255,255,255,0.6))',
                                            color: '#7f8c8d',
                                            padding: '4px 8px',
                                            borderRadius: '12px',
                                            fontWeight: '600'
                                        }
                                    }, location.Feitcodegroep)
                                ),
                                location.E_x002d_mailadres_x0020_contactp && h('div', { style: { fontSize: '13px', marginBottom: '12px' } },
                                    h('a', {
                                        href: `mailto:${location.E_x002d_mailadres_x0020_contactp}`,
                                        style: { color: '#3498db', textDecoration: 'none', fontWeight: '600' },
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
                                    h('div', { style: { fontSize: '13px', color: '#95a5a6', fontWeight: '600' } },
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
                                                    background: 'linear-gradient(135deg, rgba(255,255,255,0.9), rgba(255,255,255,0.7))',
                                                    border: '3px solid rgba(255,107,107,0.2)',
                                                    borderRadius: '12px',
                                                    padding: '16px',
                                                    margin: '12px 0',
                                                    fontStyle: 'italic',
                                                    lineHeight: '1.6',
                                                    boxShadow: '0 6px 20px rgba(0,0,0,0.08)'
                                                }
                                            }, problem.Probleembeschrijving),
                                            h('div', { style: { fontSize: '13px', color: '#7f8c8d', marginBottom: '12px', fontWeight: '600' } },
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
                                            padding: '50px', 
                                            color: '#7f8c8d',
                                            fontWeight: '600'
                                        } 
                                    }, `Geen ${problemFilter === 'all' ? '' : problemFilter === 'active' ? 'actieve' : 'opgeloste'} problemen gevonden.`)
                                )
                            )
                        ),
                        
                        h('div', { className: 'detail-sidebar' },
                            h('h3', { className: 'section-title' }, 'Statistieken'),
                            h('div', { style: { display: 'flex', flexDirection: 'column', gap: '12px' } },
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
                    h('p', null, 'Vibrant Portal wordt geladen...')
                );
            }

            return h('div', null,
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('h1', { className: 'portal-title' }, 'DDH Vibrant Portal'),
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
                                }, '→')
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
        root.render(h(VibrantPortal));
    </script>
</body>
</html>
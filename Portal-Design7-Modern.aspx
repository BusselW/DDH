<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 7: Modern Card Layout</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: linear-gradient(135deg, #f0f9ff 0%, #e0e7ff 100%);
            min-height: 100vh; color: #0f172a;
        }
        .portal-container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #0ea5e9 0%, #3b82f6 50%, #8b5cf6 100%);
            color: white; padding: 32px; border-radius: 24px; margin-bottom: 32px;
            position: relative; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .portal-header::before {
            content: ''; position: absolute; top: -50%; left: -50%; right: -50%; bottom: -50%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 8s ease-in-out infinite;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            position: relative; z-index: 1;
        }
        .portal-title {
            font-size: 36px; font-weight: 900; margin: 0 0 8px 0;
            background: linear-gradient(135deg, #ffffff, #f1f5f9);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .portal-subtitle {
            font-size: 18px; opacity: 0.95; margin: 0;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 16px;
        }
        .breadcrumb-item {
            cursor: pointer; transition: all 0.2s ease;
            display: flex; align-items: center; gap: 6px;
            padding: 8px 12px; border-radius: 12px; background: rgba(255,255,255,0.1);
        }
        .breadcrumb-item:hover { background: rgba(255,255,255,0.2); transform: translateY(-1px); }
        .breadcrumb-separator { margin: 0 8px; opacity: 0.7; }
        
        /* Navigation Layers */
        .layer-container {
            background: rgba(255,255,255,0.95); backdrop-filter: blur(20px);
            border-radius: 24px; padding: 40px; box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.5);
        }
        
        /* Gemeente Grid */
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 24px;
        }
        .gemeente-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 20px; padding: 28px; cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 2px solid transparent; position: relative; overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .gemeente-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.05) 0%, rgba(139, 92, 246, 0.05) 100%);
            opacity: 0; transition: opacity 0.3s ease;
        }
        .gemeente-card:hover {
            transform: translateY(-8px) scale(1.02); 
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            border-color: #3b82f6;
        }
        .gemeente-card:hover::before { opacity: 1; }
        .gemeente-card.has-problems {
            border-color: #ef4444;
        }
        .gemeente-card.has-problems::before {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.05) 0%, rgba(251, 113, 133, 0.05) 100%);
        }
        
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 20px; position: relative; z-index: 1;
        }
        .gemeente-name {
            font-size: 24px; font-weight: 800; color: #0f172a; margin: 0;
            text-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white; padding: 8px 16px; border-radius: 16px; 
            font-size: 13px; font-weight: 700; display: flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
            margin-bottom: 20px; position: relative; z-index: 1;
        }
        .stat-item {
            text-align: center; padding: 16px; background: rgba(248, 250, 252, 0.8);
            border-radius: 12px; backdrop-filter: blur(10px);
        }
        .stat-number {
            font-size: 20px; font-weight: 800; color: #0f172a; margin-bottom: 4px;
        }
        .stat-label {
            font-size: 11px; color: #64748b; text-transform: uppercase; 
            font-weight: 700; letter-spacing: 0.5px;
        }
        .gemeente-preview {
            font-size: 15px; color: #64748b; line-height: 1.6; position: relative; z-index: 1;
        }
        
        /* Pleeglocatie Grid */
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .pleeglocatie-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 16px; padding: 24px; cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 5px solid #e2e8f0; position: relative; overflow: hidden;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
        }
        .pleeglocatie-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.12);
        }
        .pleeglocatie-card.has-problems {
            border-left-color: #ef4444;
        }
        .pleeglocatie-card::before {
            content: ''; position: absolute; top: 0; right: 0; bottom: 0; left: 0;
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.02) 0%, rgba(139, 92, 246, 0.02) 100%);
            opacity: 0; transition: opacity 0.3s ease;
        }
        .pleeglocatie-card:hover::before { opacity: 1; }
        
        .locatie-header {
            margin-bottom: 16px; position: relative; z-index: 1;
        }
        .locatie-name {
            font-size: 18px; font-weight: 700; color: #0f172a; margin-bottom: 10px;
        }
        .locatie-badges {
            display: flex; gap: 8px; flex-wrap: wrap;
        }
        .badge {
            padding: 6px 12px; border-radius: 14px; font-size: 12px; font-weight: 700;
            display: flex; align-items: center; gap: 4px;
        }
        .badge.problems { 
            background: linear-gradient(135deg, #fef2f2, #fee2e2); 
            color: #dc2626; border: 1px solid #fecaca;
        }
        .badge.resolved { 
            background: linear-gradient(135deg, #f0fdf4, #dcfce7); 
            color: #16a34a; border: 1px solid #bbf7d0;
        }
        .locatie-meta {
            font-size: 14px; color: #64748b; line-height: 1.6; position: relative; z-index: 1;
        }
        
        /* Detail View */
        .detail-view {
            max-width: 1400px;
        }
        .detail-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 32px; padding-bottom: 24px; 
            border-bottom: 3px solid #f1f5f9;
        }
        .detail-title {
            font-size: 32px; font-weight: 900; color: #0f172a; margin: 0 0 6px 0;
            text-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .detail-subtitle {
            font-size: 18px; color: #64748b; margin: 0;
        }
        .filter-buttons {
            display: flex; gap: 12px;
        }
        .filter-btn {
            padding: 12px 20px; border: 2px solid #e2e8f0; 
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            border-radius: 12px; font-size: 15px; cursor: pointer; font-weight: 600;
            transition: all 0.3s ease; display: flex; align-items: center; gap: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .filter-btn.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white; border-color: #3b82f6;
            box-shadow: 0 4px 16px rgba(59, 130, 246, 0.3);
        }
        .filter-btn:hover:not(.active) { 
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            transform: translateY(-1px);
        }
        
        .detail-stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px; margin-bottom: 36px;
        }
        .stat-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 16px; padding: 24px; border-left: 5px solid #e2e8f0;
            display: flex; align-items: center; gap: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.1); }
        .stat-card.active { border-left-color: #ef4444; }
        .stat-card.resolved { border-left-color: #10b981; }
        .stat-icon {
            padding: 16px; border-radius: 16px; 
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        }
        .stat-content .stat-number {
            font-size: 28px; font-weight: 900; color: #0f172a; margin-bottom: 4px;
        }
        .stat-content .stat-label {
            font-size: 13px; color: #64748b; font-weight: 600;
        }
        
        .detail-sections {
            display: grid; grid-template-columns: 1fr 1fr; gap: 28px; margin-bottom: 36px;
        }
        .detail-section {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 16px; padding: 24px;
        }
        .section-title {
            font-size: 18px; font-weight: 700; color: #0f172a; margin: 0 0 20px 0;
            display: flex; align-items: center; gap: 10px;
        }
        .links-grid {
            display: flex; flex-direction: column; gap: 12px;
        }
        .link-card {
            display: flex; align-items: center; gap: 12px; padding: 16px;
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            border-radius: 12px; text-decoration: none;
            color: #374151; font-size: 15px; font-weight: 600;
            transition: all 0.3s ease; border: 1px solid #e5e7eb;
        }
        .link-card:hover {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white; transform: translateY(-1px);
            box-shadow: 0 4px 16px rgba(59, 130, 246, 0.3);
        }
        .contact-info {
            font-size: 15px; color: #374151; line-height: 1.8;
        }
        
        .problems-section {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 16px; padding: 28px;
        }
        .problems-list {
            display: grid; gap: 16px;
        }
        .problem-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 16px; padding: 20px; border-left: 5px solid #e2e8f0;
            transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .problem-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.1); }
        .problem-card.active { border-left-color: #ef4444; }
        .problem-card.resolved { border-left-color: #10b981; opacity: 0.9; }
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 12px;
        }
        .problem-id {
            font-size: 13px; color: #64748b; font-weight: 700;
        }
        .problem-age {
            font-size: 12px; color: #9ca3af; display: flex; align-items: center; gap: 4px;
        }
        .problem-description {
            font-size: 15px; color: #374151; line-height: 1.6; margin-bottom: 16px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white; padding: 6px 12px; border-radius: 14px; 
            font-size: 11px; font-weight: 700;
        }
        .problem-status {
            padding: 6px 12px; border-radius: 14px; font-size: 11px; font-weight: 700;
        }
        .problem-status.aangemeld { background: #fef2f2; color: #dc2626; }
        .problem-status.behandeling { background: #eff6ff; color: #2563eb; }
        .problem-status.uitgezet { background: #fffbeb; color: #d97706; }
        .problem-status.opgelost { background: #f0fdf4; color: #16a34a; }
        .empty-state {
            text-align: center; padding: 60px; color: #64748b;
        }
        
        /* Animations */
        @keyframes float {
            0%, 100% { transform: rotate(0deg); }
            50% { transform: rotate(180deg); }
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .gemeente-grid { grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); }
            .detail-sections { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 16px; }
            .header-content { flex-direction: column; gap: 20px; text-align: center; }
            .gemeente-card, .pleeglocatie-card { padding: 20px; }
            .gemeente-stats { grid-template-columns: repeat(2, 1fr); }
            .detail-stats { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 60px; height: 60px; border: 5px solid #f3f4f6; border-top: 5px solid #3b82f6; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 24px;"></div>
                <p style="font-size: 18px; color: #64748b;">Modern Portal wordt geladen...</p>
            </div>
        </div>
    </div>

    <!-- React -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        const { createElement: h, useState, useEffect, useMemo } = window.React;
        const { createRoot } = window.ReactDOM;

        // Import configuration, navigation and SVG icons
        const { DDH_CONFIG } = await import('./js/config/index.js');
        const { TEMP_PLACEHOLDER_DATA } = await import('./js/components/pageNavigation.js');
        const FooterNavigation = (await import('./js/components/FooterNavigation.js')).default;
        const SvgIcons = await import('./js/components/svgIcons.js');
        const { 
            HomeIcon, LocationIcon, BuildingIcon, CityIcon, CheckIcon, WarningIcon,
            AlertIcon, SearchIcon, FilterIcon, ProblemIcon, ActiveProblemIcon,
            ResolvedIcon, DocumentIcon, LinkIcon, ContactIcon, BackIcon, TimeIcon
        } = SvgIcons;

        const ModernPortal = () => {
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

            // Breadcrumb navigation
            const renderBreadcrumbs = () => {
                return h('div', { className: 'breadcrumb' },
                    h('span', {
                        className: 'breadcrumb-item',
                        onClick: () => {
                            setCurrentLayer('gemeente');
                            setSelectedGemeente(null);
                            setSelectedPleeglocatie(null);
                        }
                    }, h(HomeIcon, { size: 16 }), ' Home'),
                    currentLayer !== 'gemeente' && h('span', { className: 'breadcrumb-separator' }, ' › '),
                    currentLayer !== 'gemeente' && h('span', {
                        className: 'breadcrumb-item',
                        onClick: () => {
                            setCurrentLayer('pleeglocatie');
                            setSelectedPleeglocatie(null);
                        }
                    }, selectedGemeente),
                    currentLayer === 'detail' && h('span', { className: 'breadcrumb-separator' }, ' › '),
                    currentLayer === 'detail' && h('span', { className: 'breadcrumb-item' }, selectedPleeglocatie?.Title)
                );
            };

            // Gemeente layer
            const renderGemeenteLayer = () => {
                const gemeenteData = useMemo(() => {
                    const grouped = {};
                    data.forEach(location => {
                        const gemeente = location.Gemeente;
                        if (!grouped[gemeente]) {
                            grouped[gemeente] = {
                                name: gemeente,
                                locations: [],
                                totalProblems: 0,
                                activeProblems: 0,
                                resolvedProblems: 0
                            };
                        }
                        grouped[gemeente].locations.push(location);
                        const problems = location.problemen || [];
                        grouped[gemeente].totalProblems += problems.length;
                        grouped[gemeente].activeProblems += problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                        grouped[gemeente].resolvedProblems += problems.filter(p => p.Opgelost_x003f_ === 'Opgelost').length;
                    });
                    return Object.values(grouped);
                }, [data]);

                return h('div', { className: 'gemeente-grid' },
                    gemeenteData.map(gemeente => {
                        return h('div', {
                            key: gemeente.name,
                            className: `gemeente-card ${gemeente.activeProblems > 0 ? 'has-problems' : ''}`,
                            onClick: () => {
                                setSelectedGemeente(gemeente.name);
                                setCurrentLayer('pleeglocatie');
                            }
                        },
                            h('div', { className: 'gemeente-header' },
                                h('h3', { className: 'gemeente-name' }, gemeente.name),
                                h('div', { className: 'gemeente-badge' }, 
                                    h(BuildingIcon, { size: 16 }), ` ${gemeente.locations.length} locaties`
                                )
                            ),
                            h('div', { className: 'gemeente-stats' },
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, gemeente.totalProblems),
                                    h('div', { className: 'stat-label' }, 'Totaal')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, gemeente.activeProblems),
                                    h('div', { className: 'stat-label' }, 'Actief')
                                ),
                                h('div', { className: 'stat-item' },
                                    h('div', { className: 'stat-number' }, gemeente.resolvedProblems),
                                    h('div', { className: 'stat-label' }, 'Opgelost')
                                )
                            ),
                            h('div', { className: 'gemeente-preview' },
                                `${gemeente.locations.length} handhavingslocaties met een totaal van ${gemeente.totalProblems} geregistreerde problemen. ${gemeente.activeProblems > 0 ? `${gemeente.activeProblems} problemen vereisen nog aandacht.` : 'Alle problemen zijn opgelost.'}`
                            )
                        );
                    })
                );
            };

            // Pleeglocatie layer
            const renderPleeglocatieLayer = () => {
                const locations = data.filter(loc => loc.Gemeente === selectedGemeente);
                
                return h('div', { className: 'pleeglocatie-grid' },
                    locations.map(location => {
                        const problems = location.problemen || [];
                        const activeProblems = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                        const resolvedProblems = problems.filter(p => p.Opgelost_x003f_ === 'Opgelost').length;
                        
                        return h('div', {
                            key: location.Id,
                            className: `pleeglocatie-card ${activeProblems > 0 ? 'has-problems' : ''}`,
                            onClick: () => {
                                setSelectedPleeglocatie(location);
                                setCurrentLayer('detail');
                            }
                        },
                            h('div', { className: 'locatie-header' },
                                h('div', { className: 'locatie-name' }, location.Title),
                                h('div', { className: 'locatie-badges' },
                                    activeProblems > 0 && h('span', { className: 'badge problems' }, 
                                        h(WarningIcon, { size: 12 }), ` ${activeProblems} actief`
                                    ),
                                    resolvedProblems > 0 && h('span', { className: 'badge resolved' }, 
                                        h(CheckIcon, { size: 12 }), ` ${resolvedProblems} opgelost`
                                    )
                                )
                            ),
                            h('div', { className: 'locatie-meta' },
                                h('p', null, `Status B&S: ${location.Status_x0020_B_x0026_S || 'Onbekend'}`),
                                h('p', null, `Feitcodegroep: ${location.Feitcodegroep}`),
                                h('p', null, `Totaal ${problems.length} problemen geregistreerd`)
                            )
                        );
                    })
                );
            };

            // Detail layer
            const renderDetailLayer = () => {
                if (!selectedPleeglocatie) return null;
                
                const problems = selectedPleeglocatie.problemen || [];
                const filteredProblems = problems.filter(problem => {
                    if (problemFilter === 'active') return problem.Opgelost_x003f_ !== 'Opgelost';
                    if (problemFilter === 'resolved') return problem.Opgelost_x003f_ === 'Opgelost';
                    return true;
                });
                
                return h('div', { className: 'detail-view' },
                    // Location info header
                    h('div', { className: 'detail-header' },
                        h('div', { className: 'detail-title-section' },
                            h('h2', { className: 'detail-title' }, selectedPleeglocatie.Title),
                            h('p', { className: 'detail-subtitle' }, `${selectedPleeglocatie.Gemeente} • Handhavingslocatie`)
                        ),
                        h('div', { className: 'filter-buttons' },
                            h('button', {
                                className: `filter-btn ${problemFilter === 'all' ? 'active' : ''}`,
                                onClick: () => setProblemFilter('all')
                            }, 'Alle'),
                            h('button', {
                                className: `filter-btn ${problemFilter === 'active' ? 'active' : ''}`,
                                onClick: () => setProblemFilter('active')
                            }, h(AlertIcon, { size: 14 }), ' Actief'),
                            h('button', {
                                className: `filter-btn ${problemFilter === 'resolved' ? 'active' : ''}`,
                                onClick: () => setProblemFilter('resolved')
                            }, h(CheckIcon, { size: 14 }), ' Opgelost')
                        )
                    ),
                    
                    // Statistics cards
                    h('div', { className: 'detail-stats' },
                        h('div', { className: 'stat-card' },
                            h('div', { className: 'stat-icon' }, h(ProblemIcon, { size: 24 })),
                            h('div', { className: 'stat-content' },
                                h('div', { className: 'stat-number' }, problems.length),
                                h('div', { className: 'stat-label' }, 'Totaal Problemen')
                            )
                        ),
                        h('div', { className: 'stat-card active' },
                            h('div', { className: 'stat-icon' }, h(ActiveProblemIcon, { size: 24 })),
                            h('div', { className: 'stat-content' },
                                h('div', { className: 'stat-number' }, problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length),
                                h('div', { className: 'stat-label' }, 'Actieve Problemen')
                            )
                        ),
                        h('div', { className: 'stat-card resolved' },
                            h('div', { className: 'stat-icon' }, h(ResolvedIcon, { size: 24 })),
                            h('div', { className: 'stat-content' },
                                h('div', { className: 'stat-number' }, problems.filter(p => p.Opgelost_x003f_ === 'Opgelost').length),
                                h('div', { className: 'stat-label' }, 'Opgeloste Problemen')
                            )
                        )
                    ),
                    
                    // Location details and links
                    h('div', { className: 'detail-sections' },
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, h(DocumentIcon, { size: 18 }), ' Documenten & Links'),
                            h('div', { className: 'links-grid' },
                                h('a', { 
                                    href: '#',
                                    className: 'link-card',
                                    onClick: (e) => e.preventDefault()
                                },
                                    h(DocumentIcon, { size: 16 }),
                                    h('span', null, 'Schouwrapporten')
                                ),
                                h('a', { 
                                    href: '#',
                                    className: 'link-card',
                                    onClick: (e) => e.preventDefault()
                                },
                                    h(LinkIcon, { size: 16 }),
                                    h('span', null, 'Algemeen PV')
                                )
                            )
                        ),
                        h('div', { className: 'detail-section' },
                            h('h3', { className: 'section-title' }, h(ContactIcon, { size: 18 }), ' Contactgegevens'),
                            h('div', { className: 'contact-info' },
                                h('p', null, `Gemeente: ${selectedPleeglocatie.Gemeente}`),
                                h('p', null, `Status B&S: ${selectedPleeglocatie.Status_x0020_B_x0026_S || 'Niet beschikbaar'}`),
                                h('p', null, `Feitcodegroep: ${selectedPleeglocatie.Feitcodegroep}`)
                            )
                        )
                    ),
                    
                    // Problems list
                    h('div', { className: 'problems-section' },
                        h('h3', { className: 'section-title' }, 
                            h(ProblemIcon, { size: 18 }), 
                            ` Problemen (${filteredProblems.length})`
                        ),
                        filteredProblems.length === 0 ? 
                            h('div', { className: 'empty-state' }, 
                                h('p', null, 'Geen problemen gevonden voor deze filter.')
                            ) :
                            h('div', { className: 'problems-list' },
                                filteredProblems.map(problem => {
                                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                                    const isResolved = problem.Opgelost_x003f_ === 'Opgelost';
                                    
                                    return h('div', {
                                        key: problem.Id,
                                        className: `problem-card ${isResolved ? 'resolved' : 'active'}`
                                    },
                                        h('div', { className: 'problem-header' },
                                            h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                            h('div', { className: 'problem-age' }, 
                                                h(TimeIcon, { size: 12 }), ` ${daysSince} dagen geleden`
                                            )
                                        ),
                                        h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                        h('div', { className: 'problem-footer' },
                                            h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                            h('div', {
                                                className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                            }, problem.Opgelost_x003f_ || 'Onbekend')
                                        )
                                    );
                                })
                            )
                    )
                );
            };

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '60px', height: '60px', border: '5px solid #f3f4f6', 
                            borderTop: '5px solid #3b82f6', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 24px'
                        } }),
                        h('p', { style: { fontSize: '18px', color: '#64748b' } }, 'Modern Portal wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('div', null,
                            h('h1', { className: 'portal-title' }, 'DDH Modern Portal'),
                            h('p', { className: 'portal-subtitle' }, 'Intuïtieve handhavingsdata navigatie met moderne interface')
                        ),
                        renderBreadcrumbs()
                    )
                ),

                // Layer Navigation Container
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
        root.render(h(ModernPortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
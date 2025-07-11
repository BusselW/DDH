<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 5: Analytics & Metrics)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0 0 60px 0; background: #f8fafc; color: #2d3748;
        }
        .analytics-container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .analytics-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 28px; border-radius: 16px; margin-bottom: 24px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.25);
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
        }
        .header-left h1 {
            margin: 0 0 8px 0; font-size: 32px; font-weight: 800;
        }
        .header-left p {
            margin: 0; opacity: 0.9; font-size: 16px;
        }
        .header-right {
            display: flex; gap: 16px; align-items: center;
        }
        .time-selector {
            background: rgba(255,255,255,0.15); border: 2px solid rgba(255,255,255,0.3);
            color: white; padding: 12px 20px; border-radius: 12px; font-size: 14px;
            cursor: pointer; backdrop-filter: blur(10px);
        }
        .export-btn {
            background: #48bb78; border: none; color: white;
            padding: 12px 24px; border-radius: 12px; cursor: pointer;
            font-size: 14px; font-weight: 600; transition: all 0.2s ease;
        }
        .export-btn:hover { background: #38a169; transform: translateY(-1px); }
        
        /* Metrics Grid */
        .metrics-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px; margin-bottom: 32px;
        }
        .metric-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); position: relative;
            overflow: hidden; transition: all 0.3s ease;
        }
        .metric-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }
        .metric-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 4px; background: linear-gradient(90deg, #667eea, #764ba2);
        }
        .metric-card.danger::before { background: linear-gradient(90deg, #f56565, #e53e3e); }
        .metric-card.warning::before { background: linear-gradient(90deg, #ed8936, #dd6b20); }
        .metric-card.success::before { background: linear-gradient(90deg, #48bb78, #38a169); }
        .metric-card.info::before { background: linear-gradient(90deg, #4299e1, #3182ce); }
        
        .metric-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 16px;
        }
        .metric-icon {
            width: 48px; height: 48px; border-radius: 12px; display: flex;
            align-items: center; justify-content: center; font-size: 20px;
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
        }
        .metric-trend {
            font-size: 12px; padding: 4px 8px; border-radius: 12px;
            font-weight: 600;
        }
        .trend-up { background: #fed7d7; color: #c53030; }
        .trend-down { background: #c6f6d5; color: #2f855a; }
        .trend-stable { background: #bee3f8; color: #2b6cb0; }
        
        .metric-value {
            font-size: 36px; font-weight: 800; color: #2d3748;
            margin-bottom: 4px; line-height: 1;
        }
        .metric-label {
            font-size: 14px; color: #718096; font-weight: 500;
            margin-bottom: 12px;
        }
        .metric-details {
            font-size: 12px; color: #a0aec0; line-height: 1.4;
        }
        
        /* Charts Section */
        .charts-section {
            display: grid; grid-template-columns: 2fr 1fr; gap: 24px;
            margin-bottom: 32px;
        }
        .chart-container {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .chart-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px;
        }
        .chart-title {
            font-size: 18px; font-weight: 600; color: #2d3748;
        }
        .chart-controls {
            display: flex; gap: 8px;
        }
        .chart-btn {
            padding: 6px 12px; border: 1px solid #e2e8f0; background: white;
            border-radius: 6px; font-size: 12px; cursor: pointer;
            transition: all 0.2s ease;
        }
        .chart-btn.active { background: #667eea; color: white; border-color: #667eea; }
        
        .chart-placeholder {
            height: 300px; background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            color: #a0aec0; font-size: 14px; flex-direction: column; gap: 8px;
        }
        .chart-icon {
            font-size: 32px; opacity: 0.6;
        }
        
        /* Status Distribution */
        .status-distribution {
            display: flex; flex-direction: column; gap: 12px;
        }
        .status-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px; background: #f7fafc; border-radius: 8px;
        }
        .status-left {
            display: flex; align-items: center; gap: 12px;
        }
        .status-indicator {
            width: 12px; height: 12px; border-radius: 50%;
        }
        .status-aangemeld .status-indicator { background: #f56565; }
        .status-behandeling .status-indicator { background: #4299e1; }
        .status-uitgezet .status-indicator { background: #48bb78; }
        .status-opgelost .status-indicator { background: #a0aec0; }
        .status-name {
            font-size: 14px; font-weight: 500; color: #2d3748;
        }
        .status-count {
            font-size: 16px; font-weight: 700; color: #2d3748;
        }
        .status-percentage {
            font-size: 12px; color: #718096; margin-left: 8px;
        }
        
        /* Performance Table */
        .performance-section {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 24px;
        }
        .performance-header {
            display: flex; justify-content: between; align-items: center;
            margin-bottom: 20px;
        }
        .performance-title {
            font-size: 20px; font-weight: 600; color: #2d3748;
        }
        .performance-filters {
            display: flex; gap: 12px;
        }
        .filter-select {
            padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 8px;
            font-size: 14px; background: white; cursor: pointer;
        }
        
        .performance-table {
            width: 100%; border-collapse: collapse;
        }
        .performance-table th {
            background: #f7fafc; padding: 12px; text-align: left;
            font-size: 12px; font-weight: 600; color: #718096;
            text-transform: uppercase; border-bottom: 1px solid #e2e8f0;
        }
        .performance-table td {
            padding: 16px 12px; border-bottom: 1px solid #f1f5f9;
        }
        .performance-table tr:hover {
            background: #f7fafc;
        }
        .location-name {
            font-weight: 600; color: #2d3748;
        }
        .gemeente-name {
            font-size: 12px; color: #718096;
        }
        .metric-cell {
            text-align: center; font-weight: 600;
        }
        .score-excellent { color: #38a169; }
        .score-good { color: #48bb78; }
        .score-average { color: #ed8936; }
        .score-poor { color: #e53e3e; }
        
        /* Insights Panel */
        .insights-panel {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .insights-header {
            display: flex; align-items: center; gap: 12px; margin-bottom: 20px;
        }
        .insights-title {
            font-size: 18px; font-weight: 600; color: #2d3748;
        }
        .insights-list {
            display: flex; flex-direction: column; gap: 16px;
        }
        .insight-item {
            display: flex; gap: 12px; padding: 16px; background: #f7fafc;
            border-radius: 12px; border-left: 4px solid #667eea;
        }
        .insight-item.warning { border-left-color: #ed8936; }
        .insight-item.danger { border-left-color: #e53e3e; }
        .insight-item.success { border-left-color: #48bb78; }
        .insight-icon {
            font-size: 16px; margin-top: 2px;
        }
        .insight-content {
            flex: 1;
        }
        .insight-title {
            font-size: 14px; font-weight: 600; color: #2d3748; margin-bottom: 4px;
        }
        .insight-description {
            font-size: 12px; color: #718096; line-height: 1.4;
        }
        
        @media (max-width: 1200px) {
            .charts-section { grid-template-columns: 1fr; }
            .metrics-grid { grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); }
        }
        
        @media (max-width: 768px) {
            .header-content { flex-direction: column; gap: 16px; text-align: center; }
            .header-right { width: 100%; justify-content: center; }
            .metrics-grid { grid-template-columns: 1fr; }
            .performance-table { font-size: 12px; }
            .performance-table th,
            .performance-table td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="analytics-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Analytics Dashboard wordt geladen...</p>
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

        const AnalyticsDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [timeRange, setTimeRange] = useState('30d');

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

            const analytics = useMemo(() => {
                const allProblems = [];
                data.forEach(location => {
                    (location.problemen || []).forEach(problem => {
                        allProblems.push({
                            ...problem,
                            locationTitle: location.Title,
                            gemeente: location.Gemeente,
                            daysSince: Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24))
                        });
                    });
                });

                const totalProblems = allProblems.length;
                const activeProblems = allProblems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                const resolvedProblems = totalProblems - activeProblems;
                const avgResolutionTime = totalProblems > 0 ? 
                    Math.round(allProblems.reduce((sum, p) => sum + p.daysSince, 0) / totalProblems) : 0;
                
                const statusCounts = allProblems.reduce((acc, problem) => {
                    const status = problem.Opgelost_x003f_ || 'Aangemeld';
                    acc[status] = (acc[status] || 0) + 1;
                    return acc;
                }, {});

                const locationPerformance = data.map(location => {
                    const problems = location.problemen || [];
                    const active = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    const total = problems.length;
                    const avgAge = total > 0 ? 
                        Math.round(problems.reduce((sum, p) => sum + Math.floor((new Date() - new Date(p.Aanmaakdatum)) / (1000 * 60 * 60 * 24)), 0) / total) : 0;
                    const resolutionRate = total > 0 ? Math.round(((total - active) / total) * 100) : 100;

                    let score = 'excellent';
                    if (resolutionRate < 50 || avgAge > 45) score = 'poor';
                    else if (resolutionRate < 70 || avgAge > 30) score = 'average';
                    else if (resolutionRate < 85 || avgAge > 15) score = 'good';

                    return {
                        ...location,
                        totalProblems: total,
                        activeProblems: active,
                        resolutionRate,
                        avgAge,
                        score
                    };
                }).sort((a, b) => b.totalProblems - a.totalProblems);

                return {
                    totalProblems,
                    activeProblems,
                    resolvedProblems,
                    resolutionRate: totalProblems > 0 ? Math.round((resolvedProblems / totalProblems) * 100) : 0,
                    avgResolutionTime,
                    statusCounts,
                    locationPerformance,
                    allProblems
                };
            }, [data]);

            const insights = useMemo(() => {
                const insights = [];
                
                if (analytics.resolutionRate < 60) {
                    insights.push({
                        type: 'danger',
                        icon: '⚠️',
                        title: 'Lage Oplossingsratio',
                        description: `Slechts ${analytics.resolutionRate}% van problemen is opgelost. Focus op snellere afhandeling.`
                    });
                }
                
                if (analytics.avgResolutionTime > 30) {
                    insights.push({
                        type: 'warning',
                        icon: '⏰',
                        title: 'Lange Doorlooptijd',
                        description: `Gemiddelde oplossingstijd is ${analytics.avgResolutionTime} dagen. Streef naar minder dan 21 dagen.`
                    });
                }

                const topProblematic = analytics.locationPerformance.filter(l => l.score === 'poor').length;
                if (topProblematic > 0) {
                    insights.push({
                        type: 'warning',
                        icon: '🏢',
                        title: 'Problematische Locaties',
                        description: `${topProblematic} locaties hebben slechte prestaties en hebben extra aandacht nodig.`
                    });
                }

                if (analytics.activeProblems > analytics.resolvedProblems) {
                    insights.push({
                        type: 'danger',
                        icon: '📈',
                        title: 'Stijgende Werkvoorraad',
                        description: 'Meer actieve problemen dan opgeloste. Verhoog de verwerkingscapaciteit.'
                    });
                }

                if (insights.length === 0) {
                    insights.push({
                        type: 'success',
                        icon: '✅',
                        title: 'Uitstekende Prestaties',
                        description: 'Alle KPI\'s zijn binnen acceptabele grenzen. Blijf de goede prestaties volhouden.'
                    });
                }

                return insights;
            }, [analytics]);

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #667eea', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Analytics Dashboard wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'analytics-header' },
                    h('div', { className: 'header-content' },
                        h('div', { className: 'header-left' },
                            h('h1', null, 'Analytics & Metrics Dashboard'),
                            h('p', null, 'Uitgebreide prestatie-analyse en KPI monitoring')
                        ),
                        h('div', { className: 'header-right' },
                            h('select', {
                                className: 'time-selector',
                                value: timeRange,
                                onChange: (e) => setTimeRange(e.target.value)
                            },
                                h('option', { value: '7d' }, 'Laatste 7 dagen'),
                                h('option', { value: '30d' }, 'Laatste 30 dagen'),
                                h('option', { value: '90d' }, 'Laatste 90 dagen'),
                                h('option', { value: 'year' }, 'Dit jaar')
                            ),
                            h('button', { className: 'export-btn' }, '📊 Exporteer Rapport')
                        )
                    )
                ),

                // Metrics Grid
                h('div', { className: 'metrics-grid' },
                    h('div', { className: 'metric-card' },
                        h('div', { className: 'metric-header' },
                            h('div', { className: 'metric-icon' }, '📊'),
                            h('div', { className: 'metric-trend trend-stable' }, 'Stabiel')
                        ),
                        h('div', { className: 'metric-value' }, analytics.totalProblems),
                        h('div', { className: 'metric-label' }, 'Totaal Problemen'),
                        h('div', { className: 'metric-details' }, 'Alle geregistreerde problemen sinds begin')
                    ),
                    h('div', { className: 'metric-card warning' },
                        h('div', { className: 'metric-header' },
                            h('div', { className: 'metric-icon' }, '🔥'),
                            h('div', { className: 'metric-trend trend-up' }, '+15%')
                        ),
                        h('div', { className: 'metric-value' }, analytics.activeProblems),
                        h('div', { className: 'metric-label' }, 'Actieve Problemen'),
                        h('div', { className: 'metric-details' }, 'Vereisen nog actie of behandeling')
                    ),
                    h('div', { className: 'metric-card success' },
                        h('div', { className: 'metric-header' },
                            h('div', { className: 'metric-icon' }, '✅'),
                            h('div', { className: 'metric-trend trend-down' }, '-8%')
                        ),
                        h('div', { className: 'metric-value' }, `${analytics.resolutionRate}%`),
                        h('div', { className: 'metric-label' }, 'Oplossingsratio'),
                        h('div', { className: 'metric-details' }, 'Percentage succesvol opgeloste problemen')
                    ),
                    h('div', { className: 'metric-card info' },
                        h('div', { className: 'metric-header' },
                            h('div', { className: 'metric-icon' }, '⏱️'),
                            h('div', { className: 'metric-trend trend-stable' }, 'Gemiddeld')
                        ),
                        h('div', { className: 'metric-value' }, `${analytics.avgResolutionTime}d`),
                        h('div', { className: 'metric-label' }, 'Gem. Oplossingstijd'),
                        h('div', { className: 'metric-details' }, 'Doorlooptijd van melding tot oplossing')
                    )
                ),

                // Charts Section
                h('div', { className: 'charts-section' },
                    h('div', { className: 'chart-container' },
                        h('div', { className: 'chart-header' },
                            h('div', { className: 'chart-title' }, 'Probleem Trends Over Tijd'),
                            h('div', { className: 'chart-controls' },
                                h('button', { className: 'chart-btn active' }, 'Week'),
                                h('button', { className: 'chart-btn' }, 'Maand'),
                                h('button', { className: 'chart-btn' }, 'Kwartaal')
                            )
                        ),
                        h('div', { className: 'chart-placeholder' },
                            h('div', { className: 'chart-icon' }, '📈'),
                            h('div', null, 'Interactieve grafiek wordt hier weergegeven'),
                            h('small', null, 'Toont trends van nieuwe vs opgeloste problemen')
                        )
                    ),
                    h('div', { className: 'chart-container' },
                        h('div', { className: 'chart-header' },
                            h('div', { className: 'chart-title' }, 'Status Verdeling')
                        ),
                        h('div', { className: 'status-distribution' },
                            Object.entries(analytics.statusCounts).map(([status, count]) => {
                                const percentage = Math.round((count / analytics.totalProblems) * 100);
                                return h('div', {
                                    key: status,
                                    className: `status-item status-${status.toLowerCase().replace(/\s+/g, '-')}`
                                },
                                    h('div', { className: 'status-left' },
                                        h('div', { className: 'status-indicator' }),
                                        h('div', { className: 'status-name' }, status)
                                    ),
                                    h('div', null,
                                        h('span', { className: 'status-count' }, count),
                                        h('span', { className: 'status-percentage' }, `${percentage}%`)
                                    )
                                );
                            })
                        )
                    )
                ),

                // Performance Table
                h('div', { className: 'performance-section' },
                    h('div', { className: 'performance-header' },
                        h('h2', { className: 'performance-title' }, 'Locatie Prestaties'),
                        h('div', { className: 'performance-filters' },
                            h('select', { className: 'filter-select' },
                                h('option', null, 'Alle gemeenten'),
                                h('option', null, 'Alleen slechte prestaties'),
                                h('option', null, 'Top performers')
                            )
                        )
                    ),
                    h('table', { className: 'performance-table' },
                        h('thead', null,
                            h('tr', null,
                                h('th', null, 'Locatie'),
                                h('th', null, 'Totaal'),
                                h('th', null, 'Actief'),
                                h('th', null, 'Oplossingsratio'),
                                h('th', null, 'Gem. Leeftijd'),
                                h('th', null, 'Score')
                            )
                        ),
                        h('tbody', null,
                            analytics.locationPerformance.slice(0, 10).map(location =>
                                h('tr', { key: location.Id },
                                    h('td', null,
                                        h('div', { className: 'location-name' }, location.Title),
                                        h('div', { className: 'gemeente-name' }, location.Gemeente)
                                    ),
                                    h('td', { className: 'metric-cell' }, location.totalProblems),
                                    h('td', { className: 'metric-cell' }, location.activeProblems),
                                    h('td', { className: 'metric-cell' }, `${location.resolutionRate}%`),
                                    h('td', { className: 'metric-cell' }, `${location.avgAge}d`),
                                    h('td', { className: `metric-cell score-${location.score}` },
                                        location.score === 'excellent' ? '🌟' :
                                        location.score === 'good' ? '👍' :
                                        location.score === 'average' ? '📊' : '⚠️'
                                    )
                                )
                            )
                        )
                    )
                ),

                // Insights Panel
                h('div', { className: 'insights-panel' },
                    h('div', { className: 'insights-header' },
                        h('span', null, '💡'),
                        h('h2', { className: 'insights-title' }, 'Slimme Inzichten')
                    ),
                    h('div', { className: 'insights-list' },
                        insights.map((insight, index) =>
                            h('div', {
                                key: index,
                                className: `insight-item ${insight.type}`
                            },
                                h('div', { className: 'insight-icon' }, insight.icon),
                                h('div', { className: 'insight-content' },
                                    h('div', { className: 'insight-title' }, insight.title),
                                    h('div', { className: 'insight-description' }, insight.description)
                                )
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
        root.render(h(AnalyticsDashboard));
    </script>
</body>
</html>
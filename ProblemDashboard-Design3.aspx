<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 3: Timeline & Prioriteit)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0; background: #fafbfc; color: #333;
        }
        .dashboard-container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
        }
        
        /* Top navigation bar */
        .top-nav {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white; padding: 16px 24px; border-radius: 12px; margin-bottom: 20px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 6px 20px rgba(30, 60, 114, 0.3);
        }
        .nav-title {
            font-size: 24px; font-weight: 700; margin: 0;
        }
        .nav-subtitle {
            font-size: 14px; opacity: 0.9; margin: 4px 0 0 0;
        }
        .nav-controls {
            display: flex; gap: 12px; align-items: center;
        }
        .time-filter {
            padding: 8px 16px; border: 2px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1); color: white; border-radius: 8px;
            font-size: 14px; cursor: pointer; backdrop-filter: blur(10px);
        }
        .time-filter:focus { outline: none; border-color: rgba(255,255,255,0.6); }
        
        /* Priority indicator strip */
        .priority-strip {
            background: white; border-radius: 12px; padding: 20px; margin-bottom: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06); display: flex; gap: 16px;
            overflow-x: auto;
        }
        .priority-item {
            flex: 1; text-align: center; padding: 16px; border-radius: 8px;
            border: 2px solid transparent; cursor: pointer; transition: all 0.3s ease;
            min-width: 140px;
        }
        .priority-item.critical {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white; border-color: #ff6b6b;
        }
        .priority-item.high {
            background: linear-gradient(135deg, #ffa726, #ff9800);
            color: white; border-color: #ffa726;
        }
        .priority-item.medium {
            background: linear-gradient(135deg, #42a5f5, #2196f3);
            color: white; border-color: #42a5f5;
        }
        .priority-item.low {
            background: linear-gradient(135deg, #66bb6a, #4caf50);
            color: white; border-color: #66bb6a;
        }
        .priority-item.selected {
            transform: scale(1.05); box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        }
        .priority-number {
            font-size: 28px; font-weight: 700; margin-bottom: 4px;
        }
        .priority-label {
            font-size: 12px; text-transform: uppercase; font-weight: 600;
            opacity: 0.9;
        }
        
        /* Main layout */
        .main-layout {
            display: grid; grid-template-columns: 1fr 400px; gap: 20px;
        }
        
        /* Timeline section */
        .timeline-section {
            background: white; border-radius: 12px; padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
        }
        .timeline-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 24px; padding-bottom: 16px; border-bottom: 2px solid #f1f3f4;
        }
        .timeline-title {
            font-size: 20px; font-weight: 600; color: #2c3e50; margin: 0;
        }
        .view-selector {
            display: flex; gap: 8px;
        }
        .view-btn {
            padding: 8px 16px; border: 2px solid #e9ecef; background: white;
            border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;
            transition: all 0.2s ease;
        }
        .view-btn.active {
            background: #1e3c72; color: white; border-color: #1e3c72;
        }
        
        .timeline-container {
            position: relative; max-height: 70vh; overflow-y: auto;
        }
        .timeline-line {
            position: absolute; left: 30px; top: 0; bottom: 0;
            width: 2px; background: #e9ecef;
        }
        
        .timeline-item {
            position: relative; padding-left: 70px; margin-bottom: 24px;
            transition: all 0.3s ease;
        }
        .timeline-item:hover { transform: translateX(4px); }
        
        .timeline-marker {
            position: absolute; left: 20px; top: 8px;
            width: 20px; height: 20px; border-radius: 50%;
            border: 3px solid white; z-index: 2;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .timeline-marker.critical { background: #ff6b6b; }
        .timeline-marker.high { background: #ffa726; }
        .timeline-marker.medium { background: #42a5f5; }
        .timeline-marker.low { background: #66bb6a; }
        .timeline-marker.resolved { background: #95a5a6; }
        
        .timeline-content {
            background: #f8f9fa; border-radius: 12px; padding: 16px;
            border-left: 4px solid #e9ecef; transition: all 0.2s ease;
        }
        .timeline-item:hover .timeline-content {
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        .timeline-content.critical { border-left-color: #ff6b6b; }
        .timeline-content.high { border-left-color: #ffa726; }
        .timeline-content.medium { border-left-color: #42a5f5; }
        .timeline-content.low { border-left-color: #66bb6a; }
        
        .problem-info {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 8px;
        }
        .problem-title {
            font-weight: 600; color: #2c3e50; font-size: 14px;
        }
        .problem-time {
            font-size: 11px; color: #7f8c8d; text-align: right;
            white-space: nowrap;
        }
        .problem-location {
            font-size: 13px; color: #34495e; margin-bottom: 8px;
        }
        .problem-description {
            font-size: 12px; color: #7f8c8d; line-height: 1.4;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .problem-tags {
            display: flex; gap: 6px; margin-top: 8px; flex-wrap: wrap;
        }
        .tag {
            background: rgba(30, 60, 114, 0.1); color: #1e3c72;
            padding: 2px 8px; border-radius: 12px; font-size: 10px;
            font-weight: 500;
        }
        
        /* Detail panel */
        .detail-panel {
            background: white; border-radius: 12px; padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06); position: sticky; top: 20px;
        }
        .panel-header {
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f3f4;
        }
        .panel-title {
            font-size: 18px; font-weight: 600; color: #2c3e50; margin: 0 0 4px 0;
        }
        .panel-subtitle {
            font-size: 14px; color: #7f8c8d; margin: 0;
        }
        
        .location-selector {
            margin-bottom: 20px;
        }
        .location-dropdown {
            width: 100%; padding: 12px; border: 2px solid #e9ecef;
            border-radius: 8px; font-size: 14px; background: white;
            cursor: pointer;
        }
        .location-dropdown:focus {
            outline: none; border-color: #1e3c72;
        }
        
        .detail-content {
            display: flex; flex-direction: column; gap: 16px;
        }
        .detail-card {
            background: #f8f9fa; border-radius: 8px; padding: 16px;
            border-left: 4px solid #e9ecef;
        }
        .detail-card-title {
            font-size: 14px; font-weight: 600; color: #2c3e50;
            margin-bottom: 8px;
        }
        .detail-card-value {
            font-size: 20px; font-weight: 700; color: #1e3c72;
        }
        .detail-card-subtitle {
            font-size: 11px; color: #7f8c8d; margin-top: 4px;
        }
        
        .quick-actions {
            margin-top: 20px; padding-top: 16px; border-top: 1px solid #e9ecef;
        }
        .action-btn {
            width: 100%; padding: 12px; margin-bottom: 8px; border: none;
            border-radius: 8px; font-size: 14px; font-weight: 600;
            cursor: pointer; transition: all 0.2s ease;
        }
        .action-primary {
            background: #1e3c72; color: white;
        }
        .action-primary:hover { background: #2a5298; }
        .action-secondary {
            background: #e9ecef; color: #495057;
        }
        .action-secondary:hover { background: #dee2e6; }
        
        .empty-state {
            text-align: center; padding: 60px 20px; color: #7f8c8d;
        }
        .empty-icon {
            font-size: 48px; margin-bottom: 16px; opacity: 0.5;
        }
        
        @media (max-width: 1200px) {
            .main-layout { grid-template-columns: 1fr; }
            .detail-panel { position: static; }
            .priority-strip { flex-wrap: wrap; }
        }
        
        @media (max-width: 768px) {
            .top-nav { flex-direction: column; gap: 12px; text-align: center; }
            .nav-controls { width: 100%; justify-content: center; }
            .timeline-item { padding-left: 50px; }
            .timeline-line { left: 20px; }
            .timeline-marker { left: 10px; }
            .priority-strip { gap: 8px; }
            .priority-item { min-width: 120px; padding: 12px; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="dashboard-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #1e3c72; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Dashboard wordt geladen...</p>
            </div>
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

        const TimelinePriorityDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [selectedLocation, setSelectedLocation] = useState('all');
            const [selectedPriority, setSelectedPriority] = useState('all');
            const [timeFilter, setTimeFilter] = useState('all');
            const [viewMode, setViewMode] = useState('timeline');

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

            // Calculate priority based on problem age and status
            const calculatePriority = (problem) => {
                const daysSinceCreated = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                const status = problem.Opgelost_x003f_;
                
                if (status === 'Opgelost') return 'resolved';
                if (status === 'Aangemeld' && daysSinceCreated > 14) return 'critical';
                if (status === 'Aangemeld' && daysSinceCreated > 7) return 'high';
                if (status === 'In behandeling' && daysSinceCreated > 21) return 'high';
                if (status === 'In behandeling') return 'medium';
                return 'low';
            };

            const allProblems = useMemo(() => {
                const problems = [];
                data.forEach(location => {
                    (location.problemen || []).forEach(problem => {
                        problems.push({
                            ...problem,
                            locationTitle: location.Title,
                            gemeente: location.Gemeente,
                            priority: calculatePriority(problem),
                            daysSince: Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24))
                        });
                    });
                });
                return problems.sort((a, b) => new Date(b.Aanmaakdatum) - new Date(a.Aanmaakdatum));
            }, [data]);

            const filteredProblems = useMemo(() => {
                return allProblems.filter(problem => {
                    if (selectedLocation !== 'all' && problem.locationTitle !== selectedLocation) return false;
                    if (selectedPriority !== 'all' && problem.priority !== selectedPriority) return false;
                    
                    if (timeFilter !== 'all') {
                        const days = problem.daysSince;
                        if (timeFilter === 'recent' && days > 7) return false;
                        if (timeFilter === 'week' && (days < 7 || days > 14)) return false;
                        if (timeFilter === 'month' && days < 30) return false;
                    }
                    
                    return true;
                });
            }, [allProblems, selectedLocation, selectedPriority, timeFilter]);

            const priorityStats = useMemo(() => {
                const stats = { critical: 0, high: 0, medium: 0, low: 0, resolved: 0 };
                allProblems.forEach(problem => {
                    stats[problem.priority]++;
                });
                return stats;
            }, [allProblems]);

            const locationOptions = useMemo(() => {
                const locations = [...new Set(data.map(loc => loc.Title))];
                return locations.sort();
            }, [data]);

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #1e3c72', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Dashboard wordt geladen...')
                    )
                );
            }

            return h('div', null,
                // Top navigation
                h('div', { className: 'top-nav' },
                    h('div', null,
                        h('h1', { className: 'nav-title' }, 'Timeline & Prioriteit Dashboard'),
                        h('p', { className: 'nav-subtitle' }, 'Chronologisch overzicht met prioriteit-indeling')
                    ),
                    h('div', { className: 'nav-controls' },
                        h('select', {
                            className: 'time-filter',
                            value: timeFilter,
                            onChange: (e) => setTimeFilter(e.target.value)
                        },
                            h('option', { value: 'all' }, 'Alle periodes'),
                            h('option', { value: 'recent' }, 'Laatste week'),
                            h('option', { value: 'week' }, '1-2 weken geleden'),
                            h('option', { value: 'month' }, 'Ouder dan maand')
                        )
                    )
                ),

                // Priority indicator strip
                h('div', { className: 'priority-strip' },
                    ['critical', 'high', 'medium', 'low', 'resolved'].map(priority => 
                        h('div', {
                            key: priority,
                            className: `priority-item ${priority} ${selectedPriority === priority ? 'selected' : ''}`,
                            onClick: () => setSelectedPriority(selectedPriority === priority ? 'all' : priority)
                        },
                            h('div', { className: 'priority-number' }, priorityStats[priority]),
                            h('div', { className: 'priority-label' }, 
                                priority === 'critical' ? 'Kritiek' :
                                priority === 'high' ? 'Hoog' :
                                priority === 'medium' ? 'Gemiddeld' :
                                priority === 'low' ? 'Laag' : 'Opgelost'
                            )
                        )
                    )
                ),

                // Main layout
                h('div', { className: 'main-layout' },
                    // Timeline section
                    h('div', { className: 'timeline-section' },
                        h('div', { className: 'timeline-header' },
                            h('h2', { className: 'timeline-title' }, 'Probleem Timeline'),
                            h('div', { className: 'view-selector' },
                                h('button', {
                                    className: `view-btn ${viewMode === 'timeline' ? 'active' : ''}`,
                                    onClick: () => setViewMode('timeline')
                                }, 'Timeline'),
                                h('button', {
                                    className: `view-btn ${viewMode === 'priority' ? 'active' : ''}`,
                                    onClick: () => setViewMode('priority')
                                }, 'Prioriteit')
                            )
                        ),

                        filteredProblems.length > 0 ? (
                            h('div', { className: 'timeline-container' },
                                h('div', { className: 'timeline-line' }),
                                filteredProblems.map(problem =>
                                    h('div', { key: problem.Id, className: 'timeline-item' },
                                        h('div', { className: `timeline-marker ${problem.priority}` }),
                                        h('div', { className: `timeline-content ${problem.priority}` },
                                            h('div', { className: 'problem-info' },
                                                h('div', { className: 'problem-title' },
                                                    `Probleem #${problem.Id}`
                                                ),
                                                h('div', { className: 'problem-time' },
                                                    h('div', null, new Date(problem.Aanmaakdatum).toLocaleDateString('nl-NL')),
                                                    h('div', null, `${problem.daysSince} dagen geleden`)
                                                )
                                            ),
                                            h('div', { className: 'problem-location' },
                                                `${problem.locationTitle} - ${problem.gemeente}`
                                            ),
                                            h('div', { className: 'problem-description' },
                                                problem.Probleembeschrijving
                                            ),
                                            h('div', { className: 'problem-tags' },
                                                h('span', { className: 'tag' }, problem.Feitcodegroep),
                                                h('span', { className: 'tag' }, problem.Opgelost_x003f_),
                                                problem.priority === 'critical' && h('span', { className: 'tag' }, '🚨 Kritiek'),
                                                problem.daysSince > 30 && h('span', { className: 'tag' }, '⏰ Oud probleem')
                                            )
                                        )
                                    )
                                )
                            )
                        ) : (
                            h('div', { className: 'empty-state' },
                                h('div', { className: 'empty-icon' }, '📅'),
                                h('h3', null, 'Geen problemen gevonden'),
                                h('p', null, 'Er zijn geen problemen die voldoen aan uw filters.')
                            )
                        )
                    ),

                    // Detail panel
                    h('div', { className: 'detail-panel' },
                        h('div', { className: 'panel-header' },
                            h('h3', { className: 'panel-title' }, 'Filter & Details'),
                            h('p', { className: 'panel-subtitle' }, 'Verfijn uw weergave')
                        ),

                        h('div', { className: 'location-selector' },
                            h('select', {
                                className: 'location-dropdown',
                                value: selectedLocation,
                                onChange: (e) => setSelectedLocation(e.target.value)
                            },
                                h('option', { value: 'all' }, 'Alle locaties'),
                                locationOptions.map(location =>
                                    h('option', { key: location, value: location }, location)
                                )
                            )
                        ),

                        h('div', { className: 'detail-content' },
                            h('div', { className: 'detail-card' },
                                h('div', { className: 'detail-card-title' }, 'Totaal Problemen'),
                                h('div', { className: 'detail-card-value' }, filteredProblems.length),
                                h('div', { className: 'detail-card-subtitle' }, 'Met huidige filters')
                            ),

                            h('div', { className: 'detail-card' },
                                h('div', { className: 'detail-card-title' }, 'Gemiddelde Leeftijd'),
                                h('div', { className: 'detail-card-value' }, 
                                    filteredProblems.length > 0 
                                        ? Math.round(filteredProblems.reduce((sum, p) => sum + p.daysSince, 0) / filteredProblems.length)
                                        : 0
                                ),
                                h('div', { className: 'detail-card-subtitle' }, 'Dagen sinds aanmelding')
                            ),

                            h('div', { className: 'detail-card' },
                                h('div', { className: 'detail-card-title' }, 'Meest Voorkomend'),
                                h('div', { className: 'detail-card-value' }, 
                                    filteredProblems.length > 0 ? (
                                        (() => {
                                            const counts = {};
                                            filteredProblems.forEach(p => {
                                                counts[p.Feitcodegroep] = (counts[p.Feitcodegroep] || 0) + 1;
                                            });
                                            const most = Object.entries(counts).sort((a, b) => b[1] - a[1])[0];
                                            return most ? most[0] : '-';
                                        })()
                                    ) : '-'
                                ),
                                h('div', { className: 'detail-card-subtitle' }, 'Feitcodegroep')
                            )
                        ),

                        h('div', { className: 'quick-actions' },
                            h('button', { className: 'action-btn action-primary' }, 'Rapport Exporteren'),
                            h('button', { className: 'action-btn action-secondary' }, 'Filters Resetten'),
                            h('button', { className: 'action-btn action-secondary' }, 'Nieuwe Weergave')
                        )
                    )
                )
            );
        };

        const rootElement = document.getElementById('dashboard-root');
        const root = createRoot(rootElement);
        root.render(h(TimelinePriorityDashboard));
    </script>
</body>
</html>
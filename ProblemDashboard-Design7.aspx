<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 7: Dark Admin)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Consolas', 'Monaco', 'Lucida Console', monospace;
            margin: 0; padding: 0 0 60px 0; background: #0a0e17; color: #e2e8f0;
            overflow-x: hidden;
        }
        .dark-container {
            max-width: 1900px; margin: 0 auto; padding: 20px;
            min-height: 100vh; background: linear-gradient(135deg, #0a0e17 0%, #1a202c 100%);
        }
        
        /* Terminal-style Header */
        .terminal-header {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            border: 1px solid #4a5568; border-radius: 8px; padding: 20px;
            margin-bottom: 24px; font-family: 'Courier New', monospace;
            box-shadow: 0 0 30px rgba(56, 178, 172, 0.1);
        }
        .terminal-title {
            color: #38b2ac; font-size: 18px; margin-bottom: 8px;
            display: flex; align-items: center; gap: 8px;
        }
        .terminal-prompt {
            color: #68d391; margin-right: 8px;
        }
        .terminal-command {
            color: #90cdf4; font-weight: bold;
        }
        .terminal-output {
            color: #e2e8f0; font-size: 14px; margin-top: 8px;
        }
        .blink {
            animation: blink 1s infinite;
        }
        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0; }
        }
        
        /* System Status Grid */
        .system-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px; margin-bottom: 32px;
        }
        .system-panel {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            border: 1px solid #4a5568; border-radius: 8px; padding: 20px;
            box-shadow: 0 0 20px rgba(0,0,0,0.5); position: relative; overflow: hidden;
        }
        .system-panel::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 2px; background: linear-gradient(90deg, #38b2ac, #4fd1c7);
        }
        .system-panel.critical::before { background: linear-gradient(90deg, #f56565, #fc8181); }
        .system-panel.warning::before { background: linear-gradient(90deg, #ed8936, #f6ad55); }
        .system-panel.success::before { background: linear-gradient(90deg, #48bb78, #68d391); }
        
        .panel-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; border-bottom: 1px solid #4a5568; padding-bottom: 8px;
        }
        .panel-title {
            color: #90cdf4; font-size: 14px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .panel-status {
            display: flex; align-items: center; gap: 6px;
            font-size: 12px; font-weight: 500;
        }
        .status-dot {
            width: 8px; height: 8px; border-radius: 50%;
        }
        .status-online { background: #48bb78; box-shadow: 0 0 10px #48bb78; }
        .status-warning { background: #ed8936; box-shadow: 0 0 10px #ed8936; }
        .status-error { background: #f56565; box-shadow: 0 0 10px #f56565; }
        
        .metric-display {
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-bottom: 12px;
        }
        .metric-value {
            font-size: 28px; font-weight: 700; color: #e2e8f0;
            font-family: 'Courier New', monospace;
        }
        .metric-unit {
            font-size: 14px; color: #a0aec0; margin-left: 4px;
        }
        .metric-trend {
            display: flex; align-items: center; gap: 4px;
            font-size: 12px; font-weight: 600;
        }
        .trend-up { color: #f56565; }
        .trend-down { color: #48bb78; }
        .trend-stable { color: #90cdf4; }
        
        .progress-bar {
            width: 100%; height: 4px; background: #2d3748;
            border-radius: 2px; overflow: hidden; margin-bottom: 8px;
        }
        .progress-fill {
            height: 100%; background: linear-gradient(90deg, #38b2ac, #4fd1c7);
            transition: width 0.3s ease;
        }
        .progress-fill.warning { background: linear-gradient(90deg, #ed8936, #f6ad55); }
        .progress-fill.critical { background: linear-gradient(90deg, #f56565, #fc8181); }
        
        .panel-details {
            font-size: 12px; color: #a0aec0; line-height: 1.4;
        }
        
        /* Data Table */
        .data-section {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            border: 1px solid #4a5568; border-radius: 8px; padding: 24px;
            margin-bottom: 24px; box-shadow: 0 0 20px rgba(0,0,0,0.5);
        }
        .section-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; border-bottom: 1px solid #4a5568; padding-bottom: 12px;
        }
        .section-title {
            color: #90cdf4; font-size: 16px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .section-controls {
            display: flex; gap: 8px;
        }
        .control-btn {
            background: #2d3748; border: 1px solid #4a5568; color: #e2e8f0;
            padding: 6px 12px; border-radius: 4px; font-size: 12px;
            cursor: pointer; transition: all 0.2s ease; font-family: inherit;
        }
        .control-btn:hover { background: #4a5568; }
        .control-btn.active { background: #38b2ac; border-color: #38b2ac; }
        
        .data-table {
            width: 100%; border-collapse: collapse;
            font-family: 'Courier New', monospace; font-size: 13px;
        }
        .data-table th {
            background: #2d3748; color: #90cdf4; padding: 12px;
            text-align: left; border-bottom: 1px solid #4a5568;
            font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 12px; border-bottom: 1px solid #374151;
            color: #e2e8f0;
        }
        .data-table tr:hover {
            background: rgba(56, 178, 172, 0.1);
        }
        
        .location-cell {
            display: flex; flex-direction: column; gap: 2px;
        }
        .location-name {
            color: #90cdf4; font-weight: 600;
        }
        .location-gemeente {
            color: #a0aec0; font-size: 11px;
        }
        
        .status-cell {
            text-align: center;
        }
        .status-badge {
            display: inline-block; padding: 4px 8px; border-radius: 4px;
            font-size: 10px; font-weight: 600; text-transform: uppercase;
            border: 1px solid;
        }
        .status-aangemeld {
            background: rgba(245, 101, 101, 0.2); color: #fc8181;
            border-color: rgba(245, 101, 101, 0.3);
        }
        .status-behandeling {
            background: rgba(56, 178, 172, 0.2); color: #4fd1c7;
            border-color: rgba(56, 178, 172, 0.3);
        }
        .status-uitgezet {
            background: rgba(144, 205, 244, 0.2); color: #90cdf4;
            border-color: rgba(144, 205, 244, 0.3);
        }
        .status-opgelost {
            background: rgba(72, 187, 120, 0.2); color: #68d391;
            border-color: rgba(72, 187, 120, 0.3);
        }
        
        .metric-cell {
            text-align: center; font-weight: 600;
            font-family: 'Courier New', monospace;
        }
        .metric-good { color: #68d391; }
        .metric-average { color: #f6ad55; }
        .metric-poor { color: #fc8181; }
        
        /* Console Log */
        .console-section {
            background: linear-gradient(135deg, #0f1419 0%, #1a202c 100%);
            border: 1px solid #4a5568; border-radius: 8px; padding: 20px;
            font-family: 'Courier New', monospace; font-size: 12px;
            max-height: 300px; overflow-y: auto;
        }
        .console-header {
            color: #90cdf4; margin-bottom: 12px; padding-bottom: 8px;
            border-bottom: 1px solid #4a5568; font-weight: 600;
        }
        .console-line {
            margin-bottom: 4px; display: flex; gap: 8px;
        }
        .console-timestamp {
            color: #a0aec0; width: 80px; flex-shrink: 0;
        }
        .console-level {
            width: 60px; flex-shrink: 0; font-weight: 600;
        }
        .console-level.info { color: #90cdf4; }
        .console-level.warn { color: #f6ad55; }
        .console-level.error { color: #fc8181; }
        .console-level.success { color: #68d391; }
        .console-message {
            color: #e2e8f0; flex: 1;
        }
        
        /* Sidebar */
        .main-layout {
            display: grid; grid-template-columns: 1fr 300px; gap: 24px;
        }
        .sidebar {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            border: 1px solid #4a5568; border-radius: 8px; padding: 20px;
            box-shadow: 0 0 20px rgba(0,0,0,0.5); height: fit-content;
        }
        .sidebar-title {
            color: #90cdf4; font-size: 14px; font-weight: 600;
            margin-bottom: 16px; text-transform: uppercase; letter-spacing: 1px;
        }
        .quick-stats {
            display: flex; flex-direction: column; gap: 12px;
        }
        .quick-stat {
            display: flex; justify-content: space-between; align-items: center;
            padding: 8px; background: rgba(56, 178, 172, 0.1);
            border-radius: 4px; border-left: 3px solid #38b2ac;
        }
        .stat-label {
            color: #a0aec0; font-size: 12px;
        }
        .stat-value {
            color: #e2e8f0; font-weight: 600; font-family: 'Courier New', monospace;
        }
        
        .theme-toggle {
            position: fixed; top: 20px; right: 20px; z-index: 1000;
            background: #38b2ac; border: none; color: white;
            padding: 10px; border-radius: 50%; cursor: pointer;
            box-shadow: 0 0 20px rgba(56, 178, 172, 0.5);
            transition: all 0.3s ease;
        }
        .theme-toggle:hover { transform: scale(1.1); }
        
        .loading-terminal {
            display: flex; justify-content: center; align-items: center;
            height: 50vh; flex-direction: column; gap: 16px;
        }
        .loading-bars {
            display: flex; gap: 4px;
        }
        .loading-bar {
            width: 4px; height: 20px; background: #38b2ac;
            animation: loading 1.4s infinite ease-in-out;
        }
        .loading-bar:nth-child(1) { animation-delay: -0.32s; }
        .loading-bar:nth-child(2) { animation-delay: -0.16s; }
        .loading-bar:nth-child(3) { animation-delay: 0s; }
        @keyframes loading {
            0%, 80%, 100% { transform: scaleY(0.4); }
            40% { transform: scaleY(1); }
        }
        
        @media (max-width: 1200px) {
            .main-layout { grid-template-columns: 1fr; }
            .system-grid { grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); }
        }
        
        @media (max-width: 768px) {
            .dark-container { padding: 10px; }
            .system-grid { grid-template-columns: 1fr; }
            .data-table { font-size: 11px; }
            .data-table th,
            .data-table td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="dark-container">
        <div class="loading-terminal">
            <div class="loading-bars">
                <div class="loading-bar"></div>
                <div class="loading-bar"></div>
                <div class="loading-bar"></div>
            </div>
            <p>Initializing Dark Admin Terminal...</p>
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

        const DarkAdminDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [currentTime, setCurrentTime] = useState(new Date());
            const [consoleLines, setConsoleLines] = useState([]);

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        addConsoleLog('info', 'Initiating data fetch sequence...');
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                        addConsoleLog('success', `Data fetch completed. ${result.length} locations loaded.`);
                    } catch (error) {
                        console.error('Data loading error, using placeholder data:', error);
                        addConsoleLog('error', `Data fetch failed: ${error.message} - Using placeholder data`);
                        // Use placeholder data if SharePoint is not available
                        setData(TEMP_PLACEHOLDER_DATA);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();

                // Update time every second
                const timeInterval = setInterval(() => {
                    setCurrentTime(new Date());
                }, 1000);

                return () => clearInterval(timeInterval);
            }, []);

            const addConsoleLog = (level, message) => {
                const timestamp = new Date().toLocaleTimeString('nl-NL');
                setConsoleLines(prev => [...prev.slice(-19), { timestamp, level, message }]);
            };

            const systemMetrics = useMemo(() => {
                const totalLocations = data.length;
                const allProblems = data.reduce((acc, loc) => [...acc, ...(loc.problemen || [])], []);
                const totalProblems = allProblems.length;
                const activeProblems = allProblems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                const criticalProblems = allProblems.filter(p => {
                    const daysSince = Math.floor((new Date() - new Date(p.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                    return p.Opgelost_x003f_ === 'Aangemeld' && daysSince > 14;
                }).length;

                const systemLoad = Math.min(100, Math.round((activeProblems / Math.max(totalProblems, 1)) * 100));
                const memoryUsage = Math.round(Math.random() * 30 + 60); // Simulated
                const networkLatency = Math.round(Math.random() * 50 + 10); // Simulated

                return {
                    totalLocations,
                    totalProblems,
                    activeProblems,
                    criticalProblems,
                    systemLoad,
                    memoryUsage,
                    networkLatency,
                    uptime: '99.7%'
                };
            }, [data]);

            const locationAnalysis = useMemo(() => {
                return data.map(location => {
                    const problems = location.problemen || [];
                    const active = problems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                    const total = problems.length;
                    const avgAge = total > 0 ? 
                        Math.round(problems.reduce((sum, p) => sum + Math.floor((new Date() - new Date(p.Aanmaakdatum)) / (1000 * 60 * 60 * 24)), 0) / total) : 0;
                    
                    let severity = 'good';
                    if (active > 5 || avgAge > 30) severity = 'poor';
                    else if (active > 2 || avgAge > 15) severity = 'average';

                    return {
                        ...location,
                        activeProblems: active,
                        totalProblems: total,
                        avgAge,
                        severity,
                        lastUpdate: new Date(Math.max(...problems.map(p => new Date(p.Aanmaakdatum)))).toLocaleDateString('nl-NL')
                    };
                }).sort((a, b) => b.activeProblems - a.activeProblems);
            }, [data]);

            if (loading) {
                return h('div', { className: 'loading-terminal' },
                    h('div', { className: 'loading-bars' },
                        h('div', { className: 'loading-bar' }),
                        h('div', { className: 'loading-bar' }),
                        h('div', { className: 'loading-bar' })
                    ),
                    h('p', null, 'Initializing Dark Admin Terminal...')
                );
            }

            return h('div', null,
                // Theme Toggle
                h('button', { className: 'theme-toggle' }, '🌙'),

                // Terminal Header
                h('div', { className: 'terminal-header' },
                    h('div', { className: 'terminal-title' },
                        h('span', { className: 'terminal-prompt' }, 'admin@ddh-system:~$'),
                        h('span', { className: 'terminal-command' }, 'exec dashboard --mode=dark --realtime'),
                        h('span', { className: 'blink' }, '▋')
                    ),
                    h('div', { className: 'terminal-output' },
                        `System initialized at ${currentTime.toLocaleString('nl-NL')} | `,
                        `Active connections: ${systemMetrics.totalLocations} | `,
                        `Process ID: ${Math.floor(Math.random() * 9999) + 1000}`
                    )
                ),

                // System Metrics Grid
                h('div', { className: 'system-grid' },
                    h('div', { className: `system-panel ${systemMetrics.criticalProblems > 0 ? 'critical' : 'success'}` },
                        h('div', { className: 'panel-header' },
                            h('div', { className: 'panel-title' }, 'System Status'),
                            h('div', { className: 'panel-status' },
                                h('div', { className: `status-dot ${systemMetrics.criticalProblems > 0 ? 'status-error' : 'status-online'}` }),
                                systemMetrics.criticalProblems > 0 ? 'Critical' : 'Operational'
                            )
                        ),
                        h('div', { className: 'metric-display' },
                            h('div', null,
                                h('span', { className: 'metric-value' }, systemMetrics.systemLoad),
                                h('span', { className: 'metric-unit' }, '%')
                            ),
                            h('div', { className: 'metric-trend trend-up' },
                                '↗ +2.3%'
                            )
                        ),
                        h('div', { className: 'progress-bar' },
                            h('div', {
                                className: `progress-fill ${systemMetrics.systemLoad > 80 ? 'critical' : systemMetrics.systemLoad > 60 ? 'warning' : ''}`,
                                style: { width: `${systemMetrics.systemLoad}%` }
                            })
                        ),
                        h('div', { className: 'panel-details' },
                            `Load average: ${(systemMetrics.systemLoad / 100 * 3).toFixed(2)} | `,
                            `Uptime: ${systemMetrics.uptime}`
                        )
                    ),

                    h('div', { className: 'system-panel warning' },
                        h('div', { className: 'panel-header' },
                            h('div', { className: 'panel-title' }, 'Memory Usage'),
                            h('div', { className: 'panel-status' },
                                h('div', { className: 'status-dot status-warning' }),
                                'High'
                            )
                        ),
                        h('div', { className: 'metric-display' },
                            h('div', null,
                                h('span', { className: 'metric-value' }, systemMetrics.memoryUsage),
                                h('span', { className: 'metric-unit' }, '%')
                            ),
                            h('div', { className: 'metric-trend trend-stable' },
                                '→ 0.1%'
                            )
                        ),
                        h('div', { className: 'progress-bar' },
                            h('div', {
                                className: 'progress-fill warning',
                                style: { width: `${systemMetrics.memoryUsage}%` }
                            })
                        ),
                        h('div', { className: 'panel-details' },
                            `Used: ${(systemMetrics.memoryUsage * 0.16).toFixed(1)}GB / 16GB | `,
                            `Cache: 2.3GB`
                        )
                    ),

                    h('div', { className: 'system-panel' },
                        h('div', { className: 'panel-header' },
                            h('div', { className: 'panel-title' }, 'Active Problems'),
                            h('div', { className: 'panel-status' },
                                h('div', { className: 'status-dot status-online' }),
                                'Monitored'
                            )
                        ),
                        h('div', { className: 'metric-display' },
                            h('div', null,
                                h('span', { className: 'metric-value' }, systemMetrics.activeProblems),
                                h('span', { className: 'metric-unit' }, 'items')
                            ),
                            h('div', { className: 'metric-trend trend-down' },
                                '↘ -5.2%'
                            )
                        ),
                        h('div', { className: 'panel-details' },
                            `Critical: ${systemMetrics.criticalProblems} | `,
                            `Total: ${systemMetrics.totalProblems} | `,
                            `Resolved: ${systemMetrics.totalProblems - systemMetrics.activeProblems}`
                        )
                    ),

                    h('div', { className: 'system-panel' },
                        h('div', { className: 'panel-header' },
                            h('div', { className: 'panel-title' }, 'Network Latency'),
                            h('div', { className: 'panel-status' },
                                h('div', { className: 'status-dot status-online' }),
                                'Optimal'
                            )
                        ),
                        h('div', { className: 'metric-display' },
                            h('div', null,
                                h('span', { className: 'metric-value' }, systemMetrics.networkLatency),
                                h('span', { className: 'metric-unit' }, 'ms')
                            ),
                            h('div', { className: 'metric-trend trend-stable' },
                                '→ 0.0%'
                            )
                        ),
                        h('div', { className: 'panel-details' },
                            `RTT: ${systemMetrics.networkLatency}ms | `,
                            `Packet loss: 0.0% | `,
                            `Bandwidth: 1.2Gbps`
                        )
                    )
                ),

                // Main Layout
                h('div', { className: 'main-layout' },
                    // Data Section
                    h('div', null,
                        h('div', { className: 'data-section' },
                            h('div', { className: 'section-header' },
                                h('div', { className: 'section-title' }, 'Location Analysis Matrix'),
                                h('div', { className: 'section-controls' },
                                    h('button', { className: 'control-btn active' }, 'Real-time'),
                                    h('button', { className: 'control-btn' }, 'Filtered'),
                                    h('button', { className: 'control-btn' }, 'Export')
                                )
                            ),
                            h('table', { className: 'data-table' },
                                h('thead', null,
                                    h('tr', null,
                                        h('th', null, 'Location'),
                                        h('th', null, 'Status'),
                                        h('th', null, 'Active'),
                                        h('th', null, 'Total'),
                                        h('th', null, 'Avg Age'),
                                        h('th', null, 'Severity'),
                                        h('th', null, 'Last Update')
                                    )
                                ),
                                h('tbody', null,
                                    locationAnalysis.slice(0, 12).map(location =>
                                        h('tr', { key: location.Id },
                                            h('td', null,
                                                h('div', { className: 'location-cell' },
                                                    h('div', { className: 'location-name' }, location.Title),
                                                    h('div', { className: 'location-gemeente' }, location.Gemeente)
                                                )
                                            ),
                                            h('td', { className: 'status-cell' },
                                                h('span', {
                                                    className: `status-badge status-${(location.Status_x0020_B_x0026_S || '').toLowerCase().replace(/\s+/g, '-')}`
                                                }, location.Status_x0020_B_x0026_S || 'Unknown')
                                            ),
                                            h('td', { className: 'metric-cell' }, location.activeProblems),
                                            h('td', { className: 'metric-cell' }, location.totalProblems),
                                            h('td', { className: 'metric-cell' }, `${location.avgAge}d`),
                                            h('td', { className: `metric-cell metric-${location.severity}` },
                                                location.severity === 'good' ? '●●●' :
                                                location.severity === 'average' ? '●●○' : '●○○'
                                            ),
                                            h('td', { className: 'metric-cell' }, location.lastUpdate)
                                        )
                                    )
                                )
                            )
                        ),

                        // Console Log
                        h('div', { className: 'console-section' },
                            h('div', { className: 'console-header' },
                                '> System Log Monitor [REAL-TIME]'
                            ),
                            consoleLines.map((line, index) =>
                                h('div', { key: index, className: 'console-line' },
                                    h('span', { className: 'console-timestamp' }, line.timestamp),
                                    h('span', { className: `console-level ${line.level}` }, line.level.toUpperCase()),
                                    h('span', { className: 'console-message' }, line.message)
                                )
                            )
                        )
                    ),

                    // Sidebar
                    h('div', { className: 'sidebar' },
                        h('div', { className: 'sidebar-title' }, 'Quick Stats'),
                        h('div', { className: 'quick-stats' },
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Total Locations'),
                                h('span', { className: 'stat-value' }, systemMetrics.totalLocations)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Active Problems'),
                                h('span', { className: 'stat-value' }, systemMetrics.activeProblems)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Critical Issues'),
                                h('span', { className: 'stat-value' }, systemMetrics.criticalProblems)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'System Load'),
                                h('span', { className: 'stat-value' }, `${systemMetrics.systemLoad}%`)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Memory Usage'),
                                h('span', { className: 'stat-value' }, `${systemMetrics.memoryUsage}%`)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Network Latency'),
                                h('span', { className: 'stat-value' }, `${systemMetrics.networkLatency}ms`)
                            ),
                            h('div', { className: 'quick-stat' },
                                h('span', { className: 'stat-label' }, 'Uptime'),
                                h('span', { className: 'stat-value' }, systemMetrics.uptime)
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
        root.render(h(DarkAdminDashboard));
    </script>
</body>
</html>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 5: Executive Dashboard</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0; background: #f8fafc; color: #1a202c;
        }
        .portal-container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3730a3 50%, #581c87 100%);
            color: white; padding: 28px 32px; border-radius: 20px; margin-bottom: 32px;
            position: relative; overflow: hidden;
        }
        .portal-header::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            position: relative; z-index: 1;
        }
        .portal-title {
            font-size: 32px; font-weight: 800; margin: 0 0 4px 0;
        }
        .portal-subtitle {
            font-size: 16px; opacity: 0.9; margin: 0;
        }
        .header-actions {
            display: flex; gap: 12px; align-items: center;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 14px; color: rgba(255,255,255,0.9);
        }
        .breadcrumb-item {
            cursor: pointer; transition: opacity 0.2s ease;
            display: flex; align-items: center; gap: 4px;
        }
        .breadcrumb-item:hover { opacity: 0.8; }
        .breadcrumb-separator { margin: 0 4px; opacity: 0.6; }
        .refresh-btn {
            background: rgba(255,255,255,0.15); border: 2px solid rgba(255,255,255,0.3);
            color: white; padding: 8px 16px; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 600; backdrop-filter: blur(10px);
            transition: all 0.2s ease; display: flex; align-items: center; gap: 6px;
        }
        .refresh-btn:hover { background: rgba(255,255,255,0.25); }
        .last-update {
            font-size: 12px; opacity: 0.8;
        }
        
        /* KPI Cards */
        .kpi-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px; margin-bottom: 32px;
        }
        .kpi-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); position: relative;
            overflow: hidden; transition: all 0.3s ease;
        }
        .kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(0,0,0,0.12); }
        .kpi-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 4px; background: var(--accent-color);
        }
        .kpi-card.primary { --accent-color: linear-gradient(90deg, #3b82f6, #1d4ed8); }
        .kpi-card.success { --accent-color: linear-gradient(90deg, #10b981, #059669); }
        .kpi-card.warning { --accent-color: linear-gradient(90deg, #f59e0b, #d97706); }
        .kpi-card.danger { --accent-color: linear-gradient(90deg, #ef4444, #dc2626); }
        
        .kpi-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 16px;
        }
        .kpi-icon {
            width: 48px; height: 48px; border-radius: 12px; display: flex;
            align-items: center; justify-content: center; font-size: 20px;
            background: var(--accent-color); color: white;
        }
        .kpi-trend {
            font-size: 12px; padding: 4px 8px; border-radius: 12px; font-weight: 600;
        }
        .kpi-trend.up { background: #dcfce7; color: #16a34a; }
        .kpi-trend.down { background: #fee2e2; color: #dc2626; }
        .kpi-trend.stable { background: #e0e7ff; color: #4338ca; }
        
        .kpi-value {
            font-size: 36px; font-weight: 800; color: #1a202c; margin-bottom: 4px;
        }
        .kpi-label {
            font-size: 14px; color: #64748b; font-weight: 600; margin-bottom: 12px;
        }
        .kpi-description {
            font-size: 12px; color: #94a3b8; line-height: 1.4;
        }
        
        /* Main Dashboard Grid */
        .dashboard-grid {
            display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 32px;
        }
        
        /* Chart Placeholder */
        .chart-container {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .chart-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f5f9;
        }
        .chart-title {
            font-size: 20px; font-weight: 700; color: #1a202c;
        }
        .chart-controls {
            display: flex; gap: 8px;
        }
        .chart-btn {
            padding: 6px 12px; border: 2px solid #e2e8f0; background: white;
            border-radius: 8px; font-size: 12px; cursor: pointer; font-weight: 600;
            transition: all 0.2s ease;
        }
        .chart-btn.active { background: #3b82f6; color: white; border-color: #3b82f6; }
        .chart-btn:hover:not(.active) { background: #f8fafc; }
        
        .chart-placeholder {
            height: 300px; background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            color: #64748b; font-size: 16px; font-weight: 600; flex-direction: column; gap: 12px;
        }
        .chart-icon { font-size: 48px; opacity: 0.5; }
        
        /* Quick Stats Sidebar */
        .quick-stats {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .stats-header {
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f5f9;
        }
        .stats-title {
            font-size: 18px; font-weight: 700; color: #1a202c; margin: 0;
        }
        .stats-list {
            display: flex; flex-direction: column; gap: 16px;
        }
        .stat-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px; background: #f8fafc; border-radius: 8px;
        }
        .stat-label {
            font-size: 14px; color: #64748b; font-weight: 500;
        }
        .stat-value {
            font-size: 16px; font-weight: 700; color: #1a202c;
        }
        .stat-value.danger { color: #dc2626; }
        .stat-value.success { color: #16a34a; }
        .stat-value.warning { color: #d97706; }
        
        /* Data Tables */
        .data-tables {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px;
        }
        .table-container {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .table-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f5f9;
        }
        .table-title {
            font-size: 18px; font-weight: 700; color: #1a202c;
        }
        .view-all-btn {
            background: #3b82f6; color: white; border: none;
            padding: 6px 12px; border-radius: 6px; font-size: 12px;
            font-weight: 600; cursor: pointer; transition: all 0.2s ease;
        }
        .view-all-btn:hover { background: #2563eb; }
        
        .data-table {
            width: 100%; border-collapse: collapse;
        }
        .data-table th {
            background: #f8fafc; padding: 12px; text-align: left;
            font-size: 12px; font-weight: 600; color: #64748b;
            text-transform: uppercase; border-bottom: 1px solid #e2e8f0;
        }
        .data-table td {
            padding: 12px; border-bottom: 1px solid #f1f5f9; font-size: 14px;
        }
        .data-table tr:hover { background: #f8fafc; }
        
        .gemeente-cell {
            font-weight: 600; color: #1a202c;
        }
        .location-cell {
            color: #64748b; font-size: 13px;
        }
        .count-cell {
            text-align: center; font-weight: 600;
        }
        .status-indicator {
            display: inline-block; width: 8px; height: 8px; border-radius: 50%;
            margin-right: 6px;
        }
        .status-indicator.good { background: #16a34a; }
        .status-indicator.warning { background: #d97706; }
        .status-indicator.critical { background: #dc2626; }
        
        /* Recent Activity Feed */
        .activity-feed {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-top: 24px;
        }
        .activity-header {
            margin-bottom: 20px; padding-bottom: 16px; border-bottom: 2px solid #f1f5f9;
        }
        .activity-title {
            font-size: 18px; font-weight: 700; color: #1a202c; margin: 0;
        }
        .activity-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .activity-item {
            display: flex; gap: 12px; padding: 12px; background: #f8fafc;
            border-radius: 8px; transition: all 0.2s ease;
        }
        .activity-item:hover { background: #f1f5f9; }
        .activity-icon {
            width: 32px; height: 32px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-size: 14px;
            flex-shrink: 0;
        }
        .activity-icon.new { background: #dbeafe; color: #2563eb; }
        .activity-icon.update { background: #fef3c7; color: #d97706; }
        .activity-icon.resolved { background: #dcfce7; color: #16a34a; }
        .activity-content {
            flex: 1;
        }
        .activity-text {
            font-size: 14px; color: #374151; margin-bottom: 2px;
        }
        .activity-meta {
            font-size: 12px; color: #9ca3af;
        }
        
        /* Loading States */
        .loading-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(248, 250, 252, 0.95); display: flex; align-items: center;
            justify-content: center; flex-direction: column; gap: 16px; z-index: 1000;
        }
        .loading-spinner {
            width: 50px; height: 50px; border: 4px solid #e2e8f0;
            border-top: 4px solid #3b82f6; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        /* Layered Navigation Styles */
        .layer-title {
            text-align: center; margin-bottom: 32px;
        }
        .layer-title h2 {
            font-size: 28px; font-weight: 700; color: #1a202c; margin: 0 0 8px 0;
        }
        .layer-title p {
            font-size: 16px; color: #64748b; margin: 0;
        }
        
        .gemeente-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px; margin-bottom: 32px;
        }
        .gemeente-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border: 2px solid transparent;
        }
        .gemeente-card:hover {
            transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.15);
            border-color: #3b82f6;
        }
        .gemeente-card.has-problems {
            border-color: #dc2626;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 20px; font-weight: 700; color: #1a202c; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8); color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 4px;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
        }
        
        .pleeglocatie-layer, .detail-layer {
            background: white; border-radius: 20px; padding: 32px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .layer-header {
            text-align: center; margin-bottom: 32px;
        }
        .layer-header h2 {
            font-size: 24px; font-weight: 700; color: #1a202c; margin: 0 0 8px 0;
        }
        .layer-header p {
            font-size: 16px; color: #64748b; margin: 0;
        }
        
        .pleeglocatie-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        .pleeglocatie-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); cursor: pointer;
            transition: all 0.3s ease; border-left: 4px solid #e5e7eb;
        }
        .pleeglocatie-card:hover {
            transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        .pleeglocatie-card.has-problems {
            border-left-color: #dc2626;
        }
        .locatie-header {
            margin-bottom: 12px;
        }
        .locatie-name {
            font-size: 16px; font-weight: 600; color: #1a202c; margin-bottom: 8px;
        }
        .locatie-badges {
            display: flex; gap: 8px;
        }
        .badge {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
            display: flex; align-items: center; gap: 4px;
        }
        .badge.problems { background: #fef2f2; color: #dc2626; }
        .badge.resolved { background: #f0fdf4; color: #16a34a; }
        .locatie-meta {
            font-size: 13px; color: #64748b; line-height: 1.4;
        }
        
        .detail-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 24px; padding-bottom: 20px; border-bottom: 2px solid #f1f5f9;
        }
        .detail-title {
            font-size: 28px; font-weight: 800; color: #1a202c; margin: 0 0 4px 0;
        }
        .detail-subtitle {
            font-size: 16px; color: #64748b; margin: 0;
        }
        .filter-buttons {
            display: flex; gap: 8px;
        }
        .filter-btn {
            padding: 8px 16px; border: 2px solid #e5e7eb; background: white;
            border-radius: 8px; font-size: 14px; cursor: pointer; font-weight: 600;
            transition: all 0.2s ease; display: flex; align-items: center; gap: 6px;
        }
        .filter-btn.active {
            background: #3b82f6; color: white; border-color: #3b82f6;
        }
        .filter-btn:hover:not(.active) { background: #f8fafc; }
        
        .detail-sections {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 32px;
        }
        .detail-section {
            background: #f8fafc; border-radius: 12px; padding: 20px;
        }
        .section-title {
            font-size: 16px; font-weight: 600; color: #1a202c; margin: 0 0 16px 0;
            display: flex; align-items: center; gap: 8px;
        }
        .links-grid {
            display: flex; flex-direction: column; gap: 8px;
        }
        .link-card {
            display: flex; align-items: center; gap: 8px; padding: 12px;
            background: white; border-radius: 8px; text-decoration: none;
            color: #374151; font-size: 14px; font-weight: 500;
            transition: all 0.2s ease;
        }
        .link-card:hover {
            background: #3b82f6; color: white;
        }
        .contact-info {
            font-size: 14px; color: #374151; line-height: 1.6;
        }
        
        .problems-section {
            background: #f8fafc; border-radius: 12px; padding: 20px;
        }
        .problems-list {
            display: flex; flex-direction: column; gap: 12px;
        }
        .problem-card {
            background: white; border-radius: 12px; padding: 16px;
            border-left: 4px solid #e5e7eb; transition: all 0.2s ease;
        }
        .problem-card.active { border-left-color: #dc2626; }
        .problem-card.resolved { border-left-color: #16a34a; opacity: 0.8; }
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .problem-id {
            font-size: 12px; color: #64748b; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #9ca3af; display: flex; align-items: center; gap: 4px;
        }
        .problem-description {
            font-size: 14px; color: #374151; line-height: 1.4; margin-bottom: 12px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #3b82f6; color: white; padding: 4px 8px;
            border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status {
            padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #fef2f2; color: #dc2626; }
        .problem-status.behandeling { background: #eff6ff; color: #2563eb; }
        .problem-status.uitgezet { background: #fffbeb; color: #d97706; }
        .problem-status.opgelost { background: #f0fdf4; color: #16a34a; }
        .empty-state {
            text-align: center; padding: 40px; color: #64748b;
        }
        
        /* Responsive */
        @media (max-width: 1400px) {
            .dashboard-grid { grid-template-columns: 1fr; }
            .data-tables { grid-template-columns: 1fr; }
            .detail-sections { grid-template-columns: 1fr; }
        }
        @media (max-width: 1024px) {
            .kpi-grid { grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); }
            .header-content { flex-direction: column; gap: 16px; text-align: center; }
        }
        @media (max-width: 768px) {
            .portal-container { padding: 12px; }
            .kpi-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .kpi-card { padding: 16px; }
            .kpi-value { font-size: 28px; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div class="loading-overlay">
            <div class="loading-spinner"></div>
            <p>Executive Dashboard wordt geladen...</p>
        </div>
    </div>

    <!-- React -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <script type="module">
        const { createElement: h, useState, useEffect, useMemo } = window.React;
        const { createRoot } = window.ReactDOM;

        // Import configuration and SVG icons
        const { DDH_CONFIG } = await import('./js/config/index.js');
        const SvgIcons = await import('./js/components/svgIcons.js');
        const { 
            HomeIcon, LocationIcon, BuildingIcon, CityIcon, CheckIcon, WarningIcon,
            AlertIcon, SearchIcon, FilterIcon, ProblemIcon, ActiveProblemIcon,
            ResolvedIcon, DocumentIcon, LinkIcon, ContactIcon, BackIcon, TimeIcon,
            ChartIcon, TrendUpIcon, RefreshIcon
        } = SvgIcons;

        const ExecutiveDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [lastUpdate, setLastUpdate] = useState(new Date());
            const [currentLayer, setCurrentLayer] = useState('gemeente'); // 'gemeente', 'pleeglocatie', 'detail'
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);
            const [problemFilter, setProblemFilter] = useState('all'); // 'all', 'active', 'resolved'

            useEffect(() => {
                const fetchData = async () => {
                    try {
                        const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
                        setData(result);
                        setLastUpdate(new Date());
                    } catch (error) {
                        console.error('Data loading error:', error);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();
            }, []);

            const refreshData = () => {
                setLoading(true);
                setTimeout(() => {
                    setData([...data]); // Simulate refresh
                    setLastUpdate(new Date());
                    setLoading(false);
                }, 1000);
            };

            // Calculate comprehensive metrics
            const metrics = useMemo(() => {
                const allProblems = data.reduce((acc, location) => [...acc, ...(location.problemen || [])], []);
                const totalLocations = data.length;
                const totalProblems = allProblems.length;
                const activeProblems = allProblems.filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                const resolvedProblems = totalProblems - activeProblems;
                const resolutionRate = totalProblems > 0 ? Math.round((resolvedProblems / totalProblems) * 100) : 0;
                
                // Performance metrics
                const avgResolutionTime = allProblems.reduce((sum, p) => {
                    const days = Math.floor((new Date() - new Date(p.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                    return sum + days;
                }, 0) / Math.max(allProblems.length, 1);
                
                // Problem aging
                const criticalProblems = allProblems.filter(p => {
                    const days = Math.floor((new Date() - new Date(p.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                    return p.Opgelost_x003f_ !== 'Opgelost' && days > 30;
                }).length;
                
                // Gemeente breakdown
                const gemeenteStats = {};
                data.forEach(location => {
                    const gemeente = location.Gemeente;
                    if (!gemeenteStats[gemeente]) {
                        gemeenteStats[gemeente] = {
                            locations: 0,
                            totalProblems: 0,
                            activeProblems: 0
                        };
                    }
                    gemeenteStats[gemeente].locations++;
                    gemeenteStats[gemeente].totalProblems += (location.problemen || []).length;
                    gemeenteStats[gemeente].activeProblems += (location.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length;
                });
                
                return {
                    totalLocations,
                    totalProblems,
                    activeProblems,
                    resolvedProblems,
                    resolutionRate,
                    avgResolutionTime: Math.round(avgResolutionTime),
                    criticalProblems,
                    gemeenteStats,
                    allProblems
                };
            }, [data]);

            // Top problematic locations
            const topProblematicLocations = useMemo(() => {
                return data
                    .map(location => ({
                        ...location,
                        activeCount: (location.problemen || []).filter(p => p.Opgelost_x003f_ !== 'Opgelost').length
                    }))
                    .filter(location => location.activeCount > 0)
                    .sort((a, b) => b.activeCount - a.activeCount)
                    .slice(0, 10);
            }, [data]);

            // Recent activity simulation
            const recentActivity = useMemo(() => {
                const activities = [];
                metrics.allProblems.slice(0, 10).forEach(problem => {
                    const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                    if (daysSince <= 7) {
                        activities.push({
                            id: problem.Id,
                            type: problem.Opgelost_x003f_ === 'Opgelost' ? 'resolved' : 'new',
                            text: `Probleem #${problem.Id} ${problem.Opgelost_x003f_ === 'Opgelost' ? 'opgelost' : 'gemeld'}`,
                            location: problem.Title,
                            gemeente: problem.Gemeente,
                            time: `${daysSince} dag${daysSince !== 1 ? 'en' : ''} geleden`
                        });
                    }
                });
                return activities.slice(0, 8);
            }, [metrics.allProblems]);

            if (loading) {
                return h('div', { className: 'loading-overlay' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Executive Dashboard wordt geladen...')
                );
            }

            // Gemeente selection layer
            const renderGemeenteSelection = () => {
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
                                    h(BuildingIcon, { size: 16 }), ` ${gemeente.locations.length}`
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
                            )
                        );
                    })
                );
            };

            // Pleeglocatie layer
            const renderPleeglocatieLayer = () => {
                const locations = data.filter(loc => loc.Gemeente === selectedGemeente);
                
                return h('div', { className: 'pleeglocatie-layer' },
                    h('div', { className: 'layer-header' },
                        h('h2', null, `Pleeglocaties in ${selectedGemeente}`),
                        h('p', null, 'Selecteer een locatie voor gedetailleerde informatie')
                    ),
                    h('div', { className: 'pleeglocatie-grid' },
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
                                            h(WarningIcon, { size: 12 }), ` ${activeProblems}`
                                        ),
                                        resolvedProblems > 0 && h('span', { className: 'badge resolved' }, 
                                            h(CheckIcon, { size: 12 }), ` ${resolvedProblems}`
                                        )
                                    )
                                ),
                                h('div', { className: 'locatie-meta' },
                                    h('p', null, `Status: ${location.Status_x0020_B_x0026_S || 'Onbekend'}`),
                                    h('p', null, `Feitcode: ${location.Feitcodegroep}`),
                                    h('p', null, `${problems.length} problemen geregistreerd`)
                                )
                            );
                        })
                    )
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
                
                return h('div', { className: 'detail-layer' },
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
                    
                    // Documents and contact section
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

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('div', null,
                            h('h1', { className: 'portal-title' }, 'DDH Executive Dashboard'),
                            h('p', { className: 'portal-subtitle' }, 'Strategisch overzicht van handhavingsoperaties')
                        ),
                        h('div', { className: 'header-actions' },
                            // Breadcrumb navigation
                            h('div', { className: 'breadcrumb' },
                                h('span', {
                                    className: 'breadcrumb-item',
                                    onClick: () => {
                                        setCurrentLayer('gemeente');
                                        setSelectedGemeente(null);
                                        setSelectedPleeglocatie(null);
                                    }
                                }, h(HomeIcon, { size: 16 }), ' Home'),
                                currentLayer !== 'gemeente' && h('span', { className: 'breadcrumb-separator' }, ' > '),
                                currentLayer !== 'gemeente' && h('span', {
                                    className: 'breadcrumb-item',
                                    onClick: () => {
                                        setCurrentLayer('pleeglocatie');
                                        setSelectedPleeglocatie(null);
                                    }
                                }, selectedGemeente),
                                currentLayer === 'detail' && h('span', { className: 'breadcrumb-separator' }, ' > '),
                                currentLayer === 'detail' && h('span', { className: 'breadcrumb-item' }, selectedPleeglocatie?.Title)
                            ),
                            h('button', { className: 'refresh-btn', onClick: refreshData }, 
                                h(RefreshIcon, { size: 16 }), ' Vernieuwen'
                            ),
                            h('div', { className: 'last-update' },
                                `Laatste update: ${lastUpdate.toLocaleTimeString('nl-NL', { hour: '2-digit', minute: '2-digit' })}`
                            )
                        )
                    )
                ),

                // Layer Navigation Container
                currentLayer === 'gemeente' && h('div', { className: 'kpi-grid' },
                    // KPI Cards for gemeente overview
                    h('div', { className: 'layer-title' },
                        h('h2', null, 'Selecteer een Gemeente'),
                        h('p', null, 'Klik op een gemeente om pleeglocaties te bekijken')
                    )
                ),
                
                // Gemeente selection or other layers
                currentLayer === 'gemeente' && renderGemeenteSelection(),
                currentLayer === 'pleeglocatie' && renderPleeglocatieLayer(),
                currentLayer === 'detail' && renderDetailLayer(),
                
                // KPI Cards (shown on all layers)
                h('div', { className: 'kpi-grid' },
                    h('div', { className: 'kpi-card primary' },
                        h('div', { className: 'kpi-header' },
                            h('div', { className: 'kpi-icon' }, h(BuildingIcon, { size: 20 })),
                            h('div', { className: 'kpi-trend stable' }, 'Stabiel')
                        ),
                        h('div', { className: 'kpi-value' }, metrics.totalLocations),
                        h('div', { className: 'kpi-label' }, 'Actieve Locaties'),
                        h('div', { className: 'kpi-description' }, 'Handhavingslocaties onder monitoring')
                    ),
                    h('div', { className: 'kpi-card danger' },
                        h('div', { className: 'kpi-header' },
                            h('div', { className: 'kpi-icon' }, h(AlertIcon, { size: 20 })),
                            h('div', { className: 'kpi-trend up' }, `${metrics.activeProblems > 50 ? '+' : ''}${Math.round((metrics.activeProblems / metrics.totalProblems) * 100)}%`)
                        ),
                        h('div', { className: 'kpi-value' }, metrics.activeProblems),
                        h('div', { className: 'kpi-label' }, 'Actieve Problemen'),
                        h('div', { className: 'kpi-description' }, 'Vereisen directe aandacht van het team')
                    ),
                    h('div', { className: 'kpi-card success' },
                        h('div', { className: 'kpi-header' },
                            h('div', { className: 'kpi-icon' }, h(CheckIcon, { size: 20 })),
                            h('div', { className: 'kpi-trend down' }, `${metrics.resolutionRate}%`)
                        ),
                        h('div', { className: 'kpi-value' }, metrics.resolvedProblems),
                        h('div', { className: 'kpi-label' }, 'Opgeloste Problemen'),
                        h('div', { className: 'kpi-description' }, 'Succesvol afgehandelde meldingen')
                    ),
                    h('div', { className: 'kpi-card warning' },
                        h('div', { className: 'kpi-header' },
                            h('div', { className: 'kpi-icon' }, h(TimeIcon, { size: 20 })),
                            h('div', { className: 'kpi-trend stable' }, 'Gem.')
                        ),
                        h('div', { className: 'kpi-value' }, `${metrics.avgResolutionTime}d`),
                        h('div', { className: 'kpi-label' }, 'Gem. Afhandeltijd'),
                        h('div', { className: 'kpi-description' }, 'Doorlooptijd van melding tot oplossing')
                    )
                ),

                // Only show dashboard grid on gemeente layer
                currentLayer === 'gemeente' && h('div', { className: 'dashboard-grid' },
                    // Chart Container
                    h('div', { className: 'chart-container' },
                        h('div', { className: 'chart-header' },
                            h('h3', { className: 'chart-title' }, 'Trends & Prestaties'),
                            h('div', { className: 'chart-controls' },
                                h('button', { className: 'chart-btn active' }, '7d'),
                                h('button', { className: 'chart-btn' }, '30d'),
                                h('button', { className: 'chart-btn' }, '90d')
                            )
                        ),
                        h('div', { className: 'chart-placeholder' },
                            h('div', { className: 'chart-icon' }, h(ChartIcon, { size: 48 })),
                            h('div', null, 'Interactieve grafieken worden hier weergegeven'),
                            h('small', null, 'Trends van nieuwe vs. opgeloste problemen over tijd')
                        )
                    ),
                    
                    // Quick Stats Sidebar
                    h('div', { className: 'quick-stats' },
                        h('div', { className: 'stats-header' },
                            h('h3', { className: 'stats-title' }, 'Snelle Statistieken')
                        ),
                        h('div', { className: 'stats-list' },
                            h('div', { className: 'stat-item' },
                                h('div', { className: 'stat-label' }, 'Gemeentes'),
                                h('div', { className: 'stat-value' }, Object.keys(metrics.gemeenteStats).length)
                            ),
                            h('div', { className: 'stat-item' },
                                h('div', { className: 'stat-label' }, 'Kritieke Problemen'),
                                h('div', { className: 'stat-value danger' }, metrics.criticalProblems)
                            ),
                            h('div', { className: 'stat-item' },
                                h('div', { className: 'stat-label' }, 'Oplossingsratio'),
                                h('div', { className: `stat-value ${metrics.resolutionRate > 70 ? 'success' : metrics.resolutionRate > 50 ? 'warning' : 'danger'}` }, 
                                    `${metrics.resolutionRate}%`
                                )
                            ),
                            h('div', { className: 'stat-item' },
                                h('div', { className: 'stat-label' }, 'Locaties met Problemen'),
                                h('div', { className: 'stat-value warning' }, 
                                    data.filter(loc => (loc.problemen || []).some(p => p.Opgelost_x003f_ !== 'Opgelost')).length
                                )
                            ),
                            h('div', { className: 'stat-item' },
                                h('div', { className: 'stat-label' }, 'Schone Locaties'),
                                h('div', { className: 'stat-value success' }, 
                                    data.filter(loc => (loc.problemen || []).every(p => p.Opgelost_x003f_ === 'Opgelost')).length
                                )
                            )
                        )
                    )
                ),

                // Data Tables
                h('div', { className: 'data-tables' },
                    // Top Problematic Locations
                    h('div', { className: 'table-container' },
                        h('div', { className: 'table-header' },
                            h('h3', { className: 'table-title' }, 'Top Problematische Locaties'),
                            h('button', { className: 'view-all-btn' }, 'Alle bekijken')
                        ),
                        h('table', { className: 'data-table' },
                            h('thead', null,
                                h('tr', null,
                                    h('th', null, 'Locatie'),
                                    h('th', null, 'Gemeente'),
                                    h('th', null, 'Actief'),
                                    h('th', null, 'Status')
                                )
                            ),
                            h('tbody', null,
                                topProblematicLocations.slice(0, 8).map(location => {
                                    const severity = location.activeCount > 5 ? 'critical' : location.activeCount > 2 ? 'warning' : 'good';
                                    return h('tr', { key: location.Id },
                                        h('td', { className: 'gemeente-cell' }, location.Title),
                                        h('td', { className: 'location-cell' }, location.Gemeente),
                                        h('td', { className: 'count-cell' }, location.activeCount),
                                        h('td', null,
                                            h('span', { className: `status-indicator ${severity}` }),
                                            severity === 'critical' ? 'Kritiek' : severity === 'warning' ? 'Let op' : 'Goed'
                                        )
                                    );
                                })
                            )
                        )
                    ),
                    
                    // Gemeente Performance
                    h('div', { className: 'table-container' },
                        h('div', { className: 'table-header' },
                            h('h3', { className: 'table-title' }, 'Gemeente Prestaties'),
                            h('button', { className: 'view-all-btn' }, 'Alle bekijken')
                        ),
                        h('table', { className: 'data-table' },
                            h('thead', null,
                                h('tr', null,
                                    h('th', null, 'Gemeente'),
                                    h('th', null, 'Locaties'),
                                    h('th', null, 'Problemen'),
                                    h('th', null, 'Status')
                                )
                            ),
                            h('tbody', null,
                                Object.entries(metrics.gemeenteStats)
                                    .sort(([,a], [,b]) => b.activeProblems - a.activeProblems)
                                    .slice(0, 8)
                                    .map(([gemeente, stats]) => {
                                        const severity = stats.activeProblems > 10 ? 'critical' : stats.activeProblems > 5 ? 'warning' : 'good';
                                        return h('tr', { key: gemeente },
                                            h('td', { className: 'gemeente-cell' }, gemeente),
                                            h('td', { className: 'count-cell' }, stats.locations),
                                            h('td', { className: 'count-cell' }, `${stats.activeProblems}/${stats.totalProblems}`),
                                            h('td', null,
                                                h('span', { className: `status-indicator ${severity}` }),
                                                severity === 'critical' ? 'Kritiek' : severity === 'warning' ? 'Aandacht' : 'Goed'
                                            )
                                        );
                                    })
                            )
                        )
                    )
                ),

                // Recent Activity Feed
                h('div', { className: 'activity-feed' },
                    h('div', { className: 'activity-header' },
                        h('h3', { className: 'activity-title' }, 'Recente Activiteit')
                    ),
                    h('div', { className: 'activity-list' },
                        recentActivity.length > 0 ? recentActivity.map((activity, index) => {
                            return h('div', { key: activity.id || index, className: 'activity-item' },
                                h('div', { className: `activity-icon ${activity.type}` }, 
                                    activity.type === 'resolved' ? h(CheckIcon, { size: 14 }) : 
                                    activity.type === 'new' ? h(AlertIcon, { size: 14 }) : h(DocumentIcon, { size: 14 })
                                ),
                                h('div', { className: 'activity-content' },
                                    h('div', { className: 'activity-text' }, activity.text),
                                    h('div', { className: 'activity-meta' }, 
                                        `${activity.gemeente} • ${activity.time}`
                                    )
                                )
                            );
                        }) : h('div', { style: { textAlign: 'center', padding: '20px', color: '#64748b' } },
                            'Geen recente activiteit'
                        )
                    )
                )
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(ExecutiveDashboard));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
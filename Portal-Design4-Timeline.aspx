<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 4: Timeline & Priority View</title>
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0; padding: 0; background: #fafafa; color: #333;
        }
        .portal-container {
            max-width: 1600px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .portal-header {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white; padding: 24px 32px; border-radius: 20px; margin-bottom: 32px;
            position: relative; overflow: hidden;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            position: relative; z-index: 1;
        }
        .breadcrumb {
            display: flex; align-items: center; gap: 8px; font-size: 14px;
        }
        .breadcrumb-item {
            cursor: pointer; transition: opacity 0.2s ease;
            display: flex; align-items: center; gap: 4px;
        }
        .breadcrumb-item:hover { opacity: 0.8; }
        .breadcrumb-separator { margin: 0 4px; opacity: 0.6; }
        .portal-header::before {
            content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 50%);
            animation: float 6s ease-in-out infinite;
        }
        .portal-title {
            font-size: 36px; font-weight: 900; margin: 0 0 8px 0; position: relative; z-index: 1;
        }
        .portal-subtitle {
            font-size: 18px; opacity: 0.9; margin: 0; position: relative; z-index: 1;
        }
        
        /* Controls */
        .controls-section {
            display: grid; grid-template-columns: 1fr auto auto; gap: 16px;
            align-items: center; margin-bottom: 32px; background: white;
            padding: 20px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .search-input {
            padding: 12px 16px; border: 2px solid #e5e7eb; border-radius: 12px;
            font-size: 16px; transition: all 0.2s ease;
        }
        .search-input:focus {
            outline: none; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .view-toggle {
            display: flex; gap: 4px; background: #f3f4f6; border-radius: 8px; padding: 4px;
        }
        .toggle-btn {
            padding: 8px 16px; border: none; background: transparent; border-radius: 6px;
            cursor: pointer; font-size: 14px; font-weight: 600; transition: all 0.2s ease;
        }
        .toggle-btn.active { background: #6366f1; color: white; }
        .sort-select {
            padding: 8px 12px; border: 2px solid #e5e7eb; border-radius: 8px;
            font-size: 14px; cursor: pointer;
        }
        
        /* Navigation Layers */
        .layer-container {
            background: white; border-radius: 20px; padding: 32px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        
        /* Gemeente Grid */
        .priority-dashboard {
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
            border-color: #6366f1;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .gemeente-name {
            font-size: 20px; font-weight: 700; color: #1f2937; margin: 0;
        }
        .gemeente-badge {
            background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 4px;
        }
        .gemeente-stats {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-bottom: 16px;
        }
        .stat-item {
            text-align: center; padding: 12px; background: #f9fafb; border-radius: 8px;
        }
        .stat-number {
            font-size: 18px; font-weight: 700; color: #1f2937;
        }
        .stat-label {
            font-size: 11px; color: #6b7280; text-transform: uppercase; font-weight: 600;
        }
        .gemeente-preview {
            font-size: 14px; color: #6b7280; line-height: 1.5;
        }
        
        /* Pleeglocatie Grid */
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
            font-size: 16px; font-weight: 600; color: #1f2937; margin-bottom: 8px;
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
            font-size: 13px; color: #6b7280; line-height: 1.4;
        }
        
        /* Detail View */
        .detail-view {
            max-width: 1200px;
        }
        .detail-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 24px; padding-bottom: 20px; border-bottom: 2px solid #f1f5f9;
        }
        .detail-title {
            font-size: 28px; font-weight: 800; color: #1f2937; margin: 0 0 4px 0;
        }
        .detail-subtitle {
            font-size: 16px; color: #6b7280; margin: 0;
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
            background: #6366f1; color: white; border-color: #6366f1;
        }
        .filter-btn:hover:not(.active) { background: #f9fafb; }
        
        .detail-stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 32px;
        }
        .stat-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); border-left: 4px solid #e5e7eb;
            display: flex; align-items: center; gap: 16px;
        }
        .stat-card.active { border-left-color: #dc2626; }
        .stat-card.resolved { border-left-color: #16a34a; }
        .stat-icon {
            padding: 12px; border-radius: 12px; background: #f9fafb;
        }
        .stat-content .stat-number {
            font-size: 24px; font-weight: 800; color: #1f2937; margin-bottom: 4px;
        }
        .stat-content .stat-label {
            font-size: 12px; color: #6b7280; font-weight: 600;
        }
        
        .detail-sections {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 32px;
        }
        .detail-section {
            background: #f9fafb; border-radius: 12px; padding: 20px;
        }
        .section-title {
            font-size: 16px; font-weight: 600; color: #1f2937; margin: 0 0 16px 0;
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
            background: #6366f1; color: white;
        }
        .contact-info {
            font-size: 14px; color: #374151; line-height: 1.6;
        }
        
        .problems-section {
            background: #f9fafb; border-radius: 12px; padding: 20px;
        }
        .empty-state {
            text-align: center; padding: 40px; color: #6b7280;
        }
        .priority-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-left: 6px solid;
            transition: all 0.3s ease;
        }
        .priority-card:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(0,0,0,0.12); }
        .priority-card.critical { border-left-color: #dc2626; }
        .priority-card.high { border-left-color: #ea580c; }
        .priority-card.medium { border-left-color: #d97706; }
        .priority-card.low { border-left-color: #65a30d; }
        
        .priority-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;
        }
        .priority-title {
            font-size: 18px; font-weight: 700; margin: 0;
        }
        .priority-count {
            background: #f3f4f6; color: #374151; padding: 4px 12px;
            border-radius: 20px; font-size: 14px; font-weight: 600;
        }
        .priority-count.critical { background: #fef2f2; color: #dc2626; }
        .priority-count.high { background: #fff7ed; color: #ea580c; }
        .priority-count.medium { background: #fffbeb; color: #d97706; }
        .priority-count.low { background: #f7fee7; color: #65a30d; }
        
        .priority-description {
            font-size: 14px; color: #6b7280; margin-bottom: 16px;
        }
        .priority-items {
            display: flex; flex-direction: column; gap: 8px;
        }
        .priority-item {
            padding: 8px 12px; background: #f9fafb; border-radius: 8px;
            font-size: 13px; cursor: pointer; transition: all 0.2s ease;
        }
        .priority-item:hover { background: #f3f4f6; }
        
        /* Timeline View */
        .timeline-container {
            background: white; border-radius: 20px; padding: 32px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .timeline-header {
            margin-bottom: 32px; text-align: center;
        }
        .timeline-title {
            font-size: 24px; font-weight: 700; margin: 0 0 8px 0; color: #1f2937;
        }
        .timeline-subtitle {
            font-size: 16px; color: #6b7280; margin: 0;
        }
        
        .timeline {
            position: relative; padding-left: 32px;
        }
        .timeline::before {
            content: ''; position: absolute; left: 16px; top: 0; bottom: 0;
            width: 2px; background: linear-gradient(to bottom, #6366f1, #8b5cf6);
        }
        
        .timeline-group {
            margin-bottom: 48px; position: relative;
        }
        .timeline-group::before {
            content: ''; position: absolute; left: -24px; top: 8px;
            width: 16px; height: 16px; border-radius: 50%; background: #6366f1;
            border: 4px solid white; box-shadow: 0 0 0 2px #6366f1;
        }
        
        .group-header {
            margin-bottom: 20px;
        }
        .group-title {
            font-size: 20px; font-weight: 700; margin: 0 0 4px 0; color: #1f2937;
        }
        .group-meta {
            font-size: 14px; color: #6b7280;
        }
        
        .gemeente-section {
            margin-bottom: 32px; padding: 20px; background: #f9fafb;
            border-radius: 12px; border-left: 4px solid #6366f1;
        }
        .gemeente-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; cursor: pointer;
        }
        .gemeente-name {
            font-size: 18px; font-weight: 600; color: #1f2937; margin: 0;
        }
        .gemeente-stats {
            display: flex; gap: 12px; align-items: center;
        }
        .stat-badge {
            padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 600;
        }
        .stat-badge.problems { background: #fef2f2; color: #dc2626; }
        .stat-badge.locations { background: #eff6ff; color: #2563eb; }
        .stat-badge.resolved { background: #f0fdf4; color: #16a34a; }
        
        .locaties-list {
            display: grid; gap: 12px;
        }
        .locatie-card {
            background: white; border-radius: 12px; padding: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04); cursor: pointer;
            transition: all 0.2s ease; border-left: 4px solid #e5e7eb;
        }
        .locatie-card:hover { 
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); 
            transform: translateX(4px);
        }
        .locatie-card.has-problems { border-left-color: #dc2626; }
        .locatie-card.resolved-only { border-left-color: #16a34a; }
        
        .locatie-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 8px;
        }
        .locatie-name {
            font-size: 16px; font-weight: 600; color: #1f2937;
        }
        .locatie-badges {
            display: flex; gap: 6px;
        }
        
        .problems-summary {
            font-size: 14px; color: #6b7280; margin-bottom: 12px;
        }
        .problems-list {
            display: grid; gap: 8px;
        }
        .problem-timeline-item {
            background: #f9fafb; border-radius: 8px; padding: 12px;
            border-left: 3px solid #e5e7eb; position: relative;
        }
        .problem-timeline-item.active { border-left-color: #dc2626; background: #fef9f9; }
        .problem-timeline-item.resolved { border-left-color: #16a34a; background: #f6fcf7; }
        
        .problem-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 6px;
        }
        .problem-id {
            font-size: 12px; color: #6b7280; font-weight: 600;
        }
        .problem-age {
            font-size: 11px; color: #9ca3af;
        }
        .problem-description {
            font-size: 13px; color: #374151; line-height: 1.4; margin-bottom: 8px;
        }
        .problem-footer {
            display: flex; justify-content: space-between; align-items: center;
        }
        .problem-category {
            background: #6366f1; color: white; padding: 2px 6px;
            border-radius: 8px; font-size: 10px; font-weight: 600;
        }
        .problem-status {
            padding: 2px 6px; border-radius: 8px; font-size: 10px; font-weight: 600;
        }
        .problem-status.aangemeld { background: #fef2f2; color: #dc2626; }
        .problem-status.behandeling { background: #eff6ff; color: #2563eb; }
        .problem-status.uitgezet { background: #fffbeb; color: #d97706; }
        .problem-status.opgelost { background: #f0fdf4; color: #16a34a; }
        
        .urgency-indicator {
            position: absolute; right: 8px; top: 8px;
            width: 8px; height: 8px; border-radius: 50%;
        }
        .urgency-indicator.critical { background: #dc2626; animation: pulse 1.5s infinite; }
        .urgency-indicator.high { background: #ea580c; }
        .urgency-indicator.medium { background: #d97706; }
        .urgency-indicator.low { background: #65a30d; }
        
        /* Animations */
        @keyframes float {
            0%, 100% { transform: translate(-50%, -50%) rotate(0deg); }
            50% { transform: translate(-50%, -50%) rotate(180deg); }
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.2); }
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .controls-section { grid-template-columns: 1fr; gap: 12px; }
            .priority-dashboard { grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }
        }
        @media (max-width: 768px) {
            .portal-title { font-size: 28px; }
            .gemeente-header { flex-direction: column; align-items: flex-start; gap: 8px; }
            .gemeente-stats { flex-wrap: wrap; }
        }
    </style>
</head>
<body>
    <div id="portal-root" class="portal-container">
        <div style="display: flex; justify-content: center; align-items: center; height: 50vh;">
            <div style="text-align: center;">
                <div style="width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid #6366f1; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                <p>Timeline Portal wordt geladen...</p>
            </div>
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
            ResolvedIcon, DocumentIcon, LinkIcon, ContactIcon, BackIcon, TimeIcon
        } = SvgIcons;

        const TimelinePortal = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [searchTerm, setSearchTerm] = useState('');
            const [currentLayer, setCurrentLayer] = useState('gemeente'); // 'gemeente', 'pleeglocatie', 'detail'
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);
            const [problemFilter, setProblemFilter] = useState('all'); // 'all', 'active', 'resolved'
            const [sortBy, setSortBy] = useState('urgency');

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

            // Calculate problem urgency based on age and status
            const calculateUrgency = (problem) => {
                const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                const status = problem.Opgelost_x003f_;
                
                if (status === 'Opgelost') return 'resolved';
                if (status === 'Aangemeld' && daysSince > 30) return 'critical';
                if (status === 'Aangemeld' && daysSince > 14) return 'high';
                if (status === 'In behandeling' && daysSince > 21) return 'high';
                if (daysSince > 7) return 'medium';
                return 'low';
            };

            // Process and categorize problems
            const processedData = useMemo(() => {
                const allProblems = [];
                const groupedByGemeente = {};
                
                data.forEach(location => {
                    const gemeente = location.Gemeente;
                    if (!groupedByGemeente[gemeente]) {
                        groupedByGemeente[gemeente] = [];
                    }
                    groupedByGemeente[gemeente].push(location);
                    
                    (location.problemen || []).forEach(problem => {
                        const urgency = calculateUrgency(problem);
                        const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                        allProblems.push({
                            ...problem,
                            urgency,
                            daysSince,
                            locationTitle: location.Title,
                            gemeente: location.Gemeente,
                            locationId: location.Id
                        });
                    });
                });
                
                return { allProblems, groupedByGemeente };
            }, [data]);

            // Filter and sort data
            const filteredData = useMemo(() => {
                let filtered = processedData.allProblems;
                
                if (searchTerm) {
                    filtered = filtered.filter(problem => 
                        problem.gemeente.toLowerCase().includes(searchTerm.toLowerCase()) ||
                        problem.locationTitle.toLowerCase().includes(searchTerm.toLowerCase()) ||
                        problem.Probleembeschrijving.toLowerCase().includes(searchTerm.toLowerCase())
                    );
                }
                
                // Sort based on selected criteria
                filtered.sort((a, b) => {
                    if (sortBy === 'urgency') {
                        const urgencyOrder = { 'critical': 0, 'high': 1, 'medium': 2, 'low': 3, 'resolved': 4 };
                        if (urgencyOrder[a.urgency] !== urgencyOrder[b.urgency]) {
                            return urgencyOrder[a.urgency] - urgencyOrder[b.urgency];
                        }
                        return b.daysSince - a.daysSince; // Then by age descending
                    } else if (sortBy === 'age') {
                        return b.daysSince - a.daysSince;
                    } else if (sortBy === 'gemeente') {
                        if (a.gemeente !== b.gemeente) {
                            return a.gemeente.localeCompare(b.gemeente);
                        }
                        return a.locationTitle.localeCompare(b.locationTitle);
                    }
                    return 0;
                });
                
                return filtered;
            }, [processedData.allProblems, searchTerm, sortBy]);

            // Group for priority view
            const priorityGroups = useMemo(() => {
                const groups = {
                    critical: filteredData.filter(p => p.urgency === 'critical'),
                    high: filteredData.filter(p => p.urgency === 'high'),
                    medium: filteredData.filter(p => p.urgency === 'medium'),
                    low: filteredData.filter(p => p.urgency === 'low')
                };
                return groups;
            }, [filteredData]);

            // Group for timeline view
            const timelineGroups = useMemo(() => {
                const grouped = {};
                filteredData.forEach(problem => {
                    const gemeente = problem.gemeente;
                    if (!grouped[gemeente]) {
                        grouped[gemeente] = {};
                    }
                    const locationId = problem.locationId;
                    if (!grouped[gemeente][locationId]) {
                        grouped[gemeente][locationId] = {
                            title: problem.locationTitle,
                            problems: []
                        };
                    }
                    grouped[gemeente][locationId].problems.push(problem);
                });
                return grouped;
            }, [filteredData]);

            // Gemeente layer - shows all gemeenten as clickable cards
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

                return h('div', null,
                    h('div', { className: 'priority-dashboard' },
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
                                ),
                                h('div', { className: 'gemeente-preview' },
                                    `${gemeente.locations.length} handhavingslocaties onder monitoring`
                                )
                            );
                        })
                    )
                );
            };

            // Pleeglocatie layer - shows locations for selected gemeente
            const renderPleeglocatieLayer = () => {
                const locations = data.filter(loc => loc.Gemeente === selectedGemeente);
                
                return h('div', null,
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

            // Detail layer - shows full information for selected location
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
                        h('div', { className: 'detail-actions' },
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

            const renderPriorityView = () => {
                return h('div', null,
                    h('div', { className: 'priority-dashboard' },
                        Object.entries(priorityGroups).map(([priority, problems]) => {
                            if (problems.length === 0) return null;
                            
                            const priorityTitles = {
                                critical: 'Kritiek',
                                high: 'Hoog',
                                medium: 'Gemiddeld',
                                low: 'Laag'
                            };
                            
                            const priorityDescriptions = {
                                critical: 'Problemen ouder dan 30 dagen - directe actie vereist',
                                high: 'Problemen die al langere tijd open staan',
                                medium: 'Problemen die aandacht verdienen',
                                low: 'Recent gemelde problemen'
                            };
                            
                            return h('div', { key: priority, className: `priority-card ${priority}` },
                                h('div', { className: 'priority-header' },
                                    h('h3', { className: 'priority-title' }, priorityTitles[priority]),
                                    h('div', { className: `priority-count ${priority}` }, problems.length)
                                ),
                                h('p', { className: 'priority-description' }, priorityDescriptions[priority]),
                                h('div', { className: 'priority-items' },
                                    problems.slice(0, 5).map(problem => {
                                        return h('div', { key: problem.Id, className: 'priority-item' },
                                            `${problem.gemeente} - ${problem.locationTitle} (#${problem.Id})`
                                        );
                                    }),
                                    problems.length > 5 && h('div', { 
                                        className: 'priority-item',
                                        style: { fontStyle: 'italic', color: '#6b7280' }
                                    }, `+${problems.length - 5} meer problemen`)
                                )
                            );
                        })
                    )
                );
            };

            const renderTimelineView = () => {
                return h('div', { className: 'timeline-container' },
                    h('div', { className: 'timeline-header' },
                        h('h2', { className: 'timeline-title' }, 'Chronologisch Overzicht'),
                        h('p', { className: 'timeline-subtitle' }, 'Problemen georganiseerd per gemeente en locatie')
                    ),
                    h('div', { className: 'timeline' },
                        Object.entries(timelineGroups).map(([gemeente, locations]) => {
                            const totalProblems = Object.values(locations).reduce((sum, loc) => sum + loc.problems.length, 0);
                            const activeProblems = Object.values(locations).reduce((sum, loc) => 
                                sum + loc.problems.filter(p => p.urgency !== 'resolved').length, 0);
                            const resolvedProblems = totalProblems - activeProblems;
                            
                            return h('div', { key: gemeente, className: 'timeline-group' },
                                h('div', { className: 'group-header' },
                                    h('h3', { className: 'group-title' }, gemeente),
                                    h('div', { className: 'group-meta' }, 
                                        `${Object.keys(locations).length} locaties • ${totalProblems} problemen`
                                    )
                                ),
                                h('div', { className: 'gemeente-section' },
                                    h('div', { className: 'gemeente-header' },
                                        h('h4', { className: 'gemeente-name' }, gemeente),
                                        h('div', { className: 'gemeente-stats' },
                                            h('div', { className: 'stat-badge locations' }, 
                                                `${Object.keys(locations).length} locaties`
                                            ),
                                            activeProblems > 0 && h('div', { className: 'stat-badge problems' }, 
                                                `${activeProblems} actief`
                                            ),
                                            resolvedProblems > 0 && h('div', { className: 'stat-badge resolved' }, 
                                                `${resolvedProblems} opgelost`
                                            )
                                        )
                                    ),
                                    h('div', { className: 'locaties-list' },
                                        Object.entries(locations).map(([locationId, locationData]) => {
                                            const { title, problems } = locationData;
                                            const activeProbs = problems.filter(p => p.urgency !== 'resolved');
                                            const resolvedProbs = problems.filter(p => p.urgency === 'resolved');
                                            const hasProblems = activeProbs.length > 0;
                                            
                                            return h('div', {
                                                key: locationId,
                                                className: `locatie-card ${hasProblems ? 'has-problems' : resolvedProbs.length > 0 ? 'resolved-only' : ''}`
                                            },
                                                h('div', { className: 'locatie-header' },
                                                    h('div', { className: 'locatie-name' }, title),
                                                    h('div', { className: 'locatie-badges' },
                                                        activeProbs.length > 0 && h('div', { className: 'stat-badge problems' }, 
                                                            `${activeProbs.length} actief`
                                                        ),
                                                        resolvedProbs.length > 0 && h('div', { className: 'stat-badge resolved' }, 
                                                            `${resolvedProbs.length} opgelost`
                                                        )
                                                    )
                                                ),
                                                h('div', { className: 'problems-summary' },
                                                    `${problems.length} problemen geregistreerd`
                                                ),
                                                h('div', { className: 'problems-list' },
                                                    // Show active problems first (prominently)
                                                    activeProbs.map(problem => {
                                                        return h('div', {
                                                            key: problem.Id,
                                                            className: 'problem-timeline-item active'
                                                        },
                                                            h('div', { className: `urgency-indicator ${problem.urgency}` }),
                                                            h('div', { className: 'problem-header' },
                                                                h('div', { className: 'problem-id' }, `Probleem #${problem.Id}`),
                                                                h('div', { className: 'problem-age' }, `${problem.daysSince} dagen geleden`)
                                                            ),
                                                            h('div', { className: 'problem-description' }, problem.Probleembeschrijving),
                                                            h('div', { className: 'problem-footer' },
                                                                h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                                                h('div', {
                                                                    className: `problem-status ${(problem.Opgelost_x003f_ || '').toLowerCase().replace(/\s+/g, '-')}`
                                                                }, problem.Opgelost_x003f_)
                                                            )
                                                        );
                                                    }),
                                                    // Show some resolved problems (smaller)
                                                    resolvedProbs.slice(0, 2).map(problem => {
                                                        return h('div', {
                                                            key: problem.Id,
                                                            className: 'problem-timeline-item resolved'
                                                        },
                                                            h('div', { className: 'problem-header' },
                                                                h('div', { className: 'problem-id' }, `#${problem.Id} (Opgelost)`),
                                                                h('div', { className: 'problem-age' }, `${problem.daysSince} dagen geleden`)
                                                            ),
                                                            h('div', { className: 'problem-description' }, 
                                                                problem.Probleembeschrijving.length > 80 
                                                                    ? problem.Probleembeschrijving.substring(0, 80) + '...'
                                                                    : problem.Probleembeschrijving
                                                            ),
                                                            h('div', { className: 'problem-footer' },
                                                                h('div', { className: 'problem-category' }, problem.Feitcodegroep),
                                                                h('div', { className: 'problem-status opgelost' }, 'Opgelost')
                                                            )
                                                        );
                                                    }),
                                                    resolvedProbs.length > 2 && h('div', {
                                                        style: { 
                                                            textAlign: 'center', 
                                                            padding: '8px', 
                                                            color: '#6b7280', 
                                                            fontSize: '12px',
                                                            fontStyle: 'italic'
                                                        }
                                                    }, `+${resolvedProbs.length - 2} meer opgeloste problemen`)
                                                )
                                            );
                                        })
                                    )
                                )
                            );
                        })
                    )
                );
            };

            if (loading) {
                return h('div', { style: { display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' } },
                    h('div', { style: { textAlign: 'center' } },
                        h('div', { style: { 
                            width: '50px', height: '50px', border: '4px solid #f3f3f3', 
                            borderTop: '4px solid #6366f1', borderRadius: '50%',
                            animation: 'spin 1s linear infinite', margin: '0 auto 20px'
                        } }),
                        h('p', null, 'Timeline Portal wordt geladen...')
                    )
                );
            }

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
                );
            };

            return h('div', null,
                // Header
                h('div', { className: 'portal-header' },
                    h('div', { className: 'header-content' },
                        h('div', null,
                            h('h1', { className: 'portal-title' }, 'DDH Timeline Portal'),
                            h('p', { className: 'portal-subtitle' }, 'Layered navigation handhavingsportaal')
                        ),
                        renderBreadcrumbs()
                    )
                ),

                // Controls
                // Controls
                h('div', { className: 'controls-section' },
                    h('input', {
                        type: 'text',
                        className: 'search-input',
                        placeholder: 'Zoek gemeente, locatie of probleem...',
                        value: searchTerm,
                        onChange: (e) => setSearchTerm(e.target.value)
                    }),
                    h('div', { className: 'view-toggle' },
                        h('button', {
                            className: 'toggle-btn',
                            onClick: () => {
                                setCurrentLayer('gemeente');
                                setSelectedGemeente(null);
                                setSelectedPleeglocatie(null);
                            }
                        }, h(BackIcon, { size: 14 }), ' Reset View')
                    ),
                    h('select', {
                        className: 'sort-select',
                        value: sortBy,
                        onChange: (e) => setSortBy(e.target.value)
                    },
                        h('option', { value: 'urgency' }, 'Sorteren op urgentie'),
                        h('option', { value: 'age' }, 'Sorteren op leeftijd'),
                        h('option', { value: 'gemeente' }, 'Sorteren op gemeente')
                    )
                ),

                // Layer Navigation Container
                h('div', { className: 'layer-container' },
                    currentLayer === 'gemeente' && renderGemeenteLayer(),
                    currentLayer === 'pleeglocatie' && renderPleeglocatieLayer(),
                    currentLayer === 'detail' && renderDetailLayer()
                )
            );
        };

        const rootElement = document.getElementById('portal-root');
        const root = createRoot(rootElement);
        root.render(h(TimelinePortal));
    </script>
    
    <style>
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH - Problemen Dashboard (Design 4: Kanban Workflow)</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0; background: #f4f5f7; color: #333;
        }
        .kanban-container {
            max-width: 1900px; margin: 0 auto; padding: 20px;
        }
        
        /* Header */
        .kanban-header {
            background: linear-gradient(135deg, #6c63ff 0%, #5a52ff 50%, #4c46ff 100%);
            color: white; padding: 24px; border-radius: 12px; margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(108, 99, 255, 0.3);
        }
        .header-top {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .header-title {
            font-size: 28px; font-weight: 700; margin: 0;
        }
        .header-controls {
            display: flex; gap: 12px; align-items: center;
        }
        .control-btn {
            background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.3);
            color: white; padding: 8px 16px; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 500; transition: all 0.2s ease;
        }
        .control-btn:hover { background: rgba(255,255,255,0.3); }
        
        .header-stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 16px;
        }
        .stat-item {
            text-align: center; padding: 12px; background: rgba(255,255,255,0.1);
            border-radius: 8px; backdrop-filter: blur(10px);
        }
        .stat-number {
            font-size: 24px; font-weight: 700; margin-bottom: 4px;
        }
        .stat-label {
            font-size: 12px; opacity: 0.9; text-transform: uppercase;
        }
        
        /* Kanban Board */
        .kanban-board {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px; margin-bottom: 24px;
        }
        
        .kanban-column {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); min-height: 70vh;
            display: flex; flex-direction: column;
        }
        .column-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; padding-bottom: 12px; border-bottom: 2px solid #f1f3f4;
        }
        .column-title {
            font-size: 16px; font-weight: 600; color: #2c3e50;
            display: flex; align-items: center; gap: 8px;
        }
        .column-count {
            background: #6c63ff; color: white; padding: 4px 12px;
            border-radius: 16px; font-size: 12px; font-weight: 600;
        }
        .column-status-indicator {
            width: 12px; height: 12px; border-radius: 50%;
            margin-right: 8px;
        }
        .status-aangemeld .column-status-indicator { background: #ff6b6b; }
        .status-behandeling .column-status-indicator { background: #4ecdc4; }
        .status-uitgezet .column-status-indicator { background: #45b7d1; }
        .status-opgelost .column-status-indicator { background: #96ceb4; }
        
        .cards-container {
            flex: 1; display: flex; flex-direction: column; gap: 12px;
            overflow-y: auto; max-height: 60vh; padding-right: 4px;
        }
        .cards-container::-webkit-scrollbar { width: 6px; }
        .cards-container::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 3px; }
        .cards-container::-webkit-scrollbar-thumb { background: #c1c1c1; border-radius: 3px; }
        .cards-container::-webkit-scrollbar-thumb:hover { background: #a8a8a8; }
        
        /* Kanban Cards */
        .kanban-card {
            background: #fafbfc; border: 2px solid #e1e4e8; border-radius: 8px;
            padding: 16px; cursor: pointer; transition: all 0.3s ease;
            position: relative; overflow: hidden;
        }
        .kanban-card:hover {
            border-color: #6c63ff; box-shadow: 0 8px 24px rgba(108, 99, 255, 0.15);
            transform: translateY(-2px);
        }
        .kanban-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 3px; background: #6c63ff;
        }
        .kanban-card.priority-high::before { background: linear-gradient(90deg, #ff6b6b, #ee5a52); }
        .kanban-card.priority-medium::before { background: linear-gradient(90deg, #ffa726, #ff9800); }
        .kanban-card.priority-low::before { background: linear-gradient(90deg, #66bb6a, #4caf50); }
        
        .card-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 12px;
        }
        .card-id {
            font-size: 11px; color: #6c757d; font-weight: 600;
            background: #e9ecef; padding: 2px 8px; border-radius: 12px;
        }
        .card-age {
            font-size: 10px; color: #868e96;
        }
        .card-age.overdue { color: #dc3545; font-weight: 600; }
        
        .card-title {
            font-size: 14px; font-weight: 600; color: #2c3e50;
            margin-bottom: 8px; line-height: 1.3;
        }
        .card-description {
            font-size: 12px; color: #6c757d; line-height: 1.4;
            margin-bottom: 12px; display: -webkit-box;
            -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        
        .card-footer {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 8px; border-top: 1px solid #e9ecef;
        }
        .card-location {
            font-size: 11px; color: #495057; font-weight: 500;
        }
        .card-category {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 2px 8px; border-radius: 10px;
            font-size: 10px; font-weight: 600;
        }
        
        .card-priority-indicator {
            position: absolute; top: 12px; right: 12px;
            width: 8px; height: 8px; border-radius: 50%;
        }
        .priority-high .card-priority-indicator { background: #ff6b6b; }
        .priority-medium .card-priority-indicator { background: #ffa726; }
        .priority-low .card-priority-indicator { background: #66bb6a; }
        
        /* Quick Actions */
        .quick-actions {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); margin-top: 20px;
        }
        .actions-header {
            font-size: 18px; font-weight: 600; color: #2c3e50;
            margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
        }
        .actions-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .action-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px solid transparent; border-radius: 8px; padding: 16px;
            cursor: pointer; transition: all 0.2s ease; text-align: center;
        }
        .action-card:hover {
            border-color: #6c63ff; background: linear-gradient(135deg, #6c63ff, #5a52ff);
            color: white; transform: translateY(-2px);
        }
        .action-icon {
            font-size: 24px; margin-bottom: 8px;
        }
        .action-title {
            font-size: 14px; font-weight: 600; margin-bottom: 4px;
        }
        .action-subtitle {
            font-size: 12px; opacity: 0.8;
        }
        
        .loading-state {
            display: flex; justify-content: center; align-items: center;
            height: 50vh; flex-direction: column; gap: 16px;
        }
        .loading-spinner {
            width: 48px; height: 48px; border: 4px solid #f3f3f3;
            border-top: 4px solid #6c63ff; border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        
        .empty-column {
            text-align: center; padding: 40px 20px; color: #868e96;
        }
        .empty-icon {
            font-size: 32px; margin-bottom: 12px; opacity: 0.5;
        }
        
        @media (max-width: 1200px) {
            .kanban-board { grid-template-columns: repeat(2, 1fr); }
        }
        
        @media (max-width: 768px) {
            .kanban-board { grid-template-columns: 1fr; }
            .header-top { flex-direction: column; gap: 16px; text-align: center; }
            .header-stats { grid-template-columns: repeat(2, 1fr); }
            .actions-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div id="dashboard-root" class="kanban-container">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Kanban Dashboard wordt geladen...</p>
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

        const KanbanDashboard = () => {
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [selectedCard, setSelectedCard] = useState(null);

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

            const calculatePriority = (problem) => {
                const daysSince = Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24));
                const status = problem.Opgelost_x003f_;
                
                if (status === 'Aangemeld' && daysSince > 14) return 'high';
                if (status === 'Aangemeld' && daysSince > 7) return 'medium';
                if (status === 'In behandeling' && daysSince > 21) return 'high';
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
                            daysSince: Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24)),
                            isOverdue: Math.floor((new Date() - new Date(problem.Aanmaakdatum)) / (1000 * 60 * 60 * 24)) > 30
                        });
                    });
                });
                return problems;
            }, [data]);

            const kanbanColumns = useMemo(() => {
                const columns = {
                    'Aangemeld': { title: 'Nieuw Gemeld', problems: [], class: 'status-aangemeld' },
                    'In behandeling': { title: 'In Behandeling', problems: [], class: 'status-behandeling' },
                    'Uitgezet bij OI': { title: 'Bij Onderzoek', problems: [], class: 'status-uitgezet' },
                    'Opgelost': { title: 'Opgelost', problems: [], class: 'status-opgelost' }
                };

                allProblems.forEach(problem => {
                    const status = problem.Opgelost_x003f_ || 'Aangemeld';
                    if (columns[status]) {
                        columns[status].problems.push(problem);
                    }
                });

                return columns;
            }, [allProblems]);

            const stats = useMemo(() => {
                return {
                    total: allProblems.length,
                    new: kanbanColumns['Aangemeld'].problems.length,
                    inProgress: kanbanColumns['In behandeling'].problems.length,
                    investigating: kanbanColumns['Uitgezet bij OI'].problems.length,
                    resolved: kanbanColumns['Opgelost'].problems.length,
                    overdue: allProblems.filter(p => p.isOverdue && p.Opgelost_x003f_ !== 'Opgelost').length
                };
            }, [allProblems, kanbanColumns]);

            if (loading) {
                return h('div', { className: 'loading-state' },
                    h('div', { className: 'loading-spinner' }),
                    h('p', null, 'Kanban Dashboard wordt geladen...')
                );
            }

            return h('div', null,
                // Header
                h('div', { className: 'kanban-header' },
                    h('div', { className: 'header-top' },
                        h('h1', { className: 'header-title' }, 'Kanban Workflow Dashboard'),
                        h('div', { className: 'header-controls' },
                            h('button', { className: 'control-btn' }, '🔄 Vernieuwen'),
                            h('button', { className: 'control-btn' }, '⚙️ Instellingen'),
                            h('button', { className: 'control-btn' }, '📊 Rapporten')
                        )
                    ),
                    h('div', { className: 'header-stats' },
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.total),
                            h('div', { className: 'stat-label' }, 'Totaal')
                        ),
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.new),
                            h('div', { className: 'stat-label' }, 'Nieuw')
                        ),
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.inProgress),
                            h('div', { className: 'stat-label' }, 'Actief')
                        ),
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.investigating),
                            h('div', { className: 'stat-label' }, 'Onderzoek')
                        ),
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.resolved),
                            h('div', { className: 'stat-label' }, 'Opgelost')
                        ),
                        h('div', { className: 'stat-item' },
                            h('div', { className: 'stat-number' }, stats.overdue),
                            h('div', { className: 'stat-label' }, 'Te Laat')
                        )
                    )
                ),

                // Kanban Board
                h('div', { className: 'kanban-board' },
                    Object.entries(kanbanColumns).map(([status, column]) =>
                        h('div', { key: status, className: `kanban-column ${column.class}` },
                            h('div', { className: 'column-header' },
                                h('div', { className: 'column-title' },
                                    h('div', { className: 'column-status-indicator' }),
                                    column.title
                                ),
                                h('div', { className: 'column-count' }, column.problems.length)
                            ),
                            h('div', { className: 'cards-container' },
                                column.problems.length > 0 ? (
                                    column.problems.map(problem =>
                                        h('div', {
                                            key: problem.Id,
                                            className: `kanban-card priority-${problem.priority}`,
                                            onClick: () => setSelectedCard(problem)
                                        },
                                            h('div', { className: 'card-priority-indicator' }),
                                            h('div', { className: 'card-header' },
                                                h('div', { className: 'card-id' }, `#${problem.Id}`),
                                                h('div', {
                                                    className: `card-age ${problem.isOverdue ? 'overdue' : ''}`
                                                }, `${problem.daysSince}d`)
                                            ),
                                            h('div', { className: 'card-title' },
                                                `${problem.locationTitle} - ${problem.gemeente}`
                                            ),
                                            h('div', { className: 'card-description' },
                                                problem.Probleembeschrijving
                                            ),
                                            h('div', { className: 'card-footer' },
                                                h('div', { className: 'card-location' },
                                                    new Date(problem.Aanmaakdatum).toLocaleDateString('nl-NL')
                                                ),
                                                h('div', { className: 'card-category' },
                                                    problem.Feitcodegroep
                                                )
                                            )
                                        )
                                    )
                                ) : (
                                    h('div', { className: 'empty-column' },
                                        h('div', { className: 'empty-icon' }, '📭'),
                                        h('p', null, 'Geen problemen'),
                                        h('small', null, `in ${column.title.toLowerCase()}`)
                                    )
                                )
                            )
                        )
                    )
                ),

                // Quick Actions
                h('div', { className: 'quick-actions' },
                    h('div', { className: 'actions-header' },
                        h('span', null, '⚡'),
                        'Snelle Acties'
                    ),
                    h('div', { className: 'actions-grid' },
                        h('div', { className: 'action-card' },
                            h('div', { className: 'action-icon' }, '📝'),
                            h('div', { className: 'action-title' }, 'Nieuw Probleem'),
                            h('div', { className: 'action-subtitle' }, 'Voeg probleem toe')
                        ),
                        h('div', { className: 'action-card' },
                            h('div', { className: 'action-icon' }, '🏢'),
                            h('div', { className: 'action-title' }, 'Nieuwe Locatie'),
                            h('div', { className: 'action-subtitle' }, 'Registreer locatie')
                        ),
                        h('div', { className: 'action-card' },
                            h('div', { className: 'action-icon' }, '📊'),
                            h('div', { className: 'action-title' }, 'Rapport Genereren'),
                            h('div', { className: 'action-subtitle' }, 'Exporteer data')
                        ),
                        h('div', { className: 'action-card' },
                            h('div', { className: 'action-icon' }, '🔍'),
                            h('div', { className: 'action-title' }, 'Bulk Bewerken'),
                            h('div', { className: 'action-subtitle' }, 'Massa updates')
                        )
                    )
                )
            );
        };

        const rootElement = document.getElementById('dashboard-root');
        const root = createRoot(rootElement);
        root.render(h(KanbanDashboard));
    </script>
</body>
</html>
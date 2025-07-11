<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 12: Mobile-First</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap');
        * { box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f5f7; }
        #dashboard-root { padding-bottom: 70px; } /* Space for bottom nav */
        .header { background-color: #fff; padding: 15px; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 10; }
        .header h1 { margin: 0; font-size: 1.2em; font-weight: 600; }
        .content { padding: 15px; }
        .card { background-color: #fff; border-radius: 8px; margin-bottom: 10px; padding: 15px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); cursor: pointer; }
        .card-title { font-size: 1.1em; font-weight: 600; margin: 0 0 5px 0; }
        .card-stats { font-size: 0.9em; color: #666; }
        .pleeglocatie-card.has-problems { border-left: 4px solid #e53e3e; padding-left: 11px; }
        .probleem-details { font-size: 0.9em; margin-top: 10px; }
        .bottom-nav { position: fixed; bottom: 0; width: 100%; background-color: #fff; display: flex; justify-content: space-around; padding: 10px 0; box-shadow: 0 -1px 3px rgba(0,0,0,0.1); }
        .nav-item { color: #888; text-decoration: none; text-align: center; font-size: 0.8em; }
        .nav-item.active { color: #007aff; }
        .loading-state { text-align: center; padding: 50px; font-size: 1.2em; }
    </style>
</head>
<body>
    <div id="dashboard-root"></div>

    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
    <script type="module">
        const { createElement: h, useState, useEffect } = window.React;
        const { createRoot } = window.ReactDOM;
        const { DDH_CONFIG } = await import('./js/config/index.js');

        const Dashboard = () => {
            const [view, setView] = useState('gemeenten');
            const [data, setData] = useState([]);
            const [loading, setLoading] = useState(true);
            const [selectedGemeente, setSelectedGemeente] = useState(null);
            const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);

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

            const handleGemeenteClick = (gemeente) => {
                setSelectedGemeente(gemeente);
                setView('pleeglocaties');
            };

            const handlePleeglocatieClick = (pleeglocatie) => {
                setSelectedPleeglocatie(pleeglocatie);
                setView('problemen');
            };

            const getHeaderTitle = () => {
                if (view === 'pleeglocaties') return selectedGemeente;
                if (view === 'problemen') return selectedPleeglocatie.Title;
                return 'Alle Gemeenten';
            }

            if (loading) {
                return h('div', { className: 'loading-state' }, 'Laden...');
            }

            const gemeentenData = data.reduce((acc, item) => {
                const gemeente = item.Gemeente;
                if (!acc[gemeente]) acc[gemeente] = { pleeglocaties: 0, problemen: 0 };
                acc[gemeente].pleeglocaties++;
                acc[gemeente].problemen += item.problemen.length;
                return acc;
            }, {});

            return h('div', null,
                h('header', { className: 'header' }, h('h1', null, getHeaderTitle())),
                h('main', { className: 'content' },
                    view === 'gemeenten' && Object.entries(gemeentenData).map(([gemeente, stats]) => 
                        h('div', { key: gemeente, className: 'card gemeente-card', onClick: () => handleGemeenteClick(gemeente) },
                            h('h2', { className: 'card-title' }, gemeente),
                            h('p', { className: 'card-stats' }, `${stats.pleeglocaties} locaties, ${stats.problemen} problemen`)
                        )
                    ),
                    view === 'pleeglocaties' && data.filter(item => item.Gemeente === selectedGemeente).map(pleeglocatie =>
                        h('div', { key: pleeglocatie.Id, className: `card pleeglocatie-card ${pleeglocatie.problemen.length > 0 ? 'has-problems' : ''}`, onClick: () => handlePleeglocatieClick(pleeglocatie) },
                            h('h2', { className: 'card-title' }, pleeglocatie.Title),
                            h('p', { className: 'card-stats' }, `${pleeglocatie.problemen.length} problemen`)
                        )
                    ),
                    view === 'problemen' && selectedPleeglocatie.problemen.map(probleem => 
                        h('div', { key: probleem.Id, className: 'card probleem-card' },
                            h('h2', { className: 'card-title' }, `Probleem #${probleem.Id}`),
                            h('div', { className: 'probleem-details' },
                                h('p', null, h('strong', null, 'Status: '), probleem.Opgelost_x003f_),
                                h('p', null, h('strong', null, 'Beschrijving: '), probleem.Probleembeschrijving)
                            )
                        )
                    )
                ),
                h('nav', { className: 'bottom-nav' },
                    h('a', { href: '#', className: `nav-item ${view === 'gemeenten' ? 'active' : ''}`, onClick: () => setView('gemeenten') }, 'Gemeenten'),
                    h('a', { href: '#', className: `nav-item ${view === 'pleeglocaties' ? 'active' : ''}`, onClick: () => view === 'problemen' && setView('pleeglocaties') }, 'Locaties'),
                    h('a', { href: '#', className: 'nav-item' }, 'Instellingen')
                )
            );
        };

        const root = createRoot(document.getElementById('dashboard-root'));
        root.render(h(Dashboard));
    </script>
</body>
</html>
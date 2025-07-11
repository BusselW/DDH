<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 13: Creative Freedom</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700&display=swap');
        * { box-sizing: border-box; }
        body { font-family: 'Space Grotesk', sans-serif; margin: 0; background-color: #111; color: #eee; }
        #dashboard-root { min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 20px; }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { font-size: 3em; margin: 0; color: #fff; text-shadow: 0 0 15px rgba(255,255,255,0.3); }
        .main-container { width: 100%; max-width: 900px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .card { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.2); padding: 20px; border-radius: 10px; cursor: pointer; transition: background 0.3s, transform 0.3s; backdrop-filter: blur(10px); }
        .card:hover { background: rgba(255,255,255,0.1); transform: scale(1.05); }
        .card-title { font-size: 1.3em; font-weight: 700; margin: 0 0 10px 0; }
        .card-stats { font-size: 0.9em; opacity: 0.7; }
        .pleeglocatie-card.has-problems .card-title { color: #ff8a8a; }
        .back-button { background: none; border: 1px solid rgba(255,255,255,0.5); color: #fff; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-bottom: 20px; }
        .loading-state { font-size: 1.5em; }
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

            const goBack = () => {
                if (view === 'problemen') setView('pleeglocaties');
                else if (view === 'pleeglocaties') setView('gemeenten');
            };

            if (loading) {
                return h('div', { className: 'loading-state' }, 'Initializing Nexus...');
            }

            const gemeentenData = data.reduce((acc, item) => {
                const gemeente = item.Gemeente;
                if (!acc[gemeente]) acc[gemeente] = { pleeglocaties: 0, problemen: 0 };
                acc[gemeente].pleeglocaties++;
                acc[gemeente].problemen += item.problemen.length;
                return acc;
            }, {});

            return h('div', { className: 'main-container' },
                h('header', { className: 'header' }, h('h1', null, 'DDH Nexus')),
                view !== 'gemeenten' && h('button', { className: 'back-button', onClick: goBack }, '← Back to Overview'),
                h('div', { className: 'grid' },
                    view === 'gemeenten' && Object.entries(gemeentenData).map(([gemeente, stats]) => 
                        h('div', { key: gemeente, className: 'card gemeente-card', onClick: () => handleGemeenteClick(gemeente) },
                            h('h2', { className: 'card-title' }, gemeente),
                            h('p', { className: 'card-stats' }, `${stats.pleeglocaties} nodes, ${stats.problemen} anomalies`)
                        )
                    ),
                    view === 'pleeglocaties' && data.filter(item => item.Gemeente === selectedGemeente).map(pleeglocatie =>
                        h('div', { key: pleeglocatie.Id, className: `card pleeglocatie-card ${pleeglocatie.problemen.length > 0 ? 'has-problems' : ''}`, onClick: () => handlePleeglocatieClick(pleeglocatie) },
                            h('h2', { className: 'card-title' }, pleeglocatie.Title),
                            h('p', { className: 'card-stats' }, `${pleeglocatie.problemen.length} anomalies detected`)
                        )
                    ),
                    view === 'problemen' && selectedPleeglocatie.problemen.map(probleem => 
                        h('div', { key: probleem.Id, className: 'card probleem-card' },
                            h('h2', { className: 'card-title' }, `Anomaly #${probleem.Id}`),
                            h('p', { className: 'card-stats' }, `Status: ${probleem.Opgelost_x003f_}`)
                        )
                    )
                )
            );
        };

        const root = createRoot(document.getElementById('dashboard-root'));
        root.render(h(Dashboard));
    </script>
</body>
</html>
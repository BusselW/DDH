<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 9: Professional Dark</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background-color: #1a1a1a; color: #f0f0f0; }
        .dashboard-container { max-width: 1800px; margin: auto; padding: 20px; }
        .header { background-color: #2c2c2c; padding: 20px; text-align: center; border-bottom: 1px solid #444; margin-bottom: 20px; border-radius: 8px;}
        .header h1 { margin: 0; font-size: 2em; color: #00aaff; }
        .main-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .gemeente-card, .pleeglocatie-card, .probleem-card { background-color: #2c2c2c; border-radius: 8px; padding: 20px; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; border-left: 4px solid #00aaff; }
        .gemeente-card:hover, .pleeglocatie-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5); }
        .pleeglocatie-card.has-problems { border-left-color: #ff4d4d; }
        .card-title { font-size: 1.5em; margin: 0 0 10px 0; color: #00aaff; }
        .card-stats { font-size: 0.9em; color: #ccc; }
        .probleem-details { font-size: 0.9em; margin-top: 15px; }
        .probleem-details p { margin: 5px 0; }
        .back-button { background-color: #00aaff; color: #1a1a1a; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-bottom: 20px; }
        .loading-state { text-align: center; padding: 50px; font-size: 1.5em; }
    </style>
</head>
<body>
    <div id="dashboard-root" class="dashboard-container"></div>

    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
    <script type="module">
        const { createElement: h, useState, useEffect } = window.React;
        const { createRoot } = window.ReactDOM;
        const { DDH_CONFIG } = await import('./js/config/index.js');

        const Dashboard = () => {
            const [view, setView] = useState('gemeenten'); // gemeenten, pleeglocaties, problemen
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
                return h('div', { className: 'loading-state' }, 'Data wordt geladen...');
            }

            return h('div', null,
                h('header', { className: 'header' }, h('h1', null, 'DDH Problemen Dashboard - Dark Mode')),
                view !== 'gemeenten' && h('button', { className: 'back-button', onClick: goBack }, 'Terug'),
                h('div', { className: 'main-grid' }, 
                    view === 'gemeenten' && Object.entries(data.reduce((acc, item) => {
                        const gemeente = item.Gemeente;
                        if (!acc[gemeente]) acc[gemeente] = { pleeglocaties: 0, problemen: 0 };
                        acc[gemeente].pleeglocaties++;
                        acc[gemeente].problemen += item.problemen.length;
                        return acc;
                    }, {})).map(([gemeente, stats]) => 
                        h('div', { key: gemeente, className: 'gemeente-card', onClick: () => handleGemeenteClick(gemeente) },
                            h('h2', { className: 'card-title' }, gemeente),
                            h('p', { className: 'card-stats' }, `${stats.pleeglocaties} pleeglocaties, ${stats.problemen} problemen`)
                        )
                    ),
                    view === 'pleeglocaties' && data.filter(item => item.Gemeente === selectedGemeente).map(pleeglocatie =>
                        h('div', { key: pleeglocatie.Id, className: `pleeglocatie-card ${pleeglocatie.problemen.length > 0 ? 'has-problems' : ''}`, onClick: () => handlePleeglocatieClick(pleeglocatie) },
                            h('h2', { className: 'card-title' }, pleeglocatie.Title),
                            h('p', { className: 'card-stats' }, `${pleeglocatie.problemen.length} problemen`)
                        )
                    ),
                    view === 'problemen' && selectedPleeglocatie.problemen.map(probleem => 
                        h('div', { key: probleem.Id, className: 'probleem-card' },
                            h('h2', { className: 'card-title' }, `Probleem #${probleem.Id}`),
                            h('div', { className: 'probleem-details' },
                                h('p', null, h('strong', null, 'Status: '), probleem.Opgelost_x003f_),
                                h('p', null, h('strong', null, 'Beschrijving: '), probleem.Probleembeschrijving),
                                h('p', null, h('strong', null, 'Aangemaakt op: '), new Date(probleem.Aanmaakdatum).toLocaleDateString('nl-NL'))
                            )
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
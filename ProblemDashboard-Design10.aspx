<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 10: Vibrant Colors</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap');
        * { box-sizing: border-box; }
        body { font-family: 'Nunito', sans-serif; margin: 0; padding: 0 0 60px 0; background-color: #f0f7ff; color: #333; }
        .dashboard-container { max-width: 1800px; margin: auto; padding: 20px; }
        .header { background: linear-gradient(45deg, #ff6b6b, #f9d423); color: white; padding: 20px; text-align: center; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .header h1 { margin: 0; font-size: 2.2em; text-shadow: 1px 1px 2px rgba(0,0,0,0.2); }
        .main-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .gemeente-card, .pleeglocatie-card, .probleem-card { background-color: #fff; border-radius: 12px; padding: 20px; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; box-shadow: 0 4px 10px rgba(0,0,0,0.08); border-top: 5px solid #4facfe; }
        .gemeente-card:hover, .pleeglocatie-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.12); }
        .pleeglocatie-card.has-problems { border-top-color: #ff6b6b; }
        .card-title { font-size: 1.6em; margin: 0 0 10px 0; color: #333; font-weight: 700; }
        .card-stats { font-size: 1em; color: #555; }
        .probleem-details { font-size: 1em; margin-top: 15px; }
        .probleem-details p { margin: 8px 0; }
        .back-button { background: linear-gradient(45deg, #4facfe, #00f2fe); color: white; border: none; padding: 12px 25px; border-radius: 50px; cursor: pointer; margin-bottom: 20px; font-size: 1em; font-weight: 700; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .loading-state { text-align: center; padding: 50px; font-size: 1.5em; color: #555; }
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
        const { TEMP_PLACEHOLDER_DATA } = await import('./js/components/pageNavigation.js');
        const FooterNavigation = (await import('./js/components/FooterNavigation.js')).default;

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
                        console.error('Data loading error, using placeholder data:', error);
                        setData(TEMP_PLACEHOLDER_DATA);
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
                h('header', { className: 'header' }, h('h1', null, 'DDH Dashboard - Vibrant Colors')),
                view !== 'gemeenten' && h('button', { className: 'back-button', onClick: goBack }, '← Terug'),
                h('div', { className: 'main-grid' }, 
                    view === 'gemeenten' && Object.entries(data.reduce((acc, item) => {
                        const gemeente = item.Gemeente;
                        if (!acc[gemeente]) acc[gemeente] = { pleeglocaties: 0, problemen: 0 };
                        acc[gemeente].pleeglocaties++;
                        acc[gemeente].problemen += (item.problemen || []).length;
                        return acc;
                    }, {})).map(([gemeente, stats]) => 
                        h('div', { key: gemeente, className: 'gemeente-card', onClick: () => handleGemeenteClick(gemeente) },
                            h('h2', { className: 'card-title' }, gemeente),
                            h('p', { className: 'card-stats' }, `${stats.pleeglocaties} pleeglocaties, ${stats.problemen} problemen`)
                        )
                    ),
                    view === 'pleeglocaties' && data.filter(item => item.Gemeente === selectedGemeente).map(pleeglocatie =>
                        h('div', { key: pleeglocatie.Id, className: `pleeglocatie-card ${(pleeglocatie.problemen || []).length > 0 ? 'has-problems' : ''}`, onClick: () => handlePleeglocatieClick(pleeglocatie) },
                            h('h2', { className: 'card-title' }, pleeglocatie.Title),
                            h('p', { className: 'card-stats' }, `${(pleeglocatie.problemen || []).length} problemen`)
                        )
                    ),
                    view === 'problemen' && (selectedPleeglocatie.problemen || []).map(probleem => 
                        h('div', { key: probleem.Id, className: 'probleem-card' },
                            h('h2', { className: 'card-title' }, `Probleem #${probleem.Id}`),
                            h('div', { className: 'probleem-details' },
                                h('p', null, h('strong', null, 'Status: '), probleem.Opgelost_x003f_),
                                h('p', null, h('strong', null, 'Beschrijving: '), probleem.Probleembeschrijving),
                                h('p', null, h('strong', null, 'Aangemaakt op: '), new Date(probleem.Aanmaakdatum).toLocaleDateString('nl-NL'))
                            )
                        )
                    )
                ),
                
                // Footer Navigation
                h(FooterNavigation)
            );
        };

        const root = createRoot(document.getElementById('dashboard-root'));
        root.render(h(Dashboard));
    </script>
</body>
</html>
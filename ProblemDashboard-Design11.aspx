<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 11: Newspaper Layout</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Roboto:wght@400&display=swap');
        * { box-sizing: border-box; }
        body { font-family: 'Roboto', sans-serif; margin: 0; background-color: #f8f8f8; color: #333; }
        .dashboard-container { max-width: 1200px; margin: auto; padding: 20px; }
        .header { text-align: center; padding: 20px 0; border-bottom: 3px solid #333; margin-bottom: 20px; }
        .header h1 { font-family: 'Playfair Display', serif; margin: 0; font-size: 3em; }
        .main-content { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        .items-column { display: flex; flex-direction: column; gap: 20px; }
        .details-column { position: sticky; top: 20px; }
        .item-card { background-color: #fff; border: 1px solid #ddd; padding: 15px; cursor: pointer; transition: box-shadow 0.2s; }
        .item-card:hover { box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .item-card.active { border-left: 4px solid #d1a054; }
        .card-title { font-family: 'Playfair Display', serif; font-size: 1.5em; margin: 0 0 10px 0; }
        .card-stats { font-size: 0.9em; color: #666; }
        .details-panel { background-color: #fff; border: 1px solid #ddd; padding: 20px; }
        .details-title { font-family: 'Playfair Display', serif; font-size: 2em; margin: 0 0 15px 0; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .probleem-list li { margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px dotted #ccc; }
        .back-button { font-family: 'Roboto', sans-serif; background: none; border: 1px solid #333; color: #333; padding: 8px 15px; cursor: pointer; margin-bottom: 20px; text-transform: uppercase; font-size: 0.8em; }
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
                        if (result.length > 0) {
                            const gemeenten = Object.keys(result.reduce((acc, item) => { acc[item.Gemeente] = true; return acc; }, {}));
                            setSelectedGemeente(gemeenten[0]);
                        }
                    } catch (error) {
                        console.error('Data loading error:', error);
                    } finally {
                        setLoading(false);
                    }
                };
                fetchData();
            }, []);

            const goBack = () => {
                setSelectedPleeglocatie(null);
            };

            if (loading) {
                return h('div', { className: 'loading-state' }, 'Data wordt geladen...');
            }

            const gemeentenData = data.reduce((acc, item) => {
                const gemeente = item.Gemeente;
                if (!acc[gemeente]) acc[gemeente] = { pleeglocaties: [] };
                acc[gemeente].pleeglocaties.push(item);
                return acc;
            }, {});

            const currentPleeglocaties = selectedGemeente ? (gemeentenData[selectedGemeente]?.pleeglocaties || []) : [];

            return h('div', null,
                h('header', { className: 'header' }, h('h1', null, 'Het DDH Dagblad')),
                h('div', { className: 'main-content' },
                    h('div', { className: 'items-column' },
                        !selectedPleeglocatie && h('h2', { className: 'card-title' }, 'Pleeglocaties in ', selectedGemeente),
                        selectedPleeglocatie && h('button', { className: 'back-button', onClick: goBack }, 'Alle locaties'),
                        !selectedPleeglocatie && currentPleeglocaties.map(pleeglocatie => 
                            h('div', { key: pleeglocatie.Id, className: 'item-card', onClick: () => setSelectedPleeglocatie(pleeglocatie) },
                                h('h3', { className: 'card-title' }, pleeglocatie.Title),
                                h('p', { className: 'card-stats' }, `${(pleeglocatie.problemen || []).length} problemen gemeld`)
                            )
                        ),
                        selectedPleeglocatie && (selectedPleeglocatie.problemen || []).map(probleem => 
                            h('div', { key: probleem.Id, className: 'item-card' },
                                h('h3', { className: 'card-title' }, `Probleem #${probleem.Id}`),
                                h('p', null, h('strong', null, 'Status: '), probleem.Opgelost_x003f_)
                            )
                        )
                    ),
                    h('aside', { className: 'details-column' },
                        h('div', { className: 'details-panel' },
                            !selectedPleeglocatie && h('h2', { className: 'details-title' }, 'Selecteer een locatie'),
                            selectedPleeglocatie && h('div', null, 
                                h('h2', { className: 'details-title' }, selectedPleeglocatie.Title),
                                h('p', null, h('strong', null, 'Contactpersoon: '), selectedPleeglocatie.emailContactpersoon?.Description || 'N/A'),
                                h('h3', { className: 'card-title' }, 'Problemen'),
                                h('ul', { className: 'probleem-list' }, (selectedPleeglocatie.problemen || []).map(p => h('li', {key: p.Id}, p.Probleembeschrijving)))
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
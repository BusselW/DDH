import { DDH_CONFIG } from './config/index.js';
import { ddhDataService } from './dataServices.js';
import { TEMP_PLACEHOLDER_DATA } from './components/pageNavigation.js';
import FooterNavigation from './components/FooterNavigation.js';
import { IconExpand, IconCollapse } from './components/icons.js';

const { createElement: h, useState, useEffect, useCallback } = window.React;
const { createRoot } = window.ReactDOM;

const SubmissionModal = ({ modalConfig, closeModal, onFormSubmit }) => {
    if (!modalConfig) return null;

    const { type, data } = modalConfig;
    const isDH = type === 'dh';
    const title = isDH ? 'Nieuwe Handhavingslocatie' : `Nieuw Probleem voor ${data.Title}`;

    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const submissionData = Object.fromEntries(formData.entries());
        onFormSubmit(type, submissionData);
    };

    return h('div', { className: 'modal-overlay' },
        h('div', { className: 'modal-content' },
            h('form', { onSubmit: handleSubmit },
                h('div', { className: 'modal-header' },
                    h('h2', null, title),
                    h('button', { type: 'button', className: 'modal-close-btn', onClick: closeModal }, '×')
                ),
                isDH ? h(DHFormFields) : h(ProbleemFormFields, { dhData: data }),
                h('div', { className: 'modal-footer' },
                    h('button', { type: 'button', className: 'btn btn-secondary', onClick: closeModal }, 'Annuleren'),
                    h('button', { type: 'submit', className: 'btn btn-primary' }, 'Opslaan')
                )
            )
        )
    );
};

const DHFormFields = () => {
    return h('div', { className: 'form-grid' },
        h('div', { className: 'form-group full-width' },
            h('label', { htmlFor: 'Title' }, 'Titel / Locatie'),
            h('input', { type: 'text', id: 'Title', name: 'Title', required: true })
        ),
        h('div', { className: 'form-group' },
            h('label', { htmlFor: 'Gemeente' }, 'Gemeente'),
            h('input', { type: 'text', id: 'Gemeente', name: 'Gemeente', required: true })
        ),
        h('div', { className: 'form-group' },
            h('label', { htmlFor: 'Feitcodegroep' }, 'Feitcodegroep'),
            h('select', { id: 'Feitcodegroep', name: 'Feitcodegroep' },
                h('option', null, 'Verkeersborden'),
                h('option', null, 'Parkeren'),
                h('option', null, 'Rijgedrag')
            )
        )
    );
};

const ProbleemFormFields = ({ dhData }) => {
    return h('div', { className: 'form-grid' },
        h('div', { className: 'form-group' },
            h('label', { htmlFor: 'Title' }, 'Pleeglocatie'),
            h('input', { type: 'text', id: 'Title', name: 'Title', readOnly: true, value: dhData.Title })
        ),
        h('div', { className: 'form-group' },
            h('label', { htmlFor: 'Gemeente' }, 'Gemeente'),
            h('input', { type: 'text', id: 'Gemeente', name: 'Gemeente', readOnly: true, value: dhData.Gemeente })
        ),
        h('div', { className: 'form-group full-width' },
            h('label', { htmlFor: 'Probleembeschrijving' }, 'Probleembeschrijving'),
            h('textarea', { id: 'Probleembeschrijving', name: 'Probleembeschrijving', required: true })
        ),
        h('div', { className: 'form-group' },
            h('label', { htmlFor: 'Feitcodegroep' }, 'Feitcodegroep'),
            h('select', { id: 'Feitcodegroep', name: 'Feitcodegroep' },
                h('option', null, 'Verkeersborden'),
                h('option', null, 'Parkeren'),
                h('option', null, 'Rijgedrag')
            )
        )
    );
};

const DashboardApp = () => {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [expandedGemeenten, setExpandedGemeenten] = useState(new Set());
    const [expandedLocaties, setExpandedLocaties] = useState(new Set());
    const [modalConfig, setModalConfig] = useState(null);

    const fetchData = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            const result = await DDH_CONFIG.queries.haalAllesMetRelaties();
            setData(result);
        } catch (err) {
            console.error("Fout bij ophalen data, using placeholder data:", err);
            setData(TEMP_PLACEHOLDER_DATA);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchData();
    }, [fetchData]);

    const handleFormSubmit = async (type, submissionData) => {
        console.log("Submitting:", type, submissionData);
        try {
            if (type === 'dh') {
                await ddhDataService.digitaleHandhaving.maakDHLocatieAan(submissionData);
            } else {
                await ddhDataService.problemen.maakProbleemAan(submissionData);
            }
            setModalConfig(null);
            fetchData(); // Refresh data after submission
        } catch (err) {
            console.error("Fout bij opslaan data:", err);
            alert(`Fout bij opslaan: ${err.message}`);
        }
    };

    const toggleGemeente = (gemeente) => {
        const newExpanded = new Set(expandedGemeenten);
        if (newExpanded.has(gemeente)) {
            newExpanded.delete(gemeente);
            // Also collapse all locations in this gemeente
            const newExpandedLocaties = new Set(expandedLocaties);
            data.filter(loc => loc.Gemeente === gemeente).forEach(loc => {
                newExpandedLocaties.delete(loc.Id);
            });
            setExpandedLocaties(newExpandedLocaties);
        } else {
            newExpanded.add(gemeente);
        }
        setExpandedGemeenten(newExpanded);
    };

    const toggleLocatie = (locatieId) => {
        const newExpanded = new Set(expandedLocaties);
        if (newExpanded.has(locatieId)) {
            newExpanded.delete(locatieId);
        } else {
            newExpanded.add(locatieId);
        }
        setExpandedLocaties(newExpanded);
    };

    const renderStatusBadge = (status) => {
        const className = `status-badge status-${(status || '').toLowerCase().replace(/\s+/g, '-')}`;
        return h('span', { className }, status || '-');
    };

    const renderTableRows = () => {
        const rows = [];
        
        // Group data by gemeente
        const dataByGemeente = {};
        data.forEach(dh => {
            const gemeente = dh.Gemeente || 'Onbekend';
            if (!dataByGemeente[gemeente]) {
                dataByGemeente[gemeente] = [];
            }
            dataByGemeente[gemeente].push(dh);
        });

        // Render each gemeente group
        Object.entries(dataByGemeente).forEach(([gemeente, locations]) => {
            const isGemeenteExpanded = expandedGemeenten.has(gemeente);
            const totalProblems = locations.reduce((sum, loc) => sum + (loc.problemen?.length || 0), 0);
            const totalLocations = locations.length;

            // Gemeente header row
            rows.push(h('tr', { 
                key: `gemeente-${gemeente}`, 
                className: 'gemeente-row expandable',
                onClick: () => toggleGemeente(gemeente)
            },
                h('td', { style: { display: 'flex', alignItems: 'center', fontWeight: 'bold', backgroundColor: '#f8f9fa' } }, 
                    h('span', { className: `expander ${isGemeenteExpanded ? 'expanded' : ''}` }, 
                        isGemeenteExpanded ? h(IconCollapse) : h(IconExpand)
                    ),
                    `📍 ${gemeente}`
                ),
                h('td', { style: { backgroundColor: '#f8f9fa', fontWeight: 'bold' } }, `${totalLocations} locaties`),
                h('td', { style: { backgroundColor: '#f8f9fa' } }, ''),
                h('td', { style: { backgroundColor: '#f8f9fa' } }, ''),
                h('td', { style: { backgroundColor: '#f8f9fa', fontWeight: 'bold' } }, `${totalProblems} problemen`),
                h('td', { style: { backgroundColor: '#f8f9fa' } }, '')
            ));

            // Render locations if gemeente is expanded
            if (isGemeenteExpanded) {
                locations.forEach(dh => {
                    const isLocatieExpanded = expandedLocaties.has(dh.Id);
                    const hasProblemen = dh.problemen && dh.problemen.length > 0;

                    // Location row
                    rows.push(h('tr', { 
                        key: dh.Id, 
                        className: `dh-row ${hasProblemen ? 'expandable' : ''}`, 
                        onClick: () => hasProblemen && toggleLocatie(dh.Id)
                    },
                        h('td', { style: { display: 'flex', alignItems: 'center', paddingLeft: '30px' } }, 
                            h('span', { className: `expander ${isLocatieExpanded ? 'expanded' : ''}` }, 
                                hasProblemen ? (isLocatieExpanded ? h(IconCollapse) : h(IconExpand)) : null
                            ),
                            `🏢 ${dh.Title}`
                        ),
                        h('td', null, dh.Gemeente),
                        h('td', null, renderStatusBadge(dh.Status_x0020_B_x0026_S)),
                        h('td', null, dh.Waarschuwingsperiode),
                        h('td', null, dh.problemen?.length || 0),
                        h('td', null, 
                            h('button', { 
                                className: 'btn btn-secondary', 
                                onClick: (e) => {
                                    e.stopPropagation();
                                    setModalConfig({ type: 'probleem', data: dh });
                                }
                            }, 'Nieuw Probleem')
                        )
                    ));

                    // Render problems if location is expanded
                    if (isLocatieExpanded && hasProblemen) {
                        rows.push(h('tr', { key: `ph-${dh.Id}`, className: 'probleem-header-row' },
                            h('td', { colSpan: 6, style: { paddingLeft: '60px' } }, '🔧 Gemelde Problemen')
                        ));
                        dh.problemen.forEach(p => {
                            rows.push(h('tr', { key: `p-${p.Id}`, className: 'probleem-row' },
                                h('td', { style: { paddingLeft: '60px' } }, `⚠️ ${p.Probleembeschrijving}`),
                                h('td', null, p.Feitcodegroep),
                                h('td', null, renderStatusBadge(p.Opgelost_x003f_)),
                                h('td', null, new Date(p.Aanmaakdatum).toLocaleDateString('nl-NL')),
                                h('td', { colSpan: 2 }, '')
                            ));
                        });
                    }
                });
            }
        });
        
        return rows;
    };

    if (loading) {
        return h('div', { className: 'loading-overlay' }, 'Data wordt geladen...');
    }

    if (error) {
        return h('div', { className: 'error-overlay' }, `Fout: ${error}`);
    }

    return h('div', { className: 'ddh-app' },
        h(SubmissionModal, { modalConfig, closeModal: () => setModalConfig(null), onFormSubmit: handleFormSubmit }),
        h('header', { className: 'ddh-header' },
            h('h1', null, 'DDH Unified Dashboard'),
            h('p', null, 'Overzicht van handhavingslocaties en gerelateerde problemen')
        ),
        h('div', { className: 'top-actions' },
            h('button', { 
                className: 'btn btn-primary',
                onClick: () => setModalConfig({ type: 'dh', data: {} })
            }, 'Nieuwe Handhavingslocatie')
        ),
        h('main', { className: 'ddh-content' },
            h('h2', null, 'Handhavingslocaties'),
            h('div', { className: 'data-tabel-container' },
                h('table', { className: 'data-tabel' },
                    h('thead', null, h('tr', null,
                        h('th', null, 'Locatie'),
                        h('th', null, 'Gemeente'),
                        h('th', null, 'Status B&S'),
                        h('th', null, 'Waarschuwing'),
                        h('th', null, 'Problemen'),
                        h('th', null, 'Acties')
                    )),
                    h('tbody', null, renderTableRows())
                )
            )
        ),
        
        // Footer Navigation
        h(FooterNavigation)
    );
};

const rootElement = document.getElementById('ddh-dashboard-root');
const root = createRoot(rootElement);
root.render(h(DashboardApp));

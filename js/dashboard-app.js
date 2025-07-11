/**
 * DDH Dashboard Application
 * Uses the same data service architecture as DDH.aspx
 */

// React is available globally via window
const { createElement: h, useState, useEffect, useCallback } = window.React;
const { createRoot } = window.ReactDOM;

import { createDDHDataService } from './services/ddhDataService.js';
import { createMockDataService } from './services/mockDataService.js';

/**
 * Icon Components
 */
const IconExpand = () => {
    return h('svg', { 
        width: '16', 
        height: '16', 
        viewBox: '0 0 16 16', 
        fill: 'none', 
        xmlns: 'http://www.w3.org/2000/svg' 
    }, 
        h('path', { 
            d: 'M6 12L10 8L6 4', 
            stroke: 'currentColor', 
            strokeWidth: '2', 
            strokeLinecap: 'round', 
            strokeLinejoin: 'round' 
        })
    );
};

const IconCollapse = () => {
    return h('svg', { 
        width: '16', 
        height: '16', 
        viewBox: '0 0 16 16', 
        fill: 'none', 
        xmlns: 'http://www.w3.org/2000/svg' 
    }, 
        h('path', { 
            d: 'M4 6L8 10L12 6', 
            stroke: 'currentColor', 
            strokeWidth: '2', 
            strokeLinecap: 'round', 
            strokeLinejoin: 'round' 
        })
    );
};

/**
 * Modal Component for forms
 */
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

/**
 * Form Fields Components
 */
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
                h('option', { value: 'Verkeersborden' }, 'Verkeersborden'),
                h('option', { value: 'Parkeren' }, 'Parkeren'),
                h('option', { value: 'Rijgedrag' }, 'Rijgedrag')
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
                h('option', { value: 'Verkeersborden' }, 'Verkeersborden'),
                h('option', { value: 'Parkeren' }, 'Parkeren'),
                h('option', { value: 'Rijgedrag' }, 'Rijgedrag')
            )
        )
    );
};

/**
 * Main Dashboard Component
 */
const DashboardApp = ({ config, dataService }) => {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [expandedRows, setExpandedRows] = useState(new Set());
    const [modalConfig, setModalConfig] = useState(null);

    const fetchData = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            console.log('Fetching data using dataService...');
            const result = await dataService.fetchAll();
            console.log('Data fetched successfully:', result);
            setData(result);
        } catch (err) {
            console.error("Fout bij ophalen data:", err);
            setError(err.message || 'Kon data niet laden.');
        } finally {
            setLoading(false);
        }
    }, [dataService]);

    useEffect(() => {
        fetchData();
    }, [fetchData]);

    const handleFormSubmit = async (type, submissionData) => {
        console.log("Submitting:", type, submissionData);
        try {
            if (type === 'dh') {
                await dataService.addDH(submissionData);
            } else {
                await dataService.addProblem(submissionData);
            }
            setModalConfig(null);
            fetchData(); // Refresh data after submission
        } catch (err) {
            console.error("Fout bij opslaan data:", err);
            alert(`Fout bij opslaan: ${err.message}`);
        }
    };

    const toggleRow = (id) => {
        const newExpandedRows = new Set(expandedRows);
        if (newExpandedRows.has(id)) {
            newExpandedRows.delete(id);
        } else {
            newExpandedRows.add(id);
        }
        setExpandedRows(newExpandedRows);
    };

    const renderStatusBadge = (status) => {
        const className = `status-badge status-${(status || '').toLowerCase().replace(/\s+/g, '-')}`;
        return h('span', { className }, status || '-');
    };

    const renderTableRows = () => {
        const rows = [];
        data.forEach(dh => {
            const isExpanded = expandedRows.has(dh.Id);
            const hasProblemen = dh.problemen && dh.problemen.length > 0;

            rows.push(h('tr', { key: dh.Id, className: `dh-row ${hasProblemen ? 'expandable' : ''}`, onClick: () => hasProblemen && toggleRow(dh.Id) },
                h('td', { style: { display: 'flex', alignItems: 'center' } }, 
                    h('span', { className: `expander ${isExpanded ? 'expanded' : ''}` }, 
                        hasProblemen ? (isExpanded ? h(IconCollapse) : h(IconExpand)) : null
                    ),
                    dh.Title
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

            if (isExpanded && hasProblemen) {
                rows.push(h('tr', { key: `ph-${dh.Id}`, className: 'probleem-header-row' },
                    h('td', { colSpan: 6 }, 'Gemelde Problemen')
                ));
                dh.problemen.forEach(p => {
                    rows.push(h('tr', { key: `p-${p.Id}`, className: 'probleem-row' },
                        h('td', null, p.Probleembeschrijving),
                        h('td', null, p.Feitcodegroep),
                        h('td', null, renderStatusBadge(p.Opgelost_x003f_)),
                        h('td', null, new Date(p.Aanmaakdatum).toLocaleDateString('nl-NL')),
                        h('td', { colSpan: 2 }, '')
                    ));
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
            h('h1', null, 'DDH Dashboard'),
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
        )
    );
};

/**
 * Initialize Dashboard Application
 */
export const initDashboardApp = async (config) => {
    try {
        console.log('Initializing DDH Dashboard Application...');
        
        // Check if we're in mock mode (local testing)
        const isMockMode = config.sharepoint?.baseUrl?.includes('localhost') || 
                         config.sharepoint?.baseUrl?.includes('127.0.0.1') ||
                         window.location.hostname === 'localhost' ||
                         window.location.hostname === '127.0.0.1';
        
        // Create data service
        let dataService;
        if (isMockMode) {
            console.log('🧪 Using mock data service for local testing');
            dataService = createMockDataService();
        } else {
            console.log('📡 Using real SharePoint data service');
            dataService = createDDHDataService(config);
        }
        
        // Get root element
        const rootElement = document.getElementById('ddh-dashboard-root');
        if (!rootElement) {
            throw new Error('Root element #ddh-dashboard-root not found');
        }
        
        // Create React root
        const root = createRoot(rootElement);
        
        // Render application
        root.render(
            h(DashboardApp, {
                config: config,
                dataService: dataService
            })
        );
        
        console.log('DDH Dashboard Application initialized successfully');
        
    } catch (error) {
        console.error('Failed to initialize DDH Dashboard Application:', error);
        throw error;
    }
};

export default {
    initDashboardApp,
    DashboardApp
};
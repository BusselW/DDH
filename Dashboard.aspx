<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Dashboard</title>
    
    <!-- SharePoint CSS -->
    <link rel="stylesheet" type="text/css" href="/_layouts/15/1033/styles/themable/corev15.css" />
    
    <!-- Custom CSS (copied from shadowfile) -->
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
            color: #333;
        }
        .ddh-app {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }
        .ddh-header {
            background-color: #005a9e;
            color: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .ddh-header h1 { margin: 0 0 5px 0; font-size: 26px; }
        .ddh-header p { margin: 0; opacity: 0.9; font-size: 14px; }
        .top-actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary { background-color: #0078d4; color: white; }
        .btn-primary:hover { background-color: #005a9e; }
        .btn-secondary { background-color: #e1e1e1; color: #333; border: 1px solid #ccc; }
        .btn-secondary:hover { background-color: #d1d1d1; }
        .ddh-content {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .ddh-content h2 {
            margin: 0;
            padding: 20px;
            font-size: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .ddh-content h2 .hint {
            font-size: 14px;
            font-style: italic;
            font-weight: normal;
            color: #666;
        }

        /* Data tabel */
        .data-tabel-container { overflow-x: auto; }
        .data-tabel { width: 100%; border-collapse: collapse; }
        .data-tabel th, .data-tabel td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; white-space: nowrap; }
        .data-tabel th { background-color: #f8f9fa; font-weight: 600; color: #555; position: sticky; top: 0; }
        .data-tabel tr.dh-row.expandable:hover { background-color: #e9f5ff; cursor: pointer; }
        .data-tabel tr.probleem-row { background-color: #fafafa; }
        .data-tabel tr.probleem-row td { padding-left: 40px; border-color: #f0f0f0; border-left: 4px solid #0078d4; }
        .data-tabel tr.probleem-row:hover { background-color: #f0f0f0; }
        .probleem-header-row { background-color: #f2f2f2; font-weight: bold; color: #444; }
        .probleem-header-row td { padding-top: 10px; padding-bottom: 10px; padding-left: 25px !important; border-left: 4px solid #0078d4; }
        .expander { display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; margin-right: 10px; transition: transform 0.2s ease; }
        .expander svg { width: 100%; height: 100%; }
        .expander.expanded { transform: rotate(0deg); }
        .status-badge { display: inline-block; padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: 600; text-transform: capitalize; }
        .status-aangemeld { background-color: #fff4ce; color: #855e00; }
        .status-in-behandeling { background-color: #cce5ff; color: #004085; }
        .status-uitgezet-bij-oi { background-color: #d4edda; color: #155724; }
        .status-opgelost { background-color: #e2e3e5; color: #383d41; }
        .status-aangevraagd { background-color: #fff4ce; color: #855e00; }
        .status-instemming-verleend { background-color: #d4edda; color: #155724; }
        .modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.6); display: flex; align-items: center; justify-content: center; z-index: 1000; }
        .modal-content { background: white; padding: 30px; border-radius: 8px; width: 90%; max-width: 600px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h2 { margin: 0; font-size: 22px; }
        .modal-close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #888; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { margin-bottom: 5px; font-weight: 600; font-size: 14px; }
        .form-group input, .form-group select, .form-group textarea { padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
        .loading-overlay, .error-overlay { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.8); display: flex; align-items: center; justify-content: center; font-size: 18px; }
    </style>
</head>
<body>
    <div id="ddh-dashboard-root">
        <div class="loading-overlay">DDH Dashboard wordt geladen...</div>
    </div>

    <!-- React en ReactDOM -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

    <!-- Hoofd applicatie script -->
    <script type="module" src="./js/DashboardApp.js"></script>
    
    <noscript>
        <p>JavaScript is vereist om deze applicatie te gebruiken.</p>
    </noscript>
</body>
</html>

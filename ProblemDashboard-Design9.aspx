<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 9: Professional Dark</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #1a1a1a;
            color: #f0f0f0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .header {
            background-color: #2c2c2c;
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #444;
        }
        .header h1 {
            margin: 0;
            font-size: 2em;
            color: #00aaff;
        }
        .navigation {
            background-color: #333;
            padding: 15px 0;
            text-align: center;
        }
        .navigation a {
            color: #f0f0f0;
            text-decoration: none;
            padding: 10px 20px;
            margin: 0 10px;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
        }
        .navigation a:hover, .navigation a.active {
            background-color: #00aaff;
            color: #1a1a1a;
        }
        .container {
            display: flex;
            flex: 1;
        }
        .sidebar {
            width: 250px;
            background-color: #2c2c2c;
            padding: 20px;
            border-right: 1px solid #444;
        }
        .sidebar h2 {
            color: #00aaff;
            border-bottom: 2px solid #00aaff;
            padding-bottom: 10px;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar ul li a {
            display: block;
            color: #f0f0f0;
            text-decoration: none;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 8px;
            transition: background-color 0.3s;
        }
        .sidebar ul li a:hover {
            background-color: #444;
        }
        .main-content {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .card {
            background-color: #2c2c2c;
            border-radius: 10px;
            padding: 30px;
            width: 100%;
            max-width: 800px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            text-align: center;
        }
        .card h2 {
            margin-top: 0;
            font-size: 1.8em;
            color: #00aaff;
        }
        .card p {
            font-size: 1.1em;
            line-height: 1.6;
        }
        .footer {
            background-color: #2c2c2c;
            color: #aaa;
            text-align: center;
            padding: 20px;
            border-top: 1px solid #444;
            font-size: 0.9em;
        }
    </style>
</head>
<body>

    <header class="header">
        <h1>DDH Portaal</h1>
    </header>

    <nav class="navigation">
        <a href="#" class="active">Home</a>
        <a href="#">Problemen</a>
        <a href="#">Rapportages</a>
        <a href="#">Contact</a>
    </nav>

    <div class="container">
        <aside class="sidebar">
            <h2>Navigatie</h2>
            <ul>
                <li><a href="#">Dashboard</a></li>
                <li><a href="#">Mijn Taken</a></li>
                <li><a href="#">Instellingen</a></li>
                <li><a href="#">Help</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <div class="card">
                <h2>Design 9: Professional Dark</h2>
                <p>Dit ontwerp maakt gebruik van een donker thema voor een professionele en moderne uitstraling. Het kleurenschema is rustig voor de ogen en legt de focus op de content.</p>
            </div>
        </main>
    </div>

    <footer class="footer">
        <p>&copy; 2025 DDH. Alle rechten voorbehouden.</p>
    </footer>

</body>
</html>

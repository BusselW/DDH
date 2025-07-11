<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 10: Vibrant Colors</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            background-color: #f4f7f6;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(45deg, #ff6b6b, #f0e68c);
            padding: 20px;
            text-align: center;
            color: white;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .navigation {
            background-color: #fff;
            padding: 15px 0;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .navigation a {
            color: #ff6b6b;
            text-decoration: none;
            padding: 10px 20px;
            margin: 0 10px;
            border-radius: 20px;
            font-weight: bold;
            transition: background-color 0.3s, color 0.3s;
        }
        .navigation a:hover, .navigation a.active {
            background-color: #ff6b6b;
            color: white;
        }
        .container {
            display: flex;
            flex: 1;
        }
        .sidebar {
            width: 250px;
            background-color: #e8f5e9;
            padding: 20px;
            border-right: 1px solid #ddd;
        }
        .sidebar h2 {
            color: #4caf50;
            border-bottom: 2px solid #4caf50;
            padding-bottom: 10px;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar ul li a {
            display: block;
            color: #333;
            text-decoration: none;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 8px;
            transition: background-color 0.3s;
        }
        .sidebar ul li a:hover {
            background-color: #c8e6c9;
        }
        .main-content {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .card {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 30px;
            width: 100%;
            max-width: 800px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .card h2 {
            margin-top: 0;
            font-size: 1.8em;
            color: #ff6b6b;
        }
        .card p {
            font-size: 1.1em;
            line-height: 1.6;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 20px;
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
                <h2>Design 10: Vibrant Colors</h2>
                <p>Dit ontwerp gebruikt een levendig en kleurrijk thema om een energieke en boeiende gebruikerservaring te creëren. De kleuren zijn zorgvuldig gekozen voor een goede leesbaarheid en een positieve uitstraling.</p>
            </div>
        </main>
    </div>

    <footer class="footer">
        <p>&copy; 2025 DDH. Alle rechten voorbehouden.</p>
    </footer>

</body>
</html>

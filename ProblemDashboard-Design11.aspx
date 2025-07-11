<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 11: Newspaper Layout</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Georgia', serif;
            margin: 0;
            background-color: #fdfdfd;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .header {
            background-color: #fff;
            padding: 20px;
            text-align: center;
            border-bottom: 3px solid #333;
        }
        .header h1 {
            margin: 0;
            font-family: 'Playfair Display', serif;
            font-size: 3em;
            font-weight: 900;
        }
        .navigation {
            background-color: #333;
            padding: 10px 0;
            text-align: center;
        }
        .navigation a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            margin: 0 10px;
            font-family: 'Helvetica Neue', sans-serif;
            font-size: 0.9em;
            text-transform: uppercase;
        }
        .container {
            display: flex;
            flex: 1;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .main-content {
            flex: 3;
            padding-right: 20px;
        }
        .sidebar {
            flex: 1;
            background-color: #fff;
            padding: 20px;
            border-left: 1px solid #ddd;
        }
        .article {
            background-color: #fff;
            padding: 20px;
            margin-bottom: 20px;
        }
        .article h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2em;
            margin-top: 0;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .article p {
            line-height: 1.7;
            text-align: justify;
        }
        .sidebar h3 {
            font-family: 'Helvetica Neue', sans-serif;
            text-transform: uppercase;
            border-bottom: 2px solid #333;
            padding-bottom: 5px;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar ul li a {
            text-decoration: none;
            color: #555;
            padding: 8px 0;
            display: block;
            border-bottom: 1px dotted #ccc;
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
        <h1>Het DDH Nieuws</h1>
    </header>

    <nav class="navigation">
        <a href="#">Home</a>
        <a href="#">Binnenland</a>
        <a href="#">Buitenland</a>
        <a href="#">Economie</a>
        <a href="#">Sport</a>
    </nav>

    <div class="container">
        <main class="main-content">
            <section class="article">
                <h2>Design 11: Krantenstijl</h2>
                <p>Dit ontwerp imiteert de lay-out van een krant, met een focus op typografie en een gestructureerde, redactionele stijl. De content is georganiseerd in artikelen en kolommen voor een klassieke en leesbare presentatie.</p>
                <p>De keuze voor lettertypes zoals Georgia en Playfair Display versterkt het traditionele gevoel, terwijl de duidelijke hiërarchie zorgt voor een overzichtelijke pagina.</p>
            </section>
        </main>

        <aside class="sidebar">
            <h3>Categorieën</h3>
            <ul>
                <li><a href="#">Technologie</a></li>
                <li><a href="#">Gezondheid</a></li>
                <li><a href="#">Wetenschap</a></li>
                <li><a href="#">Opinie</a></li>
            </ul>
        </aside>
    </div>

    <footer class="footer">
        <p>&copy; 2025 DDH. Alle rechten voorbehouden.</p>
    </footer>

</body>
</html>

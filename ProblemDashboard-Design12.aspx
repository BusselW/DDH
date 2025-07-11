<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 12: Mobile-First</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background-color: #f0f2f5;
            color: #333;
        }
        .header {
            background-color: #fff;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        .header h1 {
            margin: 0;
            font-size: 1.5em;
            color: #007bff;
        }
        .main-content {
            padding: 80px 15px 80px 15px;
        }
        .card {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
        }
        .card h2 {
            margin-top: 0;
            font-size: 1.2em;
            color: #007bff;
        }
        .card p {
            line-height: 1.6;
        }
        .bottom-nav {
            position: fixed;
            bottom: 0;
            width: 100%;
            background-color: #fff;
            display: flex;
            justify-content: space-around;
            padding: 10px 0;
            box-shadow: 0 -2px 4px rgba(0,0,0,0.1);
        }
        .bottom-nav a {
            color: #007bff;
            text-decoration: none;
            text-align: center;
            padding: 5px;
            flex-grow: 1;
        }
        .bottom-nav a.active {
            color: #0056b3;
        }
        /* Desktop styles */
        @media (min-width: 768px) {
            body {
                display: flex;
            }
            .header {
                position: static;
                width: auto;
                box-shadow: none;
            }
            .sidebar {
                width: 250px;
                background-color: #e9ecef;
                padding: 20px;
                height: 100vh;
            }
            .main-content {
                flex: 1;
                padding: 40px;
            }
            .bottom-nav {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- This is a placeholder for desktop view sidebar -->
    <div class="sidebar" style="display: none;">
        <h2>Desktop Navigatie</h2>
    </div>

    <div style="flex: 1;">
        <header class="header">
            <h1>DDH Portaal</h1>
        </header>

        <main class="main-content">
            <div class="card">
                <h2>Design 12: Mobile-First</h2>
                <p>Dit ontwerp is primair ontwikkeld voor mobiele apparaten. De lay-out is vloeibaar en past zich aan grotere schermen aan (responsive design). De navigatie bevindt zich aan de onderkant voor eenvoudige bediening met de duim.</p>
            </div>
        </main>

        <nav class="bottom-nav">
            <a href="#" class="active">Home</a>
            <a href="#">Taken</a>
            <a href="#">Notificaties</a>
            <a href="#">Profiel</a>
        </nav>
    </div>

</body>
</html>

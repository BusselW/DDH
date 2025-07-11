<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDH Portal - Design 13: Creative Freedom</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: #111;
            color: #fff;
            overflow-x: hidden;
        }
        .container {
            display: grid;
            grid-template-columns: 1fr;
            min-height: 100vh;
        }
        .main-content {
            padding: 5vw;
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: radial-gradient(circle, rgba(63,94,251,0.1) 0%, rgba(252,70,107,0.1) 100%);
        }
        h1 {
            font-size: calc(3rem + 3vw);
            margin: 0;
            font-weight: 600;
            letter-spacing: 2px;
            text-shadow: 0 0 10px rgba(255,255,255,0.2), 0 0 20px rgba(255,255,255,0.2);
        }
        p {
            font-size: calc(1rem + 0.5vw);
            max-width: 600px;
            margin: 20px 0 40px 0;
            font-weight: 300;
            line-height: 1.6;
        }
        .cta-button {
            background: linear-gradient(45deg, #fc466b, #3f5efb);
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .cta-button:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .shape {
            position: absolute;
            background: linear-gradient(45deg, #3f5efb, #fc466b);
            border-radius: 50%;
            opacity: 0.1;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="container">
        <main class="main-content">
            <h1>Design 13</h1>
            <p>Een creatieve en dynamische benadering van de portal interface. Dit ontwerp breekt met de traditionele lay-out en focust op een visueel aantrekkelijke en meeslepende ervaring.</p>
            <a href="#" class="cta-button">Ontdek Meer</a>
        </main>
    </div>

    <script>
        // Add some dynamic shapes for visual effect
        const main = document.querySelector('.main-content');
        for (let i = 0; i < 10; i++) {
            const shape = document.createElement('div');
            shape.classList.add('shape');
            const size = Math.random() * 200 + 50;
            shape.style.width = `${size}px`;
            shape.style.height = `${size}px`;
            shape.style.top = `${Math.random() * 100}%`;
            shape.style.left = `${Math.random() * 100}%`;
            main.appendChild(shape);
        }
    </script>

</body>
</html>

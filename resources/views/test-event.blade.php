<!DOCTYPE html>
<html>
<head>
    <title>Event Test</title>
</head>
<body>
    <h1>Event Listener Test</h1>
    <div id="output"></div>

    <script src="{{ asset('js/app.js') }}"></script>
    <script>
        // Listen for the event
        Echo.channel('my-channel')
            .listen('.my-event', (data) => {
                console.log('Event received:', data);
                document.getElementById('output').innerHTML += 
                    `<p>${data.message} at ${new Date().toLocaleTimeString()}</p>`;
            });
        
        console.log('Listening for events...');
    </script>
</body>
</html>
# Control Panel

## Start the websockets server

Start one terminal and run the following command:

```bash
python debug_server.py 8765
```

Then start another terminal and run the following command:

```bash
python debug_server.py 8766
```

## Launch the app

Change directory to the root of the project:

```bash
cd src/control_panel
```

Then run the following command:

```bash
flutter run -d chrome
```

## Build to launch locally

build the project for web:

```bash
flutter build web
```

Then run the following command:

```bash
python -m http.server 8000 --directory build/web
```

Then open your browser and go to the following URL:

```bash
http://localhost:8000
```

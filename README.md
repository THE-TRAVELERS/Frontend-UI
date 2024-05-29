# TRAVELERS Control Panel

> This repository contains the source code for the UI of the command board.

![Demo](/assets/img/presentation.jpg)

## Introduction

This control panel serves the project TRAVELERS to display and monitor the data of the different sensors of the project (camera, temperature, humidity, etc.). It is a Flutter application that can be run on web for now but could be extended to other platforms (if the libraries used are available on these platforms).

## Installation

### Prerequisites

Tu build and run the project, you need to have Flutter installed on your machine. You can follow the instructions on the [official website](https://flutter.dev/docs/get-started/install).

Be sure to have Google Chrome installed on your machine.

Finally, run the following command to encure the Flutter web support is enabled:

```bash
flutter doctor
```

You may ignore the warnings about the Android and iOS tools if you are not planning to run the app on these platforms.

### Install

To install the project, download the project from GitHub or clone it using the following command:

```bash
git clone https://github.com/THE-TRAVELERS/Frontend-UI.git
```

Then, navigate to the project directory and run the following command to install the dependencies:

```bash
cd Frontend-UI/src/control_panel
flutter pub get
```

## Usage

### Build & Run

To build and run the project, run the following command (considering you are in the project directory `Frontend-UI/src/control_panel`):

```bash
flutter run -d chrome
```

It should download the web sdk and create a `web` directory in the project containing the basic toolkit to run the app on the web.

> [!WARNING]
> If you see an error or no results, consider checking that you opened chrome beforehand.

### Build the Web App

We start by the configuration:

```bash
flutter config --enable-web
```

Then we add the web support (if you do not see the `web` directory in the project) by running the following command:

```bash
flutter create .
```

To build the web app, run the following command:

```bash
flutter build web
```

Then run the following command to serve the web app locally:

```bash
python -m http.server 8000 --directory build/web
```

Finally, open your browser and go to this URL: [`http://localhost:8000`](http://localhost:8000).

### Start dummy websockets

You may start dummy websockets to simulate the data sent by the sensors. To do so, open a terminal and run the following command:

```bash
python debug_server.py 8765
```

To open multiple websockets, just open another terminal and change the port number, like so:

```bash
python debug_server.py 8766
```

### Start the raspberry pi health server

To start the server that will send the health data of the raspberry pi, run the following command:

```bash
python rasp_server.py --cpu-temp-port 8768 --cpu-usage-port 8769 --ram-usage-port 8770
```

### Troubleshooting

If you encouter the issue `Missing index.html.`, you can run the following command to fix it:

```bash
flutter channel beta
flutter upgrade
flutter config --enable-web
```

This will switch to the beta channel, upgrade the Flutter SDK and enable the web support.

Finally run again:

```bash
flutter create .
flutter build web
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

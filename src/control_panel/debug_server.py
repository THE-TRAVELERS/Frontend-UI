import argparse
import asyncio
import websockets
from websockets.exceptions import ConnectionClosed

client_id = 0

async def runner(websocket):
    global client_id
    client_id += 1
    current_client_id = client_id
    print(f"New client connected: {current_client_id}")
    iterateur = 0
    try:
        while True:
            await websocket.send(str(iterateur))
            await asyncio.sleep(1)
            print(iterateur)
            iterateur += 1
    except ConnectionClosed:
        print(f"Client {current_client_id} disconnected")

async def main(port):
    async with websockets.serve(runner, "localhost", port):
        await asyncio.Future()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Start a WebSocket server.")
    parser.add_argument("port", type=int, help="The port number to listen on.")
    args = parser.parse_args()

    try:
        print(f"Server started on: ws://localhost:{args.port}. Press Ctrl+C to stop.\n")
        asyncio.run(main(args.port))
    except KeyboardInterrupt:
        print("\nServer stopped by user.")
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

async def main():
    async with websockets.serve(runner, "localhost", 8765):
        await asyncio.Future()

if __name__ == "__main__":
    try:
        print("Server started on: ws://localhost:8765. Press Ctrl+C to stop.\n")
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nServer stopped by user.")
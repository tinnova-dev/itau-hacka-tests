import dto.message_request
import uvicorn
from fastapi import FastAPI, Query
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from dto.message_request import MessageRequest
from ai_service import new_message

app = FastAPI()

@app.post("/message")
async def send_aog_message(request: MessageRequest):
    message_response = new_message(request=request)
    return JSONResponse(content=jsonable_encoder(message_response))

def run():
    uvicorn.run(app, host="localhost", port=8005)

run()
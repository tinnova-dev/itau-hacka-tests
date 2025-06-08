import uvicorn
from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from dto.generate_test_env_request import GenerateTestEnvRequest
from env_engine import process

app = FastAPI()

@app.post("/generate")
async def send_aog_message(request: GenerateTestEnvRequest):
    message_response = process(request=request)
    return JSONResponse(content=jsonable_encoder(message_response))

def run():
    uvicorn.run(app, host="localhost", port=8006)

run()
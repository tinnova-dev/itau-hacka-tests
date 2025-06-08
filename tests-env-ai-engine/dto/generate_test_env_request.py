from pydantic import BaseModel

class GenerateTestEnvRequest(BaseModel):
    app_name: str
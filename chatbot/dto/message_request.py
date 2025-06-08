from pydantic import BaseModel

class MessageRequest(BaseModel):
    content: str
    chat_id: str
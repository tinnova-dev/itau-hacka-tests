from typing import Sequence

from langchain_core.messages import BaseMessage
from langgraph.graph.message import add_messages
from typing_extensions import Annotated, TypedDict
from langgraph.graph import START, MessagesState, StateGraph
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.messages import AIMessage
from langchain_core.messages import HumanMessage
from langchain.chat_models import init_chat_model
from dto.message_request import MessageRequest

class State(TypedDict):
    messages: Annotated[Sequence[BaseMessage], add_messages]
    language: str

workflow = StateGraph(state_schema=State)


model = init_chat_model("gemma2-9b-it", model_provider="groq", api_key="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")

# Define the function that calls the model
def call_model(state: MessagesState):
    response = model.invoke(state["messages"])
    return {"messages": response}


workflow.add_edge(START, "model")
workflow.add_node("model", call_model)

memory = MemorySaver()
app = workflow.compile(checkpointer=memory)


def new_message(request: MessageRequest) -> str:
    config = {"configurable": {"thread_id": request.chat_id}}
    input_messages = [HumanMessage(request.content)]
    output = app.invoke({"messages": input_messages}, config)
    output["messages"][-1].pretty_print()  # output contains all messages in state
    return output["messages"][-1]  # Return the last message, which is the AI's response

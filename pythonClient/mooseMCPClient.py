from langchain_mcp_adapters.client import MultiServerMCPClient
from langgraph.prebuilt import create_react_agent
from langchain_groq import ChatGroq

from dotenv import load_dotenv
load_dotenv()

import asyncio

global agent

# ----------------------------------------------------------------------------
async def mcp_question(quest : str) -> str:
    """Send a question to the LLM server and return the answer"""

#    print(f"Question: {quest}")
    moose_answer = await agent.ainvoke( {"messages" : [{"role": "user", "content": quest}]} )

    return moose_answer["messages"][-1].content

# ----------------------------------------------------------------------------
async def interaction_loop():
    """Interaction loop with user
     - Get question from user
     - Send it to the LLM server
     - Get the answer from the LLM server
     - Print answer"""

    while True:
        print("=========================================================================")
        question = input("Question: ")
        if (question == "quit"): break
        moose_answer = await agent.ainvoke( {"messages" : [{"role": "user", "content": question}]} )
        llm_answer = moose_answer["messages"][-1].content
        print(f"Answer: {llm_answer}")

    return

# ----------------------------------------------------------------------------
async def main():
    """Main function
     - Create connection to the LLM server
     - Register the MCP tools
     - Start interaction loop with user
    """

    global agent

    server_configs = {
        "MathServer": { "command": ".venv/bin/python", "args": ["./mathServer.py"], "transport": "stdio" },
        "MooseMCPServer": { "command": ".venv/bin/python", "args": ["./mooseMCPServer.py"], "transport": "stdio" },
#        "MyWeatherServer": { "transport": "streamable_http", "url": "http://localhost:4444" }
    }
    client=MultiServerMCPClient(server_configs)

    import os
    os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")

    tools=await client.get_tools()
    model=ChatGroq(model="qwen/qwen3-32b")

    agent = create_react_agent(model,tools)

    await interaction_loop()

# ----------------------------------------------------------------------------
if __name__ == "__main__":
    asyncio.run(main())

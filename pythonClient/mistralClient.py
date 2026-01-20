import asyncio
from openai import OpenAI
import json
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client
import logging

logging.basicConfig(filename="mooseMCP.log", level=logging.CRITICAL)
logger = logging.getLogger("mistralClient")


# --------------------------------------------------------------------------

def mcp_tools_to_openai(tools):
  openai_tools = []
  for tool in tools:
    openai_tools.append({
      "type": "function",
      "function": {
        "name": tool.name,
        "description": tool.description or "",
        "parameters": tool.inputSchema,
      }
    })
  return openai_tools

# ----------------------------------------------------------------------------
def ask_llm(openAI, llm, tools, message) :

    logger.debug("Asking model:%s/", message)
    response = openAI.chat.completions.create(
      model = llm,
      messages = message,
      tools = tools,
      tool_choice = "force",
      temperature = 0.2,
#      top_p = 0.9,
#      max_tokens = 512,
#      presence_penalty = 0.5
#      frequency_penalty = 0.3
    )
    return response


# ----------------------------------------------------------------------------
async def call_tools(mcp_session, tool_calls) :
  answer = []

  for tool in tool_calls :
    logger.debug("tool call:%s/", str(tool))
    tool_answer = await mcp_session.call_tool(
      tool.function.name,
      json.loads(tool.function.arguments),
    )
    logger.debug("tool answer:%s/", str(tool_answer))

    answer.append({
      "role": "tool",
      "tool_name": tool.function.name,
      "content": str(tool_answer),
    })

  return answer

# ----------------------------------------------------------------------------
async def interaction_loop(mcp_session, openAI, tools):
  """Interaction loop with user
   - Get question from user
   - Send it to the LLM server
   - Get the answer from the LLM server (should ask for tool calls)
   - call the tools
   - Send the tool(s) answer(s) back to the LLM
   - Print final answer"""

  llm = "llama3.1:8b"
#  llm = "mistral"

  while True :

    print("\n=========================================================================")

#    question = input("Question: ")
    question = "what are the packages in the project"
    if (question == "quit") :
      break

#        { "role": "system", "content": "You are an AI agent. You MUST call the provided tools to answer questions. Do not compute answers yourself. Always wait for tool results before responding." },
    message = [
        {"role": "user", "content": question }
    ]
    response = ask_llm(openAI, llm, tools, message)

    llm_answer = response.choices[0].message
    logger.debug("Model answer:%s/", str(llm_answer))

    # did model require tool(s)
    if not llm_answer.tool_calls :
      "if not, give answer directly"
      print("Answer:", message.content)
    else:
      "if it did, call tool(s) and send answers back to model"
      message.append(llm_answer)

      response = await call_tools(mcp_session, llm_answer.tool_calls)
      for tool_answer in response :
        message.append(tool_answer)

      # Send tool result back to model
      logger.debug("tool answer to LLM:%s/", message)
      final = openAI.chat.completions.create(
        model = llm,
        messages = message,
      )

      print("Answer:%s/", final.choices[0].message.content)

    return

# ---------------------------------------------------------------------------

async def main():
  """Main function
   - Create connection to the LLM server
   - Register the MCP tools
   - Start interaction loop with user"""

  # 1. Start MCP server process
  server_params = StdioServerParameters(
    command=".venv/bin/python",
    args=["mooseMCPServer.py"],
  )

  async with stdio_client(server_params) as (read, write):
    async with ClientSession(read, write) as mcp_session:
      await mcp_session.initialize()

      # 2. Get MCP tools in OpenAI-style schema
      list_tools_result = await mcp_session.list_tools()
      tools = mcp_tools_to_openai(list_tools_result.tools)

      # 3. Local LLM via Ollama (OpenAI-compatible)
      openAI = OpenAI(
        base_url="http://localhost:11434/v1",
        api_key="ollama",  # dummy value, not used
      )

      # 4. Interaction loop
      await interaction_loop(mcp_session, openAI, tools)

# ----------------------------------------------------------------------------
if __name__ == "__main__":
  asyncio.run(main())

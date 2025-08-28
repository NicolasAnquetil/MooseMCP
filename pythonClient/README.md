This is a (python) client for the MooseMCP server

To run it just do: `pyton mooseMCPClient.py`
It assumes there is a MooseMCP server listening on 127.0.0.1:4444

# Installing

- Download the directory
- initialize the project with `uv venv`
- download requirements: `uv add -r requirements.txt`
- activate it with `source .venv/bin/activate`
- You must create a `.env` file declaring what is your GROQ API key:
  `GROQ_API_KEY="... put your GROQ API key here ..."`

# Running

The MooseMCP server must be running on 127.0.0.1:4444
Look at the instruction on the pharo image to understand how to do that

The client is just a loop interaction with the user asking for a question and passing it to qwen LLM that will handle it with the help of the MooseMCP server.

You can finish it with the `quit` instruction ("question")
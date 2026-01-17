This is an implementation of a [Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro) server for Moose.
Using it, LLM clients can query a Moose model

The Pharo part does not actually implement the MCP protocol.
It implements a [JSON-RPC](https://en.wikipedia.org/wiki/JSON-RPC) server that answers to a python MCP server.
The python code is in the `pythonClient` directory (which is a *client* to the Moose JSON-RPC server, but acts as a *MCP server* for the LLM :wink:)

Currently the TCP port used by moose image and pythonClient is hard coded (port: 4444).
This is in `pythonClient/mooseMCPServer.py` and and `MMCPServer >> defaultPort`.

# Using it

There are two main files:
- `mooseMCPClient.py`: an end user tool that launchs a MCP server and a LLM;
- `mooseMCPServer.py`: a MCP server that forwards the LLM queries to the Moose server.

There is an additional `mathServer.py` to add "mathematical capabilities" to the LLM (comparing numbers, summing them,...).
It could/should be integrated into `mooseMCPClient.py`.

The overall interaction is the following:
1. EndUser launches the Moose image. Moose must have a Famix model of a project.
1. EndUser starts the MCP server in Moose
```st
server := MMCPToolServer new mooseModel: <the-moose-model> ; yourself.
server start.
```
1. EndUser starts the `mooseMCPClient.py` (with python).
2. `mooseMCPClient.py` starts the `mooseMCPServer.py` and the LLM;
  Some API key might be needed to use the LLM;
3. `mooseMCPClient.py` asks for the list of "MCP tools" that the `mooseMCPServer.py` offers.
  Each MCP tool is declared as a python function in the `mooseMCPServer.py` file and calls a method of the Moose server (through JSON-RPC);
4. `mooseMCPClient.py` registers the `mooseMCPServer.py` and the list of its MCP tools in the LLM;
5. `mooseMCPClient.py` starts an interaction loop with the user:
   - EndUser asks a question;
   - `mooseMCPClient.py` forwards the question to the LLM;
   - LLM decides what MCP tools it needs and calls them in the `mooseMCPServer.py`;
   - `mooseMCPServer.py` forwards the calls to the Moose JSON-RPC server;
   - answer is returned to the EndUser.

<img width="618" height="695" alt="pharo-jrcp-uml of the use of the Moose MCP server" src="resources/mcp-server.svg" />

# PythonClient

This is a standard python project adapted from an MCP example on the web.

Python environement configuration:
```sh
$ uv init [optional if .lock already exists]
$ uv venv
$ uv add -r requirements.txt
```




This is an implementation of a [Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro) server for Moose.
Using it, LLM clients can query a Moose model

The Pharo part does not actually implement the MCP protocol.
It implements only a JRCP server than answers to a python MCP server.
The python code is in the `pythonClient` directory (which is a *client* to the Moose JRCP server, but acts as a *MCP server* for the LLM :wink:)

# PythonClient

There two main files:
- `mooseMCPClient.py`: an end user tool that launchs a MCP server and a LLM;
- `mooseMCPServer.py`: a MCP server that forwards the LLM queries to the Moose server.
  Note that the Moose JRCP server must be started beforehand.

The overall interaction is the following:
- End User starts the Moose server. Moose must have a Famix model of a project.
- End User starts the `mooseMCPClient.py`
- `mooseMCPClient.py` starts the `mooseMCPServer.py` and the LLM
- `mooseMCPClient.py` asks for the list of "MCP tools" that the `mooseMCPServer.py` can offer.
  Each MCP tool is declared as a python function in the `mooseMCPServer.py` file and actually calls a method of the Moose server.
- `mooseMCPClient.py` registers the `mooseMCPServer.py` and the list of its MCP tools into the LLM
- `mooseMCPClient.py` starts an interaction loop with the user
  - End User asks a question
  - `mooseMCPClient.py` forwards the qustion to the LLM
  - LLM decide what MCP tool it needs and calls it (in the `mooseMCPServer.py`)
  - `mooseMCPServer.py` forwards the call to Moose JRCP server
  - answer is returned to the End User

<img width="618" height="695" alt="image" src="https://github.com/user-attachments/assets/7facd347-60fc-456f-8716-8f8295029a5b" />

# JRPC server

For reference, this is the UML sequence diagram of how a JRPC server works in Pharo:
<img width="1380" height="997" alt="pharo-jrcp-uml" src="https://github.com/user-attachments/assets/2d7f6f9e-1a08-4537-9f01-f9f2e6dbadfe" />

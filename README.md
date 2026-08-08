This is a [Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro) server for Moose.
Using it, LLM clients can query a Moose model

It is an extension of the Pharo [MCP server](https://github.com/Evref-BL/mcp) adding tools to query a Moose model.

# Install

To install:
```st
Metacello new
   baseline: 'MooseMCP';
   repository: 'github://NicolasAnquetil/MooseMCP';
   load.
```

# Running

The instructions for running it are the same as for Pharo MCP:
```st
mcp := MCP new.
mcp port: 4000.
mcp start.
```
Additionaly the MooseMCP tools have to be recorded in the MCPToolRegistry.
This is a temporary step that should be removed in the future):
```st
MMCPTool withAllSubclasses do: [ :c |
	c isAbstract ifFalse: [ mcp toolRegistry registerToolClass: c] ].
```

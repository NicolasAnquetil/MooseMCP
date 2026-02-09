"
This parser reads the tool description in file 'mooseMCPServer.py' and writes it as a prompt for LLM

use it with:
```st
ToolDeclarationParser new runOn: '/.../mooseMCPServer.py'
```
"
Class {
	#name : 'ToolDeclarationParser',
	#superclass : 'ToolDeclarationGrammar',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

"
I am an MCP server that provides some services on a MooseModel
I wait for commands on a TCP socket and answer them

To use just do:
- load a model in Moose
```
server := MMCPServer new.
server start.
```

"
Class {
	#name : 'MMCPServer',
	#superclass : 'JRPCTCPServer',
	#instVars : [
		'mooseModel'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'defaults' }
MMCPServer class >> defaultPort [

	^ 4444
]

{ #category : 'commands-server' }
MMCPServer >> commandMooseMCPServerVersion [

	<jrpc: #'command:version'>

	^ '0.1.0'
]

{ #category : 'commands-server' }
MMCPServer >> commandPharoQuit [

	<jrpc: #command:pharoQuit>

	SmalltalkImage current snapshot: true andQuit: true
]

{ #category : 'commands-server' }
MMCPServer >> commandServerStop [

	<jrpc: #command:serverStop>

	self log: 'command:serverStop'.

	self stop
]

{ #category : 'accessing' }
MMCPServer >> defaultMooseModel [

	^MooseModel root allModels anyOne
]

{ #category : 'utilities' }
MMCPServer >> handlers [

	^self messageProcessor handlers collect: #methodName
]

{ #category : 'initialization' }
MMCPServer >> initialize [ 

	super initialize.

	self port: self defaultPort.
	self addHandlersFromPragmasIn: self.

	self mooseModel: self defaultMooseModel.

	self resetLog.
]

{ #category : 'commands-server' }
MMCPServer >> initializeProtocol: protocolVersion capabilities: capabilities client: clientInfo [

	"MCP initialization message:

	{
		""method"":""initialize"",
			""params"":{
				""protocolVersion"":""2025-06-18"",
				""capabilities"":{},
				""clientInfo"":{
					""name"":""mcp"",
					""version"":""0.1.0""
				}
			},
		""jsonrpc"":""2.0"",
		""id"":0
	}"

	<jrpc: #initialize>

	self log: (
		'initialize connection:' , protocolVersion asString ,
		' capabilities:' , capabilities asString ,
		' clientInfo:' , clientInfo asString).

	^ '{"protocolVersion":"2025-06-18","capabilities":{"tools":{}},"serverInfo":{"name":"mooseMCP","version":"0.1.0"}}, "jsonrpc":"2.0"}'



]

{ #category : 'commands-list' }
MMCPServer >> listEntitiesForType: aName [

	<jrpc: #list:entitiesForType>

	self log: ('list:entitiesForType: ' , aName).

	^mooseModel metamodel classes
		detect: [ :c | c name = aName ]
		ifOne: [ :fmClass |
			(mooseModel allWithType: fmClass implementingClass) collect: #mooseName
		]
		ifNone: [ #() ]

]

{ #category : 'commands-list' }
MMCPServer >> listEntityChildren: aFamixEntityName [

	<jrpc: #list:entityChildren>

	self log: ('list:entityChildren for ', aFamixEntityName).

	^(mooseModel entityNamed: aFamixEntityName ifAbsent: [^#()])
		children collect: #mooseName
]

{ #category : 'commands-list' }
MMCPServer >> listEntityTypes [

	<jrpc: #list:entityTypes>

	self log: 'list:entityTypes'.

	^mooseModel metamodel classes select: #isFM3Class thenCollect: #name
]

{ #category : 'utilities' }
MMCPServer >> log: aString [

	aString record
]

{ #category : 'accessing' }
MMCPServer >> mooseModel [

	^mooseModel
]

{ #category : 'accessing' }
MMCPServer >> mooseModel: anObject [

	mooseModel := anObject
]

{ #category : 'commands-requests' }
MMCPServer >> requestModelName [

	<jrpc: #request:modelName>

	self log: 'request:modelName'.

	^mooseModel name
]

{ #category : 'commands-requests' }
MMCPServer >> requestModelRepository [

	<jrpc: #request:modelRepository>

	self log: 'request:modelRepository'.

	^'https://github.com/NicolasAnquetil/VerveineJ'
]

{ #category : 'commands-requests' }
MMCPServer >> requestModelSize [

	<jrpc: #request:modelSize>

	self log: 'request:modelSize'.

	^mooseModel size
]

{ #category : 'utilities' }
MMCPServer >> resetLog [

	TinyLogger default ensureFileLoggerNamed: 'mooseMCPServer.log'.
	TinyLogger default clearLog.

	('working on mooseModel: ' , self mooseModel name) record.
	(self messageProcessor handlersCount asString , ' handlers registered') record.
]

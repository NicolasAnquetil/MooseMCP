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
	#superclass : 'JRPCHTTPServer',
	#instVars : [
		'mooseModel',
		'formatter',
		'memory'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'defaults' }
MMCPServer class >> defaultPort [

	^ 4444
]

{ #category : 'accessing' }
MMCPServer >> byID [

	formatter := MMCPServerById new
		mooseModel: mooseModel ;
		yourself
]

{ #category : 'accessing' }
MMCPServer >> byName [

	formatter := MMCPServerByName new
		mooseModel: mooseModel ;
		yourself
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

	self stop.
	^nil
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
	self byName
]

{ #category : 'commands-server' }
MMCPServer >> initializeProtocol: protocolVersion capabilities: capabilities client: clientInfo [

	"MCP initialization message:

	{
		""method"":""initialize"",
			""params"":{
				""protocolVersion"":""2025-06-18"",
				""capabilities"":{""elicitation"": {}},
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

	^ ''



]

{ #category : 'commands-list' }
MMCPServer >> listEntitiesForType: aName [

	<jrpc: #list:entitiesForType>

	self log: ('list:entitiesForType: ' , aName).

	^mooseModel metamodel classes
		detect: [ :c | c name sameAs: aName ]
		ifOne: [ :fmClass |
			(mooseModel allWithType: fmClass implementingClass)
				reject: #isStub
		]
		ifNone: [ #() ].

]

{ #category : 'commands-list' }
MMCPServer >> listEntityChildren: anEntity [

	<jrpc: #list:entityChildren>

	self log: ('list:entityChildren for ', anEntity asString).

	^(formatter getEntity: anEntity)
		children
]

{ #category : 'commands-list' }
MMCPServer >> listEntityClients: anEntity [

	<jrpc: #list:entityClients>

	self log: ('list:entityClients for ', anEntity).

	^(formatter getEntity: anEntity)
		allClients
]

{ #category : 'commands-list' }
MMCPServer >> listEntityParents: anEntity [

	<jrpc: #list:entityParents>

	self log: ('list:entityParents for ', anEntity asString).

	^(formatter getEntity: anEntity)
		parents
]

{ #category : 'commands-list' }
MMCPServer >> listEntityProviders: anEntity [

	<jrpc: #list:entityProviders>

	self log: ('list:entityProviders for ', anEntity asString).

	^(formatter getEntity: anEntity)
		allProviders
]

{ #category : 'commands-list' }
MMCPServer >> listEntityTypes [

	<jrpc: #list:entityTypes>

	self log: 'list:entityTypes'.

	^mooseModel entityStorage allEntityTypes collect: [ :pharoClass |
		(mooseModel metamodel fmTypeOf: pharoClass) name
	]
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

{ #category : 'message performing' }
MMCPServer >> perform: selector withArguments: argArray [

	^formatter resultFormat: (super perform: selector withArguments: argArray)
]

{ #category : 'commands-requests' }
MMCPServer >> requestEntityName: anEntity [

	<jrpc: #request:entityName>

	self log: 'request:entityName for : ' , anEntity.

	^(formatter getEntity: anEntity ifAbsent: [^#()])
		mooseName
]

{ #category : 'commands-requests' }
MMCPServer >> requestEntityType: anEntity [

	<jrpc: #request:entityType>

	self log: 'request:entityType for : ' , anEntity asString.

	^(formatter getEntity: anEntity ifAbsent: [^#()])
		class name
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

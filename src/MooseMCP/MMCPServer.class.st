"
I am an MCP server that provides some services on a MooseModel
I wait for commands on a TCP socket and answer them

To use just do:
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

{ #category : 'commands-list' }
MMCPServer >> listEntitiesType: aFamixClassName [

	<jrpc: #list:entityType>

	self log: ('list:entityType for ' , aFamixClassName).

	^(Smalltalk classNamed: aFamixClassName)
		ifNil: [ nil ]
		ifNotNil: [ :famixClass | mooseModel allWithType: famixClass ]
]

{ #category : 'commands-list' }
MMCPServer >> listEntityChildren: aFamixEntityName [

	<jrpc: #list:entityChildren>

	self log: ('list:entityChildren for ', aFamixEntityName).

	^(mooseModel entityNamed: aFamixEntityName ifAbsent: [^nil])
		children collect: #mooseName
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
MMCPServer >> requestEntityTypes [

	<jrpc: #request:entityTypes>

	self log: 'request:entityTypes'.

	^mooseModel entities collectAsSet: [ :e | e class name ]
]

{ #category : 'commands-requests' }
MMCPServer >> requestModelName [

	<jrpc: #request:modelName>

	self log: 'request:modelName'.

	^mooseModel name
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

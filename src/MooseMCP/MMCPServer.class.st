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

{ #category : 'accessing' }
MMCPServer >> defaultMooseModel [

	^MooseModel root allModels anyOne
]

{ #category : 'initialization' }
MMCPServer >> initialize [ 

	super initialize.

TinyLogger default ensureFileLoggerNamed: 'mooseMCPServer.log'.
	self port: self defaultPort.
	self addHandlersFromPragmasIn: self.
(self messageProcessor handlersCount asString , ' handlers registered') record.

	self mooseModel: self defaultMooseModel
]

{ #category : 'accessing' }
MMCPServer >> mooseModel [

	^mooseModel
]

{ #category : 'accessing' }
MMCPServer >> mooseModel: anObject [

	mooseModel := anObject
]

{ #category : 'commands-model' }
MMCPServer >> requestEntityTypes [

	<jrpc: #request:entityTypes>
	^mooseModel entities collectAsSet: [ :e | e class name ]
]

{ #category : 'commands-model' }
MMCPServer >> requestModelName [

	<jrpc: #request:modelName>
	^mooseModel name
]

{ #category : 'commands-model' }
MMCPServer >> requestModelSize [

	<jrpc: #request:modelSize>
	^mooseModel size
]

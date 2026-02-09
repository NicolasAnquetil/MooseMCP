"
I am an abstract class for MooseMCP servers that provide some services on a MooseModel.
The servers wait for commands on a TCP socket and answer them

To use just do:
```
server := MMCPxxxServer new.
server
	mooseModel: <some-moose-model> ;
	start.
```

"
Class {
	#name : 'MMCPAbstractServer',
	#superclass : 'JRPCHTTPServer',
	#instVars : [
		'mooseModel',
		'memory',
		'interfacer'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPAbstractServer >> asBooleanPropery: prop for: entity [
	"Make a boolean from any property
	 - for booleans, return their value
	 - for collection, return false if they are empty, true if not
	 - for relations to FamixObject (hasOpposite), return false if it's nil, true otherwise
	 - otherwise (Numbers, Strings) return false if it's not nil"

	| value |
	value := entity perform: prop name.

	prop type class = FM3Boolean ifTrue: [ ^value ].

	prop isMultivalued ifTrue: [ ^value isNotEmpty ].

	prop hasOpposite ifTrue: [ ^value isNotNil ].

	^value isNotNil
]

{ #category : 'accessing' }
MMCPAbstractServer >> byID [

	interfacer := MMCPServerIdInterface new
		mooseModel: mooseModel ;
		yourself
]

{ #category : 'accessing' }
MMCPAbstractServer >> byName [

	interfacer := MMCPServerNameInterface new
		mooseModel: mooseModel ;
		yourself
]

{ #category : 'tools-server' }
MMCPAbstractServer >> commandPharoQuit [

	<jrpc: #command:pharoQuit>

	SmalltalkImage current snapshot: true andQuit: true
]

{ #category : 'tools-server' }
MMCPAbstractServer >> commandServerStop [

	<jrpc: #command:serverStop>

	self log: 'command:serverStop'.

	self stop.
	^nil
]

{ #category : 'accessing' }
MMCPAbstractServer >> defaultMooseModel [

	^MooseModel root allModels anyOne
]

{ #category : 'utilities' }
MMCPAbstractServer >> handlers [

	^self messageProcessor handlers collect: #methodName
]

{ #category : 'initialization' }
MMCPAbstractServer >> initialize [ 

	super initialize.

	self port: self defaultPort.
	self addHandlersFromPragmasIn: self.

	self mooseModel: self defaultMooseModel.
	memory := Dictionary new.

	self resetLog.
	self byName
]

{ #category : 'utilities' }
MMCPAbstractServer >> log: aString [

	aString record
]

{ #category : 'tools-memory' }
MMCPAbstractServer >> memoryGet: aName [

	<jrpc: #memory:get>

	self log: ('memory:get for ', aName asString).

	^memory at: aName ifAbsent: [ Error signal: 'No list named ', aName ,' found' ]
]

{ #category : 'tools-memory' }
MMCPAbstractServer >> memorySet: aName entities: aCollection [

	<jrpc: #memory:set>

	self log: ('memory:set ', aName asString, ' value: ' , aCollection asString).

	memory at: aName put: aCollection.
	^aCollection size
]

{ #category : 'accessing' }
MMCPAbstractServer >> mooseModel [

	^mooseModel
]

{ #category : 'accessing' }
MMCPAbstractServer >> mooseModel: anObject [

	mooseModel := anObject
]

{ #category : 'message performing' }
MMCPAbstractServer >> perform: selector withArguments: argArray [

	^interfacer resultFormat: (super perform: selector withArguments: argArray)
]

{ #category : 'utilities' }
MMCPAbstractServer >> property: prop matchesName: aPropertyName [

	(prop name sameAs: aPropertyName) ifTrue: [ ^true ].

	^(prop name sameAs: ('is' , aPropertyName))
]

{ #category : 'utilities' }
MMCPAbstractServer >> resetLog [

	TinyLogger default ensureFileLoggerNamed: 'mooseMCPServer.log'.
	TinyLogger default clearLog.

	('working on mooseModel: ' , self mooseModel name) record.
	(self messageProcessor handlersCount asString , ' handlers registered') record.
]

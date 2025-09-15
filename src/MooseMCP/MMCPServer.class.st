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

{ #category : 'utilities' }
MMCPServer >> asBooleanPropery: prop for: entity [
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
	memory := Dictionary new.

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
MMCPServer >> listEntityProperties: anEntity [

	<jrpc: #list:entityProperties>

	| entity |
	self log: 'list:entityProperties : ' , anEntity asString.

	entity := (formatter getEntity: anEntity).

	^entity allProperties collect: [ :prop | prop name , ' : ' , (prop comment ifNil: ['']) ]

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

{ #category : 'commands-list' }
MMCPServer >> listPropertiesForType: aName [

	<jrpc: #list:propertiesForType>

	self log: ('list:propertiesForType ' , aName).

	^mooseModel metamodel classes
		detect: [ :c | c name sameAs: aName ]
		ifOne: [ :fmClass |
			fmClass allProperties collect: [ :prop | prop name , ' : ' , (prop comment ifNil: ['']) ]
		]
		ifNone: [ #() ].

]

{ #category : 'utilities' }
MMCPServer >> log: aString [

	aString record
]

{ #category : 'commands-memory' }
MMCPServer >> memoryGet: aName [

	<jrpc: #memory:get>

	self log: ('memory:get for ', aName asString).

	^memory at: aName ifAbsent: [ Error signal: 'No list named ', aName ,' found' ]
]

{ #category : 'commands-memory' }
MMCPServer >> memorySet: aName entities: aCollection [

	<jrpc: #memory:set>

	self log: ('memory:set ', aName asString, ' value: ' , aCollection asString).

	memory at: aName put: aCollection.
	^aCollection size
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

{ #category : 'utilities' }
MMCPServer >> property: prop matchesName: aPropertyName [

	(prop name sameAs: aPropertyName) ifTrue: [ ^true ].

	^(prop name sameAs: ('is' , aPropertyName))
]

{ #category : 'commands-property' }
MMCPServer >> propertyClassLackOfCohesion: anEntity [

	<jrpc: #property:classLackOfCohesion>

	| aClass |
	self log: 'property:classLackOfCohesion for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isClass ifFalse: [ Error signal: 'Entity is not a class'  ].
	^aClass lcom3 
]

{ #category : 'commands-property' }
MMCPServer >> propertyHas: anEntity property: aPropertyName [

	<jrpc: #property:hasProperty>

	| entity |
	self log: 'property:has : ' , anEntity asString , ' property: ' , aPropertyName.

	entity := (formatter getEntity: anEntity).

	^entity allDeclaredProperties
		detect: [ :prop | self property: prop matchesName: aPropertyName ]
		ifOne: [ :prop | self asBooleanPropery: prop for: entity ]
		ifNone: [ false ]

]

{ #category : 'commands-property' }
MMCPServer >> propertyMethodCyclomaticComplexity: anEntity [

	<jrpc: #property:methodCyclomaticComplexity>

	| aClass |
	self log: 'property:methodCyclomaticComplexity for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass cyclomaticComplexity 
]

{ #category : 'commands-property' }
MMCPServer >> propertyMethodNumberOfStatements: anEntity [

	<jrpc: #property:methodNumberOfStatements>

	| aClass |
	self log: 'property:methodNumberOfStatements for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass numberOfStatements 
]

{ #category : 'commands-property' }
MMCPServer >> propertyPackageCohesion: anEntity [

	<jrpc: #property:packageCohesion>

	| package |
	self log: 'property:packageCohesion for : ' , anEntity asString.

	package := (formatter getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package martinCohesion 
]

{ #category : 'commands-property' }
MMCPServer >> propertyPackageCoupling: anEntity [

	<jrpc: #property:packageCoupling>

	| package |
	self log: 'property:packageCoupling for : ' , anEntity asString.

	package := (formatter getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package efferentCoupling 
]

{ #category : 'commands-requests' }
MMCPServer >> requestEntityName: anEntity [

	<jrpc: #request:entityName>

	self log: 'request:entityName for : ' , anEntity asString.

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

{ #category : 'resources' }
MMCPServer >> resourceModelReport [

	<jrpc: #'resource:model-report'>

	| reporter |
	self log: 'resource:model-report'.

	reporter := MiModelReportModel new.
	reporter 	initializeSettings.
	reporter mooseModel: mooseModel.
	^String streamContents: [ :st |
		reporter report: st.
		reporter document.
		reporter report
	]
]

{ #category : 'resources' }
MMCPServer >> resourcePackageDSM [

	<jrpc: #'resource:package-dsm'>

	self log: 'resource:package-dsm'.

	"browser := MiDSMBrowser new.
	browser followEntity: (mooseModel allModelPackages reject: [ :p | p types isEmpty ]).
	browser diagram canvas exportToPNG"

	^'/home/anquetil/Pharo/images/MooseMCP-250827/3934457036066856.png' asFileReference contents
]

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

{ #category : 'tools-queries' }
MMCPServer >> booleanQuery: aResource property: aProperty [

	<jrpc: #query:boolean>

	self log: ('query:boolean: ' , aProperty asString , ' on: ', aResource asString).

	^(FQBooleanQuery property: aProperty) executeOn: (formatter getList: aResource)
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

{ #category : 'tools-server' }
MMCPServer >> commandMooseMCPServerVersion [

	<jrpc: #'command:version'>

	^ '0.1.0'
]

{ #category : 'tools-server' }
MMCPServer >> commandPharoQuit [

	<jrpc: #command:pharoQuit>

	SmalltalkImage current snapshot: true andQuit: true
]

{ #category : 'tools-server' }
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

{ #category : 'tools-server' }
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

{ #category : 'tools-list' }
MMCPServer >> listAccessedEntities: aSourceMethod [

	<jrpc: #list:accessedEntites>

	self log: ('list:accessedEntites for ', aSourceMethod).

	^(formatter getEntity: aSourceMethod)
		accesses collect: #variable
]

{ #category : 'tools-list' }
MMCPServer >> listAccessingMethods: aTargetEntity [

	<jrpc: #list:accessingMethods>

	self log: ('list:accessingMethods for ', aTargetEntity).

	^(formatter getEntity: aTargetEntity)
		incomingAccesses collect: #accessor
]

{ #category : 'tools-list' }
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

{ #category : 'tools-list' }
MMCPServer >> listEntityChildren: anEntity [

	<jrpc: #list:entityChildren>

	self log: ('list:entityChildren for ', anEntity asString).

	^(formatter getEntity: anEntity)
		children
]

{ #category : 'tools-list' }
MMCPServer >> listEntityClients: anEntity [

	<jrpc: #list:entityClients>

	self log: ('list:entityClients for ', anEntity).

	^(formatter getEntity: anEntity)
		allClients
]

{ #category : 'tools-list' }
MMCPServer >> listEntityParents: anEntity [

	<jrpc: #list:entityParents>

	self log: ('list:entityParents for ', anEntity asString).

	^(formatter getEntity: anEntity)
		parents
]

{ #category : 'tools-list' }
MMCPServer >> listEntityProperties: anEntity [

	<jrpc: #list:entityProperties>

	| entity |
	self log: 'list:entityProperties : ' , anEntity asString.

	entity := (formatter getEntity: anEntity).

	^entity allProperties collect: [ :prop | prop name , ' : ' , (prop comment ifNil: ['']) ]

]

{ #category : 'tools-list' }
MMCPServer >> listEntityProviders: anEntity [

	<jrpc: #list:entityProviders>

	self log: ('list:entityProviders for ', anEntity asString).

	^(formatter getEntity: anEntity)
		allProviders
]

{ #category : 'tools-list' }
MMCPServer >> listEntityTypes [

	<jrpc: #list:entityTypes>

	self log: 'list:entityTypes'.

	^mooseModel entityStorage allEntityTypes collect: [ :pharoClass |
		(mooseModel metamodel fmTypeOf: pharoClass) name
	]
]

{ #category : 'tools-list' }
MMCPServer >> listImplementedInterface: aClass [

	<jrpc: #list:implementedInterfaces>

	self log: ('list:implementedInterfaces for ', aClass).

	^(formatter getEntity: aClass)
		interfaceImplementations collect: #interface 
]

{ #category : 'tools-list' }
MMCPServer >> listImplementingClasses: anInterface [

	<jrpc: #list:implementingClasses>

	self log: ('list:implementingClasses for ', anInterface).

	^(formatter getEntity: anInterface)
		implementations collect: #implementingClass 
]

{ #category : 'tools-list' }
MMCPServer >> listInvokedMethods: aSourceMethod [

	<jrpc: #list:invokedMethods>

	self log: ('list:invokedMethods for ', aSourceMethod).

	^(formatter getEntity: aSourceMethod)
		invokedMethods 
]

{ #category : 'tools-list' }
MMCPServer >> listInvokingMethods: aTargetMethod [

	<jrpc: #list:invokingMethods>

	self log: ('list:invokingMethods for ', aTargetMethod).

	^(formatter getEntity: aTargetMethod)
		invokingMethods 
]

{ #category : 'tools-list' }
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

{ #category : 'tools-list' }
MMCPServer >> listSubClasses: aSuperClass [

	<jrpc: #list:subClasses>

	self log: ('list:subClasses for ', aSuperClass).

	^(formatter getEntity: aSuperClass)
		subInheritances collect: #subclass 
]

{ #category : 'tools-list' }
MMCPServer >> listSuperClasses: aSuperClass [

	<jrpc: #list:superClasses>

	self log: ('list:superClasses for ', aSuperClass).

	^(formatter getEntity: aSuperClass)
		superInheritances collect: #superclass 
]

{ #category : 'utilities' }
MMCPServer >> log: aString [

	aString record
]

{ #category : 'tools-memory' }
MMCPServer >> memoryGet: aName [

	<jrpc: #memory:get>

	self log: ('memory:get for ', aName asString).

	^memory at: aName ifAbsent: [ Error signal: 'No list named ', aName ,' found' ]
]

{ #category : 'tools-memory' }
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

{ #category : 'tools-property' }
MMCPServer >> propertyClassLackOfCohesion: anEntity [

	<jrpc: #property:classLackOfCohesion>

	| aClass |
	self log: 'property:classLackOfCohesion for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isClass ifFalse: [ Error signal: 'Entity is not a class'  ].
	^aClass lcom3 
]

{ #category : 'tools-property' }
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

{ #category : 'tools-property' }
MMCPServer >> propertyMethodCyclomaticComplexity: anEntity [

	<jrpc: #property:methodCyclomaticComplexity>

	| aClass |
	self log: 'property:methodCyclomaticComplexity for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass cyclomaticComplexity 
]

{ #category : 'tools-property' }
MMCPServer >> propertyMethodNumberOfStatements: anEntity [

	<jrpc: #property:methodNumberOfStatements>

	| aClass |
	self log: 'property:methodNumberOfStatements for : ' , anEntity asString.

	aClass := (formatter getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass numberOfStatements 
]

{ #category : 'tools-property' }
MMCPServer >> propertyPackageCohesion: anEntity [

	<jrpc: #property:packageCohesion>

	| package |
	self log: 'property:packageCohesion for : ' , anEntity asString.

	package := (formatter getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package martinCohesion 
]

{ #category : 'tools-property' }
MMCPServer >> propertyPackageCoupling: anEntity [

	<jrpc: #property:packageCoupling>

	| package |
	self log: 'property:packageCoupling for : ' , anEntity asString.

	package := (formatter getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package efferentCoupling 
]

{ #category : 'tools-requests' }
MMCPServer >> requestEntityName: anEntity [

	<jrpc: #request:entityName>

	self log: 'request:entityName for : ' , anEntity asString.

	^(formatter getEntity: anEntity ifAbsent: [^#()])
		mooseName
]

{ #category : 'tools-requests' }
MMCPServer >> requestEntityType: anEntity [

	<jrpc: #request:entityType>

	self log: 'request:entityType for : ' , anEntity asString.

	^(formatter getEntity: anEntity ifAbsent: [^#()])
		class name
]

{ #category : 'tools-requests' }
MMCPServer >> requestModelName [

	<jrpc: #request:modelName>

	self log: 'request:modelName'.

	^mooseModel name
]

{ #category : 'tools-requests' }
MMCPServer >> requestModelRepository [

	<jrpc: #request:modelRepository>

	self log: 'request:modelRepository'.

	^'https://github.com/NicolasAnquetil/VerveineJ'
]

{ #category : 'tools-requests' }
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
MMCPServer >> resourceModelReport: jsonSettings [

	<jrpc: #'resource:model-report'>

	| reporter |
	self log: 'resource:model-report: ' , jsonSettings asString.

	reporter := MiModelReportModel new.
	reporter 	updateFromConfiguration: (MiModelReportSettingsConfiguration fromJson: jsonSettings).
	reporter mooseModel: mooseModel.
	reporter document.
	^reporter rawReport

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

"
I am an MCP server that provides some services on a MooseModel
I wait for commands on a TCP socket and answer them

To use just do:
- load a model in Moose
```
server := MMCPxxxServer new.
server
	mooseModel: <some-moose-model> ;
	start.
```

"
Class {
	#name : 'MMCPToolServer',
	#superclass : 'MMCPAbstractServer',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'defaults' }
MMCPToolServer class >> defaultPort [

	^ 4444
]

{ #category : 'tools-queries' }
MMCPToolServer >> booleanQuery: aResourceName property: aProperty [

	<jrpc: #query:boolean>

	self log: ('query:boolean: ' , aProperty asString , ' on: ', aResourceName asString).

	^(FQBooleanQuery property: aProperty) executeOn: (interfacer getList: aResourceName)
]

{ #category : 'tools-server' }
MMCPToolServer >> commandMooseMCPServerVersion [

	<jrpc: #'command:version'>

	^ '0.1.0'
]

{ #category : 'tools-list' }
MMCPToolServer >> listAccessedEntities: aSourceMethod [

	<jrpc: #list:accessedEntites>

	self log: ('list:accessedEntites for ', aSourceMethod).

	^(interfacer getEntity: aSourceMethod)
		accesses collect: #variable
]

{ #category : 'tools-list' }
MMCPToolServer >> listAccessingMethods: aTargetEntity [

	<jrpc: #list:accessingMethods>

	self log: ('list:accessingMethods for ', aTargetEntity).

	^(interfacer getEntity: aTargetEntity)
		incomingAccesses collect: #accessor
]

{ #category : 'tools-list' }
MMCPToolServer >> listEntitiesForType: aName [

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
MMCPToolServer >> listEntityChildren: anEntity [

	<jrpc: #list:entityChildren>

	self log: ('list:entityChildren for ', anEntity asString).

	^(interfacer getEntity: anEntity)
		children
]

{ #category : 'tools-list' }
MMCPToolServer >> listEntityClients: anEntity [

	<jrpc: #list:entityClients>

	self log: ('list:entityClients for ', anEntity).

	^(interfacer getEntity: anEntity)
		allClients
]

{ #category : 'tools-list' }
MMCPToolServer >> listEntityParents: anEntity [

	<jrpc: #list:entityParents>

	self log: ('list:entityParents for ', anEntity asString).

	^(interfacer getEntity: anEntity)
		parents
]

{ #category : 'tools-list' }
MMCPToolServer >> listEntityProperties: anEntity [

	<jrpc: #list:entityProperties>

	| entity |
	self log: 'list:entityProperties : ' , anEntity asString.

	entity := (interfacer getEntity: anEntity).

	^entity allProperties collect: [ :prop | prop name , ' : ' , (prop comment ifNil: ['']) ]

]

{ #category : 'tools-list' }
MMCPToolServer >> listEntityProviders: anEntity [

	<jrpc: #list:entityProviders>

	self log: ('list:entityProviders for ', anEntity asString).

	^(interfacer getEntity: anEntity)
		allProviders
]

{ #category : 'tools-list' }
MMCPToolServer >> listEntityTypes [

	<jrpc: #list:entityTypes>

	self log: 'list:entityTypes'.

	^mooseModel entityStorage allEntityTypes collect: [ :pharoClass |
		(mooseModel metamodel fmTypeOf: pharoClass) name
	]
]

{ #category : 'tools-list' }
MMCPToolServer >> listImplementedInterface: aClass [

	<jrpc: #list:implementedInterfaces>

	self log: ('list:implementedInterfaces for ', aClass).

	^(interfacer getEntity: aClass)
		interfaceImplementations collect: #interface 
]

{ #category : 'tools-list' }
MMCPToolServer >> listImplementingClasses: anInterface [

	<jrpc: #list:implementingClasses>

	self log: ('list:implementingClasses for ', anInterface).

	^(interfacer getEntity: anInterface)
		implementations collect: #implementingClass 
]

{ #category : 'tools-list' }
MMCPToolServer >> listInvokedMethods: aSourceMethod [

	<jrpc: #list:invokedMethods>

	self log: ('list:invokedMethods for ', aSourceMethod).

	^(interfacer getEntity: aSourceMethod)
		invokedMethods 
]

{ #category : 'tools-list' }
MMCPToolServer >> listInvokingMethods: aTargetMethod [

	<jrpc: #list:invokingMethods>

	self log: ('list:invokingMethods for ', aTargetMethod).

	^(interfacer getEntity: aTargetMethod)
		invokingMethods 
]

{ #category : 'tools-list' }
MMCPToolServer >> listPropertiesForType: aName [

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
MMCPToolServer >> listSubClasses: aSuperClass [

	<jrpc: #list:subClasses>

	self log: ('list:subClasses for ', aSuperClass).

	^(interfacer getEntity: aSuperClass)
		subInheritances collect: #subclass 
]

{ #category : 'tools-list' }
MMCPToolServer >> listSuperClasses: aSuperClass [

	<jrpc: #list:superClasses>

	self log: ('list:superClasses for ', aSuperClass).

	^(interfacer getEntity: aSuperClass)
		superInheritances collect: #superclass 
]

{ #category : 'tools-property' }
MMCPToolServer >> propertyClassLackOfCohesion: anEntity [

	<jrpc: #property:classLackOfCohesion>

	| aClass |
	self log: 'property:classLackOfCohesion for : ' , anEntity asString.

	aClass := (interfacer getEntity: anEntity).
	aClass isClass ifFalse: [ Error signal: 'Entity is not a class'  ].
	^aClass lcom3 
]

{ #category : 'tools-property' }
MMCPToolServer >> propertyHas: anEntity property: aPropertyName [

	<jrpc: #property:hasProperty>

	| entity |
	self log: 'property:has : ' , anEntity asString , ' property: ' , aPropertyName.

	entity := (interfacer getEntity: anEntity).

	^entity allDeclaredProperties
		detect: [ :prop | self property: prop matchesName: aPropertyName ]
		ifOne: [ :prop | self asBooleanPropery: prop for: entity ]
		ifNone: [ false ]

]

{ #category : 'tools-property' }
MMCPToolServer >> propertyMethodCyclomaticComplexity: anEntity [

	<jrpc: #property:methodCyclomaticComplexity>

	| aClass |
	self log: 'property:methodCyclomaticComplexity for : ' , anEntity asString.

	aClass := (interfacer getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass cyclomaticComplexity 
]

{ #category : 'tools-property' }
MMCPToolServer >> propertyMethodNumberOfStatements: anEntity [

	<jrpc: #property:methodNumberOfStatements>

	| aClass |
	self log: 'property:methodNumberOfStatements for : ' , anEntity asString.

	aClass := (interfacer getEntity: anEntity).
	aClass isMethod ifFalse: [ Error signal: 'Entity is not a method'  ].
	^aClass numberOfStatements 
]

{ #category : 'tools-property' }
MMCPToolServer >> propertyPackageCohesion: anEntity [

	<jrpc: #property:packageCohesion>

	| package |
	self log: 'property:packageCohesion for : ' , anEntity asString.

	package := (interfacer getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package martinCohesion 
]

{ #category : 'tools-property' }
MMCPToolServer >> propertyPackageCoupling: anEntity [

	<jrpc: #property:packageCoupling>

	| package |
	self log: 'property:packageCoupling for : ' , anEntity asString.

	package := (interfacer getEntity: anEntity).
	package isPackage ifFalse: [ Error signal: 'Entity is not a package' ].
	^package efferentCoupling 
]

{ #category : 'tools-requests' }
MMCPToolServer >> requestEntityName: anEntity [

	<jrpc: #request:entityName>

	self log: 'request:entityName for : ' , anEntity asString.

	^(interfacer getEntity: anEntity ifAbsent: [^#()])
		mooseName
]

{ #category : 'tools-requests' }
MMCPToolServer >> requestEntityType: anEntity [

	<jrpc: #request:entityType>

	self log: 'request:entityType for : ' , anEntity asString.

	^(interfacer getEntity: anEntity ifAbsent: [^#()])
		class name
]

{ #category : 'tools-requests' }
MMCPToolServer >> requestModelName [

	<jrpc: #request:modelName>

	self log: 'request:modelName'.

	^mooseModel name
]

{ #category : 'tools-requests' }
MMCPToolServer >> requestModelRepository [

	<jrpc: #request:modelRepository>

	self log: 'request:modelRepository'.

	^'https://github.com/NicolasAnquetil/VerveineJ'
]

{ #category : 'tools-requests' }
MMCPToolServer >> requestModelSize [

	<jrpc: #request:modelSize>

	self log: 'request:modelSize'.

	^mooseModel size
]

{ #category : 'resources' }
MMCPToolServer >> resourceModelReport: jsonSettings [

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
MMCPToolServer >> resourcePackageDSM [

	<jrpc: #'resource:package-dsm'>

	self log: 'resource:package-dsm'.

	"browser := MiDSMBrowser new.
	browser followEntity: (mooseModel allModelPackages reject: [ :p | p types isEmpty ]).
	browser diagram canvas exportToPNG"

	^'/home/anquetil/Pharo/images/MooseMCP-250827/3934457036066856.png' asFileReference contents
]

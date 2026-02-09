Class {
	#name : 'MMCPServerInterface',
	#superclass : 'Object',
	#instVars : [
		'mooseModel',
		'resources'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerInterface >> getEntity: aFamixEntityName [

	self subclassResponsibility 
]

{ #category : 'utilities' }
MMCPServerInterface >> getEntity: aFamixEntityName ifAbsent: aBlock [

	self subclassResponsibility 
]

{ #category : 'utilities' }
MMCPServerInterface >> getList: resourceName [

	^resources at: resourceName ifAbsent: [ #() ]
]

{ #category : 'initialization' }
MMCPServerInterface >> initialize [

	super initialize.

	resources := Dictionary new
]

{ #category : 'utilities' }
MMCPServerInterface >> listAsResource: aCollection [

	| resourceName |
	resourceName := 'rsrc' , (resources size + 1) asString.
	resources at: resourceName put: aCollection
]

{ #category : 'accessing' }
MMCPServerInterface >> mooseModel [

	^mooseModel
]

{ #category : 'accessing' }
MMCPServerInterface >> mooseModel: aModel [

	mooseModel := aModel 
]

{ #category : 'utilities' }
MMCPServerInterface >> resultFormat: result [

	result isString ifTrue: [ ^result ].
	result isMooseEntity ifTrue: [ ^self returnEntity: result ].
	result isCollection ifTrue: [ ^self returnCollection: result ].
	^result
]

{ #category : 'utilities' }
MMCPServerInterface >> returnCollection: aCollection [

	^aCollection
		collect: [ :anObject | self resultFormat: anObject ] as: Array
]

{ #category : 'utilities' }
MMCPServerInterface >> returnEntity: anObject [

	^anObject isMooseEntity
		ifTrue: [ self returnMooseEntity: anObject ]
		ifFalse: [ anObject ]
]

{ #category : 'utilities' }
MMCPServerInterface >> returnMooseEntity: anObject [

	^self subclassResponsibility 
]

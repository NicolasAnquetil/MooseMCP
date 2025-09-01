Class {
	#name : 'MMCPServerFormatter',
	#superclass : 'Object',
	#instVars : [
		'mooseModel'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerFormatter >> getEntity: aFamixEntityName ifAbsent: aBlock [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MMCPServerFormatter >> mooseModel [

	^mooseModel
]

{ #category : 'accessing' }
MMCPServerFormatter >> mooseModel: aModel [

	mooseModel := aModel 
]

{ #category : 'utilities' }
MMCPServerFormatter >> resultFormat: result [

	result isString ifTrue: [ ^result ].
	result isMooseEntity ifTrue: [ ^self returnEntity: result ].
	result isCollection ifTrue: [ ^self returnCollection: result ].
	^result
]

{ #category : 'utilities' }
MMCPServerFormatter >> returnCollection: aCollection [

	^aCollection
		collect: [ :anObject | self resultFormat: anObject ] as: Array
]

{ #category : 'utilities' }
MMCPServerFormatter >> returnEntity: anObject [

	^anObject isMooseEntity
		ifTrue: [ self returnMooseEntity: anObject ]
		ifFalse: [ anObject ]
]

{ #category : 'utilities' }
MMCPServerFormatter >> returnMooseEntity: anObject [

	^self subclassResponsibility 
]

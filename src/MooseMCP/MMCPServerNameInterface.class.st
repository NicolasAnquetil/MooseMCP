Class {
	#name : 'MMCPServerNameInterface',
	#superclass : 'MMCPServerInterface',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerNameInterface >> getEntity: aName [

	^mooseModel entityNamed: aName ifAbsent: [ Error signal: 'Could not find entity' ]
]

{ #category : 'utilities' }
MMCPServerNameInterface >> getEntity: aName ifAbsent: aBlock [

	^mooseModel entityNamed: aName ifAbsent: [ aBlock value ]
]

{ #category : 'utilities' }
MMCPServerNameInterface >> returnMooseEntity: anEntitity [

	^anEntitity mooseName
]

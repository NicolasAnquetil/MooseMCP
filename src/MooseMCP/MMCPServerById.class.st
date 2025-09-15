Class {
	#name : 'MMCPServerById',
	#superclass : 'MMCPServerFormatter',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerById >> getEntity: aName [

	^mooseModel entityNamed: aName ifAbsent: [ Error signal: 'Could not find entity' ]
]

{ #category : 'utilities' }
MMCPServerById >> getEntity: anID ifAbsent: aBlock [

	^mooseModel entityStorage
		detect: [ :entity | entity mooseID = anID] ifNone: [ aBlock value ]
]

{ #category : 'utilities' }
MMCPServerById >> returnMooseEntity: anEntitity [

	^anEntitity mooseID
]

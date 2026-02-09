Class {
	#name : 'MMCPServerIdInterface',
	#superclass : 'MMCPServerInterface',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerIdInterface >> getEntity: aName [

	^mooseModel entityNamed: aName ifAbsent: [ Error signal: 'Could not find entity' ]
]

{ #category : 'utilities' }
MMCPServerIdInterface >> getEntity: anID ifAbsent: aBlock [

	^mooseModel entityStorage
		detect: [ :entity | entity mooseID = anID] ifNone: [ aBlock value ]
]

{ #category : 'utilities' }
MMCPServerIdInterface >> returnMooseEntity: anEntitity [

	^anEntitity mooseID
]

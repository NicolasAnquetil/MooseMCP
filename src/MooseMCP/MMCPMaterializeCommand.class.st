"
Command that pages through actual entity data for materialize.
"
Class {
	#name : 'MMCPMaterializeCommand',
	#superclass : 'MMCPEntitySetCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPMaterializeCommand >> execute [

	| setId offset limit fields entities ordered from to page |
	setId := self request stringArgumentNamed: 'setId'.
	offset := self request
		          nonNegativeIntegerArgumentNamed: 'offset'
		          default: 0.
	limit := self request
		         nonNegativeIntegerArgumentNamed: 'limit'
		         default: 20.
	fields := self request
		          stringCollectionArgumentNamed: 'fields'
		          default: #( 'name' 'qualifiedName' 'type' ).
	entities := self entitiesForSetId: setId.
	ordered := entities asOrderedCollection.
	from := offset + 1 min: ordered size + 1.
	to := offset + limit min: ordered size.
	page := from > to
		        ifTrue: [ #(  ) ]
		        ifFalse: [ ordered copyFrom: from to: to ].
	^ Dictionary new
		  at: 'items'
		  put:
			  (page collect: [ :e | self materializeEntity: e fields: fields ])
				  asArray;
		  at: 'total' put: ordered size;
		  yourself
]

{ #category : 'executing' }
MMCPMaterializeCommand >> materializeEntity: anEntity fields: fieldNames [

	| dict |
	dict := Dictionary new.
	fieldNames do: [ :f |
			dict at: f put: (f = 'type'
					 ifTrue: [ anEntity class name ]
					 ifFalse: [
							 f = 'qualifiedName'
								 ifTrue: [ self safePerform: #mooseName on: anEntity ]
								 ifFalse: [
									 self materializedValueFor:
										 (self safePerform: f asSymbol on: anEntity) ] ]) ].
	^ dict
]

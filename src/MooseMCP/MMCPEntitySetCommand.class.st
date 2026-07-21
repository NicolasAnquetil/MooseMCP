"
I am the abstract base for MooseMCP entity-set pipeline commands (query, filter_set, traverse, materialize).

I hold the session-scoped MMCPEntitySetRegistry and the shared helpers for registering/describing sets, evaluating filter predicates, and following traverse relationships.
"
Class {
	#name : 'MMCPEntitySetCommand',
	#superclass : 'MMCPCommand',
	#instVars : [
		'registry'
	],
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'testing' }
MMCPEntitySetCommand class >> isAbstract [

	^ self == MMCPEntitySetCommand
]

{ #category : 'instance creation' }
MMCPEntitySetCommand class >> tool: aTool request: aRequest [

	^ self new
		  initializeTool: aTool
		  request: aRequest
		  registry: MMCPEntitySetRegistry default
]

{ #category : 'entity sets' }
MMCPEntitySetCommand >> describeEntitySet: aSetId entities: aCollection [

	| dict |
	dict := Dictionary new.
	dict at: 'setId' put: aSetId.
	dict at: 'count' put: aCollection size.
	dict
		at: 'preview'
		put:
			((aCollection first: (aCollection size min: 5)) collect: [ :e |
				 (self safePerform: #mooseName on: e) ifNil: [ '' ] ]) asArray.
	^ dict
]

{ #category : 'entity sets' }
MMCPEntitySetCommand >> entitiesForSetId: aSetId [

	^ registry entitiesFor: aSetId
]

{ #category : 'filtering' }
MMCPEntitySetCommand >> entity: anEntity matchesAllFilters: filterSpecs [

	^ filterSpecs allSatisfy: [ :spec |
		  self entity: anEntity matchesFilter: spec ]
]

{ #category : 'filtering' }
MMCPEntitySetCommand >> entity: anEntity matchesFilter: aFilterSpec [

	| property operator value actual |
	property := aFilterSpec at: 'property'.
	operator := aFilterSpec at: 'operator'.
	value := aFilterSpec at: 'value'.
	actual := self safePerform: property asSymbol on: anEntity.
	operator = 'equals' ifTrue: [ ^ actual = value ].
	operator = 'notEquals' ifTrue: [ ^ actual ~= value ].
	operator = 'contains' ifTrue: [
			^ actual notNil and: [
				  actual asString includesSubstring: value asString ] ].
	operator = 'matches' ifTrue: [
		^ actual notNil and: [ actual asString matchesRegex: value asString ] ].
	operator = 'gt' ifTrue: [ ^ actual notNil and: [ actual > value ] ].
	operator = 'gte' ifTrue: [ ^ actual notNil and: [ actual >= value ] ].
	operator = 'lt' ifTrue: [ ^ actual notNil and: [ actual < value ] ].
	operator = 'lte' ifTrue: [ ^ actual notNil and: [ actual <= value ] ].
	operator = 'in' ifTrue: [ ^ value includes: actual ].
	^ MCPCommandError
		  signalErrorCode: #EntityFilterOperatorUnknown
		  message: 'Unknown filter operator: ' , operator asString , '.'
		  details: { (#operator -> operator) } asDictionary
]

{ #category : 'initialization' }
MMCPEntitySetCommand >> initializeTool: aTool request: aRequest registry: aRegistry [

	super initializeTool: aTool request: aRequest.
	registry := aRegistry
]

{ #category : 'materializing' }
MMCPEntitySetCommand >> materializedValueFor: aValue [

	((aValue isKindOf: Collection) and: [ aValue isString not ]) ifTrue: [
			^ (aValue collect: [ :each | self materializedValueFor: each ])
				  asArray ].
	(self safePerform: #mooseID on: aValue) ifNotNil: [ :id |
		^ id asString ].
	^ aValue
]

{ #category : 'entity sets' }
MMCPEntitySetCommand >> registerAndDescribe: aCollection [

	| ordered setId |
	ordered := aCollection asOrderedCollection.
	setId := registry registerSet: ordered.
	^ self describeEntitySet: setId entities: ordered
]

{ #category : 'accessing' }
MMCPEntitySetCommand >> registry [

	^ registry
]

{ #category : 'traversing' }
MMCPEntitySetCommand >> traverseRelationship: aName from: anEntity [

	aName = 'methods' ifTrue: [
		^ (self safePerform: #methods on: anEntity) ifNil: [ #(  ) ] ].
	aName = 'attributes' ifTrue: [
		^ (self safePerform: #attributes on: anEntity) ifNil: [ #(  ) ] ].
	aName = 'package' ifTrue: [
			^ (self safePerform: #parentPackage on: anEntity)
				  ifNil: [ #(  ) ]
				  ifNotNil: [ :p | Array with: p ] ].
	aName = 'definingClass' ifTrue: [
			^ (self safePerform: #parentType on: anEntity)
				  ifNil: [ #(  ) ]
				  ifNotNil: [ :c | Array with: c ] ].
	aName = 'superclass' ifTrue: [
		^ self relatedTo: anEntity type: 'inheritance' direction: #outgoing ].
	aName = 'subclasses' ifTrue: [
		^ self relatedTo: anEntity type: 'inheritance' direction: #incoming ].
	aName = 'invokedMethods' ifTrue: [
		^ self relatedTo: anEntity type: 'invocation' direction: #outgoing ].
	aName = 'invokingMethods' ifTrue: [
		^ self relatedTo: anEntity type: 'invocation' direction: #incoming ].
	aName = 'accesses' ifTrue: [
		^ self relatedTo: anEntity type: 'access' direction: #outgoing ].
	aName = 'accessingMethods' ifTrue: [
		^ self relatedTo: anEntity type: 'access' direction: #incoming ].
	^ MCPCommandError
		  signalErrorCode: #EntityRelationshipUnknown
		  message: 'Unknown traverse relationship: ' , aName asString , '.'
		  details: { (#relationship -> aName) } asDictionary
]

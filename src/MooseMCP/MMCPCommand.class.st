"
I am the abstract base for MooseMCP commands.

I hold the Famix/Moose-facing helper methods (model lookup, entity formatting, relationship traversal, metrics, visualization rendering) shared across the MooseMCP tool commands.
"
Class {
	#name : 'MMCPCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'testing' }
MMCPCommand class >> isAbstract [

	^ self == MMCPCommand
]

{ #category : 'visualization' }
MMCPCommand >> asDot: edges [

	^ String streamContents: [ :s |
			  s
				  nextPutAll: 'digraph G {';
				  nextPut: Character lf.
			  edges do: [ :ed |
					  s nextPutAll: '  "' , (ed at: 'sourceId') asString , '" -> "'
						  , (ed at: 'targetId') asString , '";'.
					  s nextPut: Character lf ].
			  s
				  nextPutAll: '}';
				  nextPut: Character lf ]
]

{ #category : 'visualization' }
MMCPCommand >> asMermaid: edges [

	^ String streamContents: [ :s |
			  s
				  nextPutAll: 'graph TD';
				  nextPut: Character lf.
			  edges do: [ :ed |
					  s nextPutAll: '  ' , (ed at: 'sourceId') asString , ' --> '
						  , (ed at: 'targetId') asString.
					  s nextPut: Character lf ] ]
]

{ #category : 'metrics' }
MMCPCommand >> computeMetric: aMetricName for: anEntity [

	| selector raw |
	selector := self metricSelectors at: aMetricName ifAbsent: [ ^ nil ].
	raw := self safePerform: selector on: anEntity.
	raw ifNil: [ ^ nil ].
	(raw isKindOf: Collection) ifTrue: [ ^ raw size ].
	^ raw
]

{ #category : 'formatting' }
MMCPCommand >> describeEntity: anEntity [

	| dict parent modifiers |
	dict := Dictionary new.
	dict at: 'id' put: anEntity mooseID asString.
	dict at: 'name' put: (self safePerform: #name on: anEntity).
	dict
		at: 'qualifiedName'
		put: (self safePerform: #mooseName on: anEntity).
	dict at: 'type' put: anEntity class name.
	dict at: 'comment' put: (self safePerform: #comment on: anEntity).
	dict at: 'sourceAnchor' put: (self describeSourceAnchor: anEntity).
	parent := self safePerform: #parentPackage on: anEntity.
	dict
		at: 'parentId'
		put: (parent ifNotNil: [ parent mooseID asString ]).
	modifiers := self safePerform: #modifiers on: anEntity.
	dict at: 'modifiers' put: (modifiers ifNotNil: [
			 (modifiers asOrderedCollection collect: #asString) asArray ]).
	dict
		at: 'numChildren'
		put: ((self safePerform: #containedEntities on: anEntity)
				 ifNil: [ 0 ]
				 ifNotNil: [ :c | c size ]).
	^ dict
]

{ #category : 'formatting' }
MMCPCommand >> describeModel: aModel includeStats: includeStats [

	| dict |
	dict := Dictionary new.
	dict at: 'modelId' put: aModel name.
	dict at: 'name' put: aModel name.
	includeStats ifTrue: [
			dict
				at: 'numClasses'
				put: (self entitiesOfType: 'Class' in: aModel) size.
			dict
				at: 'numMethods'
				put: (self entitiesOfType: 'Method' in: aModel) size.
			dict
				at: 'numPackages'
				put: (self entitiesOfType: 'Package' in: aModel) size ].
	^ dict
]

{ #category : 'formatting' }
MMCPCommand >> describeSourceAnchor: anEntity [

	| anchor dict |
	anchor := self safePerform: #sourceAnchor on: anEntity.
	anchor ifNil: [ ^ nil ].
	dict := Dictionary new.
	dict at: 'file' put: (self safePerform: #fileName on: anchor).
	dict at: 'startLine' put: (self safePerform: #startLine on: anchor).
	dict at: 'endLine' put: (self safePerform: #endLine on: anchor).
	^ dict
]

{ #category : 'relationships' }
MMCPCommand >> edgeType: aType from: source to: target direction: aDirection [

	| dict |
	dict := Dictionary new.
	dict at: 'type' put: aType.
	dict at: 'sourceId' put: source mooseID asString.
	dict at: 'targetId' put: target mooseID asString.
	dict at: 'direction' put: aDirection asString.
	^ dict
]

{ #category : 'model access' }
MMCPCommand >> entitiesOfType: aTypeName in: aModel [

	^ aModel metamodel classes
		  detect: [ :c | c name sameAs: aTypeName ]
		  ifOne: [ :fmClass |
			  (aModel allWithType: fmClass implementingClass) reject: #isStub ]
		  ifNone: [ #(  ) ]
]

{ #category : 'model access' }
MMCPCommand >> entityWithId: anId in: aModel [

	^ aModel entityStorage
		  detect: [ :e | e mooseID asString = anId ]
		  ifNone: [ Error signal: 'Entity not found: ' , anId asString ]
]

{ #category : 'metrics' }
MMCPCommand >> groupTargetsFor: aModel groupBy: aGrouping [

	aGrouping = 'package' ifTrue: [
		^ self entitiesOfType: 'Package' in: aModel ].
	aGrouping = 'class' ifTrue: [
		^ self entitiesOfType: 'Class' in: aModel ].
	^ OrderedCollection with: aModel
]

{ #category : 'metrics' }
MMCPCommand >> metricSelectors [

	| dict |
	dict := Dictionary new.
	dict at: 'LOC' put: #numberOfLinesOfCode.
	dict at: 'NOM' put: #numberOfMethods.
	dict at: 'WMC' put: #wmc.
	dict at: 'cyclomaticComplexity' put: #cyclomaticComplexity.
	dict at: 'fanIn' put: #allClients.
	dict at: 'fanOut' put: #allProviders.
	dict at: 'numberOfChildren' put: #containedEntities.
	dict at: 'DIT' put: #dit.
	^ dict
]

{ #category : 'model access' }
MMCPCommand >> modelNamed: aModelId [

	^ MooseModel root allModels
		  detect: [ :m | m name = aModelId ]
		  ifNone: [ Error signal: 'No model named ' , aModelId asString ]
]

{ #category : 'relationships' }
MMCPCommand >> relatedTo: anEntity type: aType direction: aDirection [

	aType = 'inheritance' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
						  (self safePerform: #superInheritances on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | c collect: #superclass ] ]
				  ifFalse: [
						  (self safePerform: #subInheritances on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | c collect: #subclass ] ] ].
	aType = 'invocation' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
				  (self safePerform: #invokedMethods on: anEntity) ifNil: [ #(  ) ] ]
				  ifFalse: [
				  (self safePerform: #invokingMethods on: anEntity) ifNil: [
					  #(  ) ] ] ].
	aType = 'access' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
						  (self safePerform: #accesses on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | c collect: #variable ] ]
				  ifFalse: [
						  (self safePerform: #incomingAccesses on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | c collect: #accessor ] ] ].
	^ aDirection = #outgoing
		  ifTrue: [
		  (self safePerform: #allProviders on: anEntity) ifNil: [ #(  ) ] ]
		  ifFalse: [
		  (self safePerform: #allClients on: anEntity) ifNil: [ #(  ) ] ]
]

{ #category : 'utilities' }
MMCPCommand >> safePerform: aSelector on: anEntity [

	^ [ anEntity perform: aSelector ]
		  on: Error
		  do: [ :ex | nil ]
]

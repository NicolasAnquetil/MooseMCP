"
I hold the Moose/Famix business logic and model registry backing the MooseMCP tools (list_models, get_entity, get_relationships, get_metrics, render_visualization).

I am a plain singleton (MMCPToolServer default) that the MMCP*Command classes delegate to.
"
Class {
	#name : 'MMCPToolServer',
	#superclass : 'Object',
	#classInstVars : [
		'Default'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'accessing' }
MMCPToolServer class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'visualization' }
MMCPToolServer >> asDot: edges [

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
MMCPToolServer >> asMermaid: edges [

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
MMCPToolServer >> computeMetric: aMetricName for: anEntity [

	| selector raw |
	selector := self metricSelectors at: aMetricName ifAbsent: [ ^ nil ].
	raw := self safePerform: selector on: anEntity.
	raw ifNil: [ ^ nil ].
	(raw isKindOf: Collection) ifTrue: [ ^ raw size ].
	^ raw
]

{ #category : 'formatting' }
MMCPToolServer >> describeEntity: anEntity [

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
MMCPToolServer >> describeModel: aModel includeStats: includeStats [

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
MMCPToolServer >> describeSourceAnchor: anEntity [

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
MMCPToolServer >> edgeType: aType from: source to: target direction: aDirection [

	| dict |
	dict := Dictionary new.
	dict at: 'type' put: aType.
	dict at: 'sourceId' put: source mooseID asString.
	dict at: 'targetId' put: target mooseID asString.
	dict at: 'direction' put: aDirection asString.
	^ dict
]

{ #category : 'model access' }
MMCPToolServer >> entitiesOfType: aTypeName in: aModel [

	^ aModel metamodel classes
		  detect: [ :c | c name sameAs: aTypeName ]
		  ifOne: [ :fmClass |
			  (aModel allWithType: fmClass implementingClass) reject: #isStub ]
		  ifNone: [ #(  ) ]
]

{ #category : 'model access' }
MMCPToolServer >> entityWithId: anId in: aModel [

	^ aModel entityStorage
		  detect: [ :e | e mooseID asString = anId ]
		  ifNone: [ Error signal: 'Entity not found: ' , anId asString ]
]

{ #category : 'tools-lookup' }
MMCPToolServer >> getEntity: modelId query: aString entityId: anId entityType: typeName exactMatch: aBool limit: aLimit [

	| model candidates matches |
	model := self modelNamed: modelId.
	(anId isNil or: [ anId isEmpty ]) ifFalse: [
			^ Array with:
				  (self describeEntity: (self entityWithId: anId in: model)) ].
	candidates := (typeName isNil or: [ typeName isEmpty ])
		              ifTrue: [ model entityStorage ]
		              ifFalse: [ self entitiesOfType: typeName in: model ].
	matches := (candidates select: [ :e |
			            | name |
			            name := (self safePerform: #mooseName on: e) ifNil: [
				                    '' ].
			            aBool
				            ifTrue: [ name = aString ]
				            ifFalse: [
				            name asLowercase includesSubstring:
					            aString asLowercase ] ]) asOrderedCollection.
	^ ((matches first: (matches size min: aLimit)) collect: [ :e |
		   self describeEntity: e ]) asArray
]

{ #category : 'tools-lookup' }
MMCPToolServer >> getMetrics: modelId entityId: anId metrics: metricList groupBy: aGrouping [

	| model names targets |
	model := self modelNamed: modelId.
	names := (metricList isNil or: [ metricList isEmpty ])
		         ifTrue: [
		         self metricSelectors keys asSortedCollection
			         asOrderedCollection ]
		         ifFalse: [ metricList ].
	targets := (anId isNil or: [ anId isEmpty ])
		           ifTrue: [ self groupTargetsFor: model groupBy: aGrouping ]
		           ifFalse: [
		           OrderedCollection with:
			           (self entityWithId: anId in: model) ].
	^ (targets collect: [ :entity |
			   | row metricsDict entityId |
			   metricsDict := Dictionary new.
			   names do: [ :m |
				   metricsDict at: m put: (self computeMetric: m for: entity) ].
			   row := Dictionary new.
			   entityId := self safePerform: #mooseID on: entity.
			   row
				   at: 'entityId'
				   put: (entityId ifNotNil: [ entityId asString ]).
			   row at: 'metrics' put: metricsDict.
			   row ]) asArray
]

{ #category : 'tools-lookup' }
MMCPToolServer >> getRelationships: modelId entityId: anId types: typeList direction: aDirection depth: aDepth limit: aLimit [

	| model root edges visited frontier nextFrontier types dir |
	model := self modelNamed: modelId.
	root := self entityWithId: anId in: model.
	types := (typeList isNil or: [ typeList isEmpty ])
		         ifTrue: [ #( 'inheritance' 'invocation' ) ]
		         ifFalse: [ typeList ].
	dir := aDirection ifNil: [ 'both' ].
	edges := OrderedCollection new.
	visited := Set new.
	visited add: root.
	frontier := OrderedCollection with: root.
	1 to: aDepth do: [ :level |
			nextFrontier := OrderedCollection new.
			frontier do: [ :e |
					types do: [ :aType |
							(dir = 'outgoing' or: [ dir = 'both' ]) ifTrue: [
									(self relatedTo: e type: aType direction: #outgoing) do: [
											:target |
											edges add: (self
													 edgeType: aType
													 from: e
													 to: target
													 direction: #outgoing).
											(visited includes: target) ifFalse: [
													visited add: target.
													nextFrontier add: target ] ] ].
							(dir = 'incoming' or: [ dir = 'both' ]) ifTrue: [
									(self relatedTo: e type: aType direction: #incoming) do: [
											:source |
											edges add: (self
													 edgeType: aType
													 from: source
													 to: e
													 direction: #incoming).
											(visited includes: source) ifFalse: [
													visited add: source.
													nextFrontier add: source ] ] ] ] ].
			frontier := nextFrontier ].
	^ Dictionary new
		  at: 'edges' put: (edges first: (edges size min: aLimit)) asArray;
		  at: 'truncated' put: edges size > aLimit;
		  yourself
]

{ #category : 'metrics' }
MMCPToolServer >> groupTargetsFor: aModel groupBy: aGrouping [

	aGrouping = 'package' ifTrue: [
		^ self entitiesOfType: 'Package' in: aModel ].
	aGrouping = 'class' ifTrue: [
		^ self entitiesOfType: 'Class' in: aModel ].
	^ OrderedCollection with: aModel
]

{ #category : 'tools-lookup' }
MMCPToolServer >> listModels: includeStats [

	^ (MooseModel root allModels collect: [ :m |
		   self describeModel: m includeStats: includeStats ]) asArray
]

{ #category : 'metrics' }
MMCPToolServer >> metricSelectors [

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
MMCPToolServer >> modelNamed: aModelId [

	^ MooseModel root allModels
		  detect: [ :m | m name = aModelId ]
		  ifNone: [ Error signal: 'No model named ' , aModelId asString ]
]

{ #category : 'relationships' }
MMCPToolServer >> relatedTo: anEntity type: aType direction: aDirection [

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

{ #category : 'tools-lookup' }
MMCPToolServer >> renderVisualization: modelId visualization: aKind scope: aScope format: aFormat maxNodes: aMax [

	| model edgeType direction rootTypeName roots edges nodes kept |
	model := self modelNamed: modelId.
	(aFormat = 'png' or: [ aFormat = 'svg' ]) ifTrue: [
			^ Error signal:
				  'Image rendering (png/svg) is not supported yet; use format: ''dot'' or ''mermaid''.' ].
	aKind = 'inheritance_tree'
		ifTrue: [
				edgeType := 'inheritance'.
				direction := #incoming.
				rootTypeName := 'Class' ]
		ifFalse: [
				aKind = 'dependency_graph'
					ifTrue: [
							edgeType := 'dependency'.
							direction := #outgoing.
							rootTypeName := 'Package' ]
					ifFalse: [
							^ Error signal:
								  'Visualization kind not yet supported: ' , aKind asString ] ].
	roots := (aScope isNil or: [ aScope isEmpty ])
		         ifTrue: [ self entitiesOfType: rootTypeName in: model ]
		         ifFalse: [
		         OrderedCollection with:
			         (self entityWithId: aScope in: model) ].
	edges := OrderedCollection new.
	nodes := Set new.
	roots do: [ :root |
			(self relatedTo: root type: edgeType direction: direction) do: [
					:other |
					| edge |
					edge := direction = #outgoing
						        ifTrue: [
								        self
									        edgeType: edgeType
									        from: root
									        to: other
									        direction: #outgoing ]
						        ifFalse: [
								        self
									        edgeType: edgeType
									        from: other
									        to: root
									        direction: #incoming ].
					edges add: edge.
					nodes
						add: (edge at: 'sourceId');
						add: (edge at: 'targetId') ] ].
	nodes size > aMax ifTrue: [
			kept := (nodes asOrderedCollection first: aMax) asSet.
			edges := edges select: [ :edge |
					         (kept includes: (edge at: 'sourceId')) and: [
						         kept includes: (edge at: 'targetId') ] ] ].
	^ aFormat = 'mermaid'
		  ifTrue: [ self asMermaid: edges ]
		  ifFalse: [ self asDot: edges ]
]

{ #category : 'utilities' }
MMCPToolServer >> safePerform: aSelector on: anEntity [

	^ [ anEntity perform: aSelector ]
		  on: Error
		  do: [ :ex | nil ]
]

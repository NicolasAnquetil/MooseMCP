"
Command that renders a visualization for render_visualization by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPRenderVisualizationCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPRenderVisualizationCommand >> execute [

	| modelId visualization scope format maxNodes model edgeType direction rootTypeName roots edges nodes kept |
	modelId := self request stringArgumentNamed: 'modelId'.
	visualization := self request stringArgumentNamed: 'visualization'.
	scope := self request stringArgumentNamed: 'scope'.
	format := self request
		          stringArgumentNamed: 'format'
		          default: 'mermaid'.
	maxNodes := self request
		            nonNegativeIntegerArgumentNamed: 'maxNodes'
		            default: 75.
	model := self modelNamed: modelId.
	(format = 'png' or: [ format = 'svg' ]) ifTrue: [
			^ Error signal:
				  'Image rendering (png/svg) is not supported yet; use format: ''dot'' or ''mermaid''.' ].
	visualization = 'inheritance_tree'
		ifTrue: [
				edgeType := 'inheritance'.
				direction := #incoming.
				rootTypeName := 'Class' ]
		ifFalse: [
				visualization = 'dependency_graph'
					ifTrue: [
							edgeType := 'dependency'.
							direction := #outgoing.
							rootTypeName := 'Package' ]
					ifFalse: [
							^ Error signal:
								  'Visualization kind not yet supported: '
								  , visualization asString ] ].
	roots := (scope isNil or: [ scope isEmpty ])
		         ifTrue: [ self entitiesOfType: rootTypeName in: model ]
		         ifFalse: [
		         OrderedCollection with:
			         (self entityWithId: scope in: model) ].
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
	nodes size > maxNodes ifTrue: [
			kept := (nodes asOrderedCollection first: maxNodes) asSet.
			edges := edges select: [ :edge |
					         (kept includes: (edge at: 'sourceId')) and: [
						         kept includes: (edge at: 'targetId') ] ] ].
	^ format = 'mermaid'
		  ifTrue: [ self asMermaid: edges ]
		  ifFalse: [ self asDot: edges ]
]

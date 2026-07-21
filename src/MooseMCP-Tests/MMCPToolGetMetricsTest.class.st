Class {
	#name : 'MMCPToolGetMetricsTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testComputesDefaultMetricSetForEntity [

	| result metrics |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> baseClass mooseID asString) } asDictionary.

	self assert: result size equals: 1.

	metrics := result first at: 'metrics'.

	self assert: (metrics includesKey: 'LOC').
	self assert: (metrics includesKey: 'NOM').
	self assert: (metrics at: 'NOM') equals: 1.
	self assert: (metrics includesKey: 'WMC').
	self assert: (metrics includesKey: 'cyclomaticComplexity').
	self assert: (metrics includesKey: 'fanIn').
	self assert: (metrics includesKey: 'fanOut').
	self assert: (metrics includesKey: 'numberOfChildren').
	self assert: (metrics at: 'numberOfChildren') equals: 1.
	self assert: (metrics includesKey: 'DIT').
]

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testExplicitMetricsListRestrictsOutput [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> baseClass mooseID asString).
			          (#metrics -> #( 'LOC' 'NOM' )) } asDictionary.

	self assert: (result first at: 'metrics') keys asSet equals: #( 'LOC' 'NOM' ) asSet
]

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testFanInFanOutAreComputedAsCollectionSizesNotDedicatedMetrics [
	"fanIn/fanOut are #allClients/#allProviders collection sizes
	BaseClass has 2 clients (SubClass via inheritance, and invocation-derived client relationship)
	and 0 providers"

	| result metrics |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> baseClass mooseID asString).
			          (#metrics -> #( 'fanIn' 'fanOut' )) } asDictionary.

	metrics := result first at: 'metrics'.
	self assert: (metrics at: 'fanIn') equals: 2.
	self assert: (metrics at: 'fanOut') equals: 0
]

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testGroupsByClassAcrossWholeModel [

	| result byId |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#metrics -> #( 'numberOfChildren' )).
			          (#groupBy -> 'class') } asDictionary.

	self assert: result size equals: 4.

	byId := Dictionary new.
	result do: [ :row |
			byId
				at: (row at: 'entityId')
				put: ((row at: 'metrics') at: 'numberOfChildren') ].
	self assert: (byId at: baseClass mooseID asString) equals: 1.
	self assert: (byId at: subClass mooseID asString) equals: 1.
	self assert: (byId at: otherClass mooseID asString) equals: 2.
	self assert: (byId at: isolatedClass mooseID asString) equals: 0
]

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testGroupsByPackageAcrossWholeModel [
	"bothe packages have 2 children"

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#metrics -> #( 'numberOfChildren' )).
			          (#groupBy -> 'package') } asDictionary.

	self assert: result size equals: 2.
	self assert: (result allSatisfy: [ :e | ((e at: 'metrics') at: 'numberOfChildren') = 2 ])
]

{ #category : 'tests' }
MMCPToolGetMetricsTest >> testRaisesWhenEntityIdUnknown [

	self
		should: [
				self callToolWith: {
						(#modelId -> self modelName).
						(#entityId -> 'nope') } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolGetMetricsTest >> toolClass [

	^ MMCPToolGetMetrics
]

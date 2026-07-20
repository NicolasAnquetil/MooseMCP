Class {
	#name : 'MMCPToolListModelsTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolListModelsTest >> testListsLoadedModelWithStats [

	| result entry |
	result := self callToolWith: { (#includeStats -> true) } asDictionary.
	entry := result detect: [ :e | (e at: 'modelId') = self modelName ].
	self assert: (entry at: 'name') equals: self modelName.
	self assert: (entry at: 'numClasses') equals: 4.
	self assert: (entry at: 'numMethods') equals: 3.
	self assert: (entry at: 'numPackages') equals: 2
]

{ #category : 'tests' }
MMCPToolListModelsTest >> testListsLoadedModelWithoutStats [

	| result entry |
	result := self callToolWith:
		          { (#includeStats -> false) } asDictionary.
	entry := result detect: [ :e | (e at: 'modelId') = self modelName ].
	self deny: (entry includesKey: 'numClasses').
	self deny: (entry includesKey: 'numMethods').
	self deny: (entry includesKey: 'numPackages')
]

{ #category : 'private - calling' }
MMCPToolListModelsTest >> toolClass [

	^ MMCPToolListModels
]

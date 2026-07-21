"
In-image registry of entity sets exposed through the MooseMCP query pipeline (query/filter_set/traverse/materialize).

The registry assigns opaque set ids and keeps the working collection server-side, so tools never round-trip full entity lists to the LLM.
"
Class {
	#name : 'MMCPEntitySetRegistry',
	#superclass : 'Object',
	#instVars : [
		'sets',
		'nextSetId'
	],
	#classInstVars : [
		'Default'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'instance creation' }
MMCPEntitySetRegistry class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'instance creation' }
MMCPEntitySetRegistry class >> resetDefault [

	Default := nil
]

{ #category : 'accessing' }
MMCPEntitySetRegistry >> entitiesFor: aSetId [

	^ sets at: aSetId ifAbsent: [
			  MCPCommandError
				  signalErrorCode: #EntitySetNotFound
				  message: 'Entity set ' , aSetId asString , ' was not found.'
				  details: { (#setId -> aSetId) } asDictionary ]
]

{ #category : 'initialization' }
MMCPEntitySetRegistry >> initialize [

	super initialize.
	sets := Dictionary new.
	nextSetId := 0
]

{ #category : 'registering' }
MMCPEntitySetRegistry >> registerSet: aCollection [

	| setId |
	nextSetId := nextSetId + 1.
	setId := 'set-' , nextSetId asString.
	sets at: setId put: aCollection.
	^ setId
]

{ #category : 'accessing' }
MMCPEntitySetRegistry >> size [

	^ sets size
]

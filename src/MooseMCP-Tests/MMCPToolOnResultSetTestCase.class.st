Class {
	#name : 'MMCPToolOnResultSetTestCase',
	#superclass : 'MMCPToolTestCase',
	#instVars : [
		'allClassesSetId',
		'allMethodsSetId',
		'baseClassSetId',
		'baseMethodSetId'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolOnResultSetTestCase class >> isAbstract [

	^ self = MMCPToolOnResultSetTestCase or: [ super isAbstract ]
]

{ #category : 'running' }
MMCPToolOnResultSetTestCase >> setUp [

	super setUp.

	allClassesSetId := MMCPEntitySetRegistry default registerSet:
		                   (OrderedCollection withAll: { baseClass . subClass . otherClass . isolatedClass}).
	allMethodsSetId := MMCPEntitySetRegistry default registerSet:
		                   (OrderedCollection withAll: {baseMethod . subMethod . otherMethod}).
	baseClassSetId := MMCPEntitySetRegistry default registerSet:
		                  (OrderedCollection with: baseClass).
	baseMethodSetId := MMCPEntitySetRegistry default registerSet:
		                   (OrderedCollection with: baseMethod)
]

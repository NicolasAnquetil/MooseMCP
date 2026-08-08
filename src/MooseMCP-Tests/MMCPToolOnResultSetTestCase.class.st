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
		                   (OrderedCollection withAll: {
				                    fixture baseClass.
				                    fixture subClass.
				                    fixture otherClass.
				                    fixture isolatedClass }).
	allMethodsSetId := MMCPEntitySetRegistry default registerSet:
		                   (OrderedCollection withAll: {
				                    fixture baseMethod.
				                    fixture subMethod.
				                    fixture otherMethod }).
	baseClassSetId := MMCPEntitySetRegistry default registerSet:
		                  (OrderedCollection with: fixture baseClass).
	baseMethodSetId := MMCPEntitySetRegistry default registerSet:
		                   (OrderedCollection with: fixture baseMethod)
]

Class {
	#name : 'ToolDeclarationParserTest',
	#superclass : 'PP2CompositeNodeTest',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'accessing' }
ToolDeclarationParserTest >> parserClass [

	^ToolDeclarationParser 
]

{ #category : 'tests' }
ToolDeclarationParserTest >> testCommentString [

	self 
		parse: 'Gets the cyclomatic complexity for the method in parameter.
    Args:
        A string naming a method
    Returns:
        Cyclomatic complexity value for the method in parameter'
		rule: #commentString.

	self assert: result size equals: 3.
	self assert: result first  equals: 'Gets the cyclomatic complexity for the method in parameter.'.
	self assert: result second equals: 'A string naming a method'.
	self assert: result third  equals: 'Cyclomatic complexity value for the method in parameter'
]

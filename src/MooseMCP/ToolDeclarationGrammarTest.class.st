Class {
	#name : 'ToolDeclarationGrammarTest',
	#superclass : 'PP2CompositeNodeTest',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'accessing' }
ToolDeclarationGrammarTest >> parserClass [

	^ToolDeclarationGrammar 
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testColon [

	self 
		parse: ':'
		rule: #colon
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testComa [

	self 
		parse: ', '
		rule: #comma
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testCommentString [

	self 
		parse: 'Gets the cyclomatic complexity for the method in parameter.
    Args:
        A string naming a method
    Returns:
        Cyclomatic complexity value for the method in parameter'
		rule: #commentString
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFrontMatter [

	self 
		parse: '

#----------------------------------------------------------------------------
'
		rule: #frontMatter
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFunctionDef [

	self 
		parse: 'def metricMethodCyclomaticComplexity(entity : str) -> float:  '
		rule: #functionDef.

	self 
		parse: 'def hasProperty(entity : str, property : str) -> bool:'
		rule: #functionDef.

]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFunctionParameter [

	self 
		parse: 'entity : str'
		rule: #functionParameter.

	self 
		parse: 'entities : list[str]'
		rule: #functionParameter

]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFunctionParameterList [

	self 
		parse: 'entity : str'
		rule: #functionParameterList.

	self 
		parse: 'entity : str, property : str'
		rule: #functionParameterList
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFunctionParameters [

	self 
		parse: '()'
		rule: #functionParameters.

	self 
		parse: '(entity : str)'
		rule: #functionParameters.

	self 
		parse: '(entity : str, property : str)'
		rule: #functionParameters.

]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testFunctionReturnType [

	self 
		parse: ' -> float:'
		rule: #functionReturnType.

	self 
		parse: ' -> list[str]:'
		rule: #functionReturnType

]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testIdentifier [

	self 
		parse: 'requestEntitylName'
		rule: #identifier
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testQuote [

	self 
		parse: ''''
		rule: #quote
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testReturnStmt [

	self 
		parse: 'return callMooseServer(''property:methodCyclomaticComplexity'', [entity])'
		rule: #returnStmt
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testToolAnnotation [

	self 
		parse: '
#----------------------------------------------------------------------------
@mcp.tool()'
		rule: #toolAnnotation 
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testToolComment [

	self 
		parse: ' """Gets the cyclomatic complexity for the method in parameter.
    Args:
        A string naming a method
    Returns:
        Cyclomatic complexity value for the method in parameter."""'
		rule: #toolComment
]

{ #category : 'tests' }
ToolDeclarationGrammarTest >> testTripeQuote [

	self 
		parse: '"""'
		rule: #tripleQuote
]

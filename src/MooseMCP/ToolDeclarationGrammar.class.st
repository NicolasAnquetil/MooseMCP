"
This grammar reads the tool description in file 'mooseMCPServer.py'
"
Class {
	#name : 'ToolDeclarationGrammar',
	#superclass : 'PP2CompositeNode',
	#instVars : [
		'file',
		'frontMatter',
		'tools',
		'backMatter',
		'tool',
		'toolComment',
		'returnStmt',
		'functionDef',
		'functionParameterList',
		'functionParameters',
		'functionParameter',
		'identifier',
		'colon',
		'tripleQuote',
		'commentString',
		'toolName',
		'toolArguments',
		'quote',
		'comma',
		'functionReturnType',
		'toolAnnotation',
		'commentOverview',
		'commentArguments',
		'commentReturn',
		'argsMarker',
		'returnMarker',
		'listType',
		'squareOpen',
		'squareClose',
		'atTool',
		'typeIdentifier',
		'toolNameString'
	],
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> argsMarker [

	^'Args:' asPParser trim
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> atTool [

	^'@mcp.tool()' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> backMatter [

	^'@' asPParser negate star , '@mcp.resource' asPParser  , #any asPParser star
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> colon [

	^':' asPParser trim
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> comma [

	^',' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> commentArguments [

	^returnMarker negate plus
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> commentOverview [

	^argsMarker negate plus
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> commentReturn [

	^tripleQuote negate plus
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> commentString [

	^commentOverview ,
	 argsMarker , commentArguments ,
	 returnMarker , commentReturn
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> file [

	^ tools , backMatter
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> frontMatter [

	^'@' asPParser negate star
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> functionDef [

	^'def' asPParser trim , identifier , functionParameters , functionReturnType
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> functionParameter [

	^ identifier , colon , typeIdentifier
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> functionParameterList [

	^ functionParameter , (comma , functionParameterList) optional
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> functionParameters [

	^'(' asPParser trim , functionParameterList optional , ')' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> functionReturnType [

	^'->' asPParser trim , typeIdentifier , colon
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> identifier [

	^#word asPParser plus
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> listType [

	^squareOpen , identifier , squareClose
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> quote [

	^'''' asPParser
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> returnMarker [

	^'Returns:' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> returnStmt [

	^'return callMooseServer(' asPParser ,
		toolNameString , comma ,
		squareOpen , toolArguments optional, squareClose ,
		')' asPParser  trim
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> squareClose [

	^']' asPParser trim
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> squareOpen [

	^'[' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> start [
	"Answer the production to start this parser with."
	
	^file end
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> tool [

	^toolAnnotation , functionDef  , toolComment , returnStmt
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> toolAnnotation [

	^frontMatter , atTool
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> toolArguments [

	^identifier , (comma , toolArguments) optional
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> toolComment [

	^tripleQuote , commentString , tripleQuote
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> toolName [

	^quote negate plus
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> toolNameString [

	^quote , toolName , quote
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> tools [

	^tool plus
]

{ #category : 'grammar-literals' }
ToolDeclarationGrammar >> tripleQuote [

	^'"""' asPParser trim
]

{ #category : 'grammar' }
ToolDeclarationGrammar >> typeIdentifier [

	^identifier , listType optional
]

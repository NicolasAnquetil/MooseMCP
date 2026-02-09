"
This parser reads the tool description in file 'mooseMCPServer.py' and writes it as a prompt for LLM

use it with:
```st
ToolDeclarationParser new runOn: '/.../mooseMCPServer.py'
```
"
Class {
	#name : 'ToolDeclarationParser',
	#superclass : 'ToolDeclarationGrammar',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'grammar' }
ToolDeclarationParser >> commentArguments [

	^super commentArguments flatten
]

{ #category : 'grammar' }
ToolDeclarationParser >> commentOverview [

	^super commentOverview flatten
]

{ #category : 'grammar' }
ToolDeclarationParser >> commentReturn [

	^super commentReturn flatten
]

{ #category : 'grammar' }
ToolDeclarationParser >> commentString [
	"
	 commentOverview ,
	 argsMarker , commentArguments ,
	 returnMarker , commentReturn
	"

	^super commentString 

	==> [ :tokens | { tokens at: 1 . tokens at: 3 . tokens at: 5 } ]
]

{ #category : 'grammar' }
ToolDeclarationParser >> file [
	"
	tools , backMatter
	"
	
	^super file

	==> [ :tokens | tokens at: 1 ]
]

{ #category : 'running' }
ToolDeclarationParser >> printTool: aTool id: id onStream: stream [

	stream
		<< id asString ;
		<< '. name: ' ;
		<< aTool first ;
		lf ;
		<< '  description: ' ;
		<< aTool second ;
		lf ;
		<< '  parameter: ' ;
		<< aTool third ; 
		lf ;
		<< '  result: ' ;
		<< aTool fourth ;
		lf ;
		lf
]

{ #category : 'grammar' }
ToolDeclarationParser >> returnStmt [
	"
	'return callMooseServer(' ,
		toolName , comma ,
		squareOpen , toolArguments optional, squareClose ,
		')'
	"

	^super returnStmt 
	
	==> [ :tokens | tokens at: 2 ]	
]

{ #category : 'running' }
ToolDeclarationParser >> runOn: aFilename [

	aFilename asFileReference readStreamDo: [ :st |
	ToolDeclarationParser new parse: st ].

	^String streamContents: [ :st |
		self withIndexDo: [ :tool :i |
			self printTool: tool id: i onStream: st
		]
	]
]

{ #category : 'grammar' }
ToolDeclarationParser >> tool [
	"
	toolAnnotation , functionDef  , toolComment , returnStmt
	"

	^super tool
	
	==> [ :tokens | { tokens at: 4 } , (tokens at: 3) ]	
]

{ #category : 'grammar' }
ToolDeclarationParser >> toolComment [

	"
	tripleQuote , commentString , tripleQuote
	"

	^super toolComment
	
	==> [ :tokens | tokens at: 2 ]	
]

{ #category : 'grammar' }
ToolDeclarationParser >> toolName [

	^super toolName flatten
]

{ #category : 'grammar' }
ToolDeclarationParser >> toolNameString [

	^super toolNameString 

	==> [ :tokens | tokens at: 2 ]
]

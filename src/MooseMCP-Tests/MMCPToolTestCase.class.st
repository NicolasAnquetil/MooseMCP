"
I am the abstract base for MooseMCP tool tests.

I build a small, deterministic FamixJavaModel fixture (2 packages, 4 classes with one inheritance edge, 3 methods with an invocation chain, 1 attribute with an access edge) registered with `MooseModel root` so `MMCPToolServer`'s name-based model lookup finds it exactly like a real imported model. Subclasses set `toolClass` and use `callToolWith:` to exercise that tool's `executeWithRequest:` directly, since the MMCPTool* classes are not registered in `MCPToolRegistry` and cannot be reached through the normal tool-call catalog.
"
Class {
	#name : 'MMCPToolTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'uniqueModelName',
		'package1',
		'package2',
		'baseClass',
		'subClass',
		'otherClass',
		'isolatedClass',
		'inheritance',
		'baseMethod',
		'subMethod',
		'otherMethod',
		'invocation',
		'deepInvocation',
		'attribute',
		'access'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolTestCase class >> isAbstract [

	^ self = MMCPToolTestCase or: [ super isAbstract ]
]

{ #category : 'private - fixture' }
MMCPToolTestCase >> buildFixture [

	model := FamixJavaModel named: self modelName.
	package1 := model newPackageNamed: 'package1'.
	package2 := model newPackageNamed: 'package2'.
	baseClass := (model newClassNamed: 'BaseClass') parentPackage: package1.
	subClass := (model newClassNamed: 'SubClass') parentPackage: package1.
	otherClass := (model newClassNamed: 'OtherClass') parentPackage: package2.
	isolatedClass := (model newClassNamed: 'IsolatedClass') parentPackage: package2.
	inheritance := model newInheritance subclass: subClass ; superclass: baseClass.
	baseMethod := (model newMethodNamed: 'baseMethod') parentType: baseClass.
	subMethod := (model newMethodNamed: 'subMethod') parentType: subClass.
	otherMethod := (model newMethodNamed: 'otherMethod') parentType: otherClass.
	invocation := model newInvocation sender: subMethod ; addCandidate: baseMethod.
	deepInvocation := model newInvocation sender: otherMethod ; addCandidate: subMethod.
	attribute := (model newAttributeNamed: 'field1') parentType: otherClass.
	access := model newAccess accessor: otherMethod ; variable: attribute.

	MooseModel root add: model
]

{ #category : 'private - calling' }
MMCPToolTestCase >> callTool: aToolClass with: someArguments [

	| tool request |
	tool := aToolClass new.
	request := tool requestFromToolCallArguments: someArguments.
	^ (tool executeWithRequest: request) structuredContent at: #data
]

{ #category : 'private - calling' }
MMCPToolTestCase >> callToolWith: someArguments [

	^ self callTool: self toolClass with: someArguments
]

{ #category : 'private - fixture' }
MMCPToolTestCase >> modelName [
	"MMCPCommand looks models up by name (via MooseModel root allModels), so a name
	shared across instances risks one test's calls resolving to a different test's
	same-named model."

	^ uniqueModelName ifNil: [
			  uniqueModelName := 'MMCPToolTestModel_' , self class name , '_'
			                     , self identityHash printString ]
]

{ #category : 'private - fixture' }
MMCPToolTestCase >> removeFixture [

	model ifNotNil: [ model remove ]
]

{ #category : 'running' }
MMCPToolTestCase >> setUp [

	super setUp.
	self buildFixture
]

{ #category : 'running' }
MMCPToolTestCase >> tearDown [

	self removeFixture.
	super tearDown
]

{ #category : 'private - calling' }
MMCPToolTestCase >> toolClass [

	self subclassResponsibility
]

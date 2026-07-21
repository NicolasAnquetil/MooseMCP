"
I am the abstract base for MooseMCP tool tests.

I build a small, deterministic FamixJavaModel fixture (2 packages, 4 classes with one inheritance edge, 3 methods with an invocation chain, 1 attribute with an access edge) registered with `MooseModel root` so `MMCPToolServer`'s name-based model lookup finds it exactly like a real imported model. Subclasses set `toolClass` and use `callToolWith:` to exercise that tool's `executeWithRequest:` directly, since the MMCPTool* classes are not registered in `MCPToolRegistry` and cannot be reached through the normal tool-call catalog.
"
Class {
	#name : 'MMCPToolTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'package1',
		'package2',
		'baseClass',
		'subClass',
		'otherClass',
		'isolatedClass',
		'baseMethod',
		'subMethod',
		'otherMethod',
		'attribute',
		'inheritanceEdge',
		'invocationEdge',
		'deepInvocationEdge',
		'accessEdge',
		'uniqueModelName'
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
	package1 := (FamixJavaPackage named: 'package1') mooseModel: model.
	package2 := (FamixJavaPackage named: 'package2') mooseModel: model.
	baseClass := (FamixJavaClass named: 'BaseClass')
		             parentPackage: package1;
		             mooseModel: model.
	subClass := (FamixJavaClass named: 'SubClass')
		            parentPackage: package1;
		            mooseModel: model.
	otherClass := (FamixJavaClass named: 'OtherClass')
		              parentPackage: package2;
		              mooseModel: model.
	isolatedClass := (FamixJavaClass named: 'IsolatedClass')
		                 parentPackage: package2;
		                 mooseModel: model.
	inheritanceEdge := FamixJavaInheritance new
		                   subclass: subClass;
		                   superclass: baseClass;
		                   mooseModel: model.
	baseMethod := (FamixJavaMethod named: 'baseMethod')
		              parentType: baseClass;
		              mooseModel: model.
	subMethod := (FamixJavaMethod named: 'subMethod')
		             parentType: subClass;
		             mooseModel: model.
	otherMethod := (FamixJavaMethod named: 'otherMethod')
		               parentType: otherClass;
		               mooseModel: model.
	invocationEdge := FamixJavaInvocation new
		                  sender: subMethod;
		                  addCandidate: baseMethod;
		                  mooseModel: model.
	deepInvocationEdge := FamixJavaInvocation new
		                      sender: otherMethod;
		                      addCandidate: subMethod;
		                      mooseModel: model.
	attribute := (FamixJavaAttribute named: 'field1')
		             parentType: otherClass;
		             mooseModel: model.
	accessEdge := FamixJavaAccess new
		              accessor: otherMethod;
		              variable: attribute;
		              mooseModel: model.
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
	"Unique per test instance, not just per class: test_run appears to execute test
	methods of the same class with overlapping setUp/tearDown lifetimes, and
	MMCPCommand looks models up by name via MooseModel root allModels, so a name
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

"
I am a deterministic FamixJavaModel fixture used by MMCPToolTestCase and MooseMCPToolDispatchTest.

I build a small, deterministic FamixJavaModel (2 packages, 4 classes with one inheritance edge, 3 methods with an invocation chain, 1 attribute with an access edge), registered with `MooseModel root` so `MMCPCommand`'s name-based model lookup finds it exactly like a real imported model. Each instance gets a collision-safe, debug-friendly model name derived from a caller-supplied label. Consumers hold an instance as a `fixture` ivar and reach into its entities via accessors (e.g. `fixture baseClass`); `remove` unregisters the model from `MooseModel root` for teardown.
"
Class {
	#name : 'MMCPToolTestFixture',
	#superclass : 'Object',
	#instVars : [
		'model',
		'modelName',
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
	#category : 'MooseMCP-Tests-Fixture',
	#package : 'MooseMCP-Tests',
	#tag : 'Fixture'
}

{ #category : 'instance creation' }
MMCPToolTestFixture class >> buildLabeled: aLabel [

	^ self new buildLabeled: aLabel
]

{ #category : 'accessing' }
MMCPToolTestFixture >> access [

	^ access
]

{ #category : 'accessing' }
MMCPToolTestFixture >> attribute [

	^ attribute
]

{ #category : 'accessing' }
MMCPToolTestFixture >> baseClass [

	^ baseClass
]

{ #category : 'accessing' }
MMCPToolTestFixture >> baseMethod [

	^ baseMethod
]

{ #category : 'building' }
MMCPToolTestFixture >> buildLabeled: aLabel [

	modelName := 'MMCPToolTestModel_' , aLabel , '_'
	             , self identityHash printString.
	model := FamixJavaModel named: modelName.
	package1 := model newPackageNamed: 'package1'.
	package2 := model newPackageNamed: 'package2'.
	baseClass := (model newClassNamed: 'BaseClass') parentPackage:
		             package1.
	subClass := (model newClassNamed: 'SubClass') parentPackage: package1.
	otherClass := (model newClassNamed: 'OtherClass') parentPackage:
		              package2.
	isolatedClass := (model newClassNamed: 'IsolatedClass')
		                 parentPackage: package2.
	inheritance := model newInheritance
		               subclass: subClass;
		               superclass: baseClass.
	baseMethod := (model newMethodNamed: 'baseMethod') parentType:
		              baseClass.
	subMethod := (model newMethodNamed: 'subMethod') parentType: subClass.
	otherMethod := (model newMethodNamed: 'otherMethod') parentType:
		               otherClass.
	invocation := model newInvocation
		              sender: subMethod;
		              addCandidate: baseMethod.
	deepInvocation := model newInvocation
		                  sender: otherMethod;
		                  addCandidate: subMethod.
	attribute := (model newAttributeNamed: 'field1') parentType:
		             otherClass.
	access := model newAccess
		          accessor: otherMethod;
		          variable: attribute.

	MooseModel root add: model
]

{ #category : 'accessing' }
MMCPToolTestFixture >> deepInvocation [

	^ deepInvocation
]

{ #category : 'accessing' }
MMCPToolTestFixture >> inheritance [

	^ inheritance
]

{ #category : 'accessing' }
MMCPToolTestFixture >> invocation [

	^ invocation
]

{ #category : 'accessing' }
MMCPToolTestFixture >> isolatedClass [

	^ isolatedClass
]

{ #category : 'accessing' }
MMCPToolTestFixture >> model [

	^ model
]

{ #category : 'accessing' }
MMCPToolTestFixture >> modelName [

	^ modelName
]

{ #category : 'accessing' }
MMCPToolTestFixture >> otherClass [

	^ otherClass
]

{ #category : 'accessing' }
MMCPToolTestFixture >> otherMethod [

	^ otherMethod
]

{ #category : 'accessing' }
MMCPToolTestFixture >> package1 [

	^ package1
]

{ #category : 'accessing' }
MMCPToolTestFixture >> package2 [

	^ package2
]

{ #category : 'building' }
MMCPToolTestFixture >> remove [

	model ifNotNil: [ model remove ]
]

{ #category : 'accessing' }
MMCPToolTestFixture >> subClass [

	^ subClass
]

{ #category : 'accessing' }
MMCPToolTestFixture >> subMethod [

	^ subMethod
]

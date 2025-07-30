Class {
	#name : 'ChatPharoMethodBrowser',
	#superclass : 'ChatPharoPackageBrowser',
	#instVars : [
		'methodName'
	],
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'testing' }
ChatPharoMethodBrowser class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isMethodSelected ]
]

{ #category : 'accessing' }
ChatPharoMethodBrowser class >> tabOrder [

	^ -12
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> defaultTitle [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName: anObject [

	methodName := anObject
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> setUpModelFromContext [

	methodName := context lastSelectedMethod selector.
	self updateAgentMethodName

]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgent [ 

	self updateAgentMethodName 
]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgentMethodName [

	(chat notNil and: [ chat agent respondsTo: #methodName: ]) ifTrue: [
		chat agent methodName: methodName ].
]

{ #category : 'actions' }
ChatPharoMethodBrowser >> generateTestMethodFor: aMethod [

    | testClass selector prompt response methodBody currentAgent |
    testClass := self findOrCreateTestClassFor: aMethod methodClass.
    selector   := self testSelectorFor: aMethod selector.

    aMethod sourceCode ifNil: [ ^ self inform: 'Cannot generate test. Source code is unavailable.' ].
    (testClass includesSelector: selector)
        ifTrue: [ ^ self inform: 'Test method already exists.' ].

    prompt := String streamContents: [ :s |
        s
            nextPutAll: 'Generate a test method in Smalltalk SUnit style ';
            nextPutAll: 'for the following method. Only return the method body ';
            nextPutAll: '(without the method header):'; cr;
            nextPutAll: aMethod sourceCode ].

    currentAgent := ChatPharoSettings default agent.
    currentAgent := (currentAgent isKindOf: ChatPharoAgent)
        ifTrue: [ currentAgent copyForChat ]
        ifFalse: [ currentAgent ].

    response   := currentAgent prompt: prompt.
    methodBody := response ifNil: [ 'self assert: false.' ].

    self
        generateTestMethodNamed: selector
        in: testClass
        withBody: methodBody
]

{ #category : 'actions' }
ChatPharoMethodBrowser >> generateTestMethodNamed: aSelector in: aClass withBody: aMethodBody [
	| indentedBody fullSource |
    indentedBody := String streamContents: [ :stream |
        aMethodBody linesDo: [ :line |
            stream
                nextPutAll: '    ';   "4 spaces"
                nextPutAll: line; cr ] ].
    fullSource := String streamContents: [ :s |
        s
            nextPutAll: aSelector asString; cr;
            nextPutAll: indentedBody ].
    aClass compile: fullSource classified: 'tests'.
]

{ #category : 'utils' }
ChatPharoMethodBrowser >> findOrCreateTestClassFor: aClass [
	| testClassName |
    testClassName := aClass name , 'Test'.
    ^ Smalltalk
        at: testClassName asSymbol
        ifAbsentPut: [
            TestCase                          
                subclass: testClassName asSymbol
                instanceVariableNames: ''
                classVariableNames: ''
                poolDictionaries: ''
                category: aClass category , '-Tests' ]
]

{ #category : 'utils' }
ChatPharoMethodBrowser >> testSelectorFor: aSelector [
	| base |
    base := aSelector asString.
    ^ ('test', base first asUppercase, base allButFirst) asString
        withoutSeparators asSymbol
]
Class {
	#name : 'ChatPharoBrowserSystemPromptInputPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'textInput'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'layout' }
ChatPharoBrowserSystemPromptInputPresenter >> defaultLayout [ 

    ^ SpBoxLayout newTopToBottom
        add: textInput;
        yourself
]

{ #category : 'initialization' }
ChatPharoBrowserSystemPromptInputPresenter >> initializePresenters [ 

    textInput := self newTextInput
                    placeholder: 'Browser system prompt...';
                    text: model agent browserSystemPrompt;
                    yourself.
    textInput whenTextChangedDo: [ :text | model agent browserSystemPrompt: text ]
]

{ #category : 'initialization' }
ChatPharoBrowserSystemPromptInputPresenter >> setModelBeforeInitialization: anObject [ 

    model := anObject
]

"
### `ChatPharoSpecChatBubble` Class
Visual presentation for individual chat messages as bubbles.

- **`from:`**: Factory method to create a chat bubble from a message.
- **`defaultLayout`**: Arranges the content within the bubble.
- **`initializePresenters`**: Sets up the text display inside the bubble.
"
Class {
	#name : 'ChatPharoSpecChatBubble',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'spParent',
		'roleText',
		'contentArea'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatBubble class >> from: aMessage parent: par [
	^ self basicNew
		spParent: par;
		setModelBeforeInitialization: aMessage;
		initialize;
		yourself
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> contentArea [

	^ contentArea
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> contentArea: anObject [

	contentArea := anObject
]

{ #category : 'layout' }
ChatPharoSpecChatBubble >> defaultLayout [
	| modelName displayRole |
	modelName := self spParent ollamaModel model.
	displayRole := self model role.
	displayRole = 'assistant' ifTrue: [ displayRole := displayRole , ' (' , modelName , ')'].
	^ SpBoxLayout newTopToBottom
		  add: displayRole expand: false;
		  add: contentArea
		  withConstraints: [ :constraints | 
			constraints height: (self class inputTextHeight) * 4 ];
		  yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatBubble >> initializePresenters [
	contentArea := MicrodownPresenter new.
	contentArea document: (Microdown parse: self model content)
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText [

	^ roleText
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText: anObject [

	roleText := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> spParent [

	^ spParent
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> spParent: anObject [

	spParent := anObject
]

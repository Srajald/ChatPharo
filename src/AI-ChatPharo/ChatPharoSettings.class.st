"
User-editable configuration.

* Knows the currently selected `agent`.
* Produces the list of **available API choices** by returning associations `displayName -> class`.
* Delegates model selection (`useModel:`) and agent swapping (`useApi:`) to the agent it owns.
* **Why** – separates persistent/user-configurable concerns from transient chat state.


```smalltalk
(ChatPharoSettings new
	useModel: 'codellama:7b';
	ollamaApi)
		getResponseForPrompt: 'Bonjour'.

```
"
Class {
	#name : 'ChatPharoSettings',
	#superclass : 'Object',
	#instVars : [
		'agent',
		'browserExtensionEnabled',
		'browserToolsEnabled'
	],
	#classInstVars : [
		'Default'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoSettings class >> default [

	Default ifNil: [ Default := self loadOrNew ].
	^ Default
]

{ #category : 'accessing' }
ChatPharoSettings class >> loadOrNew [

	| path file |
	path := FileLocator imageDirectory / 'chatpharo-settings.ston'.

	file := path exists
		        ifTrue: [ path readStream ]
		        ifFalse: [ ^ self new ].

	[
		| settings |
		settings := STON fromStream: file.
		settings browserExtensionEnabled ifNil: [
			settings browserExtensionEnabled: false ].
	            settings browserToolsEnabled ifNil: [
                settings browserToolsEnabled: (ChatPharoBrowserEnvironment new tools collect: [ :t | t name ]) asOrderedCollection
            ].
		^ settings ]
		on: Error
		do: [ ^ self new ]
]

{ #category : 'accessing' }
ChatPharoSettings class >> resetDefault [

	<script>
	Default := nil.
	'chatpharo-settings.ston' asFileReference deleteIfAbsent: [ "do nothing" ].
	^self
]

{ #category : 'accessing' }
ChatPharoSettings class >> saveDefault [

	| path |
	path := FileLocator imageDirectory / 'chatpharo-settings.ston'.
	path writeStreamDo: [ :stream |
		STON put: self default onStream: stream ].
	^self
]

{ #category : 'accessing' }
ChatPharoSettings class >> setDefault: aSettings [ 

	Default := aSettings
]

{ #category : 'initialization' }
ChatPharoSettings >> agent [

	^ agent
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApiChoices [

	^ (self availableApis collect: [ :cls | cls displayName -> cls ])
		  asOrderedCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApis [

	^ {
		  ChatPharoNullAgent.
		  ChatPharoOllamaAgent.
		  ChatPharoGeminiAgent.}
]

{ #category : 'initialization' }
ChatPharoSettings >> browserExtensionEnabled [ 

        ^ browserExtensionEnabled
]

{ #category : 'initialization' }
ChatPharoSettings >> browserExtensionEnabled: aBoolean [ 

        browserExtensionEnabled := aBoolean
]

{ #category : 'initialization' }
ChatPharoSettings >> browserToolsEnabled [

        ^ browserToolsEnabled
]

{ #category : 'initialization' }
ChatPharoSettings >> browserToolsEnabled: aCollection [ 

        browserToolsEnabled := aCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> disableBrowserTool: toolName [ 

        browserToolsEnabled remove: toolName ifAbsent: []
]

{ #category : 'initialization' }
ChatPharoSettings >> enableBrowserTool: toolName [

	        (browserToolsEnabled includes: toolName)
                ifFalse: [ browserToolsEnabled add: toolName ]
]

{ #category : 'initialization' }
ChatPharoSettings >> initialize [

	super initialize.
	agent := ChatPharoNullAgent new.
	browserExtensionEnabled := false.
	 browserToolsEnabled := (ChatPharoBrowserEnvironment new tools collect: [ :t | t name ]) asOrderedCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> models [

	^ agent class modelNames
]

{ #category : 'initialization' }
ChatPharoSettings >> presenter [

	^  ChatPharoSettingsPresenter on: self
]

{ #category : 'initialization' }
ChatPharoSettings >> useApi: anAgentClass [

	agent := anAgentClass new.
	self class setDefault: self.
	self class saveDefault
]

{ #category : 'initialization' }
ChatPharoSettings >> useModel: aModelName [

	agent model: aModelName.
	self class setDefault: self. 
	self class saveDefault
]

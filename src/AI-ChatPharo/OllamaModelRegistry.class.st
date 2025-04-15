"
Base class and specific implementations for different models used in API interactions.

•	fullName: Constructs the full name of the model for API requests.
•	name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OllamaModelRegistry',
	#superclass : 'Object',
	#instVars : [ ],
	#classInstVars : [ ],
	#category : 'AI-ChatPharo-Model',
	#package : 'AI-ChatPharo',
	#tag : 'Model'
}

{ #category : 'model-accessing' }
OllamaModelRegistry >> allModels [

	[ OllamaAPI new listModels ]
		on: Error
		do: [ ^ #('codellama:7b') ]

]

{ #category : 'model-accessing' }
OllamaModelRegistry >> defaultModel [

	^ self allModels
		ifNotEmpty: [ :list | list first ]
		ifEmpty: [ 'codellama:7b' ] 
]
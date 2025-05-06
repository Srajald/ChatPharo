Class {
    #name : 'ChatPharoConnectionStatus',
    #superclass : 'SpToolbarItemPresenter',
    #instVars : [
        'labelMorph'
    ],
    #category : 'AI-ChatPharo2-Spec',
    #package : 'AI-ChatPharo2-Spec'
}

{ #category : 'building' }
ChatPharoConnectionStatus >> buildMorph [

    labelMorph := LabelMorph new.
    labelMorph label: self label.
    self color ifNotNil: [ labelMorph color: self color ].
    self help ifNotNil: [ labelMorph help: self help ].
    ^ labelMorph
]

{ #category : 'updating' }
ChatPharoConnectionStatus >> label: aString [

    super label: aString.
    labelMorph ifNotNil: [ labelMorph label: aString ]
]

{ #category : 'updating' }
ChatPharoConnectionStatus >> color: aColor [

    super color: aColor.
    labelMorph ifNotNil: [ labelMorph color: aColor ]
]

{ #category : 'updating' }
ChatPharoConnectionStatus >> help: aString [

    super help: aString.
    labelMorph ifNotNil: [ labelMorph help: aString ]
]

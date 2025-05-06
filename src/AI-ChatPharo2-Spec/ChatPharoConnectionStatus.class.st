Class {
    #name : 'ChatPharoConnectionStatus',
    #superclass : 'SpToolbarItemPresenter',
    #instVars : [
        'labelMorph',
        'label',
        'color',
        'help'
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

{ #category : 'accessing' }
ChatPharoConnectionStatus >> label [

    ^ label
]

{ #category : 'accessing' }
ChatPharoConnectionStatus >> label: aString [

    label := aString.
    labelMorph ifNotNil: [ labelMorph label: aString ]
]

{ #category : 'accessing' }
ChatPharoConnectionStatus >> color [

    ^ color
]

{ #category : 'accessing' }
ChatPharoConnectionStatus >> color: aColor [

    color := aColor.
    labelMorph ifNotNil: [ labelMorph color: aColor ]
]

{ #category : 'accessing' }
ChatPharoConnectionStatus >> help [

    ^ help
]

{ #category : 'accessing' }
ChatPharoConnectionStatus >> help: aString [

    help := aString.
    labelMorph ifNotNil: [ labelMorph help: aString ]
]

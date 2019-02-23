Class {
	#name : #GtPreviewStencil,
	#superclass : #BrStencil,
	#traits : 'TGt2DocumentConstants',
	#classTraits : 'TGt2DocumentConstants classTrait',
	#instVars : [
		'result',
		'showSelector',
		'height'
	],
	#category : #'GToolkit-Documenter-Brick - Stencils'
}

{ #category : #accessing }
GtPreviewStencil class >> constants [
	^ GtDocumentConstants
]

{ #category : #accessing }
GtPreviewStencil >> constants [
	^ GtDocumentConstants
]

{ #category : #'api - instantiation' }
GtPreviewStencil >> create [
	<return: #BlElement>
	| aView |
	aView := GtPhlowView empty on: self result perform: self showSelector.
	^ aView asElementDo:
		[ :anElement | self newContainerFor: anElement ]
]

{ #category : #'instance creation' }
GtPreviewStencil >> defaultHeight [
	^ self constants defaultPreviewHeight
]

{ #category : #accessing }
GtPreviewStencil >> height [
	<return: #Number or: nil>
	^ height
]

{ #category : #accessing }
GtPreviewStencil >> height: anInteger [
	self 
		assert: [ anInteger notNil ] 
		description: [ 'Height value must be non-nil' ].
	self 
		assert: [ anInteger > 0 ] 
		description: [ 'Height value must be a pozitive number' ].
	height := anInteger
]

{ #category : #initialization }
GtPreviewStencil >> initialize [
	super initialize.

	result := self class.
	showSelector := self constants defaultShowSelector.
	height := self defaultHeight.
]

{ #category : #'instance creation' }
GtPreviewStencil >> newContainerFor: anElement [
	^ BlElement new
		addChild: anElement;
		layout: BlLinearLayout new;
		look: GtPreviewLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical exact: self height ]
]

{ #category : #accessing }
GtPreviewStencil >> result [
	^ result
]

{ #category : #accessing }
GtPreviewStencil >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtPreviewStencil >> showSelector [
	^ showSelector
]

{ #category : #accessing }
GtPreviewStencil >> showSelector: aSymbol [
	self 
		assert: [ aSymbol notNil ] 
		description: [ 'Show selector name must be non-nil' ].
	self 
		assert: [ aSymbol isSymbol ] 
		description: [ 'Show selector name must be a symbol' ].
	showSelector := aSymbol
]
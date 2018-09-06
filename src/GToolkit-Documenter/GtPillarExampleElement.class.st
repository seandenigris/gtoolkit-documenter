"
I allow users to edit GT-Examples and support a preview of the result.

!! Example:

[[[
	| example exampleElement |
	""Acquire an instance of GT-Example we are interested in""
	example := (BrTextEditorExamples >> #newElement) gtExample.
	exampleElement := GtPillarExampleElement new.
	exampleElement size: 300@100.
	""attach GT-Example""
	exampleElement 
		example: example
		""specify how example's return value should be transformed into an element""
		showBlock: [ :aResult | BlTextElement new text: (BrRopedText string: aResult asString) ]
]]]
"
Class {
	#name : #GtPillarExampleElement,
	#superclass : #BlElement,
	#instVars : [
		'previewElement',
		'example',
		'previewShowBlock',
		'previewHeight'
	],
	#category : 'GToolkit-Documenter-Brick'
}

{ #category : #'instance creation' }
GtPillarExampleElement class >> withCode: shouldShowCode [
	"Create and return an example element that also shows example's
	code if true is given"
	<return: #GtPillarExampleElement>
	
	^ shouldShowCode
		ifTrue: [ GtPillarExampleWithCodeElement new ]
		ifFalse: [ GtPillarExampleWithoutCodeElement new ]
]

{ #category : #initialization }
GtPillarExampleElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #preview }
GtPillarExampleElement >> ensurePreviewElement: aBlock [
	<return: #BlElement>
	^ aBlock 
		on: Error 
		do: [ :anException | 
			anException asDebuggableElement ]
]

{ #category : #accessing }
GtPillarExampleElement >> example [
	"Return assigned gt example that can not be nil"
	<return: #GtExample>
	
	self
		assert: [ example isNotNil ]
		description: [ 'Can not access unexisting example' ].

	^ example
]

{ #category : #accessing }
GtPillarExampleElement >> example: aGTExample showBlock: aPreviewShowBlock [
	"Initialize me with a given GT-Example.
	With aPreviewShowBlock users can specify how GT-Examples result should be transformed into an element.
	aGTExample must not be nil.
	aPreviewShowBlock must not be nil"
	
	self
		assert: [ aGTExample isNotNil ]
		description: [ 'Example must not be nil' ].
		
	self
		assert: [ example isNil ]
		description: [ 'Can be initialized only once' ].
			
	self
		assert: [ aPreviewShowBlock isNotNil ]
		description: [ 'Transformation must not be nil' ].
		
	previewShowBlock := aPreviewShowBlock.
	example := aGTExample.

	self initializeElements.
	self initializeListeners
]

{ #category : #testing }
GtPillarExampleElement >> hasCustomPreviewHeight [
	"Return true if preview should have a predefined height"
	<return: #Boolean>

	^ previewHeight isNotNil
]

{ #category : #preview }
GtPillarExampleElement >> hidePreview [
	"Hide preview removing example element from its container"
	
	self
		assert: [ previewElement hasParent ]
		description: [ 'Can not hide preview if it is not shown' ].
	
	self
		assert: [ previewElement hasChildren ]
		description: [ 'Preview container must have example result element' ].
		
	self removeChild: previewElement.
	previewElement removeChildren
]

{ #category : #initialization }
GtPillarExampleElement >> initializeElements [
	"Initalize elements and add them as children.
	Note: Must be done only after attaching a GT-Example"

	previewElement := self newPreviewElement.
	previewElement constraintsDo: [ :c |
		c horizontal matchParent.
		
		self hasCustomPreviewHeight
			ifTrue: [ c vertical exact: previewHeight ]
			ifFalse: [ c vertical exact: 200 ].
		self flag: 'I do not understand why I have to say exact: 200'.
		"since parent is horizontal, I will take 50% of the available width"
		c linear weight: 0.5 ]
]

{ #category : #initialization }
GtPillarExampleElement >> initializeListeners [
	"Initalize elements listeners.
	Note: Elements must be initalized before listeners!"
]

{ #category : #preview }
GtPillarExampleElement >> isPreviewShown [
	"Return true if preview is already shown (added to myself), false otherwise"
	<return: #Boolean>
	
	^ previewElement hasParent
]

{ #category : #'instance creation' }
GtPillarExampleElement >> newArrowElement [
	"Instantiate and return a new element playing a role of an arrow
	used to show / hide a preview"
	<return: #BlElement>

	^ BlElement new
		size: 16@24;
		geometry: (BlPolygon vertices: { 0@0 . 24@0 . 12@16 } );
		margin: (BlInsets top: 5 right: 0 bottom: 5 left: 0);
		background: Color veryVeryLightGray
]

{ #category : #'instance creation' }
GtPillarExampleElement >> newPreviewElement [
	"Instantiate and return an element playing a role of a container for
	the resulting GT-Example element"
	<return: #BlElement>

	^ BlElement new
		layout: BlLinearLayout new
]

{ #category : #accessing }
GtPillarExampleElement >> previewHeight: aNumber [
	"Customize the height of a preview block"
	
	previewHeight := aNumber
]

{ #category : #preview }
GtPillarExampleElement >> showPreview [
	self showPreview: previewShowBlock
]

{ #category : #preview }
GtPillarExampleElement >> showPreview: aBlockOrSymbol [
	"Get return value of attached example and evaluate a given block
	with resulting object as an argument in order to transform it
	into a visual element to be opened as a preview"
	| aResultElement exampleResult |

	self
		assert: [ previewElement hasParent not ]
		description: [ 'Can not show preview if it is already opened' ].

	"Only resizer bar is present"
	self
		assert: [ previewElement hasChildren not ]
		description: [ 'Preview container must be empty' ].

	"we don't add resulting element directly, but instead put
	in a container that matches parent. This allows us to preserve
	layout constrains of resulting element untouched"
	exampleResult := self example result.
	aResultElement := exampleResult hasException 
		ifTrue: [ exampleResult exampleException asDebuggableElement ]
		ifFalse: [ self ensurePreviewElement: [ aBlockOrSymbol value: exampleResult returnValue ] ].
	self
		assert: [ aResultElement isNotNil ]
		description: [ 'Resulting element must not be nil' ].

	previewElement addChildFirst: aResultElement.
	previewElement := GtDocumenterUtility newResizableElementFor: previewElement.
	self addChild: previewElement
]
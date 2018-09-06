Class {
	#name : #GtPillarFigureHighlighter,
	#superclass : #GtPillarNodeHighlighter,
	#category : 'GToolkit-Documenter-Pillar - Highlighter'
}

{ #category : #'private - accessing' }
GtPillarFigureHighlighter >> figureFileReferenceOrNil [
	"Return a figure file reference or nil if figure reference is not file"
	<return: #FileReference or: nil>
	| aFileName |
	(self pillarNode reference beginsWith: 'file://') ifFalse: [ ^ nil ].
	aFileName := self pillarNode reference
	                copyFrom: 'file://' size + 1
	                to: self pillarNode reference size.
	^ GtFileUtility 
		fileReferenceOfFileName: aFileName 
		relativeTo: self fileReference parent
]

{ #category : #'api - actions' }
GtPillarFigureHighlighter >> highlight [
	| anAttributeCreatingBlock aFigureFileReference |
	aFigureFileReference := self figureFileReferenceOrNil.
	aFigureFileReference ifNil: [ ^ self styleTextNotFileReference ].
	aFigureFileReference exists ifFalse: [ ^ self styleTextAsNotExistingFile ].
	(aFigureFileReference binaryReadStreamDo: [ :aStream | 
		ImageReadWriter gtReaderClassFromStream: aStream ]) 
			ifNil: [ ^ self styleTextAsUnknownFigure ].
	
	self styleTextAsDefault.
	anAttributeCreatingBlock := [ | anImageForm |
		anImageForm := aFigureFileReference binaryReadStreamDo: [ :stream | 
			ImageReadWriter formFromStream: stream ].
		GtPillarPictureAttribute new image: anImageForm ].
	self styleExpandedTextExpandAttribute: anAttributeCreatingBlock.
]

{ #category : #'private - styling' }
GtPillarFigureHighlighter >> styleTextAsDefault [
	(self targetText 
		from: self pillarNodeStart
		to: self pillarNodeStop) foreground: Color gray.
]

{ #category : #'private - styling' }
GtPillarFigureHighlighter >> styleTextAsNotExistingFile [
	(self targetText 
		from: self pillarNodeStart
		to: self pillarNodeStop) foreground: Color red.
]

{ #category : #'private - styling' }
GtPillarFigureHighlighter >> styleTextAsUnknownFigure [
	(self targetText 
		from: self pillarNodeStart
		to: self pillarNodeStop) foreground: Color orange.
]

{ #category : #'private - styling' }
GtPillarFigureHighlighter >> styleTextNotFileReference [
	(self targetText 
		from: self pillarNodeStart
		to: self pillarNodeStop) foreground: Color blue.
]
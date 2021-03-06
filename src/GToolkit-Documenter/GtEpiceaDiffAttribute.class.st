Class {
	#name : #GtEpiceaDiffAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#traits : 'TGtDocumentConstants',
	#classTraits : 'TGtDocumentConstants classTrait',
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Documenter-Epicea'
}

{ #category : #accessing }
GtEpiceaDiffAttribute class >> constants [
	^ GtDocumentConstants
]

{ #category : #accessing }
GtEpiceaDiffAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ BrLabel new
		text: self text;
		look: BrGlamorousLabelLook new;
		background: Color gray;
		padding: (BlInsets all: 3)
]

{ #category : #initialization }
GtEpiceaDiffAttribute >> asInsert [
	self text: self constants insertLineIdentificator asRopedText monospace.
	self text foreground: self constants insertLineColor.
]

{ #category : #initialization }
GtEpiceaDiffAttribute >> asMatch [
	self text: self constants matchLineIdentificator asRopedText glamorousCodeFontAndSize.
	self text foreground: self constants matchLineColor.
]

{ #category : #initialization }
GtEpiceaDiffAttribute >> asRemove [
	self text: self constants removeLineIdentificator asRopedText glamorousCodeFontAndSize.
	self text foreground: self constants removeLineColor.
]

{ #category : #accessing }
GtEpiceaDiffAttribute >> constants [
	^ GtDocumentConstants
]

{ #category : #initialization }
GtEpiceaDiffAttribute >> initialize [
	super initialize.
	self asMatch.
	self beAppend.
]

{ #category : #accessing }
GtEpiceaDiffAttribute >> text [
	^ text
]

{ #category : #accessing }
GtEpiceaDiffAttribute >> text: anObject [
	text := anObject
]

Class {
	#name : #Gt2ChangesAnnotation,
	#superclass : #Gt2Annotation,
	#category : #'GToolkit-NewDocumenter-Model'
}

{ #category : #accessing }
Gt2ChangesAnnotation class >> possibleParameters [
	^ {
		self constants fileParameterName.
		self constants expandedParameterName.
		self constants showParameterName.
		self constants heightParameterName.
		}
]

{ #category : #protected }
Gt2ChangesAnnotation class >> tag [
	^ self constants changesAnnotationName
]

{ #category : #'private - styling' }
Gt2ChangesAnnotation >> applyButtonAttribute [
	^ Gt2ButtonAttribute new
		beAppend;
		equality: self constants applyButtonLabel;
		stencil: [
			BrButton new
				label: self constants applyButtonLabel;
				icon: self constants applyButtonIcon asElement;
				look: BrGlamorousButtonWithIconLook + BrGlamorousButtonLabelLook;
				action: [ self applyChanges ]]
]

{ #category : #operations }
Gt2ChangesAnnotation >> applyChanges [
	self halt.
]

{ #category : #'private - actions' }
Gt2ChangesAnnotation >> browseReferenceFrom: aBlClickEvent [ 
	aBlClickEvent target 
		fireEvent: (GtPhlowObjectToSpawn new
			object: self cachedChanges;
			sourceElement: aBlClickEvent target)
]

{ #category : #'private - cache' }
Gt2ChangesAnnotation >> cachedChanges [
	^ self
]

{ #category : #'accessing - parameter values' }
Gt2ChangesAnnotation >> changeFile [
	<return: #FileReference or: nil>
	^ self utility 
		valueOf: self constants fileParameterName
		in: self parameters
		value: [ :aString | aString isString 
			ifTrue: [ 
				| aFileNameWithExtension |
				aFileNameWithExtension := (aString endsWith: self constants changesFileExtension)
					ifTrue: [ aString ]
					ifFalse: [ aString, self constants changesFileExtension ].
				GtFileUtility 
					fileReferenceOfFileName: aFileNameWithExtension
					relativeTo: self sourceDirectory ]
			ifFalse: [ nil ] ]
		emptyValue: [ nil ]
		defaultValue: [ nil ]
]

{ #category : #testing }
Gt2ChangesAnnotation >> changeFileExists [
	^ self isChangeFileDefined and: [ 
		self changeFile exists ]
]

{ #category : #'private - styling' }
Gt2ChangesAnnotation >> createButtonAttribute [
	^ Gt2ButtonAttribute new
		beAppend;
		equality: self constants createButtonLabel;
		stencil: [ 
			BrButton new
				label: self constants createButtonLabel ;
				icon:  self constants createButtonIcon asElement ;
				look: BrGlamorousButtonWithIconLook + BrGlamorousButtonLabelLook;
				action: [ :aButton |
					aButton fireEvent: (GtPhlowObjectToSpawn new
						object: self cachedChanges;
						sourceElement: aButton) ]]
]

{ #category : #testing }
Gt2ChangesAnnotation >> isApplied [
	^ self changeFileExists not
]

{ #category : #testing }
Gt2ChangesAnnotation >> isChangeFileDefined [
	self changeFile ifNil: [ ^ false ].
	self changeFile exists ifFalse: [ ^ true ].
	^ self changeFile isFile 
]

{ #category : #testing }
Gt2ChangesAnnotation >> isPreviewDefined [
	^ self changeFileExists
]

{ #category : #testing }
Gt2ChangesAnnotation >> isReferenceDefined [
	^ self changeFileExists
]

{ #category : #accessing }
Gt2ChangesAnnotation >> objectToPreview [
	^ self cachedChanges
]

{ #category : #accessing }
Gt2ChangesAnnotation >> sourceDirectory [
	<return: #FileReference>
	^ self gtDocument rootDirectory
]

{ #category : #'private - styling' }
Gt2ChangesAnnotation >> styleApplyButtonInText: aBlRope [
	self isApplied ifTrue: [ ^ self ].
	(aBlRope from: self stop to: self stop) 
		attribute: self applyButtonAttribute
]

{ #category : #'private - styling' }
Gt2ChangesAnnotation >> styleCreateButtonInText: aBlRope [
	self changeFileExists ifTrue: [ ^ self ].
	(aBlRope from: self stop to: self stop) 
		attribute: self createButtonAttribute
]

{ #category : #'api - style' }
Gt2ChangesAnnotation >> styleInText: aBlRope [
	super styleInText: aBlRope.
	self styleLinkInText: aBlRope.
	self styleExpandingPreviewInText: aBlRope.
	self styleApplyButtonInText: aBlRope.
	self styleCreateButtonInText: aBlRope.
	"self registerToSystemChanges"
]
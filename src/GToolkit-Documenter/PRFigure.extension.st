Extension { #name : #PRFigure }

{ #category : #'*GToolkit-Documenter' }
PRFigure >> browseReferenceFrom: aBlClickEvent [ 
	aBlClickEvent modifiers isShift ifTrue: [ ^ self ].
	aBlClickEvent target 
		fireEvent: (GtPhlowObjectToSpawn new
			object: self figureFileReference;
			sourceElement: aBlClickEvent target)
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cacheKey [
	^ GtFigureCacheKey new
		fileName: self figureFileReference;
		counter: self counter
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cachedIsExpanded [
	<return: #Boolean>
	self gtDocument
		cacheAt: self cacheKey
		ifPresent: [ :aCachedValue | 
			^ aCachedValue isExpanded ifNil: [ self expandedParameterValue ] ]
		ifAbsentPut: [ GtAnnotationCacheValue new
				isExpanded: self expandedParameterValue ].
	^ self expandedParameterValue
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cachedIsExpanded: aBoolean [
	self gtDocument 
		cacheAt: self cacheKey
		ifPresent: [ :aCachedValue | aCachedValue isExpanded: aBoolean ]
		ifAbsentPut: [ 
			GtAnnotationCacheValue new isExpanded: aBoolean ]
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cachedPreview [
	<return: #BlElement or: nil>
	^ self gtDocument 
		cacheAt: self cacheKey
		ifPresent: [ :aCachedValue | aCachedValue preview ] 
		ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cachedPreview: anElement [
	self gtDocument 
		cacheAt: self cacheKey
		ifPresent: [ :aCachedValue | aCachedValue preview: anElement ]
		ifAbsentPut: [ 
			GtAnnotationCacheValue new 
				preview: anElement ]
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cursorLeftInText: aBlRope [
	self doesReferenceExist
		ifTrue: [ self utility hideMarkupsInText: aBlRope start: self start stop: self stop ]
		ifFalse: [ 
			self hasChildren 
				ifTrue: [ self styleTextWithoutMarkupWithCaption: aBlRope ]
				ifFalse: [ self styleTextWithoutMarkupWithoutCaption: aBlRope ] ].
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> cursorNearbyInText: aBlRope [
	self utility cursorNeabyInText: aBlRope forNode: self
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> doesReferenceExist [
	^ self figureFileReference ifNil: false ifNotNil: #exists
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> expandedParameterValue [
	^ true
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> figureFileReference [
	"Return a figure file reference or nil if figure reference is not file"
	<return: #FileReference or: nil>
	^ self 
		propertyAt: #figureFileReference 
		ifAbsentPut: [ 
			GtFileUtility
				fileReferenceOfUri: self reference 
				relativeTo: self gtDocument rootDirectory ]
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> heightParameterValue [
	^ GtDocumentConstants defaultPreviewHeight
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> isPreviewDefined [
	^ self doesReferenceExist
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> objectToPreview [
	^ self figureFileReference
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> previewAttributes [
	^ {GtCachedAttribute new
		attribute:
			(GtResizablePreviewAttribute new
				result: self objectToPreview;
				showSelector: self showParameterValue;
				height: self heightParameterValue);
		cache: self cachedPreview;
		onCachingDo:
				[ :aCachedElement :theAttribute | self cachedPreview: aCachedElement ]}
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> showParameterValue [
	^ GtDocumentConstants defaultFigureShowSelector
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> startMarkup [
	^ self utility startMarkupFor: self class
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> styleTextWithMarkup: aBlRope [
	super styleTextWithMarkup: aBlRope.
	self utility styleLinkInText: aBlRope forNode: self.
	self utility styleExpandingPreviewInText: aBlRope forNode: self
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> styleTextWithoutMarkup: aBlRope [
	super styleTextWithoutMarkup: aBlRope.
	self utility subtleMarkupsInText: aBlRope start: self start stop: self stop.
	self utility styleLinkInText: aBlRope forNode: self.
	self doesReferenceExist
		ifTrue: [ self utility mayHideMarkupsInText: aBlRope start: self start stop: self stop forNode: self ]
		ifFalse: [ 
			self hasChildren 
				ifTrue: [ self styleTextWithoutMarkupWithCaption: aBlRope ]
				ifFalse: [ self styleTextWithoutMarkupWithoutCaption: aBlRope ] ].
	self utility stylePreviewInText: aBlRope forNode: self.
	self utility styleCursorAttributeInText: aBlRope forNode: self
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> styleTextWithoutMarkupWithCaption: aBlRope [
	| aStartIndex aStopIndex |
	aStartIndex := self startMarkup size + self start.
	aStopIndex := self children first stop.
	self utility 
		mayHideMarkupsInText: aBlRope 
		start: self start
		stop: aStartIndex - 1
		forNode: self.
	self utility 
		mayHideMarkupsInText: aBlRope 
		start: aStopIndex + 1
		stop: self stop
		forNode: self.		
]

{ #category : #'*GToolkit-Documenter' }
PRFigure >> styleTextWithoutMarkupWithoutCaption: aBlRope [
	| aStartIndex aStopIndex aMarkup |
	aMarkup := self startMarkup.
	aStartIndex := self start + aMarkup size.
	aStopIndex := self stop - aMarkup size.
	self utility
		mayHideMarkupsInText: aBlRope
		start: self start
		stop: aStartIndex - 1
		forNode: self.
	self utility
		mayHideMarkupsInText: aBlRope
		start: aStopIndex + 1
		stop: self stop
		forNode: self
]
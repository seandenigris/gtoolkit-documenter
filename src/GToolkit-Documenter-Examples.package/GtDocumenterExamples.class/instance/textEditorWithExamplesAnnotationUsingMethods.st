examples - methods
textEditorWithExamplesAnnotationUsingMethods
	<gtExample>
	| aPillarElement aBrTextEditor anAttributes |
	aPillarElement := self textElementWithExamplesAnnotationUsingMethods.
	aBrTextEditor := (GtDocumenterExamplesUtility editorFromTextElement: aPillarElement).
	self assert: aBrTextEditor notNil.
	anAttributes := aBrTextEditor text attributesAt: 1.
	self assert: anAttributes size equals: 1.
	self assert: anAttributes first paint equals: Color gray.
	anAttributes := aBrTextEditor text attributesAt: aBrTextEditor text size.
	self assert: anAttributes size equals: 3.
	self assert: anAttributes first paint equals: Color gray.
	self assert: anAttributes second class equals: BrTextExpandButtonAttribute.
	self assert: anAttributes third class equals: BrTextAdornmentDynamicAttribute.
	^ aBrTextEditor
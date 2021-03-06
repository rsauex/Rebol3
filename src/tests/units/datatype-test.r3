Rebol [
	Title:   "Rebol3 datatype! test script"
	Author:  "Oldes, Peter W A Wood"
	File: 	 %datatype-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "datatype"

===start-group=== "datatype!"
	--test-- "reflect datatype!"
	;@@ https://github.com/Oldes/Rebol-issues/issues/1534
		--assert object? sp: reflect integer! 'spec
		--assert  sp/title = reflect integer! 'title
		--assert  sp/type  = reflect integer! 'type
		--assert  sp/type = 'scalar

	--test-- "to word! datatype!"
	;@@ https://github.com/Oldes/Rebol-issues/issues/38
		--assert 'logic!   = to word! logic!
		--assert 'percent! = to word! percent!
		--assert 'money!   = to word! money!

===end-group===

~~~end-file~~~
Rebol [
	Title:   "Rebol3 port! test script"
	Author:  "Oldes, Peter W A Wood"
	File: 	 %port-test.red
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "port"

===start-group=== "directory port"
	;@@ https://github.com/rebol/rebol-issues/issues/2320
	--test-- "port-issue-2320"
		--assert  %port-issue-2320/ = make-dir %port-issue-2320/
		--assert  port? p: open %port-issue-2320/
		--assert  empty? p
		--assert  not open? close p
		--assert  error? try [empty? p] ;@@ or should it reopen it instead?
		--assert  not empty? open %./
		--assert  not error? [delete %port-issue-2320/]
===end-group===

~~~end-file~~~
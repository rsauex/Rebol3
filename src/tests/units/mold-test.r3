Rebol [
	Title:   "Rebol MOLD test script"
	Author:  "bitbegin"
	File: 	 %mold-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

#include  %../../../quick-test/quick-test.red

~~~start-file~~~ "MOLD"

===start-group=== "string-basic"

	--test-- "mold-string-baseic-1"
		a: ""				;-- literal: ""
		b: {""}
		--assert b = mold a

	--test-- "mold-string-baseic-2"
		a: {}				;-- literal: ""
		b: {""}
		--assert b = mold a

	--test-- "mold-string-baseic-3"
		a: "{}"				;-- literal: "{}"
		b: {"{}"}
		--assert b = mold a

	--test-- "mold-string-baseic-4"
		a: {""}				;-- literal: {""}
		b: {{""}}
		--assert b = mold a

	--test-- "mold-string-baseic-5"
		a: "{"				;-- literal: "{"
		b: {"^{"}
		--assert b = mold a

	--test-- "mold-string-baseic-6"
		a: "}"				;-- literal: "}"
		b: {"^}"}
		--assert b = mold a

	--test-- "mold-string-baseic-7"
		a: {"}				;-- literal: {"}
		b: {{"}}
		--assert b = mold a

	--test-- "mold-string-baseic-8"
		a: {""}				;-- literal: {""}
		b: {{""}}
		--assert b = mold a

	--test-- "mold-string-baseic-9"
		a: "}{"				;-- literal: "}{"
		b: {"^}^{"}
		--assert b = mold a

	--test-- "mold-string-baseic-10"
		a: "^""				;-- literal: {"}
		b: {{"}}
		--assert b = mold a

	--test-- "mold-string-baseic-11"
		a: "^"{"			;-- literal: {"^{}
		b: {^{"^^^{^}}
		--assert b = mold a

	--test-- "mold-string-baseic-12"
		a: "^"{}"			;-- literal: {"{}}
		b: {{"{}}}
		--assert b = mold a

	--test-- "mold-string-baseic-13"
		a: "^"}{"			;-- literal: {"^}^{}
		b: {{"^^}^^{}}
		--assert b = mold a

	--test-- "mold-string-baseic-14"
		a: {^{}				;-- literal: "{"
		b: {"^{"}
		--assert b = mold a

	--test-- "mold-string-baseic-15"
		a: {^{"}			;-- literal: {^{"}
		b: {^{^^^{"^}}
		--assert b = mold a

	--test-- "mold-string-baseic-16"
		a: "{{{"			;-- literal: "{{{"
		b: {"^{^{^{"}
		--assert b = mold a

	--test-- "mold-string-baseic-17"
		a: "}}}"			;-- literal: "}}}"
		b: {"^}^}^}"}
		--assert b = mold a

	--test-- "mold-string-baseic-18"
		a: "{{{}}}}"		;-- literal: "{{{}}}}"
		b: {"{{{}}}^}"}
		--assert b = mold a

	--test-- "mold-string-baseic-19"
		a: "}{}"			;-- literal: "}{}"
		b: {"^}{}"}
		--assert b = mold a

	--test-- "mold-string-baseic-20"
		a: "}{{}"			;-- literal: "}{{}"
		b: {"^}^{^{^}"}
		--assert b = mold a

	--test-- "mold-string-baseic-21"
		a: "}{{}}"			;-- literal: "}{{}}"
		b: {"^}{{}}"}
		--assert b = mold a

	--test-- "mold-string-baseic-22"
		a: "{}{"			;-- literal: "{}{"
		b: {"{}^{"}
		--assert b = mold a

	--test-- "mold-string-baseic-23"
		a: "{}{}{"			;-- literal: "{}{"
		b: {"{}{}^{"}
		--assert b = mold a

	--test-- "mold issue #1486"
		;@@ https://github.com/rebol/rebol-issues/issues/1486
		--assert {"^^(1E)"} = mold "^(1E)" ; double ^ because it's a string in a string

===end-group=== 

===start-group=== "string"
	
	--test-- "mold-string-1"
		a: "abc"			;-- literal: "abc"
		b: {"abc"}
		--assert b = mold a

	--test-- "mold-string-2"
		a: "a^"bc"			;-- literal: {a"bc}
		b: {{a"bc}}
		--assert b = mold a

	--test-- "mold-string-3"
		a: "a{bc"			;-- literal: "a{bc"
		b: {"a^{bc"}
		--assert b = mold a

	--test-- "mold-string-4"
		a: "a}{bc"			;-- literal: "a}{bc"
		b: {"a^}^{bc"}
		--assert b = mold a

	--test-- "mold-string-5"
		a: "a}{bc"			;-- literal: "a}{bc"
		b: {{"a^^}^^{bc"}}
		--assert b = mold mold a

	--test-- "mold-string-6"
		a: "a^"b^"c"		;-- literal: {a"b"c}
		b: {{a"b"c}}
		--assert b = mold a

	--test-- "mold-string-7"
		a: "a{}bc"			;-- literal: "a{}bc"
		b: {"a{}bc"}
		--assert b = mold a

===end-group=== 

===start-group=== "url"
	
	--test-- "mold url"
		--assert "ftp://"  = mold ftp://
		--assert "ftp://š" = mold ftp://š
		--assert "ftp://+" = mold ftp://+
		--assert "ftp://+" = mold ftp://%2b
		--assert "ftp://+" = mold ftp://%2B
		--assert "ftp://%20" = mold ftp://%20
	--test-- "mold append url"
		--assert "ftp://a" = mold append ftp:// #"a"
		--assert "ftp://a" = mold append ftp://  "a"
		--assert "ftp://š" = mold append ftp://  "š"
		--assert "ftp://+" = mold append ftp://  "+"
		--assert "ftp://%2528" = mold append ftp:// "%28"
		--assert "ftp://%28" = dehex mold append ftp:// "%28"

===end-group=== 


===start-group=== "mold-all"
	
	--test-- "mold-true" --assert "true" = mold true

	--test-- "mold-all-true" --assert "#[true]" = mold/all true

	--test-- "mold-false" --assert "false" = mold false

	--test-- "mold-all-false" --assert "#[false]" = mold/all false

	--test-- "mold-none" --assert "none" = mold none

	--test-- "mold-all-none" --assert "#[none]" = mold/all none

	--test-- "mold-block" --assert "[true false none]" = mold [#[true] #[false] #[none]]

	--test-- "mold-all-block"
		--assert "[#[true] #[false] #[none]]" = mold/all [#[true] #[false] #[none]]

===end-group=== 


~~~end-file~~~
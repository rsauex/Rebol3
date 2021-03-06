Rebol [
	Title:   "Rebol codecs test script"
	Author:  "Oldes"
	File: 	 %codecs-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "Codecs"

===start-group=== "Codec's identify"
	--test-- "encoding?"
		--assert 'text = encoding? #{}
		--assert 'text = encoding? #{6162}
		--assert do-codec codecs/text/entry 'identify #{}
		if all [
			find codecs 'png
			select codecs/png 'entry ; original native codec
		][
			--assert not do-codec codecs/png/entry 'identify #{01}
		]
		if all [
			find codecs 'jpeg
			select codecs/jpeg 'entry ; original native codec
		][
			--assert not do-codec codecs/jpeg/entry 'identify #{01}
			--assert not do-codec codecs/jpeg/entry 'identify #{010203}
			bin: insert/dup make binary! 126 #{00} 126
			--assert not do-codec codecs/jpeg/entry 'identify bin
		]
		if all [
			find codecs 'gif
			select codecs/gif 'entry ; original native codec
		][
			--assert not do-codec codecs/gif/entry 'identify #{01}
		]
===end-group===

===start-group=== "TEXT codec"
	--test-- "ENCODE text"
		--assert "1 2" = encode 'text [1 2]
		--assert "1 2" = encode 'text #{312032}
	--test-- "SAVE %test.txt"
		--assert "%a %b" = load save %temp.txt [%a %b] 
		--assert [1 2]   = load save %temp.bin [1 2]
		--assert "1 2"   = load save %temp.txt [1 2]     ;-- note that result is STRING
		--assert "1 2^/" = read/string %temp.bin ;@@ should be there the newline char?!
		--assert "1 2"   = read/string %temp.txt

		--assert #{312032} = load save %temp.bin #{312032}
		--assert "#{312032}^/" = read/string %temp.bin ;@@ should be there the newline char?!
		delete %temp.bin
		delete %temp.txt

===end-group===

===start-group=== "Invalid SAVE"
	--test-- "invalid image SAVE"
		--assert error? try [save %temp.bmp [1 2]]
		--assert error? try [save %temp.png [1 2]]
		--assert error? try [save %temp.jpg [1 2]]
		--assert error? try [save %temp.bmp "foo"]
		--assert error? try [save %temp.png "foo"]
		--assert error? try [save %temp.jpg "foo"]
		--assert error? try [save %temp.bmp #{00}]
		--assert error? try [save %temp.png #{00}]
		--assert error? try [save %temp.jpg #{00}]
===end-group===

if find codecs 'wav [
	codecs/wav/verbose: 3
	===start-group=== "WAV codec"
		
		--test-- "Load WAV file"
			--assert object? snd: load %units/files/drumloop.wav
			--assert   'wave = snd/type
			--assert   44100 = snd/rate
			--assert       1 = snd/channels
			--assert      16 = snd/bits
			--assert 3097828 = checksum to-binary snd/data
			snd: none
		--test-- "Decode WAV data"
			--assert binary? bin: read %units/files/zblunk_02.wav
			--assert object? snd: decode 'WAV bin
			--assert 4283614 = checksum to-binary snd/data
			snd: none
			bin: none
			
		--test-- "Encode WAV"
			samples: #[si16! [0 -1000 -2000 -1000 0 1000 2000 1000 0]]
			--assert binary? bin: encode 'wav :samples
			--assert object? snd: decode 'wav :bin
			--assert   'wave = snd/type
			--assert   44100 = snd/rate
			--assert       1 = snd/channels
			--assert      16 = snd/bits
			--assert samples = snd/data

	===end-group===
	codecs/wav/verbose: 0
]

if find codecs 'der [
	codecs/der/verbose: 2
	===start-group=== "DER codec"
		
		--test-- "Load DER file"
			--assert block? pfx: load %units/files/test.pfx
			--assert binary? try [a: pfx/sequence/sequence/4/2]
			--assert block? b: decode 'DER a
			--assert binary? try [c: b/sequence/sequence/4/2]
			--assert block? d: decode 'DER c

	===end-group===
	codecs/der/verbose: 0
]

if find codecs 'crt [
	codecs/crt/verbose: 3
	===start-group=== "CRT codec"
		
		--test-- "Load CRT file"
			--assert object? cert: load %units/files/google.crt
			--assert "Google Internet Authority G3" = try [cert/issuer/commonName]
			--assert block? try [key: cert/public-key/rsaEncryption]
			--assert #{010001} = try [key/2]
	===end-group===
	codecs/crt/verbose: 0
]

if find codecs 'swf [
	codecs/swf/verbose: 1
	===start-group=== "SWF codec"
		
		--test-- "Load SWF file"
			--assert object? swf1: load %units/files/test1-deflate.swf
			--assert object? swf2: load %units/files/test2-lzma.swf
			--assert swf1/tags = swf2/tags
			--assert swf1/header/frames = 25

		codecs/swf/verbose: 3
		--test-- "Load SWF file with decoding tags"
			--assert not error? try [swf1: load %units/files/test3.swf]
			--assert not error? try [swf2: load %units/files/test4-as2btn.swf]

	===end-group===
	codecs/swf/verbose: 0
]

if find codecs 'zip [
	v: system/options/log/zip
	system/options/log/zip: 3
	===start-group=== "ZIP codec"
		
		--test-- "Load ZIP file"
			--assert block? load %units/files/test-lzma.zip
			--assert block? load %units/files/test-stored.zip
			--assert block? load %units/files/test-deflate.zip

		--test-- "Decode ZIP using the codec directly"
			--assert block? data: codecs/zip/decode/only %units/files/test.aar [%classes.jar]
			--assert data/2/2 = 646121705
			--assert block? codecs/zip/decode data/2/3

		--test-- "Decode ZIP using info"
			bin: read %units/files/test-lzma.zip
			--assert block? info: codecs/zip/decode/info bin
			--assert info/1   = %xJSFL.komodoproject
			--assert info/2/1 = 18-Aug-2012/5:20:28
			data: codecs/zip/decompress-file at bin info/2/2 reduce [info/2/5 info/2/3 info/2/4]
			--assert info/2/6 = checksum/method data 'crc32 

	===end-group===
	system/options/log/zip: v
]

if find codecs 'tar [
	codecs/zip/verbose: 3
	===start-group=== "TAR codec"
		
		--test-- "Load TAR file"
			--assert block? load %units/files/test.tar

		--test-- "Decode TAR using the codec directly"
			tar-decode: :codecs/tar/decode
			--assert block? data: tar-decode/only %units/files/test.tar %test.txt
			--assert data/2/1 = #{7465737474657374}

	===end-group===
	codecs/tar/verbose: 1
]

if find codecs 'unixtime [
	===start-group=== "unixtime codec"
		date: 18-Sep-2019/8:52:31+2:00
		--test-- "encode 32bit unixtime"
			--assert 1568789551  = encode 'unixtime date
			--assert 1568789551  = codecs/unixtime/encode date
			--assert  "5D81D42F" = encode/as 'unixtime date string!
			--assert #{5D81D42F} = encode/as 'unixtime date binary!
			--assert 1568789551  = encode/as 'unixtime date integer!
			--assert error? try  [ encode/as 'unixtime date url! ]

		--test-- "decode 32bit unixtime"
			--assert date = decode 'unixtime 1568789551
			--assert date = decode 'unixtime  "5D81D42F"
			--assert date = decode 'unixtime #{5D81D42F}
			--assert date = codecs/unixtime/decode 1568789551

		date: 1-1-2056/1:2:3
		--test-- "encode 64bit unixtime"
			--assert 2713914123 = encode 'unixtime date
			--assert "A1C30B0B" = encode/as 'unixtime date string!

		--test-- "decode 64bit unixtime"
			--assert date = decode 'unixtime 2713914123
			--assert date = decode 'unixtime "A1C30B0B"
	===end-group===
]

if find codecs 'JSON [
	===start-group=== "JSON codec"
	--test-- "JSON encode/decode"
		data: #(a: 1 b: #(c: 2.0) d: "^/^-")
		str: encode 'JSON data
		--assert data = decode 'JSON str
	===end-group===
]

~~~end-file~~~
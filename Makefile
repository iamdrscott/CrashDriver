.PHONY: clean

CT = cmftool
NT = niemtran

XSD_FILES :=  $(shell find model.xsd -type f -name '*.xsd')
XML_FILES :=  $(wildcard examples/*.xml)
JSON_FILES := $(patsubst %.xml,%.json,$(XML_FILES))

all: cmf json model.ttl message.json message.xsd
cmf: model.cmf

model.cmf : $(XSD_FILES)
	$(CT) x2m -o model.cmf model.xsd/CrashDriver.xsd

model.ttl : model.cmf
	$(CT) m2r model.cmf > model.ttl

message.json : model.cmf
	$(CT) m2jmsg -o message.json model.cmf

message.xsd : model.cmf
	rm -rf message.xsd
	$(CT) m2xmsg -o message.xsd model.cmf
	cp -r model.xsd/niem/external message.xsd/niem

json:	message.xsd $(JSON_FILES)

examples/%.json: examples/%.xml model.cmf
	$(NT) x2j -f model.cmf $<

clean:
	rm -rf message.json message.xsd model.cmf model.ttl examples/*.json

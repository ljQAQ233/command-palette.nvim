name=telescope-command-palette
input=$(CURDIR)/README.md

output=doc/$(name).txt

$(output): $(input)
	panvimdoc \
		--project-name $(name) \
		--input-file $(input) \
		--demojify true

gendoc: $(output)

opendoc: $(output)
	nvim \
		-c "set rtp+=$(CURDIR)" \
		-c "helptags $(CURDIR)/doc" \
		-c "help $(name)" \
		-c "only"

clean:
	rm -rf doc/tags
	rm -rf $(output)

.PHONY: gendoc opendoc clean

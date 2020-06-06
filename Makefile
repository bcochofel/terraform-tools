SEMTAG=tools/semtag

scope ?= "minor"

.PHONY: release

release:
	$(SEMTAG) final -s $(scope)

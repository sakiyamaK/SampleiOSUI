setup:
	./script/setup.sh
	open SampleiOSUI.xcworkspace

.PHONY: setup


clean:
	./script/clean.sh
	
.PHONY: clean

component:
ifdef name
	mint run pui component MVC ${name}
else
	@echo "make component name=<component name>"
endif
.PHONY: component

component_table:
ifdef name
	mint run pui component MVC_TABLE ${name}
else
	@echo "make component name=<component name>"
endif
.PHONY: component

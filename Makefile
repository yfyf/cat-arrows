TARGETS = report presentation
.PHONY: ${TARGETS}

all: ${TARGETS}

${TARGETS}:
	$(MAKE) -C $@

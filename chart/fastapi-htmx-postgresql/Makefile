
APP := $(notdir $(CURDIR))
VALUES ?= values.yaml

all:
	helm template -f $(VALUES) .

deploy install:
	helm upgrade --install $(APP) -f $(VALUES) .

clean uninstall:
	helm uninstall $(APP)

list:
	helm list -A --all

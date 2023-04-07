
.PHONY: dev
dev:
	./scripts/build.sh

.PHONY: deploy
deploy:
	flyctl deploy

.PHONY: open
open:
	fly open

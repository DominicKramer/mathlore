
.PHONY: dev
dev:
	./scripts/build.sh

.PONY: update
update:
	./scripts/update-dockerfile.sh

.PHONY: deploy
deploy:
	flyctl deploy

.PHONY: open
open:
	fly open

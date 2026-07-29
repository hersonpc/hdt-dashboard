IMAGE ?= hersonpc/hdt-dashboard
UID   := $(shell id -u)
GID   := $(shell id -g)

# Regenera requirements.lock.txt a partir de requirements.txt.
# Fluxo para atualizar versoes: make lock, revisar o diff, make build.
lock:
	@docker run --rm -v $(CURDIR):/w -w /w python:3.14-alpine \
		sh -c "pip install -q uv && uv pip compile requirements.txt -o requirements.lock.txt --no-header && chown $(UID):$(GID) requirements.lock.txt"
	@echo "requirements.lock.txt atualizado. Revise com: git diff requirements.lock.txt"

build:
	@time docker build -t $(IMAGE):latest . && docker images | grep $(IMAGE)

push:
	@docker push $(IMAGE):latest
	@echo "\n- https://hub.docker.com/r/hersonpc/hdt-dashboard/tags\n"

img:
	@docker images | grep hdt-dashboard

prune:
	@docker image prune -f

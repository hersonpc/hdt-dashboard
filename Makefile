IMAGE ?= hersonpc/hdt-dashboard
TAG   ?= $(shell date +%Y-%m-%d)-py314
UID   := $(shell id -u)
GID   := $(shell id -g)

# Regenera requirements.lock.txt a partir de requirements.txt.
# Fluxo para atualizar versoes: make lock, revisar o diff, make build.
lock:
	@docker run --rm -v $(CURDIR):/w -w /w python:3.14-slim \
		sh -c "pip install -q uv && uv pip compile requirements.txt -o requirements.lock.txt --no-header && chown $(UID):$(GID) requirements.lock.txt"
	@echo "requirements.lock.txt atualizado. Revise com: git diff requirements.lock.txt"

# Constroi a imagem com tag datada. Nao altera :latest.
build:
	@time docker build -t $(IMAGE):$(TAG) . && docker images | grep $(IMAGE)

# Move :latest para a tag datada. Passo explicito, separado do build,
# para que nenhuma construcao troque a imagem de producao sem querer.
promote:
	@docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	@echo "latest agora aponta para $(TAG)"

img:
	@docker images | grep hdt-dashboard

prune:
	@docker image prune -f

push:
	@docker push $(IMAGE):$(TAG) && \
	docker push $(IMAGE):latest && \
	echo "\n- https://hub.docker.com/r/hersonpc/hdt-dashboard/tags\n"

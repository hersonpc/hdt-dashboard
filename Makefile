build:
	@time docker build -t hersonpc/hdt-dashboard:latest . && docker images | grep hersonpc/hdt-dashboard

build313:
	@time docker build -t hersonpc/hdt-dashboard:latest -f Dockerfile313 . && docker images | grep hersonpc/hdt-dashboard

img:
	@docker images | grep hdt-dashboard

prune:
	@docker image prune -f

push:
	@docker push hersonpc/hdt-dashboard:latest && \
	echo "\n- https://hub.docker.com/r/hersonpc/hdt-dashboard/tags\n"

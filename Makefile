build:
	@time docker build -t hersonpc/hdt-dashboard:latest . && docker images | grep hersonpc/hdt-dashboard

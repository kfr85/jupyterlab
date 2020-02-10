NAME=lab
VERSION=1.0.0
DOCKER_PORT=8888
HOST_PORT=8888

build:
	docker build -t $(NAME):$(VERSION) .

restart: stop start

start:
	@docker run -itd --rm \
		-p $(HOST_PORT):$(DOCKER_PORT) \
		--name $(NAME) \
		$(NAME):$(VERSION)
	@sleep 5
	@make logs

stop:
	@docker rm -f $(NAME)

logs:
	@docker logs $(NAME)

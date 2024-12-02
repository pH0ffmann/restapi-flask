APP = restapi

test:
	flake8 . --exclude .venv

compose:
	@docker-compose build
	@docker-compose up

down:
	@docker-compose down
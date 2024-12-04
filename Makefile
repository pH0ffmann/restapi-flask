APP = restapi

test:
	@flake8 . --exclude .venv
	@pytest -v -p no:warnings 


compose:
	@docker-compose build
	@docker-compose up

down:
	@docker-compose down
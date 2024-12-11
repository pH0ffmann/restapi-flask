APP = restapi-flask

test:
	@flake8 . --exclude .venv
	@pytest -v -p no:warnings 
	@bandit -r . -x '/.venv/','/tests/'

compose:
	@docker-compose build
	@docker-compose up

down:
	@docker-compose down

setup-dev:
	@kind create cluster --config kubernetes/config/config.yaml
	@kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=270s
	@helm upgrade \
		--install \
		--set image.tag=8.0.0 \
		--set auth.rootPassword="root" \
		mongodb kubernetes/charts/mongodb
	@@kubectl wait \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=mongodb \
		--timeout=270s

teardown-dev:
	@kind delete clusters kind

deploy-dev:
	@docker build -t $(APP):latest .
	@kind load docker-image $(APP):latest
	@kubectl apply -f kubernetes/manifests
	@kubectl rollout restart deploy restapi-flask

dev: setup-dev deploy-dev
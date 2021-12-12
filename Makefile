init:
	docker-compose --env-file .env.local up -d
	docker-compose exec -T php composer install --no-interation
	docker-compose exec -T php ./bin/console doctrine:migarions:migrate

up:
	docker-compose --env-file .env.local up

upd:
	docker-compose --env-file .env.local up -d

down:
	docker-compose down

downv:
	docker-compose down -v

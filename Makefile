up:
	docker compose up -d
down:
	docker compose down --remove-orphans

deploy:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'rm -rf svodd-rabbitmq_${BUILD_NUMBER} && mkdir svodd-rabbitmq_${BUILD_NUMBER}'

	envsubst < docker-compose-production.yml > docker-compose-production-env.yml
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose-production-env.yml deploy@${HOST}:svodd-rabbitmq_${BUILD_NUMBER}/docker-compose.yml
	rm -f docker-compose-production-env.yml

	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'cd svodd-rabbitmq_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml svodd-rabbitmq --with-registry-auth --prune'

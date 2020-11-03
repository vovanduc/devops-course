Login to docker hub

push to dockerhub


docker login -u pilgrim2go
Password:
WARNING! Your password will be stored unencrypted in /home/nowhereman/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
nowhereman@docker-105:~$ docker tag  railsapp:004 pilgrim2go/railsapp:004
nowhereman@docker-105:~$ docker push
"docker push" requires exactly 1 argument.
See 'docker push --help'.

Usage:  docker push [OPTIONS] NAME[:TAG]

Push an image or a repository to a registry
nowhereman@docker-105:~$ docker push pilgrim2go/railsapp:004
The push refers to repository [docker.io/pilgrim2go/railsapp]
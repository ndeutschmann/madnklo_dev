#!/bin/bash

if [ "$1" = "--docker_build" ]
then
	docker build --tag=madnklo_dev ./docker_src
	echo ""
	echo "================================================================"
	echo "   New image built. Consider pruning/removing dangling images"
	echo "================================================================"	
	exit
fi

if [ "$1" = "--docker_update" ]
then
	docker pull ndeutschmann/madnklo_dev
	exit
fi

if [ "$1" = "--initialize" ]
then
	echo "running the initialization script"
	docker run --rm --entrypoint=/home/hep/initialize.sh -v $(pwd)/code:/home/hep/madnklo madnklo_dev
	exit
fi
	
docker run -it --rm -v $(pwd)/code:/home/hep/madnklo madnklo_dev $1

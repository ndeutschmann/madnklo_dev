#!/bin/bash

if [ "$1" = "--docker_build" ]
then
	docker build --tag=madnklo/madnklo_dev ./docker_src
	echo ""
	echo "================================================================"
	echo "   New image built. Consider pruning/removing dangling images"
	echo "================================================================"	
	exit
fi

if [ "$1" = "--docker_update" ]
then
	docker pull madnklo/madnklo_dev
	exit
fi

if [ "$1" = "--initialize" ]
then
	echo "Running the initialization script"
	docker run --rm\
	--entrypoint=/home/hep/initialize.sh \
	-v $(pwd)/code:/home/hep/madnklo\
	madnklo/madnklo_dev
	echo "Set up the MadNkLO development environment at $(pwd)/code"
	exit
fi

if [ "$1" = "--setup_venv" ]
then
	echo "Setting up 'madnklo_venv' virtual environment"
	virtualenv madnklo_venv
	source ./madnklo_venv/bin/activate
	./docker_src/requirements_pip.sh
	source ./madnklo_venv/bin/deactivate
	exit
fi

echo "MadNkLO development environment"
echo ""
echo "Make sure that you have properly initialized the environment by running"
echo "madnklo_docker.sh --initialize"
read -t 30 -p  "[press enter (30s)]"

docker run -it --rm \
-v $(pwd)/code:/home/hep/madnklo \
-v $(pwd)/madnklo_persistent:/var/madnklo_persistent \
madnklo/madnklo_dev $1

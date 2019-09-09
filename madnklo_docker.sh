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
	-v $(pwd)/madnklo_src:/home/hep/madnklo\
	madnklo/madnklo_dev
	echo "Pulling the latest version for the repo"
	cd $(pwd)/madnklo_src
	git pull
	echo "Set up the MadNkLO development environment at $(pwd)/madnklo_src"
	exit
fi

if [ "$1" = "--bash" ]
then
	echo "Running the container in bash mode"
	docker run -it --rm \
	-v $(pwd)/madnklo_src:/home/hep/madnklo \
	-v $(pwd)/madnklo_persistent:/var/madnklo_persistent \
	--entrypoint=bash \
	madnklo/madnklo_dev
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

if [ \( "$1" != "" \) -a \( ! -f "madnklo_persistent/"$1 \) ]
then
	echo "Unknown command option: "$1
	exit
fi

echo "MadNkLO development environment"
echo ""
if [ -f "madnklo_src/bin/mg5_aMC" ]; then
	docker run -it --rm \
	-v $(pwd)/madnklo_src:/home/hep/madnklo \
	-v $(pwd)/madnklo_persistent:/var/madnklo_persistent \
	madnklo/madnklo_dev $1
else
	echo "Local MadNkLO source madnklo_src folder could not be found."
	echo "Make sure that you have properly initialized the environment by running the command 'madnklo_docker.sh --initialize'"
fi


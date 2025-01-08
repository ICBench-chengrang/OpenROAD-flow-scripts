#!/usr/bin/bash

image=openroad/flow-ubuntu22.04-builder:latest

docker run --rm -it \
	-u $(id -u ${USER}):$(id -g ${USER}) \
	-v $(pwd)/flow:/OpenROAD-flow-scripts/flow \
	-v $(pwd)/etc/startup.sh:/OpenROAD-flow-scripts/etc/startup.sh \
	--entrypoint ["/OpenROAD-flow-scripts/etc/startup.sh"] \
	$image

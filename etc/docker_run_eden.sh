#!/usr/bin/bash

image="icb-registry.cn-shanghai.cr.aliyuncs.com/icb/eden_release:250107"

docker run --rm -it \
	-u $(id -u ${USER}):$(id -g ${USER}) \
	-v $(pwd)/flow:/Eden-flow/flow \
	$image \
	bash -c "eden flow/designs/smic180/m3/floorplan.tcl"

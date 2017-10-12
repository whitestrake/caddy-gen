#!/bin/sh
{
    flock -x -n 100 || exit 0
    docker-gen -config /etc/docker-gen.cfg
} 100>/tmp/docker-gen.lock

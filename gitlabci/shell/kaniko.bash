#!/bin/bash

function kaniko__init_config() {
    AUTH_BASE64=$(echo -n ${REGISTRY_USER}:${REGISTRY_PASSWORD} | base64)
    sed -i "s/AUTH_BASE64/${AUTH_BASE64}/g" ci/bash_shell/docker_kaniko/kaniko_config_base.json
    sed -i "s#HTTP_PROXY#${HTTP_PROXY}#g#" ci/bash_shell/docker_kaniko/kaniko_config_base.json
    sed -i "s#HTTPS_PROXY#${HTTP_PROXY}#g#" ci/bash_shell/docker_kaniko/kaniko_config_base.json
    mv ci/bash_shell/docker_kaniko/kaniko_config_base.json /kaniko/.docker/config.json

    cat /kaniko/.docker/config.json

}

function kaniko__build_and_push_docker_images() {

    /kaniko/executor \
    --snapshotMode=redo \
    --use-new-run \
    --context $CI_PROJECT_DIR \
    --dockerfile $CI_PROJECT_DIR/docker/Dockerfile \
    --build-arg branch=CI_COMMIT_BRANCH \
    --destination rridane/ipmitool:latest

}

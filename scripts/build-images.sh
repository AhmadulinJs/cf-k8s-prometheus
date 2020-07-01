DOCKER_ORG=${DOCKER_ORG:-oratos}
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"
DEPLAB=${DEPLAB:-true}

function buildAndReplaceImage {
    image=$1
    version=$2
    srcFolder=$3
    dockerfile=$4

    docker build --build-arg VERSION=$version -t $DOCKER_ORG/$image:$version $srcFolder -f $srcFolder/$dockerfile
    if [ -n "$DEPLAB" ]; then
        deplab --image $DOCKER_ORG/$image:$version --git ${REPO_DIR} --output-tar /tmp/$image.tgz --tag $DOCKER_ORG/$image:$version
        docker load -i /tmp/$image.tgz
    fi
    docker push $DOCKER_ORG/$image:$version
}

buildAndReplaceImage statsd_exporter v0.15.0 ${REPO_DIR}/exporters/statsd_exporter Dockerfile statsd_exporter
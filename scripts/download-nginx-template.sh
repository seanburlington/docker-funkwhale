#!/usr/bin/env bash
set -eu

dest_dir=$1
artifact_version=$2
repo_url="${REPO_URL-https://dev.funkwhale.audio/funkwhale/funkwhale}"
default_artifact_url="$repo_url/raw/$artifact_version/deploy/docker.nginx.template"
artifact_url=${ARTIFACT_URL-$default_artifact_url}

mkdir -p $dest_dir
dest_file="$dest_dir/funkwhale_nginx.template"
echo "Downloading $artifact_url to $dest_file…"
wget "$artifact_url" -O $dest_file
echo 'Fixing file content for use in our docker image…'
sed -i -e 's/api:5000/127.0.0.1:8000/' \
	-e 's/listen 80;/listen 80 default_server;/' \
	-e 's/server_name \${FUNKWHALE_HOSTNAME};/server_name _;/' \
	-e 's/\$http_upgrade/\${_}http_upgrade/' \
	-e 's/\$connection_upgrade/\${_}connection_upgrade/' \
	-e 's|/frontend|/app/front/dist|' $dest_file

echo 'Done!'

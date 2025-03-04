#!/bin/bash

set -e

# Variables d'entrée
TAG=$1
YAML_PATHS=$2
FILE_PATH=$3

# Configuration Git
git config --global user.email "${GIT_RELEASE_BOT_EMAIL}"
git config --global user.name "${GIT_RELEASE_BOT_NAME}"

# Configuration GPG (optionnelle)
if [[ "${GPG_ENABLED}" == "true" ]]; then
  echo "Enable GPG signing in git config"
  git config --global commit.gpgsign true
  git config --global user.signingkey "${GPG_KEY_ID}"

  echo "Import the GPG key"
  echo "${GPG_KEY}" | base64 -d > private.key
  gpg --batch --import ./private.key
  rm ./private.key
else
  echo "GPG signing is not enabled"
fi

# Configuration de la clé SSH (optionnelle)
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  echo "Add SSH key"
  mkdir -p ~/.ssh
  echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa
  ssh-keyscan github.com >> ~/.ssh/known_hosts
else
  echo "No SSH key defined"
fi

# Mettre à jour les valeurs dans le fichier YAML
IFS=',' read -r -a paths <<< "$YAML_PATHS"
for path in "${paths[@]}"
do
  yq eval --inplace ".${path} = \"$TAG\"" "$FILE_PATH"
done

# Commit et push des modifications
git add "$FILE_PATH"
git commit -m "Update YAML tags to $TAG"
git push origin HEAD

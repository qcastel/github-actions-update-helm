#!/bin/bash
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

#Setup SSH key
if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  echo "Add SSH key"
  add-ssh-key.sh
else
  echo "No SSH key defined"
fi

echo "Clone repository '${REPO}' and commit on branch '${BRANCH_NAME}' a manifest change to use '${TAG}' docker images."
git clone "${REPO}" deployment-repo

echo "Repo cloned. Go to deployment-repo"
cd deployment-repo
ssh-keygen -R github.com
# Checkout the specified branch
git checkout -B "${BRANCH_NAME}" "origin/${BRANCH_NAME}"

IFS=',' read -r -a paths <<< "$YAML_PATHS"
for path in "${paths[@]}"
do
  echo "Update YAML path '${path}' to '${TAG}'"
  yq write -i "$FILE_PATH" "${path}" "$TAG"
done

cat "$FILE_PATH"

echo "Commit and push changes"
git commit -am "Update YAML tags to $TAG"
git push origin "${BRANCH_NAME}"

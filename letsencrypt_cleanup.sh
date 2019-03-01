#!/bin/bash

git rm $CI_PROJECT_DIR/static/.well-known/acme-challenge/$CERTBOT_TOKEN
git commit -m "GitLab runner - Removed certbot challenge file"
git push https://$GITLAB_USER_LOGIN:$CERTBOT_RENEWAL_PIPELINE_GIT_TOKEN@gitlab.com/BasPH/blog.git HEAD:master

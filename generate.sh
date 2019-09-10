
export GITHUB_URL=https://github.com/khs1994-website
export DEPLOY_URL=https://docs.khs1994.com
export GITEE_DEPLOY_URL=https://khs1994-website.gitee.io

envsubst '${GITHUB_URL} \
          ${DEPLOY_URL} \
          ${GITEE_DEPLOY_URL} \
         ' \
         < README.md.tmp > README.md

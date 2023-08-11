.ONESHELL:
TAG = latest

draft:
	hugo serve --enableGitInfo --buildDrafts --navigateToChanged --disableFastRender
static:
	hugo || true
	open public/index.html

serve:
	hugo serve --enableGitInfo  --navigateToChanged --disableFastRender

tag:
	git tag -d ${TAG} && \
	git push origin --delete ${TAG} && \
	git tag -a ${TAG} && \
	git push origin --tags


%.md:
	hugo new content/drafts/$@
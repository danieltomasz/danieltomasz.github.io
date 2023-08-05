serve:
	hugo serve --enableGitInfo --disableFastRender

static:
	hugo || true
	open public/index.html
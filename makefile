git:
	git add .
	git commit  -m "`date`"
	git push

publish:
	bash ./publish_to_ghpages.sh

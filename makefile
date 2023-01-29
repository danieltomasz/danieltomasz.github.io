git:
	git add .
	git commit  -m "`date`"
	git push

publish:
	./publish_to_ghpages.sh

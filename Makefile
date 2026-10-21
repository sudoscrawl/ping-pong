run:
	love .

format:
	stylua main.lua conf.lua src/
	@echo "Formatted all the files"

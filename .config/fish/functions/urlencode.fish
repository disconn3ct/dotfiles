function urlencode --description 'Use Python to urlencode params'
	python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);" $argv;
end

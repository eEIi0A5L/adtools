#!/usr/bin/python
# f2h.py
# フィルタ→hostファイル変換
import sys
import re

def main():
	args = sys.argv
	argc = len(args)
	if ( argc != 2 ):
		print("Usage: f2h.py <filename>")
		quit()
	filename = args[1]
	#print( "filename=" + filename)

	f = open( filename, 'r')
	lines = f.readlines()
	f.close()

	for line in lines:
		#print(line)
		stripped = line.strip()
		#print(stripped)

		match = re.search( '^\|\|([^\/]+)[\^\/]$', stripped)
		if match:
			#print(match.group(0))
			#print(match.group(1))
			host = match.group(1)

			print( "0.0.0.0 " + host )

if __name__ == '__main__':
	main()

#!/usr/bin/python
# coding:utf-8
# diffad.py
# フィルタのdiffをとる
import sys
import re
from pprint import pprint
#from urllib.parse import urlparse
from urlparse import urlparse


def dump_match(match):
	array = (0,1,2)
	nagasa = len(array)
	print("match.end()="+str(match.end()))
	print("len(match.group)="+str(len(match.group)))
	print("match.group(0)="+match.group(0))
	if match.group(1) is not None:
		print("match.group(1)="+match.group(1))
	if match.group(2) is not None:
		print("match.group(2)="+match.group(2))
	if match.group(3) is not None:
		print("match.group(3)="+match.group(3))
	if match.group(4) is not None:
		print("match.group(4)="+match.group(4))

# ネットワークフィルタの解析
# 一度にやろうとすると正規表現がめちゃくちゃ難しい
# 徐々に切除した方がよい
#def proc_network(line):
#	match = re.search( '^(\|*)([^$/\^]*)([^$]*)(\$.*)*$', line)
#	if match:
#		dump_match(match);
#		

def cut_off_option(line):
	match = re.search( '(.*)(\$.*)$', line)
	if match:
		#dump_match(match);
		print("match.group(0)="+match.group(0))
		print("match.group(1)="+match.group(1))
		print("match.group(2)="+match.group(2))
		fundamental = match.group(1)
		option = match.group(2)
	else:
		fundamental = line
		option = ""
	#print("fundamental="+fundamental)
	#print("option="+option)
	return fundamental, option

def cut_off_beginend(line):
	match = re.search( '\|*([^\|]*)\|?', line)
	if match:
		fund2 = match.group(1)
	else:
		fund2 = line
	return fund2

# input: domain/path
def separate_domain_path(line):
	match = re.search( '([^/\^]*)([/\^].*)', line)
	if match:
		print("separate_domain_path(): match1");
		tmpdomain = match.group(1)
		tmppath = match.group(2)
		if re.search( '\.', tmpdomain):
			print("separate_domain_path(): match2");
			domain = tmpdomain
			path = tmppath
		else:
			print("separate_domain_path(): else2");
			domain = ""
			path = line
	else:
		print("separate_domain_path(): else1");
		domain = ""
		path = line
	return domain, path

def cut_off_http(line):
	match = re.search( 'https?://(.*)$', line)
	if match:
		fund3 = match.group(1)
	else:
		fund3 = line
	return fund3

def proc_network(line):
	fundamental, option = cut_off_option(line)
	print("Fundamental="+fundamental)
	print("Option="+option)

	fund2 = cut_off_beginend(fundamental)
	print("fund2="+fund2)

	o = urlparse(fund2)
	pprint(o)

	fund3 = cut_off_http(fund2)
	print("fund3="+fund3)

	domain, path = separate_domain_path(fund3)
	print("domain="+domain)
	print("path="+path)

	#global_list.append( (domain, path, line) )
	domainlist = take_apart_domain( domain )
	return (domain, path, line, domainlist)


def proc_line(line):
	print(line)

	result = ("","","",[])
	#match = re.search( '##', stripped)
	if re.search( '^\[Adblock Plus', line):
		# this is a magic word
		print("magic word")
	elif re.search( '^[ \t]*$', line):
		# this is a empty line
		print("empty line")
	elif re.search( '^[ \t]*!', line):
		# this is a comment
		print("comment")
	elif re.search( '##', line):
		# this is a cosmetic filter
		print("cosmetic")
	elif re.search( '#@#', line):
		# this is a exception of a cosmetic filter
		print("cosmetic excep")
	elif re.search( '#?#', line):
		# this is a ABP extended CSS selector
		print("ABP extended css selector")
	elif re.search( '@@', line):
		# this is a exception of a network filter
		print("network excep")
	else:
		# this is a network filter
		print("network")
		result = proc_network(line)
	return result

def proc_file(filename):
	f = open( filename, 'r')
	lines = f.readlines()
	f.close()

	list = []
	for line in lines:
		stripped = line.strip()
		#print(stripped)
		print("stripped=["+stripped+"]")
		# 空行は無視する
		if re.search( '^[ \t]*$', stripped):
			print("===empty line===")
			continue
		line_result = proc_line(stripped)
		(domain,path,filter,domainlist) = line_result
		print("proc_file():line_result:domain="+domain)
		print("proc_file():line_result:path="+path)
		print("proc_file():line_result:filter="+filter)
		if filter == "":
			continue

		list.append(line_result)

	return list

# ドメインを階層ごとに分解してトップレベルから順番に格納する
# ex: www.yahoo.jp
# list[0]=jp
# list[1]=yahoo
# list[2]=www
def take_apart_domain( domain ):
	print("take_apart_domain():domain")
	print("domain="+domain)
	list = domain.split('.')
	list.reverse()
	print("take_apart_domain():list")
	pprint(list)
	return list

#ドメインが二階層目まで同一ならTrue
# 片方がグローバルドメインならすべてマッチ
def is_same_domain( list1, list2):
	#list1 = take_apart_domain( domain1 )
	#list2 = take_apart_domain( domain2 )
	if list1[0] == '':
		return True
	if list2[0] == '':
		return True

	if list1[0] == list2[0]:
		if len(list1) > 1 and len(list2) > 1:
			if list1[1] == list2[1]:
				return True
		else:
			return True
	return False

# 片方がもう片方の部分文字列なら一致
def is_same_path( path1, path2):
	print("is_same_path(): path1="+path1)
	print("is_same_path(): path2="+path2)
	#tmppath1 = path1.replace('^','/')
	#tmppath2 = path2.replace('^','/')
	tmppath1 = path1
	tmppath2 = path2
	if tmppath1 in tmppath2:
		print("is_same_path(): True, path1 in path2")
		return True
	if tmppath2 in tmppath1:
		print("is_same_path(): True, path2 in path1")
		return True
	print("is_same_path(): False")
	return False

# listの中からitemを探す
def search( item1, list2):
	(domain1, path1, filter1, domainlist1) = item1

	if filter1 == "":
		return False

	for item2 in list2:
		(domain2, path2, filter2, domainlist2) = item2

		#if domain1 == domain2:
		print("search():domain1="+domain1)
		print("search():domain2="+domain2)
		if is_same_domain( domainlist1, domainlist2):
			print("search():same domain")
			if path1 == path2:
			#if is_same_path( path1, path2):
				return True
	return False

def main():
	args = sys.argv
	argc = len(args)
	if ( argc != 3 ):
		print("Usage: diffad.py <filename1> <filename2>")
		quit()
	filename1 = args[1]
	filename2 = args[2]
	#print( "filename=" + filename)

	list1 = proc_file(filename1)
	list2 = proc_file(filename2)


	print("===list1===")
	pprint(sorted(list1))
	print("===list2===")
	pprint(sorted(list2))

	# 比較
	for item in list1:
		result = search( item, list2)
		print("main(): search() result="+str(result))
		if result is False:
			print("not in it")
			(domain, path, filter,domainlist) = item
			print("domain="+domain)
			print("path="+path)
			print("filter=["+filter+"]")

if __name__ == '__main__':
	main()

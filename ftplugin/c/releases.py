import urllib2
import hashlib
import json


# Repo is at rgoulter/c-worksheet-instrumentor
gh_api = "https://api.github.com"
repo_owner = "rgoulter"
repo = "c-worksheet-instrumentor"



def get_releases():
	s = gh_api + ("/repos/%s/%s/releases" % (repo_owner, repo))
	req = urllib2.Request(s)
	resp = urllib2.urlopen(req)
	resp_body = resp.read()
	resp_json = json.loads(resp_body)

	return resp_json



def get_latest_release():
	s = gh_api + ("/repos/%s/%s/releases/latest" % (repo_owner, repo))
	req = urllib2.Request(s)
	resp = urllib2.urlopen(req)
	resp_body = resp.read()
	resp_json = json.loads(resp_body)

	return resp_json



# GitHub tag_name of a release.
# As string. e.g. "v0.2.3", "v0.2.3-SNAPSHOT"
def version_of_release(release):
	return release["tag_name"]



def get_browser_url_of_smallest_zip(release):
	assets = release["assets"]

	is_zip = lambda a : a["content_type"] == "application/zip"
	zip_assets = filter(is_zip, assets)

	if len(zip_assets) == 0:
		return None

	(sz, url) = min((a["size"], a["browser_download_url"]) for a in zip_assets)

	return url



# Also, urllib.urlretrive(u, intoFName)
# seems to work.

# From:
# http://stackoverflow.com/questions/22676/how-do-i-download-a-file-over-http-using-python
def download(url):
	file_name = url.split('/')[-1]
	u = urllib2.urlopen(url)
	f = open(file_name, 'wb')
	meta = u.info()
	file_size = int(meta.getheaders("Content-Length")[0])
	print "Downloading: %s Bytes: %s" % (file_name, file_size)

	file_size_dl = 0
	block_sz = 8192
	while True:
		buffer = u.read(block_sz)
		if not buffer:
			break

		file_size_dl += len(buffer)
		f.write(buffer)
		status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
		status = status + chr(8)*(len(status)+1)
		print status,

	f.close()

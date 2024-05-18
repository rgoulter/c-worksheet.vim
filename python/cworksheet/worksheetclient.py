# Python client for C Worksheetify.

import json
import shlex
import socket
import subprocess
import sys


def start_server(cmdStr):
	# On windows, sys.platform is "win32".
	# os.name gives 'nt' on Windows, 'posix' on posix-y things.
	is_posix = not sys.platform.startswith("win")
	cmd = shlex.split(cmdStr, posix = is_posix)

	srv_p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

	# From v0.2.2, Server should output at least one line when it runs,
	# So we can 'block' until it runs.
	# If server already running (when we try to run another one), it will
	#  write errors to the same file.
	srv_p.stdout.readline()



# Short of any better ideas, check if the port is in use.
def is_port_in_use(port):
	clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	try:
		clientsocket.connect(("localhost", port))
		clientsocket.close()
		return True
	except:
		return False



# Returns a list-of-lists,
# as a result corresponding to each line of the input file.
def run_worksheetify_client_req(hostname, port, message):
	clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	try:
		clientsocket.connect((hostname, port))
	except:
		return None

	clientsocket.sendall(message.encode('utf-8'))
	clientsocket.shutdown(socket.SHUT_WR)

	# Receive a message
	received = "";
	buf = clientsocket.recv(8)
	while len(buf) > 0:
		received = received + buf.decode('utf-8')
		buf = clientsocket.recv(8)

	clientsocket.close()

	lsOfLs = json.loads(received)["result"]
	return lsOfLs



def run_worksheetify_client(hostname, port, cFilePath):
	# Send a message
	req = { "inputtype": "filepath",
	        "input": cFilePath,
	        "outputtype": "json-outputlist" }
	message = json.dumps(req)

	return run_worksheetify_client_req(hostname, port, message)



def run_worksheetify_client_with_text(hostname, port, text):
	# Send a message
	req = { "inputtype": "text",
	        "input": text,
	        "outputtype": "json-outputlist" }
	message = json.dumps(req)

	return run_worksheetify_client_req(hostname, port, message)



# Like WorksheetifyOutput.generateWorksheetOutput.
# Except this only prepends spaces/comments ("//>"),
# doesn't attach to the input.
def with_spaces_and_comments(inputLines, ls_of_results, col_for_ws = 50):
	# inputLines[0] = line 1 of the program.

	def to_cmt(line, results_for_line):
		fst, rest = results_for_line[:1], results_for_line[1:]
		padding = col_for_ws - len(line)

		firstLine = lambda x : (padding * ' ') + "//> " + x
		restLine = lambda x : (col_for_ws * ' ') + "//| " + x

		if padding >= 0:
			return list(map(firstLine, fst)) + list(map(restLine, rest))
		else:
			padding = col_for_ws
			return [""] + list(map(firstLine, fst)) + list(map(restLine, rest))

	return [to_cmt(l,r) for (l, r) in zip(inputLines, ls_of_results)]

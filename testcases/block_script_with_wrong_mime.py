from http.server import HTTPServer, SimpleHTTPRequestHandler

server_address = ('0.0.0.0', 8888)

# Return JavaScript with an invalid MIME type
SimpleHTTPRequestHandler.extensions_map['.js'] = 'image/png'

SimpleHTTPRequestHandler.protocol_version = "HTTP/1.0"
httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)

sa = httpd.socket.getsockname()
print("Serving HTTP on", sa[0], "port", sa[1], "...")
try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("\nKeyboard interrupt received, exiting.")
    httpd.server_close()
    sys.exit(0)

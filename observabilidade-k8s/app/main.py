from http.server import BaseHTTPRequestHandler, HTTPServer

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        message = "✅ Aplicação de exemplo está rodando e sendo monitorada!"
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(message.encode())

if __name__ == "__main__":
    server = HTTPServer(('', 8000), SimpleHandler)
    print("🚀 Servidor iniciado em http://localhost:8000")
    server.serve_forever()print("Servidor de teste online. Aponte Prometheus para mim!")

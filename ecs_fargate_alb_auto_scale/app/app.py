from flask import Flask
app = Flask(__name__)

@app.get("/")
def index():
    return {"ok": True, "service": "ecs-fargate-demo"}, 200

@app.get("/health")
def health():
    return {"ok": True}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
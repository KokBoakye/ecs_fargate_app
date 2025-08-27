from flask import Flask, jsonify, request, abort
import os

app = Flask(__name__)

# In-memory task store (for simplicity)
tasks = {}
task_id_counter = 1

# Health check
@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200

# List all tasks
@app.route("/tasks", methods=["GET"])
def get_tasks():
    return jsonify(list(tasks.values()))

# Create a new task
@app.route("/tasks", methods=["POST"])
def create_task():
    global task_id_counter
    data = request.get_json()
    if not data or "title" not in data:
        abort(400, "Task must have a title")
    task = {
        "id": task_id_counter,
        "title": data["title"],
        "description": data.get("description", ""),
        "status": data.get("status", "pending")
    }
    tasks[task_id_counter] = task
    task_id_counter += 1
    return jsonify(task), 201

# Get a single task
@app.route("/tasks/<int:task_id>", methods=["GET"])
def get_task(task_id):
    task = tasks.get(task_id)
    if not task:
        abort(404, "Task not found")
    return jsonify(task)

# Update a task
@app.route("/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    task = tasks.get(task_id)
    if not task:
        abort(404, "Task not found")
    data = request.get_json()
    task.update({
        "title": data.get("title", task["title"]),
        "description": data.get("description", task["description"]),
        "status": data.get("status", task["status"])
    })
    return jsonify(task)

# Delete a task
@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    task = tasks.pop(task_id, None)
    if not task:
        abort(404, "Task not found")
    return jsonify({"message": "Task deleted"})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)

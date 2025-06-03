function TaskCard({ task }) {
  return (
    <div className="task-card">
      <div className={`${task.completed ? "completed-task" : ""} task-content`}>
        <p>{task.title}</p>
        <p>{task.completed ? "✅ Completed" : "🟡 Pending"}</p>
      </div>
      <button className="remove-button">Remove</button>
    </div>
  );
}

export default TaskCard;

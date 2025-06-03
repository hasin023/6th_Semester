import tasks from "../data/tasks";
import TaskCard from "./TaskCard";

const TaskTracker = () => {
  const getCompletedTasks = (tasks) => {
    return tasks.filter((task) => task.completed).length;
  };

  const getPendingTasks = (tasks) => {
    return tasks.filter((task) => !task.completed).length;
  };

  return (
    <div>
      <h1>Interactive Task Manager</h1>

      <div className="task-info">
        <h3>Total Tasks: {tasks.length}</h3>
        <h3>Completed: {getCompletedTasks(tasks)}</h3>
        <h3>Remaining: {getPendingTasks(tasks)}</h3>
      </div>

      <div className="action-buttons">
        <button className="action-button">Add Random Task</button>
        <button className="action-button">Clear Completed (Available)</button>
      </div>

      {tasks.map((task) => (
        <div key={task.id} className="card-box">
          <TaskCard task={task} />
        </div>
      ))}
    </div>
  );
};

export default TaskTracker;

import { FaCheckCircle, FaRegCircle } from "react-icons/fa";
import { RiDeleteBin6Line } from "react-icons/ri";
import { TbEdit } from "react-icons/tb";
import toast from "react-hot-toast";
import axios from "axios";
import Tooltip from "./Tooltip";

const ListItem = ({ todoList, setAddTask, setReload }) => {
  const API_BACKEND = import.meta.env.VITE_API_BASE_URL;

  // Set task for editing
  const handleEdit = (task) => {
    setAddTask(task);
  };

  // Delete task using its unique id
  const handleDelete = (_id) => {
    const headers = {
      headers: {
        "Content-Type": "application/json",
      },
    };

    async function deleteData() {
      try {
        const response = await axios.delete(
          `${API_BACKEND}/delete/${_id}`,
          headers
        );

        toast.success("Task deleted");
        setReload((reload) => !reload);
      } catch (error) {
        console.error(`${error.status} ${error.code}`);
        toast.error(`${error.status} ${error.code}`);
      }
    }
    deleteData();
  };

  // Toggle completion for a task using its unique id
  const handleComplete = (task) => {
    const updatedTask = { ...task, isCompleted: !task.isCompleted };

    const headers = {
      headers: {
        "Content-Type": "application/json",
      },
    };

    async function updateData() {
      try {
        const response = await axios.put(
          `${API_BACKEND}/update/${task._id}`,
          updatedTask,
          headers
        );

        toast.success(
          task.isCompleted
            ? `${task.todoValue} - Task not completed`
            : `${task.todoValue} - Task completed`
        );
        setReload((reload) => !reload);
      } catch (error) {
        console.error(`${error.status} ${error.code}`);
        toast.error(`${error.status} ${error.code}`);
      }
    }
    updateData();
  };

  return (
    <div className="w-full space-y-4">
      {todoList.map((task) => (
        <div
          key={task._id}
          className="flex flex-row justify-between items-start gap-x-3"
        >
          <div
            className="flex flex-row justify-start items-start gap-x-4 cursor-pointer"
            onClick={() => handleComplete(task)}
          >
            <span className="h-5 w-5">
              {task.isCompleted ? (
                <FaCheckCircle color="#16a34a" size={22} />
              ) : (
                <FaRegCircle color="#484d5c" size={22} />
              )}
            </span>

            <span
              className={`break-all ${
                task.isCompleted ? "line-through" : "no-underline"
              }`}
            >
              {task.todoValue}
            </span>
          </div>

          <div className="flex flex-row gap-3">
            <Tooltip text="Edit">
              <div
                className="h-5 w-5 cursor-pointer text-green-700 hover:text-green-900"
                onClick={() => handleEdit(task)}
              >
                <TbEdit size={20} />
              </div>
            </Tooltip>
            <Tooltip text="Delete">
              <div
                className="h-5 w-5 cursor-pointer text-gray-700 hover:text-rose-800"
                onClick={() => handleDelete(task._id)}
              >
                <RiDeleteBin6Line size={20} />
              </div>
            </Tooltip>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ListItem;

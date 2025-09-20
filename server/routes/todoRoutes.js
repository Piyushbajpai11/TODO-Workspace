const express = require("express");

const router = express.Router();

const {
  createTask,
  getTask,
  updateTask,
  deleteTask,
} = require("../controllers/todoController");

router.route("/todos").get(getTask).post(createTask);
router.route("/todos/:id").put(updateTask).delete(deleteTask);


module.exports = router;

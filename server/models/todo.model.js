const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const todoSchema = new Schema({
  todoValue: { type: String, required: true },
  isCompleted: { type: Boolean, required: true },
});

const Todo = mongoose.model("MERN-Todo", todoSchema);

module.exports = Todo;

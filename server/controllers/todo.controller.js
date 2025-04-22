// user controller
const Todo = require("../models/todo.model");

const initialData = (req, res) => {
  res.json({
    test: "✅ Welcome to MERN-Todofy! - See Live Web URL for this Server - https://mern-todofy.netlify.app",
  });
};

const creatList = (req, res) => {
  Todo.create(req.body)
    .then((list) => res.json(list))
    .catch((err) => res.status(400).json("Error! " + err));
};

const getList = (req, res) => {
  // using .find() without a paramter will match on all user instances
  Todo.find()
    .then((allList) => res.json(allList))
    .catch((err) => res.status(400).json("Error! " + err));
};

const deleteList = (req, res) => {
  Todo.findByIdAndDelete(req.params.id)
    .then(() => res.json("Success! List deleted."))
    .catch((err) => res.status(400).json("Error! " + err));
};

const updateList = (req, res) => {
  Todo.findByIdAndUpdate(req.params.id, req.body)
    .then(() => res.json("Success! List updated."))
    .catch((err) => res.status(400).json("Error! " + err));
};

module.exports = { initialData, creatList, getList, deleteList, updateList };

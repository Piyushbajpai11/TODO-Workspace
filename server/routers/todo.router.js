const express = require("express");

const router = express.Router();

const todoController = require("../controllers/todo.controller");

router.route("/new").post(todoController.creatList);

router.route("/").get(todoController.getList);

router.route("/update/:id").put(todoController.updateList);

router.route("/delete/:id").delete(todoController.deleteList);

module.exports = router;

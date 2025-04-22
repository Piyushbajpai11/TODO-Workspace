// establish an express app
const express = require("express");
const app = express();

// allow requests from outside resources like postman, or your frontend if you choose to build that out
const cors = require("cors");
app.use(cors());

// app will serve and receive data in a JSON format
app.use(express.json());

// the messenger between our app and our database
const mongoose = require("mongoose");

// allow us to hide our connection secret in the process.env object
require("dotenv").config();

// establish connection & give yourself a message so you know when its complete
const source = process.env.MONGODB_ATLAS_CONNECTION;

mongoose
  .connect(source)
  .then(() => console.log("✅ DB Connected Successfully"))
  .catch((error) => console.log(error));

const todoRoutes = require("./routers/todo.router");
app.use("/", todoRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`✅ Server is running on port ${PORT}`);
});

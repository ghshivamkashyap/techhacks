const db = require("./config/db");
// import bodyParser from "body-parser";

const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const productroutes = require("./routes/products");

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

try {
  db.connect();
  console.log("Connected to the database");
} catch (error) {
  console.error("Error connecting to the database:", error);
  process.exit(1);
}

app.use(express.json());
app.use(
  cors({
    origin: "*",
    credentials: true,
  })
);

app.use("/api", productroutes);

app.get("/", (req, res) => {
  return res.json({
    success: true,
    message: "Your server is up and running",
  });
});

app.listen(PORT, (err) => {
  if (err) {
    console.error("Error starting the server:", err);
    process.exit(1);
  }
  console.log(`App is running at port ${PORT}`);
});

const mongoose = require("mongoose");

// schema defination
const billSchema = new mongoose.Schema(
  {
    pIds: [{ type: String, required: true }],
    products: [{ type: String, required: true }],
    totalPrice: Number,
    mrp: Number,
  },
  { timestamps: true }
);

module.exports = mongoose.model("Bill", billSchema);

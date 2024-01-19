const mongoose = require("mongoose");

const storeSchema = new mongoose.Schema({
  sid: { type: String, required: true },
  name: { type: String, required: true },
  address: { type: String, required: true },
  products: [
    {
      type: String,
    },
  ],
  logo: {
    type: String,
    default:
      "https://media.istockphoto.com/id/1252652997/vector/convenience-store-rgb-color-icon-grocery-shop-exterior-small-business-in-retail-duty-free.webp?s=2048x2048&w=is&k=20&c=5K21VaDyKOojSkhetIc9o3zcNAz2QqVywmdi59ZAO4o=",
  },
});

module.exports = mongoose.model("Store", storeSchema);

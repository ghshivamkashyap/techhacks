const express = require("express");
const router = express.Router();

const { getProductById, addProduct, genrateBiill, securityCheck, getallProducts } = require("../controllers/products");
const { addStore } = require("../controllers/Store");

// Use a route parameter for 'pid'
router.get("/getproductbyid/:pid", getProductById);
router.get("/security/:billId", securityCheck);
router.post("/addproduct", addProduct);
router.post("/getbill", genrateBiill);
router.post("/addstore", addStore);
router.get("/getallproducts", getallProducts);


module.exports = router;

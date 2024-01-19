const Stores = require("../models/Stores");

exports.addStore = async (req, res) => {
  try {
    const data = req.body;
    console.log(data);

    const result = await Stores.create(data);
    return res.status(200).json({
        iserror:false,
        message: "store created success",
    })
  } catch (error) {
    console.log(error)
  }
};

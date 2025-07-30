import "dotenv/config";
import mongoose from "mongoose";
const { connect } = mongoose;

const mongoURI = process.env.MONGO_URI;

const dbConnect = () => {
  try {
    connect(mongoURI);
    console.log("Connected to MongoDB");
  } catch (err) {
    console.log("Connection Failed - " + err);
  }
};

export default dbConnect;

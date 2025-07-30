import express from "express"
import {
  GETUsersFromCollection,
  POSTUserToCollection,
  PUTUserFromCollection,
  DELETEUserFromCollection,
} from "../controllers/User.Controller.js"

const { Router } = express
const userRouter = Router()

userRouter.get("/", GETUsersFromCollection)
userRouter.post("/", POSTUserToCollection)
userRouter.put("/:id", PUTUserFromCollection)
userRouter.delete("/:id", DELETEUserFromCollection)

export default userRouter

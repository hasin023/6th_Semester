import "dotenv/config"
import express from "express"
import cors from "cors"

// import routes
import bookRouter from "./routes/Book.Router.js"
import userRouter from "./routes/User.Router.js"
import dbConnect from "./config/mongo.js"

const app = express()
const PORT = 9090

app.use(cors())
app.use(express.json())

dbConnect()

app.get("/api/v1/health", (req, res) => {
  res.json({ message: "API is Online ✔✔" })
})

// Routes
app.use("/api/v1/books", bookRouter)
app.use("/api/v1/users", userRouter)

app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`)
})

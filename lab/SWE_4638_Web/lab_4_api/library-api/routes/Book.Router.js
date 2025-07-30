import express from "express";
import {
  DELETEBookFromCollection,
  GETBooksFromCollection,
  POSTBookToCollection,
  PUTBookFromCollection,
} from "../controllers/Book.Controller.js";

const { Router } = express;
const bookRouter = Router();

bookRouter.get("/", GETBooksFromCollection);
bookRouter.post("/", POSTBookToCollection);
bookRouter.put("/:id", PUTBookFromCollection);
bookRouter.delete("/:id", DELETEBookFromCollection);

export default bookRouter;

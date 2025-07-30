import Book from "../models/bookModel.js"

export const GETBooksFromCollection = async (req, res) => {
  try {
    const books = await Book.find({})

    if (!books || books.length === 0) {
      return res.status(404).json({ error: "No books found" })
    }

    res.json({ data: books })
  } catch (error) {
    console.error("Error fetching books:", error)
    res.status(500).json({ error: "Error fetching books" })
  }
}

export const POSTBookToCollection = async (req, res) => {
  try {
    const bookData = req.body

    if (!bookData) {
      return res.status(404).json({ error: "Book data can not be empty" })
    }

    const response = await Book.create(bookData)

    res.json({ data: bookData, response: response })
  } catch (error) {
    console.error("Error creating books:", error)
    res.status(500).json({ error: "Error creating books" })
  }
}

export const PUTBookFromCollection = async (req, res) => {
  try {
    const { id } = req.params
    const bookUpdateData = req.body

    if (!bookUpdateData || !id) {
      return res
        .status(404)
        .json({ error: "Book update data or ID can not be empty" })
    }

    const updatedBook = await Book.findByIdAndUpdate(id, bookUpdateData, {
      new: true,
      runValidators: true,
    })

    if (!updatedBook) {
      return res.status(404).json({ error: "Book not found" })
    }

    res.json({ message: "Book updated successfully", data: updatedBook })
  } catch (error) {
    console.error("Error updating books:", error)
    res.status(500).json({ error: "Error updating books" })
  }
}

export const DELETEBookFromCollection = async (req, res) => {
  try {
    const { id } = req.params

    const deletedBook = await Book.findByIdAndDelete(id)

    if (!deletedBook) {
      return res.status(404).json({ error: "Book not found" })
    }

    res.json({ message: "Book deleted successfully", data: deletedBook })
  } catch (error) {
    console.error("Error deleting book:", error)
    res.status(500).json({ error: "Error deleting book" })
  }
}

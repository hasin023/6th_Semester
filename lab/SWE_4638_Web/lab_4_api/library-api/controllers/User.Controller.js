import User from "../models/userModel.js"

export const GETUsersFromCollection = async (req, res) => {
  try {
    const users = await User.find({})

    if (!users || users.length === 0) {
      return res.status(404).json({ error: "No users found" })
    }

    res.json({ data: users })
  } catch (error) {
    console.error("Error fetching users:", error)
    res.status(500).json({ error: "Error fetching users" })
  }
}

export const POSTUserToCollection = async (req, res) => {
  try {
    const userData = req.body

    if (!userData) {
      return res.status(404).json({ error: "User data can not be empty" })
    }

    const response = await User.create(userData)

    res.json({ data: userData, response: response })
  } catch (error) {
    console.error("Error creating user:", error)
    res.status(500).json({ error: "Error creating user" })
  }
}

export const PUTUserFromCollection = async (req, res) => {
  try {
    const { id } = req.params
    const userUpdateData = req.body

    if (!userUpdateData || !id) {
      return res
        .status(404)
        .json({ error: "User update data or ID can not be empty" })
    }

    const updatedUser = await User.findByIdAndUpdate(id, userUpdateData, {
      new: true,
      runValidators: true,
    })

    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" })
    }

    res.json({ message: "User updated successfully", data: updatedUser })
  } catch (error) {
    console.error("Error updating Users:", error)
    res.status(500).json({ error: "Error updating Users" })
  }
}

export const DELETEUserFromCollection = async (req, res) => {
  try {
    const { id } = req.params

    const deletedUser = await User.findByIdAndDelete(id)

    if (!deletedUser) {
      return res.status(404).json({ error: "User not found" })
    }

    res.json({ message: "User deleted successfully", data: deletedUser })
  } catch (error) {
    console.error("Error deleting User:", error)
    res.status(500).json({ error: "Error deleting User" })
  }
}

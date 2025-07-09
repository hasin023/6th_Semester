## CRUD Operations

CRUD stands for **Create, Read, Update, Delete** - the four fundamental operations for managing data in applications. In React, these operations are implemented using state management and array methods.

### What is CRUD?

CRUD operations form the backbone of most web applications:

- **Create**: Adding new data (e.g., creating a new user or post)
- **Read**: Retrieving and displaying existing data (e.g., showing a list of products)
- **Update**: Modifying existing data (e.g., editing a profile)
- **Delete**: Removing data (e.g., deleting a comment)

### Array Methods for CRUD Operations

React uses specific array methods for each CRUD operation since state must be immutable:

**Create (Adding Items)**:

```javascript
// Using concat()
const newArray = oldArray.concat(newElement)

// Using spread operator (preferred)
const newArray = [...oldArray, newElement]
```

**Read (Retrieving Data)**:

```javascript
// Using map to display items
const mappedArray = oldArray.map((item) => <div key={item.id}>{item.name}</div>)

// Using filter to find specific items
const filteredArray = oldArray.filter((item) => item.status === "active")
```

**Update (Modifying Items)**:

```javascript
// Using map to update specific item
const updatedArray = oldArray.map((item) =>
  item.id === itemId ? { ...item, name: "Updated Name" } : item
)
```

**Delete (Removing Items)**:

```javascript
// Using filter to remove item
const newArray = oldArray.filter((item) => item.id !== itemId)
```

### Complete CRUD Example: Todo App

```javascript
import React, { useState } from "react"

const TodoApp = () => {
  const [tasks, setTasks] = useState([])
  const [newTask, setNewTask] = useState("")
  const [editingId, setEditingId] = useState(null)
  const [editingText, setEditingText] = useState("")

  // CREATE - Add new task
  const createTask = () => {
    if (newTask.trim()) {
      setTasks([
        ...tasks,
        {
          id: Date.now(),
          name: newTask,
          completed: false,
        },
      ])
      setNewTask("")
    }
  }

  // READ - Display tasks (handled in JSX)
  const readTasks = () => tasks

  // UPDATE - Edit existing task
  const updateTask = (id, updatedName) => {
    setTasks(
      tasks.map((task) =>
        task.id === id ? { ...task, name: updatedName } : task
      )
    )
    setEditingId(null)
    setEditingText("")
  }

  // DELETE - Remove task
  const deleteTask = (id) => {
    setTasks(tasks.filter((task) => task.id !== id))
  }

  // Toggle completion status
  const toggleComplete = (id) => {
    setTasks(
      tasks.map((task) =>
        task.id === id ? { ...task, completed: !task.completed } : task
      )
    )
  }

  return (
    <div>
      <h1>Todo List</h1>

      {/* CREATE Section */}
      <div>
        <input
          type='text'
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder='Add new task'
        />
        <button onClick={createTask}>Add Task</button>
      </div>

      {/* READ Section */}
      <ul>
        {readTasks().map((task) => (
          <li key={task.id}>
            {editingId === task.id ? (
              <div>
                <input
                  type='text'
                  value={editingText}
                  onChange={(e) => setEditingText(e.target.value)}
                />
                <button onClick={() => updateTask(task.id, editingText)}>
                  Save
                </button>
                <button onClick={() => setEditingId(null)}>Cancel</button>
              </div>
            ) : (
              <div>
                <span
                  style={{
                    textDecoration: task.completed ? "line-through" : "none",
                  }}
                >
                  {task.name}
                </span>
                <button onClick={() => toggleComplete(task.id)}>
                  {task.completed ? "Undo" : "Complete"}
                </button>
                <button
                  onClick={() => {
                    setEditingId(task.id)
                    setEditingText(task.name)
                  }}
                >
                  Edit
                </button>
                <button onClick={() => deleteTask(task.id)}>Delete</button>
              </div>
            )}
          </li>
        ))}
      </ul>
    </div>
  )
}

export default TodoApp
```

### Advanced CRUD Example: User Management System

```javascript
import React, { useState, useEffect } from "react"

const UserManagement = () => {
  const [users, setUsers] = useState([])
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    role: "user",
  })
  const [editingUser, setEditingUser] = useState(null)
  const [loading, setLoading] = useState(false)

  // Simulate API calls
  const apiCall = (action, data) => {
    setLoading(true)
    return new Promise((resolve) => {
      setTimeout(() => {
        setLoading(false)
        resolve(data)
      }, 1000)
    })
  }

  // CREATE - Add new user
  const createUser = async (e) => {
    e.preventDefault()
    if (!formData.name || !formData.email) return

    const newUser = {
      id: Date.now(),
      ...formData,
      createdAt: new Date().toISOString(),
    }

    await apiCall("create", newUser)
    setUsers([...users, newUser])
    setFormData({ name: "", email: "", role: "user" })
  }

  // READ - Fetch users (simulated)
  const fetchUsers = async () => {
    const mockUsers = [
      { id: 1, name: "John Doe", email: "john@example.com", role: "admin" },
      { id: 2, name: "Jane Smith", email: "jane@example.com", role: "user" },
    ]

    await apiCall("read", mockUsers)
    setUsers(mockUsers)
  }

  // UPDATE - Edit user
  const updateUser = async (e) => {
    e.preventDefault()
    if (!editingUser) return

    const updatedUser = { ...editingUser, ...formData }
    await apiCall("update", updatedUser)

    setUsers(
      users.map((user) => (user.id === editingUser.id ? updatedUser : user))
    )

    setEditingUser(null)
    setFormData({ name: "", email: "", role: "user" })
  }

  // DELETE - Remove user
  const deleteUser = async (id) => {
    if (window.confirm("Are you sure you want to delete this user?")) {
      await apiCall("delete", id)
      setUsers(users.filter((user) => user.id !== id))
    }
  }

  // Load users on component mount
  useEffect(() => {
    fetchUsers()
  }, [])

  const handleInputChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    })
  }

  const startEdit = (user) => {
    setEditingUser(user)
    setFormData({
      name: user.name,
      email: user.email,
      role: user.role,
    })
  }

  return (
    <div>
      <h1>User Management System</h1>

      {/* Form for CREATE and UPDATE */}
      <form onSubmit={editingUser ? updateUser : createUser}>
        <h2>{editingUser ? "Edit User" : "Add New User"}</h2>

        <input
          type='text'
          name='name'
          placeholder='Name'
          value={formData.name}
          onChange={handleInputChange}
          required
        />

        <input
          type='email'
          name='email'
          placeholder='Email'
          value={formData.email}
          onChange={handleInputChange}
          required
        />

        <select name='role' value={formData.role} onChange={handleInputChange}>
          <option value='user'>User</option>
          <option value='admin'>Admin</option>
        </select>

        <button type='submit' disabled={loading}>
          {loading ? "Processing..." : editingUser ? "Update" : "Create"}
        </button>

        {editingUser && (
          <button
            type='button'
            onClick={() => {
              setEditingUser(null)
              setFormData({ name: "", email: "", role: "user" })
            }}
          >
            Cancel
          </button>
        )}
      </form>

      {/* Display users (READ) */}
      <div>
        <h2>Users List</h2>
        {loading ? (
          <p>Loading...</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map((user) => (
                <tr key={user.id}>
                  <td>{user.name}</td>
                  <td>{user.email}</td>
                  <td>{user.role}</td>
                  <td>
                    <button onClick={() => startEdit(user)}>Edit</button>
                    <button onClick={() => deleteUser(user.id)}>Delete</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}

export default UserManagement
```

## Conditional Rendering

Conditional rendering allows you to display different content based on certain conditions. It's essential for creating dynamic user interfaces that respond to user interactions and application state.

### Basic Conditional Rendering Techniques

#### 1. If Statement Pattern

```javascript
function UserGreeting({ isLoggedIn, username }) {
  if (isLoggedIn) {
    return <h1>Welcome back, {username}!</h1>
  }
  return <h1>Please sign in.</h1>
}
```

#### 2. Ternary Operator Pattern

```javascript
function StatusIndicator({ isOnline }) {
  return <div>Status: {isOnline ? "Online" : "Offline"}</div>
}
```

#### 3. Logical AND (\&\&) Operator

```javascript
function Notifications({ messages }) {
  return (
    <div>
      {messages.length > 0 && (
        <div>You have {messages.length} new messages</div>
      )}
    </div>
  )
}
```

### Complete Conditional Rendering Example

```javascript
import React, { useState, useEffect } from "react"

const Dashboard = () => {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [notifications, setNotifications] = useState([])
  const [showSettings, setShowSettings] = useState(false)

  // Simulate API call
  useEffect(() => {
    const fetchUserData = async () => {
      try {
        setLoading(true)
        // Simulate API delay
        await new Promise((resolve) => setTimeout(resolve, 2000))

        // Simulate random success/failure
        if (Math.random() > 0.3) {
          setUser({
            id: 1,
            name: "John Doe",
            email: "john@example.com",
            role: "admin",
            lastLogin: new Date().toISOString(),
          })
          setNotifications([
            { id: 1, message: "Welcome back!", type: "success" },
            { id: 2, message: "You have 3 pending tasks", type: "info" },
          ])
        } else {
          throw new Error("Failed to fetch user data")
        }
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchUserData()
  }, [])

  // Early return pattern for loading state
  if (loading) {
    return (
      <div className='loading-container'>
        <div className='spinner'></div>
        <p>Loading dashboard...</p>
      </div>
    )
  }

  // Early return pattern for error state
  if (error) {
    return (
      <div className='error-container'>
        <h2>Oops! Something went wrong</h2>
        <p>{error}</p>
        <button onClick={() => window.location.reload()}>Try Again</button>
      </div>
    )
  }

  // Main render with multiple conditional elements
  return (
    <div className='dashboard'>
      <header>
        <h1>Dashboard</h1>

        {/* Conditional user info */}
        {user && (
          <div className='user-info'>
            <span>Welcome, {user.name}</span>
            {user.role === "admin" && (
              <span className='admin-badge'>Admin</span>
            )}
          </div>
        )}

        <button onClick={() => setShowSettings(!showSettings)}>
          {showSettings ? "Hide" : "Show"} Settings
        </button>
      </header>

      {/* Conditional notifications */}
      {notifications.length > 0 && (
        <div className='notifications'>
          <h3>Notifications</h3>
          {notifications.map((notification) => (
            <div
              key={notification.id}
              className={`notification ${notification.type}`}
            >
              {notification.message}
            </div>
          ))}
        </div>
      )}

      {/* Conditional settings panel */}
      {showSettings && (
        <div className='settings-panel'>
          <h3>Settings</h3>
          <div className='setting-item'>
            <label>
              <input type='checkbox' />
              Email notifications
            </label>
          </div>
          <div className='setting-item'>
            <label>
              <input type='checkbox' />
              Dark mode
            </label>
          </div>
        </div>
      )}

      {/* Main content area */}
      <main>
        {user ? (
          <div>
            <h2>Welcome back, {user.name}!</h2>
            <p>Last login: {new Date(user.lastLogin).toLocaleString()}</p>

            {/* Conditional content based on user role */}
            {user.role === "admin" ? <AdminPanel /> : <UserPanel />}
          </div>
        ) : (
          <div>
            <h2>Please log in to access the dashboard</h2>
            <button>Login</button>
          </div>
        )}
      </main>
    </div>
  )
}

// Separate components for different user roles
const AdminPanel = () => (
  <div className='admin-panel'>
    <h3>Admin Panel</h3>
    <div className='admin-actions'>
      <button>Manage Users</button>
      <button>View Reports</button>
      <button>System Settings</button>
    </div>
  </div>
)

const UserPanel = () => (
  <div className='user-panel'>
    <h3>Your Dashboard</h3>
    <div className='user-actions'>
      <button>View Profile</button>
      <button>My Tasks</button>
      <button>Settings</button>
    </div>
  </div>
)

export default Dashboard
```

### Advanced Conditional Rendering Example

```javascript
import React, { useState } from "react"

const ShoppingCart = () => {
  const [items, setItems] = useState([
    { id: 1, name: "Laptop", price: 999, quantity: 1, inStock: true },
    { id: 2, name: "Mouse", price: 29, quantity: 2, inStock: true },
    { id: 3, name: "Keyboard", price: 79, quantity: 1, inStock: false },
  ])
  const [discount, setDiscount] = useState(0)
  const [isCheckingOut, setIsCheckingOut] = useState(false)

  const subtotal = items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  )
  const total = subtotal - discount

  const updateQuantity = (id, newQuantity) => {
    setItems(
      items.map((item) =>
        item.id === id ? { ...item, quantity: Math.max(0, newQuantity) } : item
      )
    )
  }

  const removeItem = (id) => {
    setItems(items.filter((item) => item.id !== id))
  }

  const checkout = () => {
    setIsCheckingOut(true)
    // Simulate checkout process
    setTimeout(() => {
      setIsCheckingOut(false)
      alert("Order placed successfully!")
      setItems([])
    }, 2000)
  }

  return (
    <div className='shopping-cart'>
      <h1>Shopping Cart</h1>

      {/* Empty cart state */}
      {items.length === 0 ? (
        <div className='empty-cart'>
          <h2>Your cart is empty</h2>
          <p>Add some items to get started!</p>
          <button>Continue Shopping</button>
        </div>
      ) : (
        <div>
          {/* Cart items */}
          <div className='cart-items'>
            {items.map((item) => (
              <div key={item.id} className='cart-item'>
                <h3>{item.name}</h3>
                <p>${item.price}</p>

                {/* Stock status */}
                {item.inStock ? (
                  <span className='in-stock'>In Stock</span>
                ) : (
                  <span className='out-of-stock'>Out of Stock</span>
                )}

                {/* Quantity controls - only show if in stock */}
                {item.inStock && (
                  <div className='quantity-controls'>
                    <button
                      onClick={() => updateQuantity(item.id, item.quantity - 1)}
                    >
                      -
                    </button>
                    <span>{item.quantity}</span>
                    <button
                      onClick={() => updateQuantity(item.id, item.quantity + 1)}
                    >
                      +
                    </button>
                  </div>
                )}

                <button onClick={() => removeItem(item.id)}>Remove</button>
              </div>
            ))}
          </div>

          {/* Order summary */}
          <div className='order-summary'>
            <h3>Order Summary</h3>
            <p>Subtotal: ${subtotal.toFixed(2)}</p>

            {/* Discount section - only show if discount > 0 */}
            {discount > 0 && <p>Discount: -${discount.toFixed(2)}</p>}

            <p>
              <strong>Total: ${total.toFixed(2)}</strong>
            </p>

            {/* Checkout button state */}
            {isCheckingOut ? (
              <button disabled>Processing...</button>
            ) : (
              <button
                onClick={checkout}
                disabled={items.some((item) => !item.inStock)}
              >
                {items.some((item) => !item.inStock)
                  ? "Remove out of stock items to checkout"
                  : "Checkout"}
              </button>
            )}
          </div>

          {/* Warning for out of stock items */}
          {items.some((item) => !item.inStock) && (
            <div className='warning'>
              <p>⚠️ Some items in your cart are out of stock</p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default ShoppingCart
```

## Forms and Controlled Components

Forms are essential for user interaction in web applications. React provides controlled components where form data is handled by React state rather than the DOM.

### Understanding Controlled Components

In controlled components, React manages the form state completely:

- The form element's value is controlled by React state
- Every change triggers a state update
- The component re-renders with the updated value
- This creates a "single source of truth" for form data

### Basic Controlled Component Example

```javascript
import React, { useState } from "react"

const SimpleForm = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    message: "",
  })

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }))
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    console.log("Form submitted:", formData)
    // Process form data here
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Name:</label>
        <input
          type='text'
          name='name'
          value={formData.name}
          onChange={handleChange}
          required
        />
      </div>

      <div>
        <label>Email:</label>
        <input
          type='email'
          name='email'
          value={formData.email}
          onChange={handleChange}
          required
        />
      </div>

      <div>
        <label>Message:</label>
        <textarea
          name='message'
          value={formData.message}
          onChange={handleChange}
          rows='4'
        />
      </div>

      <button type='submit'>Submit</button>
    </form>
  )
}

export default SimpleForm
```

### Advanced Form Example with Validation

```javascript
import React, { useState } from "react"

const AdvancedForm = () => {
  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    password: "",
    confirmPassword: "",
    age: "",
    country: "",
    hobbies: [],
    newsletter: false,
    terms: false,
  })

  const [errors, setErrors] = useState({})
  const [isSubmitting, setIsSubmitting] = useState(false)

  // Validation functions
  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  const validatePassword = (password) => {
    return password.length >= 6
  }

  const validateForm = () => {
    const newErrors = {}

    if (!formData.firstName.trim()) {
      newErrors.firstName = "First name is required"
    }

    if (!formData.lastName.trim()) {
      newErrors.lastName = "Last name is required"
    }

    if (!formData.email.trim()) {
      newErrors.email = "Email is required"
    } else if (!validateEmail(formData.email)) {
      newErrors.email = "Please enter a valid email"
    }

    if (!formData.password) {
      newErrors.password = "Password is required"
    } else if (!validatePassword(formData.password)) {
      newErrors.password = "Password must be at least 6 characters"
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = "Passwords do not match"
    }

    if (!formData.age || formData.age < 18) {
      newErrors.age = "Must be at least 18 years old"
    }

    if (!formData.country) {
      newErrors.country = "Please select a country"
    }

    if (!formData.terms) {
      newErrors.terms = "You must agree to the terms"
    }

    return newErrors
  }

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target

    setFormData((prevData) => ({
      ...prevData,
      [name]: type === "checkbox" ? checked : value,
    }))

    // Clear error when user starts typing
    if (errors[name]) {
      setErrors((prevErrors) => ({
        ...prevErrors,
        [name]: "",
      }))
    }
  }

  const handleHobbyChange = (hobby) => {
    setFormData((prevData) => ({
      ...prevData,
      hobbies: prevData.hobbies.includes(hobby)
        ? prevData.hobbies.filter((h) => h !== hobby)
        : [...prevData.hobbies, hobby],
    }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    const formErrors = validateForm()
    setErrors(formErrors)

    if (Object.keys(formErrors).length === 0) {
      setIsSubmitting(true)

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 2000))

        console.log("Form submitted successfully:", formData)
        alert("Registration successful!")

        // Reset form
        setFormData({
          firstName: "",
          lastName: "",
          email: "",
          password: "",
          confirmPassword: "",
          age: "",
          country: "",
          hobbies: [],
          newsletter: false,
          terms: false,
        })
      } catch (error) {
        console.error("Submission error:", error)
        alert("Registration failed. Please try again.")
      } finally {
        setIsSubmitting(false)
      }
    }
  }

  return (
    <form onSubmit={handleSubmit} className='advanced-form'>
      <h2>User Registration</h2>

      {/* Name fields */}
      <div className='form-row'>
        <div className='form-group'>
          <label>First Name *</label>
          <input
            type='text'
            name='firstName'
            value={formData.firstName}
            onChange={handleInputChange}
            className={errors.firstName ? "error" : ""}
          />
          {errors.firstName && (
            <span className='error-message'>{errors.firstName}</span>
          )}
        </div>

        <div className='form-group'>
          <label>Last Name *</label>
          <input
            type='text'
            name='lastName'
            value={formData.lastName}
            onChange={handleInputChange}
            className={errors.lastName ? "error" : ""}
          />
          {errors.lastName && (
            <span className='error-message'>{errors.lastName}</span>
          )}
        </div>
      </div>

      {/* Email field */}
      <div className='form-group'>
        <label>Email *</label>
        <input
          type='email'
          name='email'
          value={formData.email}
          onChange={handleInputChange}
          className={errors.email ? "error" : ""}
        />
        {errors.email && <span className='error-message'>{errors.email}</span>}
      </div>

      {/* Password fields */}
      <div className='form-row'>
        <div className='form-group'>
          <label>Password *</label>
          <input
            type='password'
            name='password'
            value={formData.password}
            onChange={handleInputChange}
            className={errors.password ? "error" : ""}
          />
          {errors.password && (
            <span className='error-message'>{errors.password}</span>
          )}
        </div>

        <div className='form-group'>
          <label>Confirm Password *</label>
          <input
            type='password'
            name='confirmPassword'
            value={formData.confirmPassword}
            onChange={handleInputChange}
            className={errors.confirmPassword ? "error" : ""}
          />
          {errors.confirmPassword && (
            <span className='error-message'>{errors.confirmPassword}</span>
          )}
        </div>
      </div>

      {/* Age and Country */}
      <div className='form-row'>
        <div className='form-group'>
          <label>Age *</label>
          <input
            type='number'
            name='age'
            value={formData.age}
            onChange={handleInputChange}
            min='18'
            className={errors.age ? "error" : ""}
          />
          {errors.age && <span className='error-message'>{errors.age}</span>}
        </div>

        <div className='form-group'>
          <label>Country *</label>
          <select
            name='country'
            value={formData.country}
            onChange={handleInputChange}
            className={errors.country ? "error" : ""}
          >
            <option value=''>Select Country</option>
            <option value='us'>United States</option>
            <option value='uk'>United Kingdom</option>
            <option value='ca'>Canada</option>
            <option value='au'>Australia</option>
          </select>
          {errors.country && (
            <span className='error-message'>{errors.country}</span>
          )}
        </div>
      </div>

      {/* Hobbies - Multiple checkboxes */}
      <div className='form-group'>
        <label>Hobbies</label>
        <div className='checkbox-group'>
          {["Reading", "Gaming", "Sports", "Music", "Travel"].map((hobby) => (
            <label key={hobby} className='checkbox-label'>
              <input
                type='checkbox'
                checked={formData.hobbies.includes(hobby)}
                onChange={() => handleHobbyChange(hobby)}
              />
              {hobby}
            </label>
          ))}
        </div>
      </div>

      {/* Newsletter subscription */}
      <div className='form-group'>
        <label className='checkbox-label'>
          <input
            type='checkbox'
            name='newsletter'
            checked={formData.newsletter}
            onChange={handleInputChange}
          />
          Subscribe to newsletter
        </label>
      </div>

      {/* Terms and conditions */}
      <div className='form-group'>
        <label className='checkbox-label'>
          <input
            type='checkbox'
            name='terms'
            checked={formData.terms}
            onChange={handleInputChange}
          />
          I agree to the terms and conditions *
        </label>
        {errors.terms && <span className='error-message'>{errors.terms}</span>}
      </div>

      {/* Submit button */}
      <button type='submit' disabled={isSubmitting} className='submit-button'>
        {isSubmitting ? "Registering..." : "Register"}
      </button>
    </form>
  )
}

export default AdvancedForm
```

### Dynamic Form Example

```javascript
import React, { useState } from "react"

const DynamicForm = () => {
  const [formFields, setFormFields] = useState([
    { id: 1, type: "text", label: "Name", value: "", required: true },
  ])

  const [availableFieldTypes] = useState([
    { value: "text", label: "Text Input" },
    { value: "email", label: "Email" },
    { value: "number", label: "Number" },
    { value: "textarea", label: "Textarea" },
    { value: "select", label: "Select" },
    { value: "checkbox", label: "Checkbox" },
  ])

  const addField = () => {
    const newField = {
      id: Date.now(),
      type: "text",
      label: "New Field",
      value: "",
      required: false,
      options: [], // for select fields
    }
    setFormFields([...formFields, newField])
  }

  const updateField = (id, updates) => {
    setFormFields(
      formFields.map((field) =>
        field.id === id ? { ...field, ...updates } : field
      )
    )
  }

  const removeField = (id) => {
    setFormFields(formFields.filter((field) => field.id !== id))
  }

  const handleFieldValueChange = (id, value) => {
    updateField(id, { value })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    const formData = {}
    formFields.forEach((field) => {
      formData[field.label] = field.value
    })
    console.log("Dynamic form submitted:", formData)
  }

  const renderField = (field) => {
    switch (field.type) {
      case "text":
      case "email":
      case "number":
        return (
          <input
            type={field.type}
            value={field.value}
            onChange={(e) => handleFieldValueChange(field.id, e.target.value)}
            required={field.required}
          />
        )

      case "textarea":
        return (
          <textarea
            value={field.value}
            onChange={(e) => handleFieldValueChange(field.id, e.target.value)}
            required={field.required}
            rows='3'
          />
        )

      case "select":
        return (
          <select
            value={field.value}
            onChange={(e) => handleFieldValueChange(field.id, e.target.value)}
            required={field.required}
          >
            <option value=''>Select an option</option>
            {field.options.map((option, index) => (
              <option key={index} value={option}>
                {option}
              </option>
            ))}
          </select>
        )

      case "checkbox":
        return (
          <input
            type='checkbox'
            checked={field.value}
            onChange={(e) => handleFieldValueChange(field.id, e.target.checked)}
          />
        )

      default:
        return null
    }
  }

  return (
    <div className='dynamic-form'>
      <h2>Dynamic Form Builder</h2>

      {/* Form Builder */}
      <div className='form-builder'>
        <h3>Form Fields</h3>
        {formFields.map((field) => (
          <div key={field.id} className='field-builder'>
            <div className='field-config'>
              <input
                type='text'
                placeholder='Field Label'
                value={field.label}
                onChange={(e) =>
                  updateField(field.id, { label: e.target.value })
                }
              />

              <select
                value={field.type}
                onChange={(e) =>
                  updateField(field.id, { type: e.target.value })
                }
              >
                {availableFieldTypes.map((type) => (
                  <option key={type.value} value={type.value}>
                    {type.label}
                  </option>
                ))}
              </select>

              <label>
                <input
                  type='checkbox'
                  checked={field.required}
                  onChange={(e) =>
                    updateField(field.id, { required: e.target.checked })
                  }
                />
                Required
              </label>

              {field.type === "select" && (
                <input
                  type='text'
                  placeholder='Options (comma-separated)'
                  onChange={(e) =>
                    updateField(field.id, {
                      options: e.target.value
                        .split(",")
                        .map((opt) => opt.trim()),
                    })
                  }
                />
              )}

              <button
                type='button'
                onClick={() => removeField(field.id)}
                className='remove-field'
              >
                Remove
              </button>
            </div>
          </div>
        ))}

        <button type='button' onClick={addField} className='add-field'>
          Add Field
        </button>
      </div>

      {/* Generated Form */}
      <div className='generated-form'>
        <h3>Generated Form</h3>
        <form onSubmit={handleSubmit}>
          {formFields.map((field) => (
            <div key={field.id} className='form-field'>
              <label>
                {field.label}
                {field.required && <span className='required'>*</span>}
              </label>
              {renderField(field)}
            </div>
          ))}

          <button type='submit' className='submit-button'>
            Submit Form
          </button>
        </form>
      </div>
    </div>
  )
}

export default DynamicForm
```

## React Hooks

React Hooks are functions that allow you to use state and lifecycle features in functional components. They were introduced in React 16.8 and have become the preferred way to write React components.

### Basic Hooks

#### 1. useState Hook

The `useState` hook allows you to add state to functional components.

**Basic Syntax:**

```javascript
const [state, setState] = useState(initialValue)
```

**Simple Example:**

```javascript
import React, { useState } from "react"

const Counter = () => {
  const [count, setCount] = useState(0)

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(count - 1)}>Decrement</button>
      <button onClick={() => setCount(0)}>Reset</button>
    </div>
  )
}
```

**Advanced useState Example:**

```javascript
import React, { useState } from "react"

const UserProfile = () => {
  const [user, setUser] = useState({
    name: "",
    email: "",
    age: "",
    preferences: {
      theme: "light",
      notifications: true,
    },
  })

  const [errors, setErrors] = useState({})

  const updateUser = (field, value) => {
    setUser((prevUser) => ({
      ...prevUser,
      [field]: value,
    }))
  }

  const updatePreferences = (field, value) => {
    setUser((prevUser) => ({
      ...prevUser,
      preferences: {
        ...prevUser.preferences,
        [field]: value,
      },
    }))
  }

  const validateForm = () => {
    const newErrors = {}

    if (!user.name.trim()) newErrors.name = "Name is required"
    if (!user.email.trim()) newErrors.email = "Email is required"
    if (!user.age || user.age < 1) newErrors.age = "Valid age is required"

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    if (validateForm()) {
      console.log("User profile:", user)
      alert("Profile saved!")
    }
  }

  return (
    <div>
      <h2>User Profile</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Name:</label>
          <input
            type='text'
            value={user.name}
            onChange={(e) => updateUser("name", e.target.value)}
          />
          {errors.name && <span style={{ color: "red" }}>{errors.name}</span>}
        </div>

        <div>
          <label>Email:</label>
          <input
            type='email'
            value={user.email}
            onChange={(e) => updateUser("email", e.target.value)}
          />
          {errors.email && <span style={{ color: "red" }}>{errors.email}</span>}
        </div>

        <div>
          <label>Age:</label>
          <input
            type='number'
            value={user.age}
            onChange={(e) => updateUser("age", parseInt(e.target.value))}
          />
          {errors.age && <span style={{ color: "red" }}>{errors.age}</span>}
        </div>

        <div>
          <label>Theme:</label>
          <select
            value={user.preferences.theme}
            onChange={(e) => updatePreferences("theme", e.target.value)}
          >
            <option value='light'>Light</option>
            <option value='dark'>Dark</option>
          </select>
        </div>

        <div>
          <label>
            <input
              type='checkbox'
              checked={user.preferences.notifications}
              onChange={(e) =>
                updatePreferences("notifications", e.target.checked)
              }
            />
            Enable notifications
          </label>
        </div>

        <button type='submit'>Save Profile</button>
      </form>
    </div>
  )
}
```

#### 2. useEffect Hook

The `useEffect` hook handles side effects in functional components.

**Basic Syntax:**

```javascript
useEffect(() => {
  // Effect logic
  return () => {
    // Cleanup (optional)
  }
}, [dependencies]) // Dependencies array
```

**Simple Example:**

```javascript
import React, { useState, useEffect } from "react"

const Timer = () => {
  const [seconds, setSeconds] = useState(0)
  const [isRunning, setIsRunning] = useState(false)

  useEffect(() => {
    let interval = null

    if (isRunning) {
      interval = setInterval(() => {
        setSeconds((prevSeconds) => prevSeconds + 1)
      }, 1000)
    }

    return () => {
      if (interval) clearInterval(interval)
    }
  }, [isRunning])

  const reset = () => {
    setSeconds(0)
    setIsRunning(false)
  }

  return (
    <div>
      <h2>Timer: {seconds}s</h2>
      <button onClick={() => setIsRunning(!isRunning)}>
        {isRunning ? "Pause" : "Start"}
      </button>
      <button onClick={reset}>Reset</button>
    </div>
  )
}
```

**Advanced useEffect Example:**

```javascript
import React, { useState, useEffect } from "react"

const DataFetcher = () => {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [page, setPage] = useState(1)

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true)
        setError(null)

        // Simulate API call
        const response = await fetch(`/api/data?page=${page}`)
        if (!response.ok) {
          throw new Error("Failed to fetch data")
        }

        const result = await response.json()
        setData(result)
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [page]) // Re-run when page changes

  useEffect(() => {
    // Set document title
    document.title = `Data Page ${page}`

    // Cleanup on unmount
    return () => {
      document.title = "React App"
    }
  }, [page])

  if (loading) return <div>Loading...</div>
  if (error) return <div>Error: {error}</div>

  return (
    <div>
      <h2>Data (Page {page})</h2>
      {data && (
        <ul>
          {data.map((item) => (
            <li key={item.id}>{item.name}</li>
          ))}
        </ul>
      )}

      <div>
        <button onClick={() => setPage(page - 1)} disabled={page === 1}>
          Previous
        </button>
        <button onClick={() => setPage(page + 1)}>Next</button>
      </div>
    </div>
  )
}
```

### Complete Hooks Example: Task Manager

```javascript
import React, { useState, useEffect, useRef, useMemo } from "react"

const TaskManager = () => {
  const [tasks, setTasks] = useState([])
  const [filter, setFilter] = useState("all")
  const [newTask, setNewTask] = useState("")
  const [editingId, setEditingId] = useState(null)
  const [editingText, setEditingText] = useState("")
  const inputRef = useRef(null)

  // Load tasks from localStorage on mount
  useEffect(() => {
    const savedTasks = localStorage.getItem("tasks")
    if (savedTasks) {
      setTasks(JSON.parse(savedTasks))
    }
  }, [])

  // Save tasks to localStorage whenever tasks change
  useEffect(() => {
    localStorage.setItem("tasks", JSON.stringify(tasks))
  }, [tasks])

  // Focus input when editing starts
  useEffect(() => {
    if (editingId && inputRef.current) {
      inputRef.current.focus()
    }
  }, [editingId])

  // Filtered tasks using useMemo for performance
  const filteredTasks = useMemo(() => {
    switch (filter) {
      case "completed":
        return tasks.filter((task) => task.completed)
      case "pending":
        return tasks.filter((task) => !task.completed)
      default:
        return tasks
    }
  }, [tasks, filter])

  // Task statistics
  const taskStats = useMemo(() => {
    const total = tasks.length
    const completed = tasks.filter((task) => task.completed).length
    const pending = total - completed
    return { total, completed, pending }
  }, [tasks])

  const addTask = () => {
    if (newTask.trim()) {
      const task = {
        id: Date.now(),
        text: newTask,
        completed: false,
        createdAt: new Date().toISOString(),
      }
      setTasks([...tasks, task])
      setNewTask("")
    }
  }

  const deleteTask = (id) => {
    setTasks(tasks.filter((task) => task.id !== id))
  }

  const toggleComplete = (id) => {
    setTasks(
      tasks.map((task) =>
        task.id === id ? { ...task, completed: !task.completed } : task
      )
    )
  }

  const startEditing = (id, text) => {
    setEditingId(id)
    setEditingText(text)
  }

  const saveEdit = () => {
    if (editingText.trim()) {
      setTasks(
        tasks.map((task) =>
          task.id === editingId ? { ...task, text: editingText } : task
        )
      )
    }
    setEditingId(null)
    setEditingText("")
  }

  const cancelEdit = () => {
    setEditingId(null)
    setEditingText("")
  }

  const clearCompleted = () => {
    setTasks(tasks.filter((task) => !task.completed))
  }

  return (
    <div className='task-manager'>
      <h1>Task Manager</h1>

      {/* Task Statistics */}
      <div className='task-stats'>
        <span>Total: {taskStats.total}</span>
        <span>Completed: {taskStats.completed}</span>
        <span>Pending: {taskStats.pending}</span>
      </div>

      {/* Add Task */}
      <div className='add-task'>
        <input
          type='text'
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder='Add new task...'
          onKeyPress={(e) => e.key === "Enter" && addTask()}
        />
        <button onClick={addTask}>Add Task</button>
      </div>

      {/* Filter Options */}
      <div className='filters'>
        <button
          className={filter === "all" ? "active" : ""}
          onClick={() => setFilter("all")}
        >
          All
        </button>
        <button
          className={filter === "pending" ? "active" : ""}
          onClick={() => setFilter("pending")}
        >
          Pending
        </button>
        <button
          className={filter === "completed" ? "active" : ""}
          onClick={() => setFilter("completed")}
        >
          Completed
        </button>
      </div>

      {/* Task List */}
      <div className='task-list'>
        {filteredTasks.length === 0 ? (
          <p>No tasks found.</p>
        ) : (
          filteredTasks.map((task) => (
            <div key={task.id} className='task-item'>
              <input
                type='checkbox'
                checked={task.completed}
                onChange={() => toggleComplete(task.id)}
              />

              {editingId === task.id ? (
                <div className='editing'>
                  <input
                    ref={inputRef}
                    type='text'
                    value={editingText}
                    onChange={(e) => setEditingText(e.target.value)}
                    onKeyPress={(e) => {
                      if (e.key === "Enter") saveEdit()
                      if (e.key === "Escape") cancelEdit()
                    }}
                  />
                  <button onClick={saveEdit}>Save</button>
                  <button onClick={cancelEdit}>Cancel</button>
                </div>
              ) : (
                <div className='task-content'>
                  <span
                    className={task.completed ? "completed" : ""}
                    onDoubleClick={() => startEditing(task.id, task.text)}
                  >
                    {task.text}
                  </span>
                  <div className='task-actions'>
                    <button onClick={() => startEditing(task.id, task.text)}>
                      Edit
                    </button>
                    <button onClick={() => deleteTask(task.id)}>Delete</button>
                  </div>
                </div>
              )}
            </div>
          ))
        )}
      </div>

      {/* Clear Completed */}
      {taskStats.completed > 0 && (
        <button className='clear-completed' onClick={clearCompleted}>
          Clear Completed ({taskStats.completed})
        </button>
      )}
    </div>
  )
}

export default TaskManager
```

### Hook Rules and Best Practices

1. **Only call hooks at the top level** - Never call hooks inside loops, conditions, or nested functions
2. **Only call hooks from React functions** - Call hooks from React function components or custom hooks
3. **Use the dependency array correctly** - Include all values from component scope that change over time
4. **Prefer multiple useEffect hooks** - Separate concerns by using different useEffect hooks for different purposes
5. **Custom hooks for reusability** - Extract stateful logic into custom hooks for reuse across components

### Browser Router vs. Hash Router vs. Static Router

| Router Type       | URL Style             | Browser Requirement        | Typical Deployment                                      | Trade-offs                       | Suitable Use Cases            |
| :---------------- | :-------------------- | :------------------------- | :------------------------------------------------------ | :------------------------------- | :---------------------------- |
| `<BrowserRouter>` | `/users/42`           | Requires HTML5 History API | Full SPA hosting with server rewrite `/* -> index.html` | Clean URLs; needs server config  | Modern browsers, public sites |
| `<HashRouter>`    | `/#/users/42`         | Works on legacy browsers   | GitHub Pages or static hosting with no rewrite rules    | Ugly URLs; no server config      | Demos, prototypes             |
| `<StaticRouter>`  | N/A (non-interactive) | None; used on server       | Server-side rendering (SSR)                             | Read-only context; no navigation | Pre-rendering                 |

### Declarative Route Matching

React Router matches URL segments left-to-right and picks the “most specific” route. A path can include:

- Static segments: `/about`
- Dynamic segments: `/users/:id`
- Star segments: `/docs/*`

`<Routes>` wraps multiple `<Route>` elements, each specifying `path` and `element` props. Declarative matching keeps components decoupled from imperative URL parsing logic.

### Nested and Layout Routes

Routes can mirror component hierarchies. Parent routes render shared UI (navbars, sidebars) and inject descendant routes through `<Outlet>`. Nesting simplifies deeply hierarchical UIs such as dashboards or CMS editors.

### Special Routes

1. **Index Route**: `index` prop; renders when the parent path matches but none of the siblings do.
2. **Layout Route**: route without `path`; always matches and wraps children.
3. **“No Match” Route**: `path="*"`; catch-all for 404 pages.

### Navigation Strategies

- `<Link to="/profile">Profile</Link>` replaces `<a>` tags to prevent full reloads.
- `<NavLink>` adds an `"active"` class for styling the current tab.
- `useNavigate()` returns an imperative function to push or replace entries in history—ideal for redirects after form submissions.

### URL State Handling

- `useParams()` pulls dynamic segments (`/posts/:postId` → `postId`).
- `useSearchParams()` reads and mutates query strings (`?sort=date&filter=open`).
- `navigate('/checkout', {state: cartData})` pushes in-memory objects via `location.state`. `useLocation()` retrieves them.

### Router-Aware Architectural Patterns

- **Shell + Feature Routes**: wrap global chrome (header, sidebar) in a shell component and slot feature modules via nested routes.
- **Modal Routes**: star routes (`path="*"` inside `/photos/:id`) open overlays based on URL.
- **Auth-Guarded Routes**: context-aware wrappers that redirect unauthenticated users.

### React Router Code Examples

#### Example A (Beginner): Personal Blog

```jsx
// App.jsx
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  useParams,
  Navigate,
} from "react-router-dom"

function App() {
  return (
    <Router>
      <header>
        <nav>
          <Link to='/'>Home</Link>
          {" | "}
          <Link to='/about'>About</Link>
        </nav>
      </header>

      <Routes>
        <Route element={<Layout />}>
          <Route index element={<Home />} />
          <Route path='about' element={<About />} />
          {/* Dynamic route */}
          <Route path='posts/:slug' element={<Post />} />
          {/* 404 */}
          <Route path='*' element={<NoMatch />} />
        </Route>
      </Routes>
    </Router>
  )
}

function Layout() {
  return (
    <>
      <hr />
      <Outlet />
    </>
  )
}

function Home() {
  return <h2>Welcome to my blog!</h2>
}

function About() {
  return <p>All about me.</p>
}

function Post() {
  const { slug } = useParams()
  return <h3>Reading post: {slug}</h3>
}

function NoMatch() {
  return <Navigate to='/' replace />
}
export default App
```

#### Example B (Advanced): Nested Dashboard with Deep Links

```jsx
// DashboardApp.jsx
import {
  BrowserRouter,
  Routes,
  Route,
  Link,
  NavLink,
  Outlet,
  useParams,
  useSearchParams,
} from "react-router-dom"

function DashboardApp() {
  return (
    <BrowserRouter>
      <nav className='sidebar'>
        <NavLink to='overview'>Overview</NavLink>
        <NavLink to='reports'>Reports</NavLink>
        <NavLink to='settings'>Settings</NavLink>
      </nav>

      <Routes>
        <Route path='/' element={<DashboardLayout />}>
          <Route index element={<Welcome />} />
          <Route path='overview' element={<Overview />} />
          <Route path='reports/*' element={<ReportsRoutes />} />
          <Route path='settings/*' element={<SettingsRoutes />} />
          <Route path='*' element={<NoMatch />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

function DashboardLayout() {
  return (
    <main>
      <h1>Admin Dashboard</h1>
      <Outlet />
    </main>
  )
}

function Welcome() {
  return <p>Select a section on the left.</p>
}

function Overview() {
  return <h2>KPIs at a glance.</h2>
}

// Nested reports
function ReportsRoutes() {
  return (
    <Routes>
      <Route index element={<Monthly />} />
      <Route path=':year/:month' element={<Monthly />} />
    </Routes>
  )
}

function Monthly() {
  const { year, month } = useParams()
  const [params, setParams] = useSearchParams()
  const sort = params.get("sort") || "revenue"
  return (
    <>
      <h3>
        Report – {year ?? "Current Year"} / {month ?? "Current Month"}
      </h3>
      <p>Sorting by: {sort}</p>
      <button onClick={() => setParams({ sort: "profit" })}>
        Sort by profit
      </button>
    </>
  )
}

// Nested settings
function SettingsRoutes() {
  return (
    <Routes>
      <Route index element={<Account />} />
      <Route path='billing' element={<Billing />} />
    </Routes>
  )
}

function Account() {
  return <p>Account settings.</p>
}
function Billing() {
  return <p>Billing settings.</p>
}
function NoMatch() {
  return <h4>404 – Not Found</h4>
}

export default DashboardApp
```

## Fetch API Fundamentals

### Promises, `async/await`, and the Response Object

`fetch(url, options)` returns a Promise that resolves to a `Response`. Key fields:

- `ok` (Boolean): `true` for 200–299 codes.
- `status`, `statusText`: raw HTTP code and phrase.
- `headers`, `url`, `body`: metadata and stream.

### Error Handling Patterns

`fetch` rejects only on network failure, not on HTTP errors. Best practice:

```js
const res = await fetch("/api/items")
if (!res.ok) throw new Error(res.statusText) // catch 404, 500, etc.
const items = await res.json() // will reject if invalid JSON
```

### GET, POST, and Parallel Requests

```js
// POST JSON
await fetch("/api/tasks", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ title: "Buy milk" }),
})

// Parallel GETs
const [profile, posts] = await Promise.all([
  fetch("/api/profile").then((r) => r.json()),
  fetch("/api/posts").then((r) => r.json()),
])
```

### When to Reach for Axios

Axios polyfills older browsers, ships built-in timeouts, and auto-parses JSON. Fetch remains the default unless you need those extras.

### Fetch API Code Examples

#### Example C (Beginner): To-Do CRUD

```jsx
// TodoList.jsx
import { useEffect, useState } from 'react';

export default function TodoList() {
  const [todos, setTodos] = useState([]);
  const [text, setText] = useState('');

  // Load once
  useEffect(() => { loadTodos(); }, []);

  async function loadTodos() {
    try {
      const res = await fetch('/api/todos');
      if (!res.ok) throw new Error('Load failed');
      setTodos(await res.json());
    } catch (err) { console.error(err); }
  }

  async function addTodo() {
    const res = await fetch('/api/todos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text })
    });
    if (res.ok) {
      setTodos(prev => [...prev, await res.json()]);
      setText('');
    }
  }

  return (
    <>
      <h3>Things to do</h3>
      <input value={text} onChange={e => setText(e.target.value)} />
      <button onClick={addTodo}>Add</button>
      <ul>{todos.map(t => <li key={t.id}>{t.text}</li>)}</ul>
    </>
  );
}
```

#### Example D (Advanced): Parallel Weather Dashboard (≈120 lines)

```jsx
// WeatherDashboard.jsx
import { useEffect, useState } from "react"

const CITIES = ["Paris", "Rome", "Tokyo"]

export default function WeatherDashboard() {
  const [reports, setReports] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchWeather()
  }, [])

  async function fetchWeather() {
    try {
      const start = performance.now()
      const promises = CITIES.map((city) =>
        fetch(`https://api.example.com/weather?q=${city}`).then((r) =>
          r.ok ? r.json() : Promise.reject(r.statusText)
        )
      )
      const results = await Promise.all(promises)
      setReports(results)
      console.log(`Fetched in ${performance.now() - start} ms`)
    } catch (err) {
      console.error("Some call failed:", err)
    } finally {
      setLoading(false)
    }
  }

  if (loading) return <p>Loading…</p>

  return (
    <section>
      <h2>Live Weather</h2>
      {reports.map((rep) => (
        <article key={rep.city}>
          <h3>{rep.city}</h3>
          <p>
            {rep.temp} °C, {rep.description}
          </p>
        </article>
      ))}
    </section>
  )
}
```

## Context API Core Concepts

### Context Three Ingredients

| Ingredient     | Purpose                          | Declared Via                                | Scope Rules                  |
| :------------- | :------------------------------- | :------------------------------------------ | :--------------------------- |
| Context Object | Keys future Provider \& Consumer | `React.createContext(default)`              | One per logical global value |
| Provider       | Injects value into subtree       | `<MyCtx.Provider value={…}>`                | Closest provider wins        |
| Consumer       | Reads the current value          | `<MyCtx.Consumer>` _or_ `useContext(MyCtx)` | Must be inside provider      |

### `useContext` Hook vs. `<Context.Consumer>`

| Aspect         | `useContext`                            | Consumer Component                     |
| :------------- | :-------------------------------------- | :------------------------------------- |
| Syntax         | Call inside function component          | JSX wrapper around child render-prop   |
| Readability    | Flat, direct                            | Deeply nested Consumers become verbose |
| Static Context | Not supported (no new context creation) | Same limitation                        |

### Multiple Contexts and Performance

`useContext` can be called multiple times per component. Each Provider update triggers re-render of its consumers. Memoization (`React.memo`, `useMemo`) prevents excessive re-calculations.

### Anti-Patterns and Refactoring Signals

- **“Context everything”** dilutes component portability.
- If two components only share state via a common ancestor, prefer prop-lifting.
- When Context drives frequent updates (e.g., cursor position), co-locate state further down the tree.

### Context API Code Examples

#### Example E (Beginner): Theme Switcher

```jsx
// ThemeContext.js
import { createContext } from "react"
export const ThemeCtx = createContext("light")

// App.jsx
import { ThemeCtx } from "./ThemeContext"
import { useState, useContext } from "react"

export default function App() {
  const [theme, setTheme] = useState("light")
  return (
    <ThemeCtx.Provider value={{ theme, toggle }}>
      <Toolbar />
    </ThemeCtx.Provider>
  )

  function toggle() {
    setTheme((t) => (t === "light" ? "dark" : "light"))
  }
}

function Toolbar() {
  return (
    <div>
      <ThemeButton />
      <Paragraph />
    </div>
  )
}

function ThemeButton() {
  const { toggle } = useContext(ThemeCtx)
  return <button onClick={toggle}>Switch theme</button>
}

function Paragraph() {
  const { theme } = useContext(ThemeCtx)
  return (
    <p style={{ background: theme === "dark" ? "#222" : "#eee" }}>
      Current theme: {theme}
    </p>
  )
}
```

#### Example F (Advanced): Auth-Aware API Wrapper

```jsx
// AuthContext.js
import { createContext, useState, useEffect } from "react"

export const AuthCtx = createContext()

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)

  useEffect(() => {
    // Auto-login on refresh
    fetch("/api/session")
      .then((r) => (r.ok ? r.json() : null))
      .then(setUser)
      .catch(() => setUser(null))
  }, [])

  async function login(credentials) {
    const res = await fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(credentials),
    })
    if (!res.ok) throw new Error("Bad creds")
    setUser(await res.json())
  }

  function logout() {
    fetch("/api/logout", { method: "POST" }).finally(() => setUser(null))
  }

  return (
    <AuthCtx.Provider value={{ user, login, logout }}>
      {children}
    </AuthCtx.Provider>
  )
}

// useApi.js
import { useContext } from "react"
import { AuthCtx } from "./AuthContext"

export function useApi() {
  const { user } = useContext(AuthCtx)

  return async function request(path, options = {}) {
    const res = await fetch(path, {
      ...options,
      headers: {
        ...options.headers,
        Authorization: user ? `Bearer ${user.token}` : undefined,
      },
    })
    if (!res.ok) throw new Error(res.statusText)
    return res.json()
  }
}

// Usage in a component
import { useApi } from "./useApi"

export function Orders() {
  const api = useApi()
  const [orders, setOrders] = useState([])

  useEffect(() => {
    api("/api/orders").then(setOrders).catch(console.error)
  }, [api])

  return (
    <ul>
      {orders.map((o) => (
        <li key={o.id}>{o.item}</li>
      ))}
    </ul>
  )
}
```

## Integrating All Three in Production

### Global App Shell Pattern

Wrap the app once:

```jsx
<BrowserRouter>
  <AuthProvider>
    <ThemeProvider>
      <AppShell /> {/* nav + <Outlet /> */}
    </ThemeProvider>
  </AuthProvider>
</BrowserRouter>
```

Now:

- Routes decide **where** to render pages.
- Context supplies **who/what** renders them.
- Components fetch **when** they need data.

### Route-Based Data Fetching with Context

- Store auth/session in context.
- Create route loaders (React Router ≥ 6.4) that call APIs with that auth token.
- Co-locate `useEffect` data hooks inside pages for incremental fetching.

### Handling Race Conditions and Cleanup

Always accompany `fetch` in `useEffect` with an `AbortController` to cancel stale requests when navigating away.

```jsx
useEffect(() => {
  const ctrl = new AbortController()
  fetch("/api/items", { signal: ctrl.signal })
    .then((r) => r.ok && r.json())
    .then(setItems)
    .catch((err) => {
      if (err.name !== "AbortError") console.error(err)
    })
  return () => ctrl.abort()
}, [locationKey])
```

## Asked Questions

1. **Does Context replace Redux?**
   Context removes prop-drilling but offers no built-in reducers, middleware, or time-travel debugging. Redux or Zustand sit on top when you need sophisticated state orchestration.
2. **Can I preload data before navigation?**
   Use route loaders (React Router ≥ 6.4) or wrap `navigate` calls in async functions that await data before redirect.
3. **How big can JSON bodies be in fetch?**
   `fetch` streams bodies as `ReadableStream`; large file uploads/downloads are handled efficiently, but browsers may impose memory constraints.

## Glossary

| Term                | Definition                                                                                  |
| :------------------ | :------------------------------------------------------------------------------------------ |
| **SPA**             | Single-page application; client receives one HTML shell and navigates without full reloads. |
| **Deep Linking**    | Directly navigating to an internal view via URL parameters.                                 |
| **Prop Drilling**   | Passing props through intermediate components that don’t care about them.                   |
| **ReadableStream**  | Web API interface for chunked data; underlying basis for `response.body`.                   |
| **AbortController** | Web API for canceling ongoing fetch requests.                                               |

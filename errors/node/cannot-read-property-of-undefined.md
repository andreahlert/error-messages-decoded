# TypeError: Cannot read properties of undefined

> TypeError: Cannot read properties of undefined (reading 'map')
>     at UserList (/home/user/project/src/components/UserList.jsx:12:24)
>     at renderWithHooks (node_modules/react-dom/cjs/react-dom.development.js:14985:18)

## What happened

You accessed a property or called a method on something that is `undefined`. You expected an object or array to be there, but it wasn't at the time the code ran.

## Why it happens

The variable you're accessing hasn't been assigned yet, was assigned asynchronously and the code ran before the assignment completed, or the data shape doesn't match what you assumed. The most common triggers: API response hasn't arrived yet, optional chaining was missed on nested objects, or a function returned `undefined` instead of the expected value.

## How to fix it

Read the stack trace. The error tells you exactly which property it tried to read. Work backwards from there.

```javascript
// Problem: data is undefined on first render
const users = data.users.map(u => u.name);

// Fix 1: Optional chaining + nullish coalescing
const users = data?.users?.map(u => u.name) ?? [];

// Fix 2: Guard clause (better for components)
if (!data || !data.users) return <Loading />;
const users = data.users.map(u => u.name);

// Fix 3: Default values at destructuring
const { users = [] } = data || {};
```

For async data (React, API calls):

```javascript
// Problem: useState initializes before fetch completes
const [data, setData] = useState();  // undefined!
return <div>{data.title}</div>;      // BOOM

// Fix: initialize with a safe default
const [data, setData] = useState({ title: '', users: [] });
```

## Don't do this

**Don't scatter `|| {}` everywhere without understanding why the value is undefined.** You're hiding a bug, not fixing it. If an API should always return users, figure out why it's not.

**Don't wrap everything in try/catch.** The error is telling you about a logic flaw. Catching it silently makes debugging harder later.

## Still not working?

If the error is deep in a library, check the data you're passing in:

```javascript
// Add a console.log RIGHT before the failing line
console.log('data:', JSON.stringify(data, null, 2));
```

Common traps with destructuring:

```javascript
// This silently sets user to undefined if response has no data key
const { data: { user } } = await axios.get('/api/user');

// Safer:
const response = await axios.get('/api/user');
const user = response.data?.user;
```

In Node.js with environment variables:

```javascript
// process.env.PORT is a string or undefined, never a number
const config = JSON.parse(process.env.CONFIG);  // crashes if CONFIG not set

// Fix
const config = JSON.parse(process.env.CONFIG || '{}');
```

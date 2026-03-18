# TypeError: Cannot read properties of undefined (reading 'map')

> TypeError: Cannot read properties of undefined (reading 'map')
> TypeError: Cannot read properties of null (reading 'map')

## What happened

You called `.map()` on something that's `undefined` or `null`. This usually means your data hasn't loaded yet, or the API response has a different shape than you expected.

## Why it happens

- State initialized as `undefined` or `null`, and the component renders before data arrives
- API response nested differently than expected (`response.data.items` vs `response.items`)
- A prop wasn't passed to the component
- Destructuring from an undefined parent object

## How to fix it

**Initialize state as an empty array:**

```jsx
// WRONG
const [items, setItems] = useState();

// RIGHT
const [items, setItems] = useState([]);
```

**Guard before mapping:**

```jsx
// Option 1: optional chaining
{items?.map(item => <li key={item.id}>{item.name}</li>)}

// Option 2: default value with nullish coalescing
{(items ?? []).map(item => <li key={item.id}>{item.name}</li>)}

// Option 3: early return
if (!items) return <LoadingSpinner />;
return <ul>{items.map(item => <li key={item.id}>{item.name}</li>)}</ul>;
```

**Check your API response shape:**

```jsx
// Your API might return { data: { results: [...] } }
// but you're accessing response.data directly
useEffect(() => {
  fetch('/api/items')
    .then(r => r.json())
    .then(json => {
      console.log(json); // check the actual shape
      setItems(json.data.results); // not json.data
    });
}, []);
```

## Don't do this

- Don't wrap the entire component in a try/catch. Handle the loading/empty state properly.
- Don't use `Array.from()` on undefined. It creates an empty array but hides the real problem: your data isn't arriving.

## Still not working?

- Add a `console.log` right before the `.map()` call to see what the variable actually is.
- If using TypeScript, the type might say `Item[]` but the runtime value is `undefined`. Check where the data is assigned.
- If the data comes from context or Redux, make sure the provider is wrapping this component.

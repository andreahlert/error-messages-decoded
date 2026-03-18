# React key prop warning persists despite adding keys

> Warning: Each child in a list should have a unique 'key' prop.

## What happened
React warns about missing or unstable keys in a list even though you think keys are set, because the keys are either not unique, using array index in a dynamic list, or placed on the wrong element.

## Why it happens
Using array index as key causes issues when items are reordered, added, or removed, because React uses keys to track which items changed. If items can change order, index-based keys cause incorrect remounts and stale state. The warning also appears if keys are duplicated or if the key is on a wrapping Fragment instead of the list item.

## How to fix it
```jsx
// Use a stable, unique identifier as the key
{items.map((item) => (
  <ListItem key={item.id} data={item} />
))}

// If no unique id exists, create one from stable data
{items.map((item) => (
  <ListItem key={`${item.name}-${item.email}`} data={item} />
))}

// When using Fragment, put key on Fragment, not the child
{items.map((item) => (
  <React.Fragment key={item.id}>
    <dt>{item.term}</dt>
    <dd>{item.definition}</dd>
  </React.Fragment>
))}
```

## Still not working?
Check for duplicate `id` values in your data. If you must use index as key, it's only safe when the list is static and never reordered. Also verify the key is on the outermost element returned from `map`, not on a nested child.

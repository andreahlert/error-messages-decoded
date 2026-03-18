# Each child in a list should have a unique "key" prop

> Warning: Each child in a list should have a unique "key" prop.
> Check the render method of `ComponentName`.

## What happened

You rendered a list of elements (via `.map()`) without giving each element a unique `key` prop. React uses keys to track which items changed, were added, or removed.

## Why it happens

React needs keys to efficiently update the DOM when a list changes. Without keys (or with duplicate/unstable keys), React can't tell which items moved and may re-render the wrong components or lose their state.

## How to fix it

**Use a stable unique identifier from your data:**

```jsx
// RIGHT: use a unique id from the data
{users.map(user => (
  <UserCard key={user.id} user={user} />
))}
```

**If your data doesn't have IDs:**

```jsx
// Acceptable if the list is static and never reordered
{items.map((item, index) => (
  <li key={index}>{item.name}</li>
))}
```

**If rendering fragments:**

```jsx
// Use React.Fragment with explicit key
{items.map(item => (
  <React.Fragment key={item.id}>
    <dt>{item.term}</dt>
    <dd>{item.description}</dd>
  </React.Fragment>
))}
```

## Don't do this

- Don't use `Math.random()` or `Date.now()` as keys. This creates a new key every render, destroying and recreating every item. It's worse than no key at all.
- Don't use array index as key if the list can be reordered, filtered, or items can be added/removed in the middle. You'll get subtle state bugs where the wrong component holds the wrong data.
- Don't put the key on the inner element. It goes on the outermost element returned by `.map()`.

## Still not working?

- If keys are unique but you still see the warning, check if you're rendering the list in multiple places.
- Duplicate keys in the same list also trigger this. Check if your data has duplicate IDs.
- Nested lists each need their own keys. A key only needs to be unique among its siblings.

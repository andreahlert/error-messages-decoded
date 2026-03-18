# No overload matches this call

> No overload matches this call.
>   Overload 1 of 3, '(type: string, listener: EventListenerOrEventListenerObject, options?: boolean | AddEventListenerOptions | undefined): void', gave the following error.
>     Argument of type 'xxx' is not assignable to parameter of type 'yyy'.

## What happened

You called a function that has multiple type signatures (overloads), and your arguments don't match any of them. TypeScript tried every overload and they all failed.

## Why it happens

The function accepts different combinations of parameters, and the types you passed don't match any valid combination. This is common with:

- DOM event listeners (`addEventListener`)
- React's `useState`, `useRef`
- Library functions with multiple signatures (like Express route handlers)

## How to fix it

**Read the overload signatures.** The error lists each overload and why it failed. The last overload in the list is usually the most permissive one, so focus on that.

**Common example with event listeners:**

```typescript
// Wrong
document.addEventListener('click', (e: MouseEvent) => {
  // TS might complain depending on how the callback is typed
});

// Right: let TS infer the event type
document.addEventListener('click', (e) => {
  // e is automatically MouseEvent
});
```

**Common example with useState:**

```typescript
// Wrong: TS infers never[] and then you can't push objects
const [items, setItems] = useState([]);

// Right: provide the generic type
const [items, setItems] = useState<Item[]>([]);
```

**Common example with useRef:**

```typescript
// Wrong
const ref = useRef(null);
ref.current.focus(); // error

// Right
const ref = useRef<HTMLInputElement>(null);
```

## Don't do this

- Don't just cast arguments to `any`. The overloads exist to catch real bugs.
- Don't ignore the detailed error messages under each overload. They tell you exactly which parameter is wrong.

## Still not working?

- Check if you're using an outdated `@types` package. Type overloads change between versions.
- Try hovering over the function in your IDE to see all available overloads.
- If writing your own overloads, make sure the implementation signature is compatible with all overload signatures.

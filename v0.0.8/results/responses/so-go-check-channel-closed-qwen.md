The error you're encountering suggests that there's an issue with checking whether a Go channel has been closed without reading from it, which can lead to undefined behavior or panics in your program. This problem arises because channels are designed to be read-only by default, and attempting to write to them (even if they are closed) will result in a panic.

### Root Cause:
The root cause of this issue is that Go channels are not meant for concurrent writes. When you attempt to write to a channel that has been closed, the program panics because it's trying to modify an immutable state (the channel). This behavior is intended to prevent race conditions and ensure thread safety in concurrent programming.

### How to Fix It:
To check if a Go channel is closed without consuming values from it, you can use one of several approaches:

1. **Wait for the Channel to Close:**
   You can wait until the channel closes by using `select` or `sync.WaitGroup`. This approach ensures that your program waits for the channel to be closed before proceeding.

2. **Use a Wait Group:**
   A common pattern is to use a `sync.WaitGroup` and wait on it in a goroutine that reads from the channel. When the read operation completes, you can then check if the channel has been closed.

3. **Check for Closed Channels Explicitly:**
   You can explicitly check if the channel is closed before attempting any operations on it. This involves using `channel.IsClosed()` or checking the return value of a function that reads from the channel (like `select`).

Here's an example demonstrating how to use a Wait Group and wait for the channel to close:

```go
package main

import (
	"fmt"
	"sync"
)

func readFromChannel(ch <-chan int, wg *sync.WaitGroup) {
	defer wg.Done()
	for i := range ch {
		fmt.Println(i)
	}
}

func checkIfClosed(ch <-chan int) bool {
	var closed bool
	select {
	case <-ch:
		closed = true
	default:
		closed = false
	}
	return closed
}

func main() {
	ch := make(chan int, 10)

	wg := new(sync.WaitGroup)
	wg.Add(2)

	go readFromChannel(ch, wg)
	go checkIfClosed(ch, wg)

	wg.Wait()
}
```

### Explanation:
- **`readFromChannel`:** This function reads from the channel and prints each value.
- **`checkIfClosed`:** This function checks if the channel is closed by waiting for a value to be read or not. If it receives a value, it means the channel was closed; otherwise, it's still open.

### Conclusion:
Using `sync.WaitGroup` combined with `select` allows you to safely check if a channel has been closed without consuming its values. This approach ensures that your program behaves correctly and avoids panics due to attempting to modify an immutable state.

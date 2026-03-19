The "OOMKilled" error in Kubernetes indicates that a container within a pod has run out of memory resources, leading to the process being terminated due to insufficient available memory. This can be caused by several factors:

### Root Cause Analysis

1. **Container Memory Usage**: The primary cause is usually excessive memory usage by one or more containers within the pod.
2. **Pod Resource Limits**: If the pod has resource limits set (e.g., CPU, memory), but these are not being respected, it can lead to OOMKilled errors.
3. **Resource Allocation**: Incorrect allocation of resources between pods and their containers might also contribute to this issue.

### Steps to Fix

#### 1. Identify the Container with High Memory Usage
   - Use `kubectl top pod` or `kubectl describe pod <pod-name>` to get a list of running containers in the pod.
   - Look for the container that is consuming the most memory.

#### 2. Inspect Pod Resource Limits
   - Check the resource limits set on the pod using:
     ```bash
     kubectl describe pod <pod-name>
     ```
   - Ensure that these limits are respected by the containers running within the pod.

#### 3. Adjust Container Memory Usage
   - If a container is consuming too much memory, you can try to reduce its resource usage or increase the available resources.
   - For example:
     ```bash
     kubectl exec <container-name> -- /bin/sh -c "echo $(( $(free -m | grep Mem | awk '{print $3}') * 1024) >> /var/log/memory_usage.txt"
     ```
   - This command logs the current memory usage of a container to a file, which can help you understand where the excessive memory is being used.

#### 4. Increase Pod Resource Limits
   - If the pod's resource limits are too low, consider increasing them:
     ```bash
     kubectl update pod <pod-name> --replace=<old-limits> --add=limits:<new-limits>
     ```
   - Replace `<old-limits>` with the current limits and `<new-limits>` with the desired new limits.

#### 5. Check for Resource Overcommitment
   - Ensure that there is no resource overcommitment in your cluster:
     ```bash
     kubectl describe node <node-name>
     ```
   - If you find that a node has more available resources than it can actually use, consider adjusting the node's configuration or increasing its capacity.

#### 6. Monitor and Adjust Continuously
   - After making changes, monitor the pod again to ensure that the issue is resolved:
     ```bash
     kubectl top pod <pod-name>
     ```

### Example Scenario

Suppose you have a pod with two containers, `container1` and `container2`, where `container1` is consuming too much memory. You can follow these steps:

1. Identify `container1` using:
   ```bash
   kubectl top pod <pod-name>
   ```
2. Inspect the resource limits on the pod:
   ```bash
   kubectl describe pod <pod-name>
   ```
3. Reduce the memory usage of `container1` if possible, or increase its resources.
4. Increase the pod's overall resource limits to ensure that it can handle more containers without OOMKilled errors.

By following these steps, you should be able to identify and fix the root cause of the "OOMKilled" error in your Kubernetes pods.

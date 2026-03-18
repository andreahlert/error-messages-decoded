The "OOMKilled" error in Kubernetes indicates that a container within a pod has run out of memory resources, leading to its termination due to insufficient available memory. This can be caused by several factors:

### Root Cause Analysis

1. **Container Memory Usage**: The primary reason for OOMKilled is excessive memory usage by the containers running inside the pod.
2. **Pod Resource Limits**: If the pod has resource limits set (e.g., CPU, memory), but these are not being respected or exceeded, it can lead to OOMKilled.
3. **Container Crash Looping**: A container that crashes repeatedly due to insufficient resources is also a common cause of OOMKilled.
4. **Pod Resource Requests vs. Limits**: If the pod requests more resources than what is available in the cluster, Kubernetes will eventually kill the pods when they run out of resources.

### Steps to Fix

1. **Identify the Container with High Memory Usage**:
   - Use `kubectl top` or `kubectl describe pod <pod-name>` to get a detailed view of each container's memory usage.
   - Look for containers that are consistently using more memory than expected, especially if they have high CPU utilization as well.

2. **Check Resource Requests and Limits**:
   - Ensure that the resource requests (e.g., `memory` in bytes) match or exceed the limits set by the pod (`resources.limits.memory`).
   - Verify that there are no misconfigurations where resources are being requested but not respected, such as incorrect labels or annotations.

3. **Adjust Resource Requests and Limits**:
   - If necessary, adjust the resource requests and limits in your deployment configuration to better match the actual needs of the containers.
   - For example, if a container is using more memory than expected, consider reducing its request or increasing its limit.

4. **Monitor and Inspect Containers**:
   - Use `kubectl exec` with `-i -t` (interactive) to inspect the running containers in your pod.
   - Check for any errors or logs that might indicate why the container is consuming excessive memory.

5. **Scale Resources Up**:
   - If you find that resources are being underutilized, consider scaling up the resource requests and limits to better match the actual needs of the pods.

6. **Review Pod Annotations and Labels**:
   - Ensure there are no annotations or labels that might be causing misconfiguration.
   - For example, if a pod is labeled with `node.kubernetes.io/not-ready`, it could prevent containers from being scheduled on nodes where they can run without issues.

7. **Check for Misconfigured Services or Deployments**:
   - If the issue persists, check your services and deployments to ensure that they are not causing resource leaks.
   - For example, if a service is constantly restarting due to misconfiguration, it might be consuming more resources than expected.

8. **Review Pod Logs**:
   - Check the pod logs for any errors or warnings related to memory usage.
   - Look for patterns in how containers are using memory and CPU that could indicate potential issues.

### Example Commands

- To check resource requests and limits:
  ```bash
  kubectl describe pod <pod-name>
  ```

- To inspect a container's memory usage:
  ```bash
  kubectl exec -i -t <container-name> -- /bin/sh
  ```

By following these steps, you should be able to identify the root cause of the OOMKilled error and take appropriate actions to fix it.

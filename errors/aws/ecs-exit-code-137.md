# ECS container exit code 137 (OOM killed)

> Essential container in task exited, exit code: 137

## What happened
An ECS task was terminated because a container exceeded its memory hard limit. Exit code 137 means the process received SIGKILL (128 + 9), which is what happens when the Linux OOM killer terminates a process.

## Why it happens
The container used more memory than the hard limit defined in the task definition. ECS enforces the `memory` (hard limit) setting at the container level. When a container's RSS exceeds this limit, the kernel's OOM killer sends SIGKILL. This is common with memory-leaking applications, JVM services with heap misconfiguration, or workloads with variable memory usage.

## How to fix it

Check and increase the container memory in the task definition:
```json
{
  "containerDefinitions": [
    {
      "name": "app",
      "memory": 1024,
      "memoryReservation": 512,
      "essential": true
    }
  ]
}
```

Using the AWS CLI:
```bash
# Check current task definition
aws ecs describe-task-definition --task-definition my-task:latest \
  --query 'taskDefinition.containerDefinitions[*].{name:name,memory:memory,memoryReservation:memoryReservation}'

# Register updated task definition with more memory
aws ecs register-task-definition \
  --family my-task \
  --container-definitions '[{"name":"app","image":"my-image","memory":2048,"memoryReservation":1024,"essential":true}]'
```

Key settings:
- `memory` (hard limit): container is killed if it exceeds this
- `memoryReservation` (soft limit): memory reserved for scheduling, can burst above this

## Still not working?
- Check if your application has a memory leak: monitor container memory over time with CloudWatch Container Insights.
- For JVM apps, set `-Xmx` to about 75% of the container memory limit to leave room for off-heap memory.
- If running multiple containers in one task, the sum of all containers' memory must fit within the task-level memory.
- Use `aws ecs describe-tasks --tasks <task-id>` with `stoppedReason` to confirm it was an OOM kill.

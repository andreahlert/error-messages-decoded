# containerd/runc cgroup v2 mismatch

> failed to create containerd task: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process

## What happened
Container creation fails because the container runtime (runc/containerd) is incompatible with the host's cgroup configuration.

## Why it happens
The host OS uses cgroup v2 (unified hierarchy) but the container runtime (runc) or kubelet is configured for cgroup v1 (legacy hierarchy). Newer Linux distributions (Ubuntu 22.04+, Fedora 31+) default to cgroup v2. Older versions of runc, containerd, or Docker do not support cgroup v2.

## How to fix it
```bash
# Check which cgroup version the host uses
stat -fc %T /sys/fs/cgroup/
# "cgroup2fs" = v2, "tmpfs" = v1

# Update runc to a version that supports cgroup v2
sudo apt install runc  # or download from github.com/opencontainers/runc

# For Kubernetes, ensure kubelet uses the systemd cgroup driver
# /var/lib/kubelet/config.yaml
# cgroupDriver: systemd

# For containerd, set SystemdCgroup = true
# /etc/containerd/config.toml
# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#   SystemdCgroup = true

sudo systemctl restart containerd
sudo systemctl restart kubelet
```

## Still not working?
Ensure runc version is 1.1.0+ for full cgroup v2 support. If running Kubernetes, both kubelet and the container runtime must use the same cgroup driver (both `systemd` or both `cgroupfs`). Check kernel version is 5.2+ for cgroup v2 features. To temporarily revert to cgroup v1, add `systemd.unified_cgroup_hierarchy=0` to kernel boot parameters.

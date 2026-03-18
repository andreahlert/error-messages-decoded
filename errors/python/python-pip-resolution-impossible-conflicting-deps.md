# pip resolution impossible due to conflicting dependencies

> ERROR: Cannot install package-a==2.0 and package-b==3.1 because these package versions have conflicting dependencies.

## What happened
pip cannot find a set of package versions that satisfies all dependency constraints simultaneously.

## Why it happens
Two or more packages in your requirements require incompatible versions of a shared dependency. For example, `package-a==2.0` requires `shared-lib>=3.0` while `package-b==3.1` requires `shared-lib<3.0`. pip's resolver cannot satisfy both constraints.

## How to fix it

Use `pip-compile` from `pip-tools` to find a compatible resolution:
```bash
pip install pip-tools

# Create a requirements.in with your direct dependencies
echo "package-a
package-b" > requirements.in

# Let pip-compile find compatible versions
pip-compile requirements.in --output-file=requirements.txt
pip install -r requirements.txt
```

Check which versions are compatible:
```bash
pip index versions package-a
pip index versions package-b
```

Use a constraint file to pin the shared dependency:
```bash
# constraints.txt
shared-lib==2.9

pip install -c constraints.txt package-a package-b
```

If one package is flexible, allow pip to find a compatible older version:
```bash
# Instead of pinning both, pin only the critical one
pip install package-a==2.0 package-b
```

## Still not working?
- Use `pipdeptree` to visualize the full dependency tree: `pip install pipdeptree && pipdeptree --warn fail`.
- Check if either package has a newer release that relaxes the constraint: `pip install --upgrade package-a package-b`.
- As a last resort, use `--override` (pip 23.1+) or install in separate virtual environments and use one as a subprocess.

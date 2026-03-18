# Cycle in security group references

> Error: Cycle: aws_security_group.app, aws_security_group_rule.app_to_db, aws_security_group.db, aws_security_group_rule.db_to_app, aws_security_group.app

## What happened

Terraform detected a circular dependency between your security groups. It cannot determine which resource to create first because each one references the other.

## Why it happens

When two security groups reference each other using inline `ingress` or `egress` blocks, Terraform sees a cycle. Security group A needs B's ID in its ingress rule, and B needs A's ID in its ingress rule. Neither can be created first.

```hcl
# This creates a cycle
resource "aws_security_group" "app" {
  ingress {
    security_groups = [aws_security_group.db.id]  # needs db first
  }
}

resource "aws_security_group" "db" {
  ingress {
    security_groups = [aws_security_group.app.id]  # needs app first
  }
}
```

Terraform builds a dependency graph before applying, and cycles make that graph impossible to resolve.

## How to fix it

Use separate `aws_security_group_rule` resources instead of inline blocks. Create the security groups first (with no rules), then add rules that reference them:

```hcl
# Step 1: Create security groups with no inline rules
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "App tier security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Database tier security group"
  vpc_id      = var.vpc_id
}

# Step 2: Add rules as separate resources
resource "aws_security_group_rule" "app_to_db" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "db_from_app" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.app.id
}
```

This works because Terraform can now create both security groups first (no cross-references), then create the rules that link them.

Verify the cycle is resolved:

```bash
terraform validate
terraform plan
```

## Don't do this

- Don't use `depends_on` to break cycles. It doesn't actually resolve the circular reference, it just forces an ordering that may cause apply failures or silent misconfigurations.
- Don't mix inline rules and separate `aws_security_group_rule` resources for the same security group. Terraform will fight with itself and randomly remove rules on each apply.
- Don't use `aws_security_group` with `revoke_rules_on_delete = true` and then reference it circularly. Deletion will also cycle.

## Still not working?

If you have complex multi-tier architectures, visualize the dependency graph:

```bash
terraform graph | dot -Tpng > graph.png
```

For existing infrastructure with inline rules that you need to migrate:

```bash
# Import the existing rules as separate resources
terraform import aws_security_group_rule.db_from_app sg-abc123_ingress_tcp_5432_5432_sg-def456

# Then remove the inline blocks from your aws_security_group resources
# Run plan to verify no changes
terraform plan
```

If you're using Terraform modules that create security groups, pass the security group IDs as outputs from one module and inputs to another, rather than having modules reference each other.

# Root Cause

When Jackson serializes a JPA entity with a bidirectional relationship, it follows both directions infinitely:

```
Entity A → Entity B (serializes all fields)
  ↓
  Entity B has a reference back to Entity A
  ↓
  Entity A → Entity B (again)
  ↓
  Stack overflow after N iterations
```

The problem occurs because Jackson sees the full object graph and tries to serialize everything, creating a cycle with no exit point.

---

# Solutions (Ranked by Best Practice)

## 1. **@JsonIgnore on the "back-reference" side** (Most Common)

Mark the inverse side of the relationship to prevent serialization:

```java
// Parent.java
@Entity
public class Parent {
    @Id
    private Long id;
    
    @OneToMany(mappedBy = "parent")
    private List<Child> children;
    // getters/setters
}

// Child.java
@Entity
public class Child {
    @Id
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "parent_id")
    @JsonIgnore  // ← Prevents serialization of parent reference
    private Parent parent;
    
    // getters/setters
}
```

When you serialize `Parent`, it will serialize `children` but each `Child` won't try to serialize its `parent` back.

---

## 2. **@JsonBackReference / @JsonManagedReference** (Cleaner Approach)

Uses Jackson's built-in handling for bidirectional relationships:

```java
// Parent.java
@Entity
public class Parent {
    @Id
    private Long id;
    
    @OneToMany(mappedBy = "parent")
    @JsonManagedReference  // ← Parent side of the relationship
    private List<Child> children;
}

// Child.java
@Entity
public class Child {
    @Id
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "parent_id")
    @JsonBackReference  // ← Child side - references back to parent
    private Parent parent;
}
```

Jackson automatically knows not to serialize the back-reference, avoiding the cycle.

---

## 3. **DTOs (Data Transfer Objects)** (Best for APIs)

Don't serialize entities directly. Use dedicated DTOs for API responses:

```java
// ParentDTO.java (for API responses)
public class ParentDTO {
    private Long id;
    private List<ChildDTO> children;
    
    // Only includes what you need, no circular refs
}

// ChildDTO.java
public class ChildDTO {
    private Long id;
    private String name;
    // No parent reference at all
}
```

This is the most maintainable approach for REST APIs because it decouples your domain model from serialization concerns.

---

## 4. **@JsonIdentityInfo** (For Complex Scenarios)

If you need both directions serialized, use object identity:

```java
@Entity
@JsonIdentityInfo(
    generator = ObjectIdGenerators.PropertyGenerator.class,
    property = "id"
)
public class Parent {
    @Id
    private Long id;
    
    @OneToMany(mappedBy = "parent")
    private List<Child> children;
}

@Entity
@JsonIdentityInfo(
    generator = ObjectIdGenerators.PropertyGenerator.class,
    property = "id"
)
public class Child {
    @Id
    private Long id;
    
    @ManyToOne
    private Parent parent;
}
```

Jackson will serialize the full object first, then only include the `id` for subsequent references. This prevents infinite recursion while keeping the relationship data.

---

# Quick Decision Matrix

| Scenario | Solution |
|----------|----------|
| Simple parent-child, only need parent side serialized | `@JsonIgnore` |
| Both sides needed, want clean code | `@JsonBackReference` / `@JsonManagedReference` |
| Building a REST API | **Use DTOs** (recommended) |
| Need full graph with both directions | `@JsonIdentityInfo` |

**For most cases, start with `@JsonBackReference` / `@JsonManagedReference` or use DTOs.** DTOs are strongly preferred in production APIs because they give you explicit control over what gets exposed.

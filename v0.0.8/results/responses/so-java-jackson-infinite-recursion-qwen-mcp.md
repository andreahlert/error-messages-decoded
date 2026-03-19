The error "Infinite recursion" typically occurs when you are trying to serialize a complex object graph that includes circular references, such as those involving bidirectional relationships in your entities. This can lead to an infinite loop of serialization attempts.

### Root Cause:
1. **Circular References**: The entity has properties that reference other instances of the same class or related classes.
2. **Bidirectional Relationships**: Entities have fields pointing back to each other (e.g., `@ManyToOne` with `@JoinColumn`).
3. **Jackson Configuration**: Jackson's default behavior for handling circular references is not always optimal, leading to infinite recursion.

### Steps to Fix:

#### 1. Use `@JsonIgnoreProperties`
If you know which properties are causing the issue and they should be ignored during serialization, use `@JsonIgnoreProperties` on those fields in your entity classes.

```java
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonIgnoreProperties(value = {"related_entity"}, ignoreUnknown = true)
    private RelatedEntity relatedEntity;

    // Getters and setters...
}
```

#### 2. Use `@JsonManagedReference` and `@JsonBackReference`
If you want to control the direction of the relationship, use `@JsonManagedReference` for the owning side (the one that references the other entity) and `@JsonBackReference` for the referenced side.

```java
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonManagedReference
    private RelatedEntity relatedEntity;

    // Getters and setters...
}

@Entity
public class RelatedEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "your_entity_id")
    @JsonBackReference
    private YourEntity yourEntity;

    // Getters and setters...
}
```

#### 3. Use `@JsonIgnore`
If you want to ignore all references, use `@JsonIgnore` on the entire class.

```java
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonIgnore
    private RelatedEntity relatedEntity;

    // Getters and setters...
}
```

#### 4. Use `@JsonAutoDetect`
If you want to control the visibility of Jackson annotations, use `@JsonAutoDetect`.

```java
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;

@Entity
@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonTypeName("your-entity-type")
    @JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "type")
    private RelatedEntity relatedEntity;

    // Getters and setters...
}
```

#### 5. Use `@JsonIgnoreProperties`
If you want to ignore specific fields:

```java
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonIgnoreProperties({"related_entity", "your-entity-type"})
    private RelatedEntity relatedEntity;

    // Getters and setters...
}
```

#### 6. Use `@JsonAutoDetect` with `@JsonTypeInfo`
If you want to control the visibility of Jackson annotations:

```java
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonTypeName;

@Entity
@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class YourEntity {
    @Id
    private Long id;
    
    // Other fields...

    @ManyToOne
    @JoinColumn(name = "related_entity_id")
    @JsonTypeName("your-entity-type")
    @JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "type")
    private RelatedEntity relatedEntity;

    // Getters and setters...
}
```

### Conclusion:
By using one of these strategies, you can control how Jackson handles circular references in your entities. This will prevent infinite recursion errors and allow you to serialize complex object graphs without issues.

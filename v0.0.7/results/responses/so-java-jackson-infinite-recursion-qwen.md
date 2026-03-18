The error "Infinite recursion" in Jackson when serializing a JPA entity with a bidirectional relationship typically occurs due to circular references or improper handling of relationships between entities. Here are some steps you can take to diagnose and resolve this issue:

### 1. **Check for Circular References**
   - Ensure that there is no circular reference between your entities.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         private Parent parent;

         // getters and setters...
     }
     ```

### 2. **Use `@JsonIgnore` on the Relationship**
   - If you have a bidirectional relationship, consider using `@JsonIgnore` to prevent Jackson from serializing it.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         @JsonIgnore
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         @JsonIgnore
         private Parent parent;

         // getters and setters...
     }
     ```

### 3. **Use `@JsonManagedReference` or `@JsonBackReference`
   - If you want to serialize the relationship but don't want Jackson to include it in the JSON, use `@JsonManagedReference`.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         @JsonManagedReference
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         @JsonBackReference
         private Parent parent;

         // getters and setters...
     }
     ```

### 4. **Use `@JsonIgnoreProperties`
   - If you want to ignore all relationships, use `@JsonIgnoreProperties`.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         @JsonIgnoreProperties("children")
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         @JsonIgnoreProperties("parent")
         private Parent parent;

         // getters and setters...
     }
     ```

### 5. **Check for Circular Dependencies in Your Entities**
   - Ensure that your entities are not referencing each other directly or indirectly through a common ancestor class.

### 6. **Use `@JsonIdentityInfo` with `propertyFilter`
   - If you need to handle circular references but want to keep them in the JSON, use `@JsonIdentityInfo`.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         @JsonIdentityInfo(generator = ObjectIdGenerator.class)
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         @JsonIdentityInfo(generator = ObjectIdGenerator.class)
         private Parent parent;

         // getters and setters...
     }
     ```

### 7. **Check for Custom Serializers or Deserializers**
   - Ensure that you are not manually serializing/deserializing the relationships in a way that could lead to infinite recursion.

### 8. **Use `@JsonAutoDetect` with `showAll`
   - If Jackson is unable to detect the relationship, use `@JsonAutoDetect`.
     ```java
     @Entity
     public class Parent {
         @Id
         private Long id;
         private String name;

         @OneToMany(mappedBy = "parent")
         @JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
         private List<Child> children;

         // getters and setters...
     }

     @Entity
     public class Child {
         @Id
         private Long id;
         private String name;

         @ManyToOne
         @JoinColumn(name = "parent_id", referencedColumnName = "id")
         @JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
         private Parent parent;

         // getters and setters...
     }
     ```

### 9. **Check for Custom Annotations or Mixins**
   - Ensure that you are not using custom annotations or mixins that could be causing the infinite recursion.

By following these steps, you should be able to identify and resolve the issue with Jackson serialization of JPA entities with bidirectional relationships.

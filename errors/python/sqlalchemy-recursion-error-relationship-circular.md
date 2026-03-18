# SQLAlchemy RecursionError on circular relationship

> RecursionError: maximum recursion depth exceeded while calling a Python object

## What happened
Your SQLAlchemy model has a circular relationship (e.g., Parent -> Children -> Parent) that causes infinite recursion when loading, serializing, or printing related objects.

## Why it happens
When two models reference each other via `relationship()` with eager loading (the default `lazy='select'` combined with attribute access), accessing one side triggers loading the other, which triggers loading back, creating an infinite loop. This is especially common when serializing models to JSON or printing them in `__repr__`.

## How to fix it

Use `back_populates` (instead of `backref`) and set lazy loading explicitly:
```python
class Parent(Base):
    __tablename__ = 'parents'
    id = Column(Integer, primary_key=True)
    children = relationship("Child", back_populates="parent", lazy="selectin")

class Child(Base):
    __tablename__ = 'children'
    id = Column(Integer, primary_key=True)
    parent_id = Column(Integer, ForeignKey('parents.id'))
    parent = relationship("Parent", back_populates="children", lazy="joined")
```

When querying, control loading strategy explicitly with `selectinload` or `joinedload`:
```python
from sqlalchemy.orm import selectinload

stmt = select(Parent).options(selectinload(Parent.children))
results = session.execute(stmt).scalars().all()
```

If the recursion happens during serialization, break the circular reference in your serializer:
```python
def serialize_parent(parent):
    return {
        "id": parent.id,
        "children": [{"id": c.id} for c in parent.children]  # don't include c.parent
    }
```

## Still not working?
- Check your `__repr__` method: if it prints related objects, it can trigger the recursion. Only print scalar columns in `__repr__`.
- For self-referential relationships (e.g., tree structures), use `remote_side` and `lazy="selectin"`.
- If using Pydantic with SQLAlchemy, set `model_config = ConfigDict(from_attributes=True)` and exclude back-references from the schema.

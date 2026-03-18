# Celery received unregistered task

> Received unregistered task of type 'myapp.tasks.process_data'

## What happened
A Celery worker received a task message but does not have that task registered in its task registry. The worker cannot execute it.

## Why it happens
The worker process does not know about the task because it was not imported or discovered. Common causes: the `autodiscover_tasks()` call is missing or misconfigured, the task module is not in the `include` list, or the worker was started from a different directory/package than expected.

## How to fix it

Make sure `autodiscover_tasks` is configured in your Celery app:
```python
# celery_app.py
from celery import Celery

app = Celery('myapp')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()  # discovers tasks.py in all INSTALLED_APPS
```

Or explicitly include task modules:
```python
app = Celery('myapp')
app.conf.include = ['myapp.tasks', 'otherapp.tasks']
```

If using Django, make sure the Celery app is loaded in `__init__.py`:
```python
# myproject/__init__.py
from .celery_app import app as celery_app

__all__ = ('celery_app',)
```

Verify the task name matches what the producer sends:
```bash
# List registered tasks on the worker
celery -A myapp inspect registered
```

Check the task name attribute if you set it explicitly:
```python
@app.task(name='myapp.tasks.process_data')  # must match exactly
def process_data():
    pass
```

## Still not working?
- Make sure you restart the worker after code changes. Celery workers do not auto-reload by default (use `--autoreload` in development).
- If tasks are in a subpackage, check that all `__init__.py` files exist in the package chain.
- Verify `CELERY_IMPORTS` in your config if using a settings-based configuration.

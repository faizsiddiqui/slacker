# Slacker Stack Example

"Slacker" Stack is like a normal stack which is a collection of independent Layer. A Layer defines a ordered set of smallest execution unit called as Task.

```txt
stack
 -- layer_1
 ---- task_1
 ---- task_2

 -- layer_2
 ---- task_1

 -- layer_3
 ---- task_1
 ---- task_2
 ---- task_3
```

A Task has only four properties -

1. `id`: [Integer] Used to order the tasks in a layer
2. `type`: [String] Type of task to perform, currently only three types are supported, i.e., `file`, `package` & `service`.
3. `spec`: [Object] Defines the properties to the task (Properties varies based on the type of task)
4. `post`: [List of Tasks] Defines the list of tasks to execute if the main tasks changes its state.

Example:

1. Package

```json
{
  "id": 1,
  "type": "package",
  "spec": {
    "name": "apache2",
    "action": "install"
  }
}
```

2. Service

```json
{
  "id": 1,
  "type": "service",
  "spec": {
    "name": "apache2",
    "action": "restart"
  }
}
```

3. File

```json
{
  "id": 3,
  "type": "file",
  "spec": {
    "src": "files/index.php",
    "dest": "/var/www/html/index.php",
    "owner": "root",
    "group": "root",
    "mode": "644",
    "action": "create"
  }
}
```

4. Post Action

```json
{
  "id": 2,
  "type": "file",
  "spec": {
    "dest": "/var/www/html/index.html",
    "action": "delete"
  },
  "post": [
    {
      "id": 1,
      "type": "service",
      "spec": {
        "name": "apache2",
        "action": "restart"
      }
    }
  ]
}
```

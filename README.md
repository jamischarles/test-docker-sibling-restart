# test-docker-restart-sibling
Simple example to test how to restart one docker container from another.

This contains 2 node containers. One is `little brother`, whose only job is to run and sleep. The other is `big brother`. When you start it up, little brother will just sleep and keep the process running.
Big brother will wait 5 seconds, and then look up the ID of little brother, and attempt to restart little brother.

After 500 seconds bothe containers will end.

## Important things to note:
- You can access the parent docker instance from a container by mounting the docker unix domain socket as a volume.
- You can then use curl to call the parent docker process and use the docker http API to make docker do things...

## To rebuild the images from local and start the docker containers
`$ docker-compose up --build`

This is a great pattern for easily trying things out locally because it builds the docker images and composes the services from all the local files. This allows for quick and easy iteration and experimentation.

## Success
This is what success looks like
```
little_brother_1  | STARTING UP THE APP
big_brother_1     |
[...]
dockertestsiblingrestart_little_brother_1 exited with code 137
little_brother_1  | STARTING UP THE APP
```



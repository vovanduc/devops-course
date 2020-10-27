#### Processes

Containers are just normal Linux Processes with additional configuration applied. Launch the following Redis container so we can see what is happening under the covers.

`docker run -d --name=db redis:alpine`


The Docker container launches a process called redis-server. From the host, we can view all the processes running, including those started by Docker.

`ps aux | grep redis-server`

Docker can help us identify information about the process including the PID (Process ID) and PPID (Parent Process ID) via docker top db

Who is the PPID? Use `ps aux | grep <ppid> ` to find the parent process. Likely to be Containerd.

The command pstree will list all of the sub processes. See the Docker process tree using `pstree -c -p -A $(pgrep dockerd)`

As you can see, from the viewpoint of Linux, these are standard processes and have the same properties as other processes on our system.

#### Process Directory

Linux is just a series of magic files and contents, this makes it fun to explore and navigate to see what is happening under the covers, and in some cases, change the contents to see the results.

The configuration for each process is defined within the `/proc` directory. If you know the process ID, then you can identify the configuration directory.

The command below will list all the contents of /proc, and store the Redis PID for future use.

```
DBPID=$(pgrep redis-server)
echo Redis is $DBPID
ls /proc
```
Each process has it's own configuration and security settings defined within different files. `ls /proc/$DBPID`

For example, you can view and update the environment variables defined to that process. `cat /proc/$DBPID/environ`

docker exec -it db env

CONTINUE
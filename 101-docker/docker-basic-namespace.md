### Namespaces
One of the fundamental parts of a container is namespaces. The concept of namespaces is to limit what processes can see and access certain parts of the system, such as other network interfaces or processes.

When a container is started, the container runtime, such as Docker, will create new namespaces to sandbox the process. By running a process in it's own Pid namespace, it will look like it's the only process on the system.

The available namespaces are:

```
Mount (mnt)

Process ID (pid)

Network (net)

Interprocess Communication (ipc)

UTS (hostnames)

User ID (user)

Control group (cgroup)

```

More information at https://en.wikipedia.org/wiki/Linux_namespaces

#### Unshare can launch "contained" processes.
Without using a runtime such as Docker, a process can still operate within it's own namespace. One tool to help is unshare.

`unshare --help`

With `unshare` it's possible to launch a process and have it create a new namespace, such as Pid. By unsharing the Pid namespace from the host, it looks like the bash prompt is the only process running on the machine.

```
sudo unshare --fork --pid --mount-proc bash
ps
exit
```

### What happens when we share a namespace?
Under the covers, Namespaces are inode locations on disk. This allows for processes to shared/reused the same namespace, allowing them to view and interact.

List all the namespaces with `ls -lha /proc/$DBPID/ns/`

Another tool, NSEnter is used to attach processes to existing Namespaces. Useful for debugging purposes.

nsenter --help

nsenter --target $DBPID --mount --uts --ipc --net --pid ps aux

With Docker, these namespaces can be shared using the syntax container:<container-name>. For example, the command below will connect nginx to the DB namespace.

docker run -d --name=web --net=container:db nginx:alpine
WEBPID=$(pgrep nginx | tail -n1)
echo nginx is $WEBPID
cat /proc/$WEBPID/cgroup

While the net has been shared, it will still be listed as a namespace. ls -lha /proc/$WEBPID/ns/

However, the net namespace for both processes points to the same location.

ls -lha /proc/$WEBPID/ns/ | grep net ls -lha /proc/$DBPID/ns/ | grep net


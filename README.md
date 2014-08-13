# Docker Ambassador

For information about the docker ambassador linking pattern 
check out this link [here](https://docs.docker.com/articles/ambassador_pattern_linking).  

## Busybox

To start from scratch you need to first build the busybox image. 
The script `mkrootfs.sh` is a helper to build `rootfs.tar`. The
tarmaker installs the `busybox-static` Ubuntu package and uses
it as the base for the newly built image. Beyond that, it also
includes the socat binary.[^1]

```
cd ./busybox
TARMAKER=ubuntu
./mkrootfs.sh
docker build -t busybox .
```

Once built, you can run it with:

```
docker run -t -i busybox
```

## Ambassador

Once you have the busybox built you can use the `Dockerfile` [^2] in the root
of this repository to build the ambassador:

```
docker build -t ReedD/ambassador .
docker tag ReedD/ambassador ambassador
```

To run it on a remote host, you can use:

```
docker run -t -i \
    -name redis_ambassador \
    -expose 6379 \
    -e REDIS_PORT_6379_TCP=tcp://<DOMAIN OR IP ADDRESS>:6379 \
    ambassador
```

Here is another example with MySQL:


```
docker run -t -i \
    -name sql_ambassador \
    -expose 3306 \
    -e MYSQL_PORT_3306_TCP=tcp://<DOMAIN OR IP ADDRESS>:3306 \
    ambassador
```

If you want to access your ambassador locally you can simply add the `-p` option with the ports you'd like to use i.e. `-p 3306:3306`.

#### Boot2Docker Notes

If you want the ambassador to connect to the localhost of the machine that's running your Boot2Docker VM you can do it with the IP address `10.0.2.2` 

```
docker run -t -i \
    -name sql_ambassador \
    -p 3306:3306 \
    -expose 3306 \
    -e MYSQL_PORT_3306_TCP=tcp://10.0.2.2:3306 \
    ambassador
```

[^1]: https://github.com/jpetazzo/docker-busybox
[^2]: https://github.com/SvenDowideit/dockerfiles/blob/master/ambassador/Dockerfile
[Busybox]: http://www.busybox.net/
[Docker]: http://docker.io/
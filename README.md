# Cross Linux From Scratch (CLFS) on the Docker

Cross Linux From Scratch (CLFS) is a project that provides you with step-by-step instructions for building your own customized Linux system entirely from source.

**The default password is `clfs`. This can be changed by editing `CONFIG_ROOT_PASSWD` of `config.mk`.**

## Preparing Build Environment

Ubuntu 20.04 is recommended.

```bash
sudo apt update
sudo apt install gcc g++ make wget
```

## Step 1) Download All The Packages

```bash
make download
```

## Step 2) Build Toolchain

```bash
make toolchain
```

```
$ out/tools/bin/x86_64-clfs-linux-musl-gcc --version
x86_64-clfs-linux-musl-gcc (CLFS x86_64 2021.09) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Step 3) Build Root File System

```bash
make system
```

## Step 4) Generate Root File System File

```bash
make image
```

## How to use it in Docker

```bash
sudo su
cat out/images/CLFS-1.0.0.tar.gz | docker import - clfs:1.0.0
docker run --name clfs -d -i -t --restart always clfs:1.0.0 /bin/sh
docker attach clfs
```

## Publish a Docker Image to GitHub

1. Go to 'GitHub Profile > Settings > Developer settings > Personal access tokens > Generate new token'.  
   [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new)
2. Check the checkboxes of `repo`, `write:packages`, `read:packages`, and `delete:packages`.
3. Use the terminal with root privileges.
4. Execute the `docker login ghcr.io -u <GitHub_Username>` in Terminal.
5. When prompted for a password, enter the token generated in step 2.
6. Execute the `docker images -a` in Terminal.  
   The image you just added is displayed. Note the 'IMAGE_ID'.
7. `docker tag <IMAGE_ID> ghcr.io/<GitHub_Username>/<IMAGE_NAME>:<TAG>`  
   Execute the above command. `<IMAGE_ID>` is the 'IMAGE_ID' you just wrote down.
8. Execute the command below to push to GitHub.  
   `docker push ghcr.io/<GitHub_Username>/<IMAGE_NAME>:<TAG>`
9. If you go to 'Profile' on GitHub, you can see 'Packages' added.  
   Click the 'Packages' so that check published docker image.

## Useful Docker Commands

Delete all containers and images :

```bash
sudo su
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -q)
```

## Thanks to

- [Buildroot](https://buildroot.org)
- [Cross Linux From Scratch (CLFS)](http://clfs.org)
- [PiLFS](http://www.intestinate.com/pilfs/)

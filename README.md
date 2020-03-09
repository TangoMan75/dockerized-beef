TangoMan Dockerized BeEF
========================

**TangoMan Dockerized BeEF** is a fast and handy way to deploy BeEF with docker.

Dependencies
------------

**TangoMan Dockerized BeEF** requires the following dependencies:

- Make
- Docker

### Make

#### Install Make (Linux)

Make is present by default on most linux distributions, if you want a newer version enter following command:

```bash
$ sudo apt-get update
$ sudo apt-get install -y make
```

#### Install Make (Windows)

On windows machine you will need to install [cygwin](http://www.cygwin.com/) or [GnuWin make](http://gnuwin32.sourceforge.net/packages/make.htm) first to execute make script.

#### Install Make (OS X)

Make exists by default on OS X, if you want a newer version:

```bash
$ brew install make
```

### Docker

#### Install Docker (Linux)

On linux machine enter following command

```bash
$ sudo apt-get update
$ sudo apt-get install -y docker.io
```

#### Configure Docker (Linux)

Add current user to docker group

```bash
$ sudo usermod -a -G docker ${USER}
```
> You will need to log out and log back in current user to use docker

#### Install Docker (Windows)

Download docker installer

- [https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip](https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip)

#### Install Docker (OS X)

Download docker installer

- [https://download.docker.com/mac/static/stable/x86_64/docker-19.03.5.tgz](https://download.docker.com/mac/static/stable/x86_64/docker-19.03.5.tgz)
- [https://download.docker.com/mac/beta/Docker.dmg](https://download.docker.com/mac/beta/Docker.dmg)

### Start container

Enter following command to build container and start node server.

```shell
$ make up
```

Bonus
-----

Anytime you need more details about available commands, type :

```shell
$ make
```

BeEF
----

BeEF official website: [https://beefproject.com](https://beefproject.com)

BeEF control panel can be found here: [http://localhost/ui/panel](http://localhost/ui/panel)

```
username: root
password: toor
```

Basic demo page here: [http://localhost/demos/basic.html](http://localhost/demos/basic.html)

Advanced demo page: [http://localhost/demos/butcher/index.html](http://localhost/demos/butcher/index.html)

Hook can be found here: [http://localhost/hook.js](http://localhost/hook.js)

License
-------

Copyrights (c) 2020 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENCE)
Distributed under the MIT license.

If you like **TangoMan Makefile Generator** please star, follow or tweet:

[![GitHub stars](https://img.shields.io/github/stars/TangoMan75/dockerized-beef?style=social)](https://github.com/TangoMan75/dockerized-beef/stargazers)
[![GitHub followers](https://img.shields.io/github/followers/TangoMan75?style=social)](https://github.com/TangoMan75)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fdockerized-beef)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fdockerized-beef)

... And check my other cool projects.

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=morinmatthias)](https://www.linkedin.com/in/morinmatthias)

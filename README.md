README
======

Docker container for running lua check with some defaults (to allow whitespace) pre set

## Usage

```
docker run -it --rm -v $(pwd):/lua SGTGunner/luacheck
```

Will run luacheck on the local directory


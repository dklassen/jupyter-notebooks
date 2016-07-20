# Jupyter Container

Build a jupyter container with the required unbuntu and python libs.

There are two empty folders which are mounted as volume in the container:
```
.
..
notebooks
data
...
```

The notebooks directory is where all your ipython notebooks are saved so you have easy access. I don't commit my noteboks for the simple fact that some of the data is private. The data dir is where you organize all your local data files for access in the container. Makes life easy and simple to drap and drop data from where ever.

## Setup MacOSX

Go install docker for mac [here](https://docs.docker.com/engine/installation/mac/#/docker-for-mac). The instructions are pretty good and simple if you have issues let me know. After that is all setup check the preferences via the menu bar app and adjust the memory you require for the host. The defaults are pretty tiny for running notebooks. Apply and restart.

After you docker for mac is setup go ahead and run `script/build` to build the jupyter container. This isn't building from scratch but does setup extra requirements in the `requirements.txt` file to include things like numpy and matplotlib. Once the image is built successfully go ahead and test out the container with `script/run` this will run in the console window and will make jupyter notebooks accessible via:

> open  localhost:8888

Enjoy

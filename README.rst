####################################################
 YAAAS: Yet Another Albeit Atypical Speedtest (CLI)
####################################################

This containerized version of the well-known
command-line based internet speed test
has only the notable difference that it runs
on the scratch base image with the
minimal requirements needed, initializing
PID 1 through dumb-init and runs
as a non-root user.

============
Requirements
============

- `Docker <https://docs.docker.com/get-docker/>`_

===============
Build the image
===============

.. code-block:: bash

    $ docker build -t your/speedtest .

=====
Usage
=====

Simply run:

.. code-block:: bash

    $ docker run -it --rm --cap-drop ALL your/speedtest

The flags `--accept-license` and `--accept-gdrp` are part of the
CMD block, allowing you to, well, deny them if you do so wish.

Read the usage description for more:

.. code-block:: bash

    $ docker run -it --rm --cap-drop ALL your/speedtest --help

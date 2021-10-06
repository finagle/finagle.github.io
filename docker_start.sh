#!/bin/bash

# This script will boot you into the image ready to start at the `bundle install` command.
docker run -p 4567:4567 -v "$HOME/.gitconfig:/root/.gitconfig" -v "$HOME/.ssh:/root/.ssh" -v "$PWD:/finagle.github.io" -it ghpublish bash

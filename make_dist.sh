#!/usr/bin/env bash

[ -e beware-space.love ] && rm beware-space.love
zip -9 -r --exclude='*.git*' --exclude='*.idea*' dist/beware-space.love .

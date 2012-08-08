#!/bin/bash
erl +K true +A 16 -pa apps/sttest/ebin -pa deps/stampede/ebin -s stampede -s sttest_app

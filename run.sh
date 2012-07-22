#!/bin/bash
erl -pa apps/sttest/ebin -pa deps/stampede/ebin -s stampede -s sttest_app

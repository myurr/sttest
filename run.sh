#!/bin/bash
erl +K true +A 50 -env ERL_MAX_PORTS 50000 -pa apps/sttest/ebin -pa deps/stampede/ebin -s sttest_app

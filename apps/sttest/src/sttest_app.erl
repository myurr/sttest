-module(sttest_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	start(normal, []).

start(_StartType, _StartArgs) ->
	stampede:listen([{port, 8080}], {callback, sttest_handler}, [{idle_workers, 100}]).

stop(_State) ->
    ok.

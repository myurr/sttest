-module(sttest_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	application:start(sttest).

start(_StartType, _StartArgs) ->
	io:format("Firing up the listener...~n"),
	stampede:listen([{port, 8080}], {callback, sttest_handler}, [{idle_workers, 5}]).

stop(_State) ->
	io:format("Oh... I've died.  Bugger...~n"),
    ok.

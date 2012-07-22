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
	io:format("Hello!~n"),
	ok.
%	stampede:listen(http, {all, 8080}, {callback, sttest_handler}, [{pool_size, 100}]).

stop(_State) ->
    ok.

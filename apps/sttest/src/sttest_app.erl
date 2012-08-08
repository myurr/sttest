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

	Routes = [
		{method, 'GET', [
			{host, <<"localhost">>, [
				{set_path, <<"/www/sites/test/">>},
				{url, <<"/static">>, [
					{path, <<"htdocs/">>},
					{static_dir, <<"index.html">>}
				]}
			]}
		]},
		{method, 'ERROR', [
			{url, <<"404">>, [{static, <<"Err we seem to be missing something here Bert.">>}]},
			{url, <<"500">>, [{static, <<"Total failure!!">>}]}
		]}
	],

	stampede:listen([{port, 8080}], Routes, [{idle_workers, 5}]).

stop(_State) ->
	io:format("Oh... I've died.  Bugger...~n"),
    ok.

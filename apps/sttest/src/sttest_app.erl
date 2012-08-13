-module(sttest_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	ok = application:start(sttest).

start(_StartType, _StartArgs) ->
	io:format("Firing up the listener...~n"),

	Routes = [
		{host, [<<"localhost">>, <<"stampede.pureinnovation.com">>], [
			{method, 'GET', [
				{set_path, <<"/www/sites/test/">>},
				{browser_cache_for, {{0, 0, 1}, {0, 0, 0}}},
				{map_file, <<"/favicon.ico">>, <<"htdocs/favicon.ico">>, []},
	%			{set_site, testsite},
	%			{session, <<"sid">>, <<"">>},
				{url, <<"/static">>, [
					{path, <<"htdocs/">>},
					{static_dir, <<"index.html">>, []}
				]}
			]},
			{method, 'ERROR', [
%				{url, <<"404">>, [{static, <<"Err we seem to be missing something here Bert.">>}]},
%				{url, <<"500">>, [{static, <<"Total failure!!">>}]}
			]}
		]}
	],

	application:start(stampede),
	% stampede:nodes([]),
	% stampede:create_site(testsite, [{tmpdir, <<"/tmp/stampede/testsite">>}]),
	stampede:listen([{port, 8080}], Routes, [{idle_workers, 200}]).

stop(_State) ->
	io:format("Oh... I've died.  Bugger...~n"),
    ok.

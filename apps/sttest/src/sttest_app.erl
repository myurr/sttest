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

	SiteRoutes = [
		{host, [<<"*:8080">>, <<"localhost">>, <<"stampede.pureinnovation.com">>], [
			{set_path, <<"/www/sites/test/">>},
			{site, testsite}
		]}
	],

	TestRoutes = [
		{method, 'GET', [
			{browser_cache_for, {{0, 0, 1}, {0, 0, 0}}},
			{map_file, <<"/favicon.ico">>, <<"htdocs/favicon.ico">>, []},
			{session, [{reset_timeout, true}]},
			{url, <<"/static">>, [
				{path, <<"htdocs/">>},
				{static_dir, <<"index.html">>, []}
			]},
			{url, <<"/dynamic">>, [
				{url, <<"/redirect">>, [
					{erlang, {call, fun handler_example:dynamic/3, []}}
				]},
				{url, <<"/clock">>, [
					{erlang, {call, fun handler_example:gen/3, []}}
				]}
			]}
		]},
		{method, 'POST', [
			{url, <<"/dynamic/post">>, [
				{content_type, <<"application/x-www-form-urlencoded">>, [
					{post_args, {64, kb}, []},
					{erlang, {call, fun handler_example:post_test/3, []}}
				]}
			]}
		]},
		{method, 'ERROR', [
%			{url, <<"404">>, [{static, <<"Err we seem to be missing something here Bert.">>}]},
%			{url, <<"500">>, [{static, <<"Total failure!!">>}]}
		]}
	],

	% fprof:trace(start),
	application:start(stampede),
	stampede:nodes([]),
	ok = stampede_site:create(testsite, TestRoutes, [{cache_dir, <<"/tmp/stampede/testsite">>}, {config, []}]),
	SiteList = stampede_site:list(),
	stampede:listen([{port, 8080}], SiteRoutes, SiteList, [{idle_workers, 200}]).

stop(_State) ->
	io:format("Oh... I've died.  Bugger...~n"),
	% fprof:trace(stop),
    ok.

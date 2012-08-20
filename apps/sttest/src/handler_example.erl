-module(handler_example).

-export([dynamic/3, gen/3, ticker/1, post_test/3]).

dynamic(Request, _RoutingState, _Args) ->
	io:format("Dynamic function has been called! ~p~n", [st_session:id(st_request:session(Request))]),
	{reroute, <<"/static/dynamic.html">>}.

gen(Request, _RoutingState, _Args) ->
	{ok, Response} = st_response:new(
			Request, ok, [],
			{stream, <<"<html><head><title>Peekaboo</title></head>",
						"<body><h1>This is a programatically generated page</h1><div>Current time:</div>">>}
		),
	spawn_link(?MODULE, ticker, [self()]),
	{send, Response}.

ticker(Pid) ->
	link(Pid),
	do_ticker(Pid).

do_ticker(Pid) ->
	Msg = <<"<div>", (stutil:to_binary(httpd_util:rfc1123_date()))/binary, "</div>", 13, 10>>,
	Pid ! {stream, Msg},
	io:format("Tick~n"),
	timer:sleep(1000),
	ticker(Pid).

post_test(Request, _RoutingState, _Args) ->
	Text = stutil:to_binary(io_lib:format("~p", [st_request:post_arg(Request, <<"foo">>)])),
	{ok, Response} = st_response:new(
			Request, ok, [],
			<<"<html><head><title>Post Test</title></head>",
						"<body><h1>Post Test</h1><div>Received post data:</div><div><pre>",
						Text/binary,
						"</pre></div></body></html>">>
		),
	{send, Response}.


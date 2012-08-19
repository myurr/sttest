-module(handler_example).

-export([dynamic/3, gen/3]).

dynamic(_Request, _RoutingState, _Args) ->
	io:format("Dynamic function has been called!~n"),
	{reroute, <<"/static/dynamic.html">>}.

gen(Request, _RoutingState, _Args) ->
	{ok, Response} = st_response:new(
			Request, ok, [],
			<<"<html><head><title>Peekaboo</title></head>",
			"<body><h1>This is a programatically generated page</h1><div>Current time: ",
			(stutil:to_binary(httpd_util:rfc1123_date()))/binary, "</div></body></html>">>
		),
	{send, Response}.

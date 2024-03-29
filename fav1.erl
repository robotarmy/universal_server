-module(fav1).
-export([test/0,test/1,rtest/2]).

rtest(Remote,N) ->
    Pid = spawn(fun universal_server/0),
    Pid ! {become, fun fac_server/0},
    Pid ! {Remote, N}.

test(N) ->
    Pid = spawn(fun universal_server/0),
    Pid ! {become, fun fac_server/0},
    Pid ! {self(), N},
    receive
	    X -> X
    end.

test() ->
  test(50).
universal_server() ->
    receive
	{become, F} -> F()
    end.

fac_server() ->
    receive
	{From, N} ->
	    From ! factorial(N),
	    fac_server()
    end.

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

    

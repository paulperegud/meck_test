-module(b).
-compile(export_all).

%% test_fun() ->
%%     ok.


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-define(DBG(F, A), io:fwrite(user, "~p@~p:~p :: " ++ F ++ "~n", [self(), ?MODULE, ?LINE] ++ A)).
%% -define(DBG(F, A), debugFmt("~p@~p:~p :: " ++ F ++ "~n", [self(), ?MODULE, ?LINE] ++ A)).

-define(OTHER, a).

zetests() ->
    fun(_) ->
	    %% {spawn,
	     [ ?_assert(true) ]
    %% 	    }
    end.

b_test_() ->
    {setup,
     spawn,
     fun() ->
	     Pid = proc_lib:spawn(fun() ->
					  meck:new(?OTHER,[no_passthrough_cover]),
					  receive
					      stop ->
						  ok
					  end
	     			  end),
	     register(?MODULE, Pid)
     end,
     fun(_) ->
             R = [P || P <- processes(), erlang:check_process_code(P, ?OTHER), P == self()],
	     ?DBG("users of old code of module ~p: ~p", [?OTHER, R]),
	     ?MODULE ! stop,
	     spawn(fun() -> meck:unload(?OTHER) end)
     end,
     zetests()
    }.

-endif.

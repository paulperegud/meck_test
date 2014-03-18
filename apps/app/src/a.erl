-module(a).
-compile(export_all).

c() ->
    ok.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-define(OTHER, b).

-define(DBG(F, A), io:fwrite(user, "~p@~p:~p :: " ++ F ++ "~n", [self(), ?MODULE, ?LINE] ++ A)).
%% -define(DBG(F, A), debugFmt("~p@~p:~p :: " ++ F ++ "~n", [self(), ?MODULE, ?LINE] ++ A)).

zetests() ->
    fun(_) ->
	    %% {spawn,
 	     [ ?_assert(true) ]
            %% }
    end.


a_test_() ->
    {setup,
     spawn,
     fun() ->
	     Pid = proc_lib:spawn(fun() ->
					  meck:new(?OTHER,[no_passthrough_cover]),
					  receive
					      stop ->
						  %% meck:unload(?OTHER),
						  ok
					  end
	     			  end),
	     register(?MODULE, Pid)
     end,
     fun(_) ->
             %% the following should match otherwise code:purge in meck:unload
             %% will fail (it will kill test process)
             R = [P || P <- processes(), erlang:check_process_code(P, ?OTHER), P == self()],
	     ?DBG("users of old code of module ~p: ~p", [?OTHER, R]),
	     ?MODULE ! stop,
	     spawn(fun() -> meck:unload(?OTHER) end)
             %% meck:unload(?OTHER)
     end,
     zetests()
    }.

-endif.

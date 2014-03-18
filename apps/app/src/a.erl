-module(a).
-compile(export_all).

c() ->
    ok.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

a_test_() ->
    {setup,
     fun() ->
             meck:new(b,[no_passthrough_cover])
     end,
     fun(_) ->
             %% the following should match otherwise code:purge in meck:unload
             %% will fail (it will kill test process)
             %% [] = [P || P <- processes(), erlang:check_process_code(P, b), P == self()],
             meck:unload()
     end,
     fun(_) ->
             [ ?_assert(true) ]
     end
    }.

-endif.

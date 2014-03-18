-module(b).
-compile(export_all).

test_fun() ->
    ok.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

b_test_() ->
    {setup,
     fun() ->
             meck:new(a,[no_passthrough_cover])
     end,
     fun(_) ->
%             [] = [P || P <- processes(), erlang:check_process_code(P, a), P == self()],
%             meck:unload()
ok
     end,
     fun(_) ->
             [ ?_assert(true) ]
     end
    }.

-endif.

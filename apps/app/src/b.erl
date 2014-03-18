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
             %% the following should match otherwise code:purge in meck:unload
             %% will fail (it will kill test process)
             false = erlang:check_process_code(self(), a),
             meck:unload()
     end,
     fun(_) ->
             [ ?_assert(true) ]
     end
    }.

-endif.

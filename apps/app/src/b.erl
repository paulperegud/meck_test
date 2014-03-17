-module(b).
-compile(export_all).

test_fun() ->
    ok.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

baz_test_() ->
    {setup,
     fun() ->
             meck:new(a),
             meck:expect(a, b, fun()-> ok end)
     end,
     fun(_) ->
             meck:unload(a)
     end,
     fun(_) ->
             [ ?_assert(true),
               ?_assertNot(false) ]
     end
    }.

-endif.

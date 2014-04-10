%%% Testing of Map Reduce using word count
test_map_reduce() ->
 M_func = fun(Line) ->
            lists:map(
              fun(Word) ->
                {Word, 1}
              end, Line)
          end,

 R_func = fun(V1, Acc) ->
            Acc + V1
          end,

 map_reduce(3, 5, M_func, R_func, 0,
            [[this, is, a, boy],
             [this, is, a, girl],
             [this, is, lovely, child]]).

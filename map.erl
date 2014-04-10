%%% The mapper process
map_task(Reduce_processes, MapFun) ->
 receive
   {map, Data} ->
     IntermediateResults = MapFun(Data),
     io:format("Map function produce: ~w~n",
               [IntermediateResults ]),
     lists:foreach(
       fun({K, V}) ->
         Reducer_proc =
           find_reducer(Reduce_processes, K),
         Reducer_proc ! {reduce, {K, V}}
       end, IntermediateResults),

     map_task(Reduce_processes, MapFun)
 end.

%%% The reducer process
reduce_task(Acc0, ReduceFun) ->
 receive
   {reduce, {K, V}} ->
     Acc = case get(K) of
             undefined ->
               Acc0;
             Current_acc ->
               Current_acc
           end,
     put(K, ReduceFun(V, Acc)),
     reduce_task(Acc0, ReduceFun);
   {collect, PPid} ->
     PPid ! {result, get()},
     reduce_task(Acc0, ReduceFun)
 end.

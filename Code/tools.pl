index([X|_],0,X).
index([_|Xs],N,X):- 
    N1 is N-1, 
    index(Xs,N1,X1),
    X = X1,!.

index_Matriz(X,Y,Matriz,Resultado):-
    index(Matriz,Y,Fila),
    index(Fila,X,Resultado),!.

min(X,Y,R):- 
    X<Y, R is X,!;
    X>=Y, R is Y,!.


    
suma(A,B,C):- C is A+B.

suma_mod_M(A,B,M,C):- 
Temp is A+B,
C is Temp mod M.

suma_listas_5(Lista1,Lista2,Result):-
    index(Lista1,0,Value_1_0),
    index(Lista1,1,Value_1_1),
    index(Lista1,2,Value_1_2),
    index(Lista1,3,Value_1_3),
    index(Lista1,4,Value_1_4),
    
    index(Lista2,0,Value_2_0),
    index(Lista2,1,Value_2_1),
    index(Lista2,2,Value_2_2),
    index(Lista2,3,Value_2_3),
    index(Lista2,4,Value_2_4),

    suma(Value_1_0, Value_2_0,Value_final_0),
    suma(Value_1_1, Value_2_1,Value_final_1),
    suma(Value_1_2, Value_2_2,Value_final_2),
    suma(Value_1_3, Value_2_3,Value_final_3),
    suma(Value_1_4, Value_2_4,Value_final_4),

    Result = [Value_final_0,Value_final_1,Value_final_2,Value_final_3,Value_final_4],!.


%contador de elementos de una lista
    count_list([], 0):-!.
    count_list([_|Xs], S):- count_list(Xs, S1), S is S1 + 1.

%set en lista
    :- dynamic temporal_set/1.

    set_temporal(Result):-
        retractall(temporal_set(_)),
        asserta(temporal_set(Result)).
    
    set_in_matriz(Elemento,X,Y,Matriz,Matriz_Resultante):-
        index(Matriz,Y,Fila),
        set_x_in_pos(Elemento,X,Fila,Fila_nueva),
        set_x_in_pos(Fila_nueva,Y,Matriz,Matriz_Resultante),!.

    set_x_in_pos(X,Pos,List, Result ):-
        count_list(List,Len),
        set_x_in_pos_manual(X,Pos,List,[],0,Len);
        temporal_set(Temp),
        Result = Temp,!.

    set_x_in_pos_manual(X,0,List,Nueva,Count,Len):- 
        nuevoElemento(X,Nueva,List_result),!, 
        Count1 is Count+1,
        set_x_in_pos_manual(X,-1,List,List_result ,Count1,Len).

    set_x_in_pos_manual(X,Pos,List,Nueva,Count,Len):- 
        set_temporal(Nueva),%El resultado es la lista que se esta llenando

        Count < Len,
        index(List,Count,Temp),
        nuevoElemento(Temp,Nueva,Temp_list),

        Count1 is Count + 1,
        Pos1 is Pos-1,
        set_x_in_pos_manual(X,Pos1,List,Temp_list ,Count1,Len).


    inserta([],X,[X]).
    inserta([H|T], N, [H|R]) :- inserta(T, N, R).
    nuevoElemento(Y,X,Result ):-inserta(X, Y, Nueva), Result = Nueva.
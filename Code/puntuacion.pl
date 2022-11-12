:-[tools].
:-[jugadores].
:-[juego].

% [0,0,1,1,0]
% [0,0,0,1,0]
% [0,1,1,0,0]
% [0,1,0,1,0]
% [0,0,1,0,0]

%Casos de Prueba
    %puntuar(2,3,[[0,0,1,1,0],[0,0,0,1,0],[0,1,1,0,0],[0,1,0,1,0],[0,0,1,0,0]],T,Puntos).
    %array_columna(1,[[0,0,1,1,0],[0,0,0,1,0],[0,1,1,0,0],[0,1,0,1,0],[0,0,1,0,0]],Columna).
    %izquierda([1,1,0,1,0],2,R).
    %derecha([1,0,1,1,0],1,R).

puntuar(X,Y,Muro,Nuevo_Muro,Puntos):-
    index_Matriz(X,Y,Muro,Valor_en_muro),
    Valor_en_muro == 0,
    array_columna(X,Muro,Columna),
    index(Muro,Y,Fila),
    derecha(Fila,X,P0),
    izquierda(Fila,X,P1),
    derecha(Columna,Y,P2),
    izquierda(Columna,Y,P3),
    Fila_puntos is P0 + P1,
    Columna_puntos is P2 + P3,

    Puntos is P0 + P1 + P2 + P3 + 1,
    set_in_matriz(1,X,Y,Muro,Nuevo_Muro),
    condicion_fin(Fila_puntos),
    % condicion_fin(Columna_puntos),
    !.

condicion_fin(4):- finalizar_juego(),!.
condicion_fin(_):- !.
    

% Devuelve la columna en un array
    array_columna(X,Muro,Columna):-
        index(Muro,0,Fila0),
        index(Muro,1,Fila1),
        index(Muro,2,Fila2),
        index(Muro,3,Fila3),
        index(Muro,4,Fila4),
        
        index(Fila0,X,C0),
        index(Fila1,X,C1),
        index(Fila2,X,C2),
        index(Fila3,X,C3),
        index(Fila4,X,C4),
        nuevoElemento(C0,[],Columna0),
        nuevoElemento(C1,Columna0,Columna1),
        nuevoElemento(C2,Columna1,Columna2),
        nuevoElemento(C3,Columna2,Columna3),
        nuevoElemento(C4,Columna3,Columna),!.

% Metodos auxiliares para contar los 1 consecutivos en un array
    %   Metodo que calcula la cantidad de 1 a la derecha de un index en una lista de 
    % 0 y 1... se utiliza para contar los 1 a la derecha de la fila y hacia debajo en 
    % la columna, La columna se entra al metodo en forma de lista.

    derecha(Fila,Pos,Resultado):-
        %cuenta la cantidad de bloques adyacentes consecutivos a la derecha
        contar_derecha(Fila,0,Pos,1,R),
        Resultado is R,!.
    %Si llega a un cero, no debe contar mas y ese valor no cuenta, por tanto se le resta 1.
    contar_derecha(_,Valor,_,0,R):- R is Valor - 1,!. 
    %llega al final de la lista con el ultimo valor = 1.
    contar_derecha(_,Valor,4,_,Valor):-!. 
    contar_derecha(Fila,Valor,Iteracion,Fila_index,Resultado):-
        Iteracion1 is Iteracion +1,
        index(Fila,Iteracion1,Fila_index1),
        Iteracion1<5,
        Fila_index ==1,
        contar_derecha(Fila,Valor,Iteracion1,Fila_index1,Resultado1),
        Resultado is Resultado1 + 1,
        !.

    %   Metodo que calcula la cantidad de 1 a la izquierda de un index en una lista de 
    % 0 y 1... se utiliza para contar los 1 a la izquierda de la fila y hacia arriba en 
    % la columna, La columna se entra al metodo en forma de lista.
    izquierda(Fila,Pos,Resultado):-
        contar_izquierda(Fila,0,Pos,1,R),
        Resultado is R,!.
    %Si llega a un cero, no debe contar mas y ese valor no cuenta, por tanto se le resta 1.
    contar_izquierda(_,Valor,_,0,R):- R is Valor - 1,!. 
    %llega al principio de la lista con el ultimo valor = 1.
    contar_izquierda(_,Valor,0,_,Valor):-!. 

    contar_izquierda(Fila,Valor,Iteracion,Fila_index,Resultado):-
        Iteracion1 is Iteracion - 1,
        index(Fila,Iteracion1,Fila_index1),
        Iteracion1 >= 0,
        Fila_index == 1,
        contar_izquierda(Fila,Valor,Iteracion1,Fila_index1,Resultado1),
        Resultado is Resultado1 + 1,
        !.


%ejecucion de las puntuaciones
    ejecutar_todo():-
        cantidad_jugadores(Len),
        ejecutar_todo1(0,Len),!.

    ejecutar_todo1(N,Len):-
        ejecutar_puntuacion(N),
        N1 is N + 1,
        N1 < Len,
        ejecutar_todo1(N1,Len),!.

    ejecutar_puntuacion(Jugador):-
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        actualizar_muro(Jugador,0,Muro,Tablero,Extra,Puntuacion,Puntuacion_final,Muro_final,Tablero_final),
        extra(Extra,Extra_nuevo),
        Puntos is Puntuacion_final + Extra_nuevo,
        set_datos_jug(Jugador,Tablero_final,Muro_final,0,Puntos),
        !.

    actualizar_muro(Jugador,N,Muro,Tablero,Extra,Puntuacion,Puntuacion_final,Muro_final,Tablero_final):-
        N == 5, 
        Puntuacion_final is Puntuacion,
        Muro_final = Muro,
        Tablero_final = Tablero,!;

        N < 5,
        index(Tablero,N,F),
        index(F,0,Color),index(F,1,Cant_Color),

        N1 is N+1,
        Cant_Color == N1,
        suma_mod_M(Color,N,5,X),
        puntuar(X,N,Muro,Nuevo_Muro,Puntos),
        set_x_in_pos([-1,0],N,Tablero,Tablero_nuevo),
        push_x_color(Color,N), %agrega directo a la tapa todo lo que sobre
        Puntuacion_nueva is Puntuacion + Puntos, 
        actualizar_muro(Jugador,N1,Nuevo_Muro,Tablero_nuevo,Extra,Puntuacion_nueva,Puntuacion_final,Muro_final,Tablero_final),
        !;
        N < 5,
        N2 is N+1,
        actualizar_muro(Jugador,N2,Muro,Tablero,Extra,Puntuacion,Puntuacion_final,Muro_final,Tablero_final);!.

    cerrar_puntuacion():-
        cantidad_jugadores(Cant),
        cerrar_puntuacion1(Cant),
        !.
    cerrar_puntuacion1(N):-
        N == 0,!;
        N > 0,
        N1 is N -1,
        ultima_puntuacion(N1),
        cerrar_puntuacion1(N1),!.
    
/*
ultima_puntuacion_simulacion([  [1,1,1,1,1],
                                [1,0,0,1,1],
                                [1,0,0,1,0],
                                [1,1,1,1,1],
                                [1,1,1,1,1]],Puntos).

ultima_puntuacion_simulacion([[1,1,1,1,1],[1,0,0,1,1],[1,0,0,1,0],[1,1,1,1,1],[1,1,1,1,1]],Puntos).
*/
    ultima_puntuacion_simulacion(Muro,Puntos):-
        puntos_por_color(Muro,0,0,PuntosColor),
        puntos_por_columna(Muro,0,0,PuntosColumna),
        puntos_por_fila(Muro,0,0,PuntosFila),
        Puntos is PuntosColor + PuntosColumna + PuntosFila, % devuelve los puntos que aumenta
        !.

    ultima_puntuacion(Jugador):-
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        puntos_por_color(Muro,0,0,PuntosColor),
        puntos_por_columna(Muro,0,0,PuntosColumna),
        puntos_por_fila(Muro,0,0,PuntosFila),
        Puntuacion_final is Puntuacion + PuntosColor + PuntosColumna + PuntosFila,
        Puntuacion_str = Puntuacion + PuntosColor + PuntosColumna + PuntosFila,
        set_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion_str),
        !.
    
puntos_por_columna(Muro,N,PuntosAcumulados,Puntos):-
        N == 5,Puntos is PuntosAcumulados,!;
        N<5,
        array_columna(N,Muro,Columna),
        puntos_fila_columna(Columna,10,PuntosTemp),
        N1 is N+1,
        PuntosNuevos is PuntosTemp+PuntosAcumulados,
        puntos_por_columna(Muro,N1,PuntosNuevos,Puntos),!.
    
    puntos_por_fila(Muro,N,PuntosAcumulados,Puntos):-
        N == 5,Puntos is PuntosAcumulados,!;
        N<5,
        index(Muro,N,Fila),
        puntos_fila_columna(Fila,2,PuntosTemp),
        N1 is N+1,
        PuntosNuevos is PuntosTemp+PuntosAcumulados,
        puntos_por_fila(Muro,N1,PuntosNuevos,Puntos),!.
    
    puntos_fila_columna(Array,Recompensa,Puntos):-
        index(Array,0,F0),index(Array,1,F1),index(Array,2,F2),index(Array,3,F3),index(Array,4,F4),
        F0 == 1,F1 == 1,F2 == 1,F3 == 1,F4 == 1, Puntos is Recompensa,!;
        Puntos is 0,!.
        
    
    puntos_color(Muro,Color,Puntos):-
        Pos0 = Color,
        index_Matriz(0,Pos0,Muro,C0),suma_mod_M(Pos0,1,5,Pos1),
        index_Matriz(1,Pos1,Muro,C1),suma_mod_M(Pos1,1,5,Pos2),
        index_Matriz(2,Pos2,Muro,C2),suma_mod_M(Pos2,1,5,Pos3),
        index_Matriz(3,Pos3,Muro,C3),suma_mod_M(Pos3,1,5,Pos4),
        index_Matriz(4,Pos4,Muro,C4),suma_mod_M(Pos4,1,5,Pos5),
        C0 == 1,C1 == 1,C2 == 1,C3 == 1,C4 == 1, Puntos is 7,!;
        Puntos is 0,!.
    
    puntos_por_color(Muro,N,PuntosAcumulados,Puntos):-
        N == 5,Puntos is PuntosAcumulados,!;
        N<5,
        puntos_color(Muro,N,PuntosTemp),
        N1 is N+1,
        PuntosNuevos is PuntosTemp+PuntosAcumulados,
        puntos_por_color(Muro,N1,PuntosNuevos,Puntos),!.
    



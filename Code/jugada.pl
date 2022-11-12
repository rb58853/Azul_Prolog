:-[tools].
:-[puntuacion].
:-[juego].
:-[jugadores].

:-dynamic mejor_jugada/4. 
:-dynamic contador_permutaciones/1. 

aumentar_contador():-
    contador_permutaciones(C),
    C1 is C +1,
    retractall(contador_permutaciones(_)),
    asserta(contador_permutaciones(C1)),!.

reset_contador():-    
    retractall(contador_permutaciones(_)),
    asserta(contador_permutaciones(0)),!.

imprimir_contador():-
    contador_permutaciones(C),
    write('se entro a un total de '),write(C),write(' itereaciones al permutar'),!.    

ejecutar_pruebas():-
    reset_contador(),
    permutaciones();
    % imprimir_contador(),
    !.

permutaciones():-
    get_cant_fab(Len_Fabrica),
    Len_menos1 is Len_Fabrica -1,
    permutaciones1(0,0,0,0,0,0,Len_Fabrica,4,5),!.
    % permutaciones1(0,0,0,0,0,0,2,2,2),!.


permutaciones1(X,Y,Z,Lock_x,Lock_y,Lock_z,Len_x,Len_y,Len_z):-
    % write(' X = '),write(X),write(' Y = '),write(Y),write(' Z = '),write(Z),nl,
    aumentar_contador(),
    testear_jugada(X,Y,Z),
    
    X<Len_x, Lock_x == 0,
    X1 is X+1,
    permutaciones1(X1,Y,Z,0,0,0,Len_x,Len_y,Len_z);
    
    Y<Len_y, Lock_y == 0,
    Y1 is Y+1,
    permutaciones1(X,Y1,Z,1,0,0,Len_x,Len_y,Len_z);
    
    Z<Len_z, Lock_z == 0,
    Z1 is Z+1,
    permutaciones1(X,Y,Z1,1,1,0,Len_x,Len_y,Len_z),!.
    
testear_jugada(No_fab,Color,No_fila):-    
    jugador_actual(Jugador),
    jugada_valida(Jugador,Color,No_fila,No_fab), %La condicional es esta.
    
    jugador_actual(Jugador1),
    get_datos_jug(Jugador1,Tablero,_,_,_),
    % write('Tablero inicial: '),write(Tablero),nl,
    
    simular_jugada(Jugador1,No_fab,Color,No_fila,Tablero_simulado,Extra_simulado),
    % write('Tablero resultante: '),write(Tablero_simulado),nl,
    % write('Extra: '),write(Extra_simulado),nl,
    
    simular_puntuacion(Jugador1,Tablero_simulado,Extra_simulado,Puntos),
    % write('jugada:'),write(' fab = '),write(No_fab),
    % write(' color = '),write(Color),write(' fila = '),write(No_fila),
    % write(' Puntos = '),write(Puntos),nl,
    actualizar_mejor_jugada(No_fab,Color,No_fila,Puntos),!;
    1==1,%quiero que esto sea true.
    !.

actualizar_mejor_jugada(Fabrica,Color,Fila,Puntos):-
    mejor_jugada(_,_,_,Puntuacion),
    Puntos >= Puntuacion,
    retractall(mejor_jugada(_,_,_,_)),
    asserta(mejor_jugada(Fabrica,Color,Fila,Puntos));
    1==1, %siempre quiero que esto devuelva true
    !.

reset_mejor_jugada():-
    retractall(mejor_jugada(_,_,_,_)),
    asserta(mejor_jugada(-1,-1,-1,-1000)),
    !.

get_mejor_jugada(Fabrica,Color,Fila,Puntos):-
    mejor_jugada(Fabrica,Color,Fila,Puntos),!.

ver_mejor_jugada():-
    mejor_jugada(Fabrica,Color,Fila,Puntos),
    write('Fabrica: '),write(Fabrica),nl,
    write('Color: '),write(Color),nl,
    write('Fila: '),write(Fila),nl,
    write('Puntos: '),write(Puntos),nl,!.


jugada_valida(_,Color,5,Fabrica):-
    get_datos_fab(Fabrica,Azulejos),
    index(Azulejos,Color,Count_color_en_fabrica),
    Count_color_en_fabrica \== 0,
    !.

jugada_valida(Jugador,Color,No_Fila,Fabrica):-
    suma_mod_M(Color,No_Fila,5,Eje_Y),
    get_datos_jug(Jugador,Tablero,Muro,_,_),
    index_Matriz(No_Fila,Eje_Y,Muro,Posicion_en_muro),
    get_datos_fab(Fabrica,Azulejos),
    index(Azulejos,Color,Count_color_en_fabrica),
    index(Tablero,No_Fila,Fila),
    index(Fila,0,Color_fila),

    jugada_valida1(Posicion_en_muro,Count_color_en_fabrica,Color_fila,Color),!.
    

jugada_valida1(Posicion_en_muro,Count_color_en_fabrica,Color_fila,Color):-
    Posicion_en_muro \== 1, 
    Count_color_en_fabrica \== 0, 
    Color == Color_fila;
    
    Posicion_en_muro \== 1, 
    Count_color_en_fabrica \== 0, 
    Color_fila == -1,
    !.

% jugada_valida1(Posicion_en_muro,Count_color_en_fabrica,Color_fila,Color,Bool):-
%     Posicion_en_muro == 1, Bool is 0,!;
%     Count_color_en_fabrica == 0, Bool is 0,!;
%     Color_fila == -1, Bool is 1,!;
%     Color \== Color_fila, Bool is 0,!;
%     Bool is 1,!.

%simular_puntuacion(1,[[1,1],[-1,0],[2,3],[4,2],[-1,0]],0).

simular_puntuacion(Jugador,Tablero_simulado,Extra_simulado,Puntos):-
    get_datos_jug(Jugador,_,Muro,_,Puntuacion),
    actualizar_muro_simulacion(Jugador,0,Muro,Tablero_simulado,Extra_simulado,Puntuacion,Puntuacion_final),
    extra(Extra_simulado,Extra_nuevo),
    Puntos is Puntuacion_final + Extra_nuevo,!.

actualizar_muro_simulacion(Jugador,N,Muro,Tablero,Extra,Puntuacion,Puntuacion_final):-
    % pintar_muro(Muro),nl,
    N == 5,
    ultima_puntuacion_simulacion(Muro,Puntos_finales),
    Puntuacion_final is Puntuacion + Puntos_finales,!;
    
    N < 5,
    index(Tablero,N,F),
    index(F,0,Color),index(F,1,Cant_Color),

    N1 is N+1,
    Cant_Color == N1,
    suma_mod_M(Color,N,5,X),
    puntuar(X,N,Muro,Nuevo_Muro,Puntos),
    Puntuacion_nueva is Puntuacion + Puntos, 
    actualizar_muro_simulacion(Jugador,N1,Nuevo_Muro,Tablero,Extra,Puntuacion_nueva,Puntuacion_final),
    !;
    N < 5,
    N2 is N+1,
    actualizar_muro_simulacion(Jugador,N2,Muro,Tablero,Extra,Puntuacion,Puntuacion_final);!.

simular_jugada(Jugador,Fabrica,Color,5,Tablero_simulado,Extra_simulado):-
        get_datos_fab(Fabrica,Azulejos),

        index(Azulejos,Color,Count_color), 

        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
    
        Resto is Count_color,
        
        Extra_nuevo is Extra + Resto,
        min(Extra_nuevo,7,Extra_final),
        Tablero_simulado = Tablero,
        Extra_simulado = Extra_final,
        !.    


simular_jugada(Jugador,Fabrica,Color,Fila,Tablero_simulado,Extra_simulado):-
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
        get_datos_fab(Fabrica,Azulejos),
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
        index(Azulejos,Color,Count_color), 
    %Guardar [Tablero] y [Extra] del jugador actual
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
    
    %Realizar modificaciones en tablero
        index(Tablero,Fila,Fila_nueva),
        index(Fila_nueva,1,Cant_en_fila),
        Len_fila is Fila+1,
        suma(Cant_en_fila, Count_color,Cant_en_fila_nueva),
        min(Cant_en_fila_nueva, Len_fila,Cant_en_fila_final),
        Resto is Cant_en_fila_nueva - Cant_en_fila_final,
        
        %falta crear la tapa y condicionar el Extra
        Extra_nuevo is Extra + Resto,
        min(Extra_nuevo,7,Extra_final),
        % write('El nuevo campo extra tiene '), write(Extra_nuevo),write(' azulejos'),nl,
        set_x_in_pos(Color,0,Fila_nueva,Fila_final0),
        set_x_in_pos(Cant_en_fila_final,1,Fila_final0,Fila_final),
        Tablero_nuevo = Tablero,
        set_x_in_pos(Fila_final,Fila,Tablero_nuevo,Tablero_final),
        %set_datos_jug(Jugador,Tablero_final,Muro,Extra_nuevo,Puntuacion),
        Tablero_simulado = Tablero_final,
        Extra_simulado = Extra_final,
        !.    

    
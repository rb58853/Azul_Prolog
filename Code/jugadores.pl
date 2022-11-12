:-dynamic jugador_actual/1.
:-dynamic cantidad_jugadores/1.

:- dynamic jugador/5.

set_datos_jug(N,Tablero,Muro,Extra,Puntuacion):-
        retractall(jugador(N,_,_,_,_)),
        asserta(jugador(N,Tablero,Muro,Extra,Puntuacion)).

get_datos_jug(N,Tablero,Muro,Extra,Puntuacion):-
    jugador(N,Tablero_,Muro_,Extra_,Puntuacion_),
    Tablero = Tablero_,
    Muro = Muro_,
    Extra = Extra_,
    Puntuacion = Puntuacion_.
    
%JugadorActual
    set_jugador_actual(Actual):-
        retractall(jugador_actual(_)),
        asserta(jugador_actual(Actual)),!.

    get_jugador_actual(Actual):-
        jugador_actual(Actual_), Actual is Actual_.

    proximo_jugador():- 
        jugador_actual(Actual),
        cantidad_jugadores(Cant_jugadores),
        Temp is Actual+1,Proximo is Temp mod Cant_jugadores,
        set_jugador_actual(Proximo),!.
    
    set_cant_jug(N):-
        retractall(cantidad_jugadores(_)),
        asserta(cantidad_jugadores(N)),
        write('Se unieron '),write(N), write(' jugadores a la partida.'),nl,
        set_jugador_actual(0),!.

%Iniciar Jugadores
    iniciar_jugadores():-
        ini_jug(0),
        write('Se inicializaron los tableros, muro, puntuacion y campo extra de cada jugador,
        cada uno vacio'),!.
    ini_jug(N):-
        set_datos_jug(N,
        [[-1,0],[-1,0],[-1,0],[-1,0],[-1,0]],
        [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]],
        0,
        0),
        cantidad_jugadores(Count),
        N1 is N+1, N1 < Count, ini_jug(N1);!.


extra(0,0).
extra(1,-1).
extra(2,-2).
extra(3,-4).
extra(4,-6).
extra(5,-8).
extra(6,-11).
extra(7,-14).
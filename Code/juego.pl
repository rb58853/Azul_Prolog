:-[fabricas].

:- dynamic muro/1.
:- dynamic terminado/1.

set_muro():-
    retractall(muro(_)),
    asserta(muro([[0,1,2,3,4],[4,0,1,2,3],[3,4,0,1,2],[2,3,4,0,1],[1,2,3,4,0]])).

get_muro(Azulejos):-
    muro(Azulejos_), Azulejos = Azulejos_.

iniciar_juego():-
    retractall(terminado(_)),
    asserta(terminado(0)),
    set_muro(),
    set_datos_mesa([0,0,0,0,0],1),
    iniciar_bolsa(),
    llenar_fabricas(), %fabrica.44
    write(' Se inicializan los muros, la mesa en [0,0,0,0,0] y la bolsa del juego, y se llenan las fabricas.'),nl.


mostrar_juego():-
    write('||||||||||||||||||||FABRICAS|||||||||||||||||||||'),nl,
    mostrar_fabricas(0),nl,
    mostrar_mesa(),nl,
    write('||||||||||||||||||||JUGADORES|||||||||||||||||||||'),nl,
    mostrar_jugadores(0),nl,!.


mostrar_fabricas(N):-
    write('Fabrica #'),write(N), write(' : '),
    get_datos_fab(N,Azulejos),
    write(Azulejos),nl,
    N1 is N+1,
    cantidad_fabricas(Len),
    N1<Len,
    mostrar_fabricas(N1);!.

mostrar_mesa():-    
    write('Mesa: '),nl,
    get_datos_mesa(Azulejos,Ficha),
    write(Azulejos),write('   ficha: '),write(Ficha),nl,!.

mostrar_jugadores(N):-
    get_datos_jug(N,Tablero,Muro,Extra,Puntuacion),
    write('JUGADOR #'),write(N),nl,write('Tablero:'),nl,
    pintar_tablero(Tablero),
    write('Muro: '),nl,
    pintar_muro(Muro),
    write('Puntuacion : '),write(Puntuacion),nl,
    write('Extra : '),write(Extra),nl,
    write('_______________________________________'),nl,
    N1 is N+1,
    cantidad_jugadores(Len),
    N1<Len,
    mostrar_jugadores(N1);!.

pintar_tablero(Tablero):-
    write(Tablero),nl,!.

pintar_muro(Muro):-
    index(Muro,0,F0),index(Muro,1,F1),index(Muro,2,F2),
    index(Muro,3,F3),index(Muro,4,F4),
    write(F0),nl,
    write(F1),nl,
    write(F2),nl,
    write(F3),nl,
    write(F4),nl,!.

get_fin(Termino):-
    terminado(Termino),!.
finalizar_juego():-
    retractall(terminado(_)),
    asserta(terminado(1)),
    !.   
:-[tools].
:-[jugadores].

:- dynamic fabrica/2.
:- dynamic mesa/2.
:- dynamic cantidad_fabricas/1.
:- dynamic ficha_mesa/1.

pop_ficha(Jugador):-
    ficha_mesa(Jugador),
    retractall(ficha_mesa(_)),!.

    reset_datos_fab(N):-
        set_datos_fab(N,[0,0,0,0,0]).

    set_datos_fab(N,Azulejos):-
        retractall(fabrica(N,_)),
        asserta(fabrica(N,Azulejos)).
    
    set_dato_simple_fab(No_fab,Color):-
        get_datos_fab(No_fab,Azulejos),
        index(Azulejos,Color,Cant),
        Cant_nueva is Cant + 1,
        set_x_in_pos(Cant_nueva,Color,Azulejos,Azulejos_nuevos),
        set_datos_fab(No_fab,Azulejos_nuevos),!.

%get_datos_fabrica
    get_datos_fab(N,Azulejos):-
        fabrica(N,Azulejos_),
        Azulejos = Azulejos_,
        !.

set_cant_fab(N):-
    retractall(cantidad_fabricas(_)),
    asserta(cantidad_fabricas(N)),
    set_fab_vacias(0),
    write('Se crean '),write(N),write(' fabricas vacias para el juego.'),nl.
get_cant_fab(N):-
    cantidad_fabricas(N),!.

set_fab_vacias(N):-
    reset_datos_fab(N),
    N1 is N+1,
    cantidad_fabricas(Len),
    N1 < Len,
    set_fab_vacias(N1);!.

llenar_fabricas():-
    llenar_fab(0),!.

llenar_fab(N):-
    llenar_la_fabrica(N),
    N1 is N+1,
    cantidad_fabricas(Len),
    N1 < Len,
    llenar_fab(N1);!.

llenar_la_fabrica(N):-
    add_to_fab(N,0),!.


fabrica_vacia(N):-
    get_datos_fab(N,Azulejos),
    index(Azulejos,0,A0),index(Azulejos,1,A1),index(Azulejos,2,A2),
    index(Azulejos,3,A3),index(Azulejos,4,A4),
    A0 == 0,A1 == 0,A2 == 0,A3 == 0,A4 == 0,!.

todo_vacio():-
    cantidad_fabricas(Len),
    Len1 is Len+1,
    todo_vacio1(0,Len1),!.

todo_vacio1(N,Len):-
    N>=Len;
    N<Len,
    fabrica_vacia(N),
    N1 is N+1,
    todo_vacio1(N1,Len),!.    


set_datos_mesa(Azulejos,Bool_chapa):-
    retractall(mesa(_,_)),
    asserta(mesa(Azulejos,Bool_chapa)),
    cantidad_fabricas(Cant),
    retractall(fabrica(Cant,_)),
    set_datos_fab(Cant,Azulejos),!
    .

get_datos_mesa(Azulejos,Bool_chapa):-
    mesa(Azulejos_, Bool_),
    Azulejos = Azulejos_,
    Bool_chapa is Bool_.


%Dado la mesa, una fabrica y un color, pasar el resto de la fabrica distinta d color hacia la mesa
    
    tratar_con_mesa(Num_color):-
        get_datos_mesa(Azulejos_mesa,Ficha),
        set_x_in_pos(0,Num_color,Azulejos_mesa,Azulejos_nuevos),
        set_datos_mesa(Azulejos_nuevos,0),
        Ficha == 1, 
        get_jugador_actual(Jugador),
        retractall(ficha_mesa(_)),
        asserta(ficha_mesa(Jugador));!.
    
    tratar_con_fabrica(Fabrica,Num_color):-
        get_datos_mesa(Azulejos_mesa,Bool_chapa),
        get_datos_fab(Fabrica,Azulejos_fabrica),

        suma_listas_5(Azulejos_mesa,Azulejos_fabrica,Color),

        %   La estrategia que se sigue a continuacion es sumar y hayar modulo de esa forma
        %nunk se llega al numero que no se desea sumar a la mesa
            
            suma_mod_M(Num_color,1,5,T0),
            index(Color,T0,Color0),
            set_x_in_pos( Color0,T0,Azulejos_mesa,Azulejos_nuevos_0),
        
            suma_mod_M(T0,1,5,T1),
            index(Color,T1,Color1),
            set_x_in_pos( Color1,T1,Azulejos_nuevos_0,Azulejos_nuevos_1),

            suma_mod_M(T1,1,5,T2),
            index(Color,T2,Color2),
            set_x_in_pos(Color2,T2,Azulejos_nuevos_1,Azulejos_nuevos_2),

            suma_mod_M(T2,1,5,T3),
            index(Color,T3,Color3),
            set_x_in_pos( Color3,T3,Azulejos_nuevos_2,Azulejos_nuevos_3),

        reset_datos_fab(Fabrica),    
        set_datos_mesa(Azulejos_nuevos_3,Bool_chapa),!.

    nueva_mesa(Fabrica,Num_color):-
        get_cant_fab(Cant_fab),
        Fabrica < Cant_fab,
        tratar_con_fabrica(Fabrica,Num_color),!;
        
        tratar_con_mesa(Num_color),!.

        
        
        

        
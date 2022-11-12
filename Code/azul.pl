:-[tools].
:-[jugadores].
:-[juego].
:-[fabricas].
:-[jugada].
:-[bolsa].
:-[jugada].
:-[puntuacion].

:-dynamic llego_el_fin/1.


inicio(Cant_jug):-
    Cant_fab is Cant_jug*2 +1,
    set_cant_jug(Cant_jug),
    set_cant_fab(Cant_fab),
    retractall(llego_el_fin(_)),
    asserta(llego_el_fin(0)),
    iniciar_juego(),
    reset_mejor_jugada(),
    iniciar_jugadores(),!.    

jugar_hasta_el_final():-
    jugar_sin_mostrar(),
    % jugar(),
    llego_el_fin(Final),
    Final == 0,
    jugar_hasta_el_final().

jugar():-
    llego_el_fin(Final),
    Final == 0,
    ejecutar_pruebas(),
    get_mejor_jugada(Fabrica,Color,Fila,_),
    jugar1(Fabrica,Color,Fila),
    mostrar_juego(),
    todo_vacio(),
    reset(),!;
    1 == 1,
    !.

jugar_sin_mostrar():-
    llego_el_fin(Final),
    Final == 0,
    ejecutar_pruebas(),
    get_mejor_jugada(Fabrica,Color,Fila,_),
    jugar1s(Fabrica,Color,Fila),
    todo_vacio(),
    reset(),!;
    1 == 1,
    !.


reset():-
    set_datos_mesa([0,0,0,0,0],1),
    pop_ficha(Proximo),
    set_jugador_actual(Proximo),
    ejecutar_todo();
    terminar(),
    fin(),
    llenar_fabricas(),
    write('/////////////////////////////////////////////COMENZO NUEVO TURNO/////////////////////////////////////////////'),nl,
    mostrar_juego(),!.

fin():-
    get_fin(Fin),
    Fin \= 1,!.

terminar():-
    get_fin(Fin),
    Fin == 1,
    retractall(llego_el_fin(_)),
    asserta(llego_el_fin(1)),
    write('<<<<<<<<<<<<<<<<<<<< EL JUEGO HA FINALIZADO >>>>>>>>>>>>>>>>>>>>>>>>'),nl,
    write('<<<<<<<<<<<<<<<<<<<< RESULTADO DEL JUEGO : >>>>>>>>>>>>>>>>>>>>>>>>'),nl,
    cerrar_puntuacion(),
    mostrar_juego(),
    write('<<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>><<<FIN>>>'),!;
    1 == 1,!. % lo kiero true.

jugar1(Fabrica,Color,5):-
    cantidad_fabricas(No_mesa),
    Fabrica == No_mesa,
    jugar_en_mesa(Fabrica,Color,Fila),!;
        
    %Guardar en [Jugador] el # del jugador actual 
        jugador_actual(Jugador),
        write('Juega el jugador #'),write(Jugador),nl,
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
        get_datos_fab(Fabrica,Azulejos),
        write('Selecciona la fabrica #'),write(Fabrica),nl,
        write('La fabrica seleccionada tiene los azulejos: '),write(Azulejos),nl,
        write('Selecciona la fila extra'),nl,
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
        index(Azulejos,Color,Count_color), 
        write('Selecciona el color #'),write(Color),
        write(', este tiene una cantidad de repeticiones '),write(Count_color),
        write(' en la fabrica seleccionada.'),nl,
    %Guardar [Tablero] y [Extra] del jugador actual
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        write('El tablero antes de la jugada del jugador es '),write(Tablero),nl,
        write('La cantidad de fichas en el campo extra antes de la jugada del jugador es '),
        write(Extra),nl,
    
    %Realizar modificaciones en tablero
        Resto is Count_color,
        push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
        
        Extra_nuevo is Extra + Resto,
        min(Extra_nuevo,7,Extra_final),
        write('El nuevo campo extra tiene '), write(Extra_final),write(' azulejos'),nl,
        
        set_datos_jug(Jugador,Tablero,Muro,Extra_final,Puntuacion),
        write('El nuevo tablero del jugador es '),write(Tablero),nl,

    %Actualizar la mesa
        nueva_mesa(Fabrica,Color),
        reset_mejor_jugada(),
        proximo_jugador(),
        !.             

jugar1(Fabrica,Color,Fila):-
    cantidad_fabricas(No_mesa),
    Fabrica == No_mesa,
    jugar_en_mesa(Fabrica,Color,Fila),!;
    
    Fila < 5,
    %Guardar en [Jugador] el # del jugador actual 
        jugador_actual(Jugador),
        write('Juega el jugador #'),write(Jugador),nl,
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
        get_datos_fab(Fabrica,Azulejos),
        write('Selecciona la fabrica #'),write(Fabrica),nl,
        write('La fabrica seleccionada tiene los azulejos: '),write(Azulejos),nl,
        write('Selecciona la fila #'),write(Fila),nl,
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
        index(Azulejos,Color,Count_color), 
        write('Selecciona el color #'),write(Color),
        write(', este tiene una cantidad de repeticiones '),write(Count_color),
        write(' en la fabrica seleccionada.'),nl,
    %Guardar [Tablero] y [Extra] del jugador actual
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        write('El tablero antes de la jugada del jugador es '),write(Tablero),nl,
        write('La cantidad de fichas en el campo extra antes de la jugada del jugador es '),
        write(Extra),nl,
    
    %Realizar modificaciones en tablero
        index(Tablero,Fila,Fila_nueva),
        index(Fila_nueva,1,Cant_en_fila),
        Len_fila is Fila+1,
        suma(Cant_en_fila, Count_color,Cant_en_fila_nueva),
        min(Cant_en_fila_nueva, Len_fila,Cant_en_fila_final),
        Resto is Cant_en_fila_nueva - Cant_en_fila_final,
        push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
        
        %falta crear la tapa y condicionar el Extra
        Extra_nuevo is Extra + Resto,
        min(Extra_nuevo,7,Extra_final),
        write('El nuevo campo extra tiene '), write(Extra_final),write(' azulejos'),nl,
        set_x_in_pos(Color,0,Fila_nueva,Fila_final0),
        set_x_in_pos(Cant_en_fila_final,1,Fila_final0,Fila_final),
        Tablero_nuevo = Tablero,
        set_x_in_pos(Fila_final,Fila,Tablero_nuevo,Tablero_final),
        set_datos_jug(Jugador,Tablero_final,Muro,Extra_final,Puntuacion),

        write('El nuevo tablero del jugador es '),write(Tablero_final),nl,

    %Actualizar la mesa
        nueva_mesa(Fabrica,Color),
        reset_mejor_jugada(),
        proximo_jugador(),
        !.    
    
jugar1(Fabrica,Color,5):-
    cantidad_fabricas(No_mesa),
    Fabrica == No_mesa,
    jugar_en_mesa(Fabrica,Color,Fila),!;
        
    %Guardar en [Jugador] el # del jugador actual 
        jugador_actual(Jugador),
        write('Juega el jugador #'),write(Jugador),nl,
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
        get_datos_fab(Fabrica,Azulejos),
        write('Selecciona la fabrica #'),write(Fabrica),nl,
        write('La fabrica seleccionada tiene los azulejos: '),write(Azulejos),nl,
        write('Selecciona la fila extra'),nl,
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
        index(Azulejos,Color,Count_color), 
        write('Selecciona el color #'),write(Color),
        write(', este tiene una cantidad de repeticiones '),write(Count_color),
        write(' en la fabrica seleccionada.'),nl,
        %Guardar [Tablero] y [Extra] del jugador actual
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        write('El tablero antes de la jugada del jugador es '),write(Tablero),nl,
        write('La cantidad de fichas en el campo extra antes de la jugada del jugador es '),
        write(Extra),nl,
    
    %Realizar modificaciones en tablero
        Resto is Count_color,
        push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
        
        Extra_nuevo is Extra + Resto,
        min(Extra_nuevo,7,Extra_final),
        write('El nuevo campo extra tiene '), write(Extra_final),write(' azulejos'),nl,
        
        set_datos_jug(Jugador,Tablero,Muro,Extra_final,Puntuacion),
        write('El nuevo tablero del jugador es '),write(Tablero),nl,

    %Actualizar la mesa
        nueva_mesa(Fabrica,Color),
        reset_mejor_jugada(),
        proximo_jugador(),
        !.             


jugar_en_mesa(Fabrica,Color,5):-
    %Guardar en [Jugador] el # del jugador actual 
    jugador_actual(Jugador),
    write('Juega el jugador #'),write(Jugador),nl,
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
    get_datos_fab(Fabrica,Azulejos),
    write('Selecciona la mesa'),nl,
    write('La fabrica seleccionada tiene los azulejos: '),write(Azulejos),nl,
    write('Selecciona la fila extra'),nl,
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
    index(Azulejos,Color,Count_color), 
    write('Selecciona el color #'),write(Color),
    write(', este tiene una cantidad de repeticiones '),write(Count_color),
    write(' en la fabrica seleccionada.'),nl,
    %Guardar [Tablero] y [Extra] del jugador actual
    get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
    write('El tablero antes de la jugada del jugador es '),write(Tablero),nl,
    write('La cantidad de fichas en el campo extra antes de la jugada del jugador es '),
    write(Extra),nl,

    %Realizar modificaciones en tablero
    Resto is Count_color,
    push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
    
    %falta crear la tapa y condicionar el Extra
    mesa(_,Ficha),
    Extra_nuevo is Extra + Resto + Ficha,
    min(Extra_nuevo,7,Extra_final),
    write('El nuevo campo extra tiene '), write(Extra_final),write(' azulejos'),nl,
    
    set_datos_jug(Jugador,Tablero,Muro,Extra_final,Puntuacion),
    write('El nuevo tablero del jugador es '),write(Tablero),nl,

%Actualizar la mesa
    nueva_mesa(Fabrica,Color),
    reset_mejor_jugada(),
    proximo_jugador(),
    !.         

jugar_en_mesa(Fabrica,Color,Fila):-
    Fila < 5,
    %Guardar en [Jugador] el # del jugador actual 
        jugador_actual(Jugador),
        write('Juega el jugador #'),write(Jugador),nl,
    %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
        get_datos_fab(Fabrica,Azulejos),
        write('Selecciona la mesa'),nl,
        write('La fabrica seleccionada tiene los azulejos: '),write(Azulejos),nl,
        write('Selecciona la fila #'),write(Fila),nl,
    %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
        index(Azulejos,Color,Count_color), 
        write('Selecciona el color #'),write(Color),
        write(', este tiene una cantidad de repeticiones '),write(Count_color),
        write(' en la fabrica seleccionada.'),nl,
    %Guardar [Tablero] y [Extra] del jugador actual
        get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
        write('El tablero antes de la jugada del jugador es '),write(Tablero),nl,
        write('La cantidad de fichas en el campo extra antes de la jugada del jugador es '),
        write(Extra),nl,
    
    %Realizar modificaciones en tablero
        index(Tablero,Fila,Fila_nueva),
        index(Fila_nueva,1,Cant_en_fila),
        Len_fila is Fila+1,
        suma(Cant_en_fila, Count_color,Cant_en_fila_nueva),
        min(Cant_en_fila_nueva, Len_fila,Cant_en_fila_final),
        Resto is Cant_en_fila_nueva - Cant_en_fila_final,
        push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
        
        %falta crear la tapa y condicionar el Extra
        mesa(_,Ficha),
        Extra_nuevo is Extra + Resto + Ficha,
        min(Extra_nuevo,7,Extra_final),
        write('El nuevo campo extra tiene '), write(Extra_final),write(' azulejos'),nl,
        set_x_in_pos(Color,0,Fila_nueva,Fila_final0),
        set_x_in_pos(Cant_en_fila_final,1,Fila_final0,Fila_final),
        Tablero_nuevo = Tablero,
        set_x_in_pos(Fila_final,Fila,Tablero_nuevo,Tablero_final),
        set_datos_jug(Jugador,Tablero_final,Muro,Extra_final,Puntuacion),

        write('El nuevo tablero del jugador es '),write(Tablero_final),nl,

    %Actualizar la mesa
        nueva_mesa(Fabrica,Color),
        reset_mejor_jugada(),
        proximo_jugador(),
        !.    






jugar1s(Fabrica,Color,5):-
      %Guardar en [Jugador] el # del jugador actual 
      jugador_actual(Jugador),
      %Sacar los datos de los azulejos de la fabrica dada, Guardarlos en [Azulejos]
      get_datos_fab(Fabrica,Azulejos),
      %Guardar en [Count_color] la cantidad de azulejos d ese color en la fabrica dada
      index(Azulejos,Color,Count_color), 
      %Guardar [Tablero] y [Extra] del jugador actual
      get_datos_jug(Jugador,Tablero,Muro,Extra,Puntuacion),
      %Realizar modificaciones en tablero
      Resto is Count_color,
      push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
      
      %falta crear la tapa y condicionar el Extra
      Extra_nuevo is Extra + Resto,
      min(Extra_nuevo,7,Extra_final),
      
      set_datos_jug(Jugador,Tablero,Muro,Extra_final,Puntuacion),

  %Actualizar la mesa
      nueva_mesa(Fabrica,Color),
      reset_mejor_jugada(),
      proximo_jugador(),
      !.          
jugar1s(Fabrica,Color,Fila):-
    Fila < 5,
%Guardar en [Jugador] el # del jugador actual 
    jugador_actual(Jugador),
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
    push_x_color(Color,Resto), %agrega directo a la tapa todo lo que sobre
    
    %falta crear la tapa y condicionar el Extra
    Extra_nuevo is Extra + Resto,
    min(Extra_nuevo,7,Extra_final),
    set_x_in_pos(Color,0,Fila_nueva,Fila_final0),
    set_x_in_pos(Cant_en_fila_final,1,Fila_final0,Fila_final),
    Tablero_nuevo = Tablero,
    set_x_in_pos(Fila_final,Fila,Tablero_nuevo,Tablero_final),
    set_datos_jug(Jugador,Tablero_final,Muro,Extra_final,Puntuacion),
%Actualizar la mesa
    nueva_mesa(Fabrica,Color),
    reset_mejor_jugada(),
    proximo_jugador(),
    !.    
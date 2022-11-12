:-[fabricas].
:-[tools].
:-[juego].

:- dynamic bolsa/1.
:- dynamic countbolsa/1.
:- dynamic color_cant/2.

iniciar_bolsa():-
   asserta(countbolsa(0)),
   ini_20_azulejos_por_color(),
   add_all_azulejos_a_bolsa(),!.   

len_bolsa(Len):-
   countbolsa(Len),!.
   
push(Nuevo_color) :-
   countbolsa(Count),
   Count_nuevo is Count+1,
   retractall(countbolsa(_)),
   asserta(countbolsa(Count_nuevo)),
   asserta(bolsa(Nuevo_color)),!.

pop(Dato):-
   countbolsa(Count),
   Count>0,
   pop1(Dato),!;
   
   tapa_vacia(), finalizar_juego(),!;
   add_all_azulejos_a_bolsa(),
   pop1(Dato),!.
   
pop1(Dato) :-
   countbolsa(Count),
   Count_nuevo is Count - 1,
   retractall(countbolsa(_)),
   asserta(countbolsa(Count_nuevo)),
   retract(bolsa(Dato)),
   !.

add_to_fab(No_fabrica, Cont):-
   get_fin(Termino),
   Termino == 0,
   Cont < 4,
   pop(Color),
   set_dato_simple_fab(No_fabrica,Color),
   Cont1 = Cont+1,
   add_to_fab(No_fabrica,Cont1);!.

limpiar_bolsa():-
   retractall(bolsa(_)),
   retractall(countbolsa(_)),
   asserta(countbolsa(0)),!.
   
ini_20_azulejos_por_color():-
   asserta(color_cant(0,20)),
   asserta(color_cant(1,20)),
   asserta(color_cant(2,20)),
   asserta(color_cant(3,20)),
   asserta(color_cant(4,20)),!.

tapa_vacia():-
   color_cant(0,0),
   color_cant(1,0),
   color_cant(2,0),
   color_cant(3,0),
   color_cant(4,0),!.
   
ver_colores_tapa():-
   color_cant(0,C0),
   color_cant(1,C1),
   color_cant(2,C2),
   color_cant(3,C3),
   color_cant(4,C4),
   write('0 : '),write(C0),nl,
   write('1 : '),write(C1),nl,
   write('2 : '),write(C2),nl,
   write('3 : '),write(C3),nl,
   write('4 : '),write(C4),nl,!.

push_x_color(Color,X):-
   X1 is X - 1,
   X1>=0,
   push_color(Color),
   push_x_color(Color,X1),!;
   1==1,!. %kiero que sea true siempre

push_color(Color):-
   color_cant(Color,Cant),
   Cant1 is Cant + 1,
   retractall(color_cant(Color,_)),
   asserta(color_cant(Color,Cant1)),!.

pop_color(Color):-
   color_cant(Color,Cant),
   Cant1 is Cant - 1,
   retractall(color_cant(Color,_)),
   asserta(color_cant(Color,Cant1)),!.

add_all_azulejos_a_bolsa():-
   color_cant(0,X0),
   color_cant(1,X1),
   color_cant(2,X2),
   color_cant(3,X3),
   color_cant(4,X4),
   X is X0 + X1 + X2 + X3 + X4,
   add_N_azulejos_a_bolsa(X),!.

add_N_azulejos_a_bolsa(Cont):-
   Cont > 0,
   random(0,5,Color),
   add_azulejo_a_bolsa(Color),
   Cont1 is Cont - 1,
   add_N_azulejos_a_bolsa(Cont1);!.

add_azulejo_a_bolsa(Color):-

   color_cant(Color  ,Temp0),
   Temp0 > 0, add_color_simple_a_bolsa(Color),!;
   
   suma_mod_M(Color,1,5,Color1),
   color_cant(Color1 ,Temp1),
   Temp1 > 0, add_color_simple_a_bolsa(Color1),!;
   
   suma_mod_M(Color,2,5,Color2),
   color_cant(Color2 ,Temp2),
   Temp2 > 0, add_color_simple_a_bolsa(Color2),!;
   
   suma_mod_M(Color,3,5,Color3),
   color_cant(Color3 ,Temp3),
   Temp3 > 0, add_color_simple_a_bolsa(Color3),!;
   
   suma_mod_M(Color,4,5,Color4),
   color_cant(Color4 ,Temp4),
   Temp4 > 0, add_color_simple_a_bolsa(Color4),!.


add_color_simple_a_bolsa(Color):-
   push(Color),
   pop_color(Color),!.

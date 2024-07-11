/*
En un juego de "construya su caniería", hay piezas de distintos tipos: codos, canios y canillas.
De los codos me interesa el color, p.ej. un codo rojo.
De los canios me interesan color y longitud, p.ej. un canio rojo de 3 metros.
De las canillas me interesan: tipo (de la pieza que se gira para abrir/cerrar), color y ancho (de la boca).
P.ej. una canilla triangular roja de 4 cm de ancho.
*/

% BASE DE CONOCIMIENTO
codo(rojo).
codo(amarillo).
codo(verde).
codo(azul).

canio(rojo,3).
canio(amarillo,3).
canio(verde,4).
canio(azul,5).

canilla(triangular,rojo,4).
canilla(circular,verde,3).
canilla(cuadrada,azul,2).

extremo(rojo,izquierdo).
extremo(azul,derecho).
extremo(verde,izquierdo).
extremo(rojo,derecho).

pieza(codo(_)).
pieza(canio(_,_)).
pieza(canilla(_,_,_)).
pieza(extremo(_,_)).
% [codo(rojo), codo(amarillo), codo(verde), codo(azul), canio(rojo, 3), canio(amarillo, 3), canio(verde, 4), canio(azul, 5), canilla(triangular, rojo, 4), canilla(circular, verde, 3), canilla(cuadrada, azul, 2)].

/*
Definir un predicado que relacione una caniería con su precio. Una caniería es una lista de piezas. Los precios son:
codos: $5.
canios: $3 el metro.
canillas: las triangulares $20, el resto $12 hasta 5 cm de ancho, $15 si son de más de 5 cm.
*/
precioCodo(5).
precioCanio(Metros,Precio):-Precio is 3*Metros.

precioCanilla(triangular,_,20).
precioCanilla(_,_,Ancho,12):- 
    Ancho =< 5.
precioCanilla(_,_,Ancho,15):- 
    Ancho > 5.

precio_pieza(codo(_), Precio) :-
    precioCodo(Precio).
    
precio_pieza(canio(_, Metros), Precio) :-
    precioCanio(Metros, Precio).
    
precio_pieza(canilla(Forma, _, Ancho), Precio) :-
    precioCanilla(Forma, _, Ancho, Precio).

precioCanieria([], 0).
precioCanieria([Pieza|Resto], PrecioTotal) :-
    precio_pieza(Pieza, PrecioPieza),
    precioCanieria(Resto, PrecioResto),
    PrecioTotal is PrecioPieza + PrecioResto.

% Definir el predicado puedoEnchufar/2, tal que puedoEnchufar(P1,P2) se verifique si puedo enchufar P1 a la izquierda de P2. 
% Puedo enchufar dos piezas si son del mismo color, o si son de colores enchufables. 
% Las piezas azules pueden enchufarse a la izquierda de las rojas, y las rojas pueden enchufarse a la izquierda de las negras. 
% Las azules no se pueden enchufar a la izquierda de las negras, tiene que haber una roja en el medio. P.ej.
% sí puedo enchufar (codo rojo, canio negro de 3 m).
% sí puedo enchufar (codo rojo, canio rojo de 3 m) (mismo color).
% no puedo enchufar (canio negro de 3 m, codo rojo) (el rojo tiene que estar a la izquierda del negro).
% no puedo enchufar (codo azul, canio negro de 3 m) (tiene que haber uno rojo en el medio).

colorPieza(codo(Color), Color).
colorPieza(canio(Color,_), Color).
colorPieza(canilla(_,Color,_), Color).
colorPiezaExtremo(extremo(Color,_), Color).

% sonEnchufables(C1,C2):- C1 == C2.
% sonEnchufables(C1,C2):- C1 == azul, C2 == rojo.
% sonEnchufables(C1,C2):- C1 == rojo, C2 == negro.

sonEnchufables(C1, C2) :- C1 = C2.
sonEnchufables(azul, rojo).
sonEnchufables(rojo, negro).

ultimoElemento([Head|Tail],Head):- length(Tail, 0).
ultimoElemento([_|Tail],Ultimo):- ultimoElemento(Tail,Ultimo).
% Consultar si hay otra forma de hacerlo 

puedoEnchufar(extremo(C1,izquierdo), P2) :-
    colorPieza(P2, C2),
    sonEnchufables(C1, C2).

puedoEnchufar(P1, extremo(C2,derecho)) :-
    colorPieza(P1, C1),
    sonEnchufables(C1, C2).

puedoEnchufar(extremo(C1,izquierdo), extremo(C2,derecho)) :-
    sonEnchufables(C1, C2).

puedoEnchufar(extremo(C1,izquierdo),[P2|_]):-
    colorPieza(P2,C2),
    sonEnchufables(C1,C2),
    P2 \= extremo(_,izquierdo).
     
puedoEnchufar([P|Resto1],extremo(C2,derecho)) :-
    ultimoElemento([P|Resto1],P1),
    colorPieza(P1,C1),
    sonEnchufables(C1,C2),
    P1 \= extremo(_,derecho).
    
puedoEnchufar(Canieria,[P2|_]):- 
    ultimoElemento(Canieria,P1),
    colorPieza(P1,C1),
    colorPieza(P2,C2),
    sonEnchufables(C1,C2),
    P2 \= extremo(_,izquierdo),
    P1 \= extremo(_,derecho).

puedoEnchufar(P1, P2) :-
    colorPieza(P1, C1),
    colorPieza(P2, C2),
    sonEnchufables(C1, C2).

puedoEnchufar(P1,[P2|_]):-
    colorPieza(P1,C1),
    colorPieza(P2,C2),
    sonEnchufables(C1,C2).

puedoEnchufar(P1,[P2|_]):-
    colorPieza(P1,C1),
    P2 = extremo(_,derecho),
    colorPiezaExtremo(P2, C2),
    sonEnchufables(C1,C2).

puedoEnchufar([P|Resto1],P2):-
    ultimoElemento([P|Resto1],P1),
    colorPieza(P1,C1),
    colorPieza(P2,C2),
    sonEnchufables(C1,C2).

puedoEnchufar(Canieria,[P2|_]):-
    ultimoElemento(Canieria,P1),
    colorPieza(P1,C1),
    colorPieza(P2,C2),
    sonEnchufables(C1,C2).

% Modificar el predicado puedoEnchufar/2 de forma tal que pueda preguntar por elementos sueltos o por canierías ya armadas. 
% P.ej. una caniería (codo azul, canilla roja) la puedo enchufar a la izquierda de un codo rojo (o negro), 
% y a la derecha de un canio azul. Ayuda: si tengo una caniería a la izquierda, ¿qué color tengo que mirar? 
% Idem si tengo una caniería a la derecha.

% Definir un predicado canieriaBienArmada/1, que nos indique si una caniería está bien armada o no. 
% Una caniería está bien armada si a cada elemento lo puedo enchufar al inmediato siguiente, de acuerdo a lo indicado 
% al definir el predicado puedoEnchufar/2.

canieriaBienArmada([_|Resto]):-length(Resto,0).
canieriaBienArmada([P|Resto]):-
    puedoEnchufar(P,Resto),
    canieriaBienArmada(Resto).
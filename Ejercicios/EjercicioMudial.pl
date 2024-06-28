% Punto 1: Acciones del partido
% Conocemos el nombre de cada jugador y las acciones que fueron pasando en el partido.
% Las cuales son:
% el dibu hizo una atajada en el minuto 122. También, en la tanda de penales atajó 2 de ellos.
% messi metió 2 goles, uno en el minuto 108 de jugada y otro en el minuto 23 de penal. A su vez, 
% también metió el primer penal de la tanda.
% montiel metió el último penal de la tanda de penales.
% Se pide modelar la base de conocimientos con las acciones y quienes las realizaron.

jugador(messi).
jugador(elDibu).
jugador(montiel).
jugador(mbappe).
jugador(armani).

accion(elDibu, atajada(122)).
accion(elDibu, atajadaPenal(2)).
accion(messi, gol(108)).
accion(messi, gol(23)).
accion(messi, penal(1)).
accion(montiel, penal(5)).
accion(armani, roja(2, mbappe)).

% En las atajadas y en los goles me interesa en que tiempo, mientras que en los penales el "orden".
% Invente accion roja que es la tarjeta rojo, de la que me interesa en que tiempo y quien se la hizo.

% Punto 2: Puntajes de las acciones
% Queremos saber cuantos puntos suma cada acción. Los cuales son calculados de la siguiente forma:
% Para las atajadas tanda de penales, suman 15 * la cantidad que se hayan atajado
% Para las otras atajadas, el puntaje se calcula como el minuto en el que ocurrió más 10
% Para los goles, se calcula como el minuto en el que se metió más 20
% Por último, para los penales que se metieron, en caso de que sea el primero suma  45 puntos mientras 
% que si es el último suma 80 puntos
% También, queremos saber cuantos puntos suma cada jugador. Es necesario que este predicado sea inversible.

puntaje(atajadaPenal(N),P):-
    P is N*15.

puntaje(atajada(T),P):-
    P is T + 10.

puntaje(gol(T),P):-
    P is T + 20.

puntaje(roja(T,mbappe),P):-
    P is 100*T.

puntaje(roja(T,Jugador),P):-
    Jugador \= mbappe,
    P is -T.

puntaje(penal(1),45).

puntaje(penal(5),80).

puntajeJugador(Jugador,Puntaje):-
    accion(Jugador,Accion),
    puntaje(Accion,Puntaje).

puntosJugador(Jugador,Puntos):-   %Conviene tener una lista de puntos que una lista de acciones.
    jugador(Jugador),
    findall(Puntaje, puntajeJugador(Jugador,Puntaje), Puntajes),
    sum_list(Puntajes, Puntos).
    

% sumarPuntaje([X|Xs],P,Pacum):-
%     puntaje(X,P),
%     Pacum is Pacum + P,
%     sumarPuntaje(Xs,P,Pacum).

% sumarPuntaje([],0,_).

% puntajeJugador(Jugador,Puntaje):-
%     jugador(Jugador),
%     findall(Accion, accion(Jugador,Accion), Acciones),
%     sumarPuntaje(Acciones,_,Puntaje).
    
% Punto 3: Puntaje total
% Dada una lista de jugadores, queremos saber cuantos puntos sumaron todos. 

puntosTotales(Jugadores,Puntos):-
    findall(Puntos,(member(Jugador, Jugadores),puntosJugador(Jugador,Puntos)),Puntaje),
    sum_list(Puntaje,Puntos).
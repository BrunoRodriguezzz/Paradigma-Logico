% Sabemos que Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas Doradas. Alf, en cambio, se va a 
% Bariloche, San Martín de los Andes y El Bolsón. Nico se va a Mar del Plata, como siempre. Y Vale se va para Calafate y El Bolsón.

% Además Martu se va donde vayan Nico y Alf. 
% Juan no sabe si va a ir a Villa Gesell o a Federación
% Carlos no se va a tomar vacaciones por ahora

% Se pide que defina los predicados correspondientes, y justifique sus decisiones en base a conceptos vistos en la cursada.

aDondeVa(dodain, pehuenia).
aDondeVa(dodain, sanMa).
aDondeVa(dodain, esquel).
aDondeVa(dodain, sarmiento).
aDondeVa(dodain, camarones).
aDondeVa(dodain, playasDoradas).
aDondeVa(alf, bariloche).
aDondeVa(alf, sanMa).
aDondeVa(alf, bolson).
aDondeVa(nico, marDel).
aDondeVa(vale, calafate).
aDondeVa(vale, bolson).

aDondeVa(martu, Lugar):-
    aDondeVa(nico, Lugar).
aDondeVa(martu, Lugar):-
    aDondeVa(alf, Lugar).

persona(Persona):-
    aDondeVa(Persona,_).

% Por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar
% Por principio de universo cerrado, lo desconocido se presume falso

% Incorporamos ahora información sobre las atracciones de cada lugar. Las atracciones se dividen en
%     un parque nacional, donde sabemos su nombre
%     un cerro, sabemos su nombre y la altura
%     un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si se puede pescar y la temperatura promedio del agua
%     una playa: tenemos la diferencia promedio de marea baja y alta
%     una excursión: sabemos su nombre

% Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo modelaría las atracciones. Por ejemplo: Esquel tiene como 
% atracciones un parque nacional (Los Alerces) y dos excursiones (Trochita y Trevelin). Villa Pehuenia tiene como atracciones un cerro 
% (Batea Mahuida de 2.000 m) y dos cuerpos de agua (Moquehue, donde se puede pescar y tiene 14 grados de temperatura promedio y Aluminé, 
%     donde se puede pescar y tiene 19 grados de temperatura promedio).

atraccion(esquel, paraqueNacional(losAlerces)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(travelin)).
atraccion(villaPehuenia, cerro(bateaMahuida, 2000)).
atraccion(villaPehuenia, cuerpoAgua(moquehue, puedePescar, 14)).
atraccion(villaPehuenia, cuerpoAgua(alumine, puedePescar, 19)).
atraccion(marDel, playa(4)).

% Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a visitar tienen por lo menos una atracción copada. 
%   un cerro es copado si tiene más de 2000 metros
%   un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20
%   una playa es copada si la diferencia de mareas es menor a 5
%   una excursión que tenga más de 7 letras es copado
%   cualquier parque nacional es copado
%   El predicado debe ser inversible. 

vacacionesCopadas(Persona):-
    aDondeVa(Persona,_),
    forall(aDondeVa(Persona,Lugar), tieneAtraccionCopada(Lugar)).

tieneAtraccionCopada(Lugar):-
    atraccion(Lugar, Atraccion), 
    atraccionCopada(Atraccion).

atraccionCopada(cerro(_,Altura)):-
    atraccion(_,cerro(_,Altura)),
    Altura > 2000.

atraccionCopada(cuerpoAgua(_,puedePescar, T)):-
    atraccion(_,cuerpoAgua(_,puedePescar, T)), % Para que sea inversible
    T > 20.

atraccionCopada(playa(DiferenciaEntreNiveles)):-
    atraccion(_,playa(DiferenciaEntreNiveles)), % Para que sea inversible
    DiferenciaEntreNiveles < 5.

atraccionCopada(paraqueNacional(_)).

atraccionCopada(excursion(Nombre)):-
    atraccion(_,excursion(Nombre)), % Para que sea inversible
    atom_length(Nombre, Tamanio),
    Tamanio > 7.

% Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. Por ejemplo, Dodain no se cruzó con Nico 
% ni con Vale (sí con Alf en San Martín de los Andes). Vale no se cruzó con Dodain ni con Nico (sí con Alf en El Bolsón). El predicado debe ser 
% completamente inversible.

noCoincide(Persona1, Persona2):-
    aDondeVa(Persona1,_),
    aDondeVa(Persona2,_),
    forall(aDondeVa(Persona1, Lugar), not(aDondeVa(Persona2, Lugar))).

% Punto 4: Vacaciones gasoleras (2 puntos)

costoVida(sarmiento,100).
costoVida(esquel,150).
costoVida(pehuenia,180).
costoVida(sanMa, 150).
costoVida(camarones,135).
costoVida(playasDoradas,170).
costoVida(bariloche,140).
costoVida(calafate,240).
costoVida(bolson,145).
costoVida(marDel,140).

% Queremos saber si unas vacaciones fueron gasoleras para una persona. Esto ocurre si todos los destinos son gasoleros, es decir, 
% tienen un costo de vida menor a 160. Alf, Nico y Martu hicieron vacaciones gasoleras.
% El predicado debe ser inversible.

vacacionesGasoleras(Persona):-
    aDondeVa(Persona,_),
    forall(aDondeVa(Persona, Lugar),(costoVida(Lugar, CtoVida),CtoVida < 160)).

% Queremos conocer todas las formas de armar el itinerario de un viaje para una persona sin importar el recorrido. Para eso todos los destinos 
% tienen que aparecer en la solución (no pueden quedar destinos sin visitar).

itinerario(Persona, Itinerario):-
    aDondeVa(Persona,_),
    findall(Lugar, aDondeVa(Persona, Lugar), Lugares),
    permutacion(Lugares, Itinerario).

% Caso base: la permutación de una lista vacía es una lista vacía.
permutacion([], []).

% Caso recursivo: selecciona un elemento E de la lista [E|Es], permuta el resto de la lista,
% y luego inserta E en todas las posiciones posibles de cada permutación.
permutacion(L, [E|PermutacionResto]) :-
    seleccionar(E, L, Resto),
    permutacion(Resto, PermutacionResto),
    insertar(E, PermutacionResto, L).

% Selecciona un elemento de la lista, devolviendo el elemento seleccionado, y el resto de la lista sin ese elemento.
seleccionar(E, [E|Es], Es).
seleccionar(E, [X|Xs], [X|Ys]) :- seleccionar(E, Xs, Ys).

% Inserta un elemento en todas las posiciones posibles de la lista.
insertar(E, Lista, [E|Lista]).
insertar(E, [X|Xs], [X|Ys]) :- insertar(E, Xs, Ys).
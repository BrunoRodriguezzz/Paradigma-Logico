persona(harry).
persona(draco).
persona(hermione).
persona(ron).
persona(luna).

sangre(harry,mestiza).
sangre(draco,pura).
sangre(hermione,impura).

caracteriza(harry,coraje).
caracteriza(harry,amistoso).
caracteriza(harry,orgullo).
caracteriza(harry,inteligencia).
caracteriza(draco,inteligencia).
caracteriza(draco,orgullo).
caracteriza(hermione,inteligencia).
caracteriza(hermione,orgullo).
caracteriza(hermione,responsabilidad).
caracteriza(hermione,amistoso). % sino no puede haber una cadena de amistad.

odiariaQuedar(draco, hufflepuff).
odiariaQuedar(harry, slytherin).

masImportante(gryffindor, coraje).
masImportante(slytherin, orgullo).
masImportante(slytherin, inteligencia).
masImportante(ravenclaw, inteligencia).
masImportante(ravenclaw, responsabilidad).
masImportante(hufflepuff, amistoso).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

% Parte 1 - Sombrero Seleccionador

% Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, 
% que no permite entrar a magos de sangre impura.

puedeEntrar(slytherin,persona(_,sangre(Sangre),_)):-
    Sangre \= impura.

puedeEntrar(Casa,_):-
    Casa \= slytherin.

% Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características incluyen todo 
% lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.

caracterApropiado(Casa,Personaje):-
    persona(Personaje),
    casa(Casa),
    forall(masImportante(Casa,Caracteristica),caracteriza(Personaje,Caracteristica)).

% Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, 
% la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada 
% en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.

casaApropiada(hermione,gryffindor).
casaApropiada(Personaje,Casa):-
    persona(Personaje),
    casa(Casa),
    caracterApropiado(Casa,Personaje),
    not(odiariaQuedar(Personaje,Casa)).

% Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos y 
% cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual.

cadenaDeAmistades(ListaMagos):-
    forall(member(Mago,ListaMagos),caracteriza(Mago,amistoso)),
    puedeEstarCasaSiguiente(ListaMagos).

puedeEstarCasaSiguiente([_]).

puedeEstarCasaSiguiente([Mago|RestoMagos]):-
    primerElemento(RestoMagos, Mago2),
    casaApropiada(Mago, Casa),
    casaApropiada(Mago2, Casa),
    puedeEstarCasaSiguiente(RestoMagos).

primerElemento([X|_], X).

% Parte 2 - La copa de las casas

puntos(accion(fueraCama),-50).
puntos(accion(lugar(bosque)),-50).
puntos(accion(lugar(biblioteca)),-10).
puntos(accion(lugar(tercerPiso)),-75).
puntos(accion(ganarAjedrez),50).
puntos(accion(salvarAmigos),50).
puntos(accion(ganarVoldemort),60).
puntos(accion(lugar(L)),0):-
    not(lugarProhibido(L)).
puntos(accion(respuesta(_,Dificultad,Profesor)),Dificultad):-
    Profesor \= snape.
puntos(accion(respuesta(_,Dificultad,snape)),Puntos):-
    Puntos is Dificultad/2.

queHizo(harry,accion(fueraCama)).
queHizo(harry,accion(lugar(bosque))).
queHizo(harry,accion(lugar(tercerPiso))).
queHizo(harry,accion(ganarVoldemort)).
queHizo(hermione,accion(lugar(tercerPiso))).
queHizo(hermione,accion(lugar(biblioteca))).
queHizo(hermione,accion(salvarAmigos)).
queHizo(ron,accion(ganarAjedrez)).
queHizo(draco,accion(lugar(mazmorras))).
queHizo(draco,accion(ganarVoldemort)). %Para que haya un ganador

queHizo(hermione, accion(respuesta(dondeEstaBezoar, 20, snape))).
queHizo(hermione, accion(respuesta(comoLevitarPluma, 25, flitwick))).

lugarProhibido(bosque).
lugarProhibido(biblioteca).
lugarProhibido(tercerPiso).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera 
% una mala acción (que son aquellas que provocan un puntaje negativo).

buenAlumno(Mago):-
    persona(Mago),
    forall(queHizo(Mago,Accion),(puntos(Accion,P),P>0)).

% Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.

accionRecurrente(Accion):-
    queHizo(Mago1,Accion),
    queHizo(Mago2,Accion),
    Mago1 \= Mago2.

% Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.

puntajeMago(Mago, Puntos):-
    persona(Mago),
    findall(P, (queHizo(Mago,Accion),puntos(Accion,P)), ListaPuntos),
    sum_list(ListaPuntos, Puntos).

puntajeTotalCasa(Casa, Puntos):-
    casa(Casa),
    findall(P, (esDe(Mago,Casa),puntajeMago(Mago,P)), ListaDePuntos),
    sum_list(ListaDePuntos, Puntos).

% Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor 
% de puntos que todas las otras.

casaGanadora(Casa):-
    puntajeTotalCasa(Casa, Puntos),
    forall((puntajeTotalCasa(Casa2,Puntos2), Casa \= Casa2),(Puntos > Puntos2)).

% Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de 
% las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo

% respuesta(Pregunta, Dificultad, Profesor)
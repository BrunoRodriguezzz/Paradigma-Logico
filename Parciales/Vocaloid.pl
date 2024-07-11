vocaloid(megurineLuka).
vocaloid(hatsuneMiku).
vocaloid(gumi).
vocaloid(seeU).
vocaloid(kaito).

canta(megurineLuka, nightFever, 4).
canta(megurineLuka, foreverYoung, 5).
canta(hatsuneMiku, tellYourWorld, 4).
canta(gumi, foreverYoung, 4).
canta(gumi, tellYourWorld, 5).
canta(seeU, novemberRain, 6).
canta(seeU, nightFever, 5).

cancion(nightFever).
cancion(foreverYoung).
cancion(tellYourWorld).
cancion(novemberRain).

% Definir los siguientes predicados que sean totalmente inversibles, a menos que se indique lo contrario.

% Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado 
% para saber si un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería 
% ser menor a 15.

vocaloidNovedoso(Vocaloid):-
    vocaloid(Vocaloid),
    duracionMenor(Vocaloid, 15),
    sabeXCanciones(Vocaloid,NroCanciones),
    NroCanciones >= 2.

duracionMenor(Vocaloid, DuracionMax):-
    findall(Duracion, canta(Vocaloid,_,Duracion),ListaDuracion),
    sum_list(ListaDuracion, DuracionTotal),
    DuracionTotal < DuracionMax.

sabeXCanciones(Vocaloid, X):-
    vocaloid(Vocaloid),
    findall(Cancion, canta(Vocaloid,Cancion,_),ListaCanciones),
    length(ListaCanciones, X).

% Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber si un 
% cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2

cantanteAcelerado(Vocaloid):-
    vocaloid(Vocaloid),
    canta(Vocaloid,_,_),
    not((canta(Vocaloid,_,T),T>4)).

% Además de los vocaloids, conocemos información acerca de varios conciertos que se darán en un futuro no muy lejano. 
% De cada concierto se sabe su nombre, el país donde se realizará, una cantidad de fama y el tipo de concierto.

% Hay tres tipos de conciertos:
% gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y además la duración total de todas las canciones 
% tiene que ser mayor a una cantidad dada.
% mediano sólo pide que la duración total de las canciones del cantante sea menor a una cantidad cantidad determinada.
% pequenio el único requisito es que alguna de las canciones dure más de una cantidad dada.

% Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. 
% También sabemos que Hatsune Miku puede participar en cualquier concierto.

duracionMayor(Vocaloid, DuracionMin):-
    findall(Duracion, canta(Vocaloid,_,Duracion),ListaDuracion),
    sum_list(ListaDuracion, DuracionTotal),
    DuracionTotal > DuracionMin.

puedeParticiparConcierto(hatsuneMiku,_).

puedeParticiparConcierto(Vocaloid,Concierto):-
    concierto(Concierto,_,_,gigante(CantMin, DuracionMin)),
    sabeXCanciones(Vocaloid, NroCanciones),
    NroCanciones >= CantMin,
    duracionMayor(Vocaloid, DuracionMin).

puedeParticiparConcierto(Vocaloid,Concierto):-
    canta(Vocaloid,_,_),   %Para que no aparezca kaito
    concierto(Concierto,_,_,mediano(DuracionMax)),
    duracionMenor(Vocaloid, DuracionMax).

puedeParticiparConcierto(Vocaloid,Concierto):-
    concierto(Concierto,_,_,pequenio(Duracion)),
    canta(Vocaloid,_,Tiempo),
    Tiempo > Duracion.

% Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como la fama total 
% que le dan los conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar.

vocaloidMasFamoso(Vocaloid):-
    vocaloid(Vocaloid),
    fama(Vocaloid,Fama),
    forall((fama(Vocaloid2,Fama2),Vocaloid\=Vocaloid2),Fama > Fama2).

fama(Vocaloid, Fama):-
    vocaloid(Vocaloid),
    findall(F, (puedeParticiparConcierto(Vocaloid,Concierto),concierto(Concierto,_,F,_)), ListaFama),
    sum_list(ListaFama, Fama).

% Sabemos que:
%     megurineLuka conoce a hatsuneMiku  y a gumi 
%     gumi conoce a seeU
%     seeU conoce a kaito

% conce(Quien conoce, A quien).
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

% Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos 
% ya sea directo o indirectos (en cualquiera de los niveles) participa en el mismo concierto.

todosLosQueConoce(V1, V2):-
    conoce(V1,V2).

todosLosQueConoce(V1,V2):-
    conoce(V1,Vintermedio),
    todosLosQueConoce(Vintermedio,V2).

unicoQueParticipa(Vocaloid, Concierto):-
    puedeParticiparConcierto(Vocaloid, Concierto),
    forall(todosLosQueConoce(Vocaloid, V2), not(puedeParticiparConcierto(V2,Concierto))).

% Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, explique los cambios 
% que habría que realizar para que siga todo funcionando. ¿Qué conceptos facilitaron dicha implementación?

% Lo unico que habria que hacer es agregar un predicado que verifique las condiciones que deba cumplir ese nuevo concierto,
% Siguiendo la estructura anterior. Los conceptos que lo facilitaron fueron el polimorfismo y los functores.
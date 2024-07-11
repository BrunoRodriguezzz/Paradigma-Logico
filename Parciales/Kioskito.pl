atiende(dodain, lunes, horario(9,15)).
atiende(dodain, miercoles, horario(9,15)).
atiende(dodain, viernes, horario(9,15)).
atiende(lucas, martes, horario(10,20)).
atiende(juanC, sabados, horario(18,22)).
atiende(juanC, domingos, horario(18,22)).
atiende(juanFdS, jueves, horario(10, 20)).
atiende(juanFdS, viernes, horario(12, 20)).
atiende(leoC, lunes, horario(14, 18)).
atiende(leoC, miercoles, horario(14, 18)).
atiende(martu, miercoles, horario(23, 24)).

% Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:

%     vale atiende los mismos días y horarios que dodain y juanC.

atiende(vale, Dia, Horario):-
    atiende(dodain, Dia, Horario).
atiende(vale, Dia, Horario):-
    atiende(juanC, Dia, Horario).

%     nadie hace el mismo horario que leoC

% Por universo cerrado, como en la base de datos no hay nadie que atienda como leoC -> no existe nadie.

%     maiu está pensando si hace el horario de 0 a 8 los martes y miércoles

% Solo definimos hechos, no algo que este pensando.

% En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta.

% --------------------------------------------------------------------------------------------------------------------------------

% Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. Algunos ejemplos:
%   si preguntamos quién atiende los lunes a las 14, son dodain, leoC y vale
%   si preguntamos quién atiende los sábados a las 18, son juanC y vale
%   si preguntamos si juanFdS atiende los jueves a las 11, nos debe decir que sí.
%   si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes.

% El predicado debe ser inversible para relacionar personas y días.

estaEnHorario(Persona, Dia, Horario):-
    atiende(Persona, Dia, horario(Hi, Hf)),
    between(Hi, Hf, Horario).
    
    % Hi =< Horario,
    % Hf >= Horario.

% --------------------------------------------------------------------------------------------------------------------------------

% Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. 
% En este predicado debe utilizar not/1, y debe ser inversible para relacionar personas. Ejemplos:
%   si preguntamos quiénes están forever alone el martes a las 19, lucas es un individuo que satisface esa relación.
%   si preguntamos quiénes están forever alone el jueves a las 10, juanFdS es una respuesta posible.
%   si preguntamos si martu está forever alone el miércoles a las 22, nos debe decir que no (martu hace un turno diferente)
%   martu sí está forever alone el miércoles a las 23
%   el lunes a las 10 dodain no está forever alone, porque vale también está
    
estaSolo(Persona, Dia, Horario):-
    estaEnHorario(Persona, Dia, Horario),
    estaEnHorario(Persona2, Dia, Horario),
    not(Persona \= Persona2).

% --------------------------------------------------------------------------------------------------------------------------------

% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, 
% si preguntamos por el miércoles, tiene que darnos esta combinatoria:
%     nadie
%     dodain solo
%     dodain y leoC
%     dodain, vale, martu y leoC
%     vale y martu
%     etc.

% Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día 
% (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).

% Punto extra: indique qué conceptos en conjunto permiten resolver este requerimiento, justificando su respuesta.

posibilidadesAtencion(Dia, Personas):-
    findall(Persona, distinct(Persona, estaEnHorario(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).
  
combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas).

% --------------------------------------------------------------------------------------------------------------------------------

% En el kiosko tenemos por el momento tres ventas posibles:
%   golosinas, en cuyo caso registramos el valor en plata
%   cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
%   bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

% Queremos agregar las siguientes cláusulas:
%   dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
%   dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
%   martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
%   lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
%   lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

ventas(dodain, 10, agosto, golosinas(1200)).
ventas(dodain, 10, agosto, cigarrillos([jockey])).
ventas(dodain, 10, agosto, golosinas(50)).
ventas(dodain, 12, agosto, bebidaAlcoholica(8)).
ventas(dodain, 12, agosto, bebidaNoAlcoholica(1)).
ventas(dodain, 12, agosto, golosinas(10)).
ventas(martu, 12, agosto, golosinas(1000)).
ventas(martu, 12, agosto, cigarrillos([chesterfield,colorado,parisiennes])).
ventas(lucas, 11, agosto, golosinas(600)).
ventas(lucas, 18, agosto, bebidaNoAlcoholica(2)).
ventas(lucas, 18, agosto, cigarrillos([deberly])).

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en 
% los que vendió, la primera venta que hizo fue importante. Una venta es importante:
% en el caso de las golosinas, si supera los $ 100.
% en el caso de los cigarrillos, si tiene más de dos marcas.
% en el caso de las bebidas, si son alcohólicas o son más de 5.

% El predicado debe ser inversible: martu y dodain son personas suertudas.

vendedorSuertudo(Persona):-
    ventas(Persona,_,_,_),
    forall(primeraVenta(Persona, [Venta|_]), ventaImportante(Venta)).

primeraVenta(Persona, ListaVenta):-
    ventas(Persona,Dia,Mes,_),
    findall(Venta, ventas(Persona, Dia, Mes, Venta), ListaVenta).

ventaImportante(golosinas(Precio)):-
    Precio > 100.

ventaImportante(cigarrillos(Lista)):-
    length(Lista, Cantidad),
    Cantidad > 2.

ventaImportante(bebidaAlcoholica(_)).

ventaImportante(bebidaNoAlcoholica(Cantidad)):-
    Cantidad >= 5.

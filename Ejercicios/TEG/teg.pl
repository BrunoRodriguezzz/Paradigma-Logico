:- use_module(paises).
:- use_module(ocupacion).

sonLimitrofes(P1, P2) :- limita(P1, P2).
sonLimitrofes(P1, P2) :- limita(P2, P1).

% Predicado que me diga que pais limita con un pais de otro continente

paisDeOtroContinente(P1, P2) :-
    sonLimitrofes(P1, P2),
    pais(P1, C1),
    pais(P2, C2),
    C1 \= C2.

% Predicado que me diga los enemigos de un país, es decir sus limítrofes que no tengan el mismo color.

enemigosPais(P1, P2):-
    sonLimitrofes(P1, P2),
    ocupa(Color1, P1, _),
    ocupa(Color2, P2, _),
    Color1 \= Color2.

% Predicado complicado/1 verifica si un país está "complicado", es decir, si tiene dos países limítrofes 
% del mismo color y la suma de los ejércitos de ambos países es al menos 5.

complicado(P1) :-
    sonLimitrofes(P1, P2),
    sonLimitrofes(P1, P3),
    P2 \= P3,
    ocupa(Color1, P1, _),
    ocupa(Color2, P2, Cant2),
    ocupa(Color3, P3, Cant3),
    Color1 \= Color2,
    Color1 \= Color3,
    Cant2 + Cant3 >= 5.
    
% Predicado puede_atacar/1 que determine si un país tiene más ejércitos que uno de sus países limítrofes 
% que sea de otro color.

puedeAtacar(P1) :-
    enemigosPais(P1, P2),
    ocupa(_, P1, E1),
    ocupa(_, P2, E2),
    E1 > E2.

% Un ejercito esFuerte/1 si ninguno de sus países está complicado.
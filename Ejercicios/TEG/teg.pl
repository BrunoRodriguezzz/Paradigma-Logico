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

esFuerte(C):-
    ocupa(C,_,_),      %Hago que la variable C este ligada antes del not
    not((ocupa(C,P,_), %La variable que llega libre al not la interpreto no existe
    complicado(P))).   %De esta forma se lee como Existe algun C, tal que no exista P que este complicado.

% esFuerte(C):-
%     ocupa(C,_,_),     Podri reducir los duplicados poniendo color(C) y definiendo cuales son los colores.
%     forall(ocupa(C,P,_), not(complicado(P))).

% Conquisto es que un color ocupo todos los paises de ese continente.
% Destruir al ejercito significa que ese Color no ocupa ningun pais.

% Objetivo

% Destruir al ejercito amarillo

color(rojo).
color(azul).
color(verde).

ejercitoDestruido(C):-
    color(C),
    not(ocupa(C,_,_)).   % Si estuviera solo esta linea no seria inversible, ya que not es una funcion de orden superior.

% Conquistar Asia

conquistarContinente(Continente, Color):-
    pais(_,Continente),         % En este caso utilizo pais y ocupa para poder ligar las variables desde antemano
    ocupa(Color,_,_),           % De esta forma garantizo la inversibilidad
    forall(pais(P,Continente), ocupa(P,Color,_)). % Recordar que el forall devuelve solo true o false
    % P solo esta ligado dentro del forall que es lo correcto, si no fuera necesario pondriamos _.

%Conquistar sudamerica y africa

objetivo3(Color):-
    conquistarContinente(sudamerica,Color),
    conquistarContinente(africa,Color).

%Conquistar Europa y dos paises de oceania.

objetivo4(Color):-
    conquistarContinente(europa, Color),
    pais(P1,oceania),
    pais(P2,oceania),
    ocupa(Color,P1,_),
    ocupa(Color,P2,_),
    P1 \= P2.

% Crear objetivo

% Conquistar 50 paises

conquisto50paises(Color):-
    findall(Pais, ocupa(Color,Pais,_), ListaPaises),
    length(ListaPaises, Cantidad),
    Cantidad >= 50.
    
    
tecnologia(herreria).
tecnologia(forja).
tecnologia(fundicion).
tecnologia(emplumado).
tecnologia(laminas).
tecnologia(punzon).
tecnologia(horno).
tecnologia(malla).
tecnologia(placas).
tecnologia(collera).
tecnologia(molino).
tecnologia(arado).

civilizacion(romanos).
civilizacion(incas).

jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).
jugador(elsa).

partida(ana,romanos,herreria).
partida(ana,romanos,forja).
partida(ana,romanos,emplumado).
partida(ana,romanos,laminas).

partida(beto,incas,herreria).
partida(beto,incas,forja).
partida(beto,incas,fundicion).

partida(carola,romanos,herreria).

partida(dimitri,romanos,herreria).
partida(dimitri,romanos,fundicion).

% Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, 
% forja y o bien desarrolló fundición o bien juega con los romanos.
% En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.

desarrolloTecnologia(Jugador,Tecnologia):- partida(Jugador,_,Tecnologia).

expertoEnMetales(Jugador):-
    jugador(Jugador),
    desarrolloTecnologia(Jugador,herreria),
    desarrolloTecnologia(Jugador,forja),
    desarrolloTecnologia(Jugador,fundicion).

expertoEnMetales(Jugador):-
    jugador(Jugador),
    partida(Jugador,romanos,_),
    desarrolloTecnologia(Jugador,herreria),
    desarrolloTecnologia(Jugador,forja).

% Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno).
% En los ejemplos, los romanos es una civilización popular, pero los incas no.

esPopular(Civilizacion):-
    partida(Jugador1,Civilizacion,_),
    partida(Jugador2,Civilizacion,_),
    Jugador1 \= Jugador2.

% Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.
% En los ejemplos, la herrería tiene alcance global, pues Ana, Beto, Carola y Dimitri la desarrollaron.

tieneAlcanceGlobal(Tecnologia):- 
    tecnologia(Tecnologia), % Para que sea inversible.
    forall(partida(_,_,_),desarrolloTecnologia(_,Tecnologia)).

% Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las tecnologías 
% que alcanzaron las demás.
% En los ejemplos, los romanos es una civilización líder pues entre Ana y Dimitri, que juegan con romanos, ya tienen todas 
% las tecnologías que se alcanzaron.

civilizacionLider(Civilizacion):-
    civilizacion(Civilizacion),
    forall(tecnologia(Tecnologia),partida(_,Civilizacion,Tecnologia)).

% No se puede ganar la guerra sin soldados. Las unidades que existen son los campeones (con vida de 1 a 100),
% los jinetes (que los puede haber a caballo o a camello) y los piqueros, que tienen un nivel de 1 a 3, y pueden o no tener escudo.

tieneUnidad(ana,unidad(jinete(caballo))).
tieneUnidad(ana,unidad(piquero(nivel(1),conEscudo))).
tieneUnidad(ana,unidad(piquero(nivel(2),sinEscudo))).
tieneUnidad(beto,unidad(campeon(100))).
tieneUnidad(beto,unidad(campeon(80))).
tieneUnidad(beto,unidad(piquero(nivel(1),conEscudo))).
tieneUnidad(beto,unidad(jinete(camello))).
tieneUnidad(beto,unidad(piquero(nivel(3),sinEscudo))).
tieneUnidad(beto,unidad(piquero(nivel(2),conEscudo))).

vida(unidad(jinete(caballo)),90).
vida(unidad(jinete(camello)),80).
vida(unidad(campeon(V)),V).
vida(unidad(piquero(nivel(1),sinEscudo)),50).
vida(unidad(piquero(nivel(2),sinEscudo)),65).
vida(unidad(piquero(nivel(3),sinEscudo)),70).
vida(unidad(piquero(nivel(1),conEscudo)),55).
vida(unidad(piquero(nivel(2),conEscudo)),71.5).
vida(unidad(piquero(nivel(3),conEscudo)),77).    

% Conocer la unidad con más vida
% En los ejemplos, la unidad más “viva” de Ana es el jinete a caballo,
% pues tiene 90 de vida, y ninguno de sus dos piqueros tiene tanta vida.

unidadConMasVida(Jugador,Unidad):-
    jugador(Jugador),
    tieneUnidad(Jugador,Unidad),
    vida(Unidad,Vida1),
    forall(tieneUnidad(Jugador,UAux), (vida(UAux,Vida2),Vida1>=Vida2)).
    
% Queremos saber si una unidad le gana a otra. Las unidades tienen una ventaja por tipo sobre otras. 
% Cualquier jinete le gana a cualquier campeón, cualquier campeón le gana a cualquier piquero y cualquier piquero le gana a cualquier jinete, 
% pero los jinetes a camello le ganan a los a caballo. En caso de que no exista ventaja entre las unidades, se compara la vida (el de mayor vida gana). 
% Este punto no necesita ser inversible

tieneVentaja(unidad(jinete(_)),unidad(campeon(_))).
tieneVentaja(unidad(campeon(_)),unidad(piquero(nivel(_),_))).
tieneVentaja(unidad(piquero(nivel(_),_)),unidad(jinete(_))).
tieneVentaja(unidad(jinete(camello)),unidad(jinete(caballo))).

leGana(U1,U2):-tieneVentaja(U1,U2).

leGana(U1,U2):-
    not(tieneVentaja(U2,U1)),
    vida(U1,V1),
    vida(U2,V2),
    V1 > V2.

% Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más piqueros con escudo que sin escudo.
% En los ejemplos, Beto es el único que puede sobrevivir a un asedio, pues tiene 1 piquero con escudo y 0 sin escudo.

puedeSobrevivirAsedio(Jugador):-
    jugador(Jugador),
    findall(Nivel, tieneUnidad(Jugador,unidad(piquero(nivel(Nivel),conEscudo))), PConEscudo),
    findall(Nivel, tieneUnidad(Jugador,unidad(piquero(nivel(Nivel),sinEscudo))), PSinEscudo),
    length(PConEscudo, L1),
    length(PSinEscudo, L2),
    L1>L2.
    
% Árbol de tecnologías
% Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. 
% Hasta no desarrollar una, no se puede desarrollar la siguiente. Modelar el siguiente árbol de ejemplo:

paraDesarrollarNecesito(horno,fundicion).
paraDesarrollarNecesito(placas,malla).
paraDesarrollarNecesito(punzon,emplumado).
paraDesarrollarNecesito(fundicion,forja).
paraDesarrollarNecesito(malla,laminas).
paraDesarrollarNecesito(emplumado,herreria).
paraDesarrollarNecesito(forja,herreria).
paraDesarrollarNecesito(laminas,herreria).
paraDesarrollarNecesito(arado,collera).
paraDesarrollarNecesito(collera,molino).

paraDesarrollarNecesito(herreria,_).
paraDesarrollarNecesito(molino,_).

puedeDesarrollar(Personaje,herreria):-
    jugador(Personaje),
    not(desarrolloTecnologia(Personaje,herreria)).

puedeDesarrollar(Personaje,molino):-
    jugador(Personaje),
    not(desarrolloTecnologia(Jugador,molino)).

puedeDesarrollar(Jugador,Tecnologia):-
    jugador(Jugador),
    tecnologia(Tecnologia),
    not(desarrolloTecnologia(Jugador,Tecnologia)),
    paraDesarrollarNecesito(Tecnologia,T2),
    desarrolloTecnologia(Jugador,T2).

% Bonus.

% 11) a. Encontrar un orden válido en el que puedan haberse desarrollado las tecnologías para que un jugador llegue a 
% desarrollar todo lo que tiene. Se espera una relación de jugador con lista de tecnologías.
% Ejemplo: Un orden válido para Ana es: herreria, emplumado, forja, láminas. Otro orden válido sería herreria, forja, láminas, 
% emplumado. Pero seguro que Ana no desarrolló primero la forja, porque antes necesitaría la herrería.
% Recordar que debe funcionar para cualquier árbol y no sólo para el de el ejemplo. Y recordar que debe ser completamente inversible.
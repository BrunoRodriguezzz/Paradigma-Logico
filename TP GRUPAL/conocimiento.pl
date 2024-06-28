:- module(conocimiento, [jugador/1, tecnologia/1, civilizacion/1, partida/3]).

tecnologia(herreria).
tecnologia(forja).
tecnologia(fundicion).
tecnologia(emplumado).
tecnologia(laminas).

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
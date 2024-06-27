padre(juan, maria).
padre(juan, pedro).
padre(pedro, ana).

abuelo(X, Y) :- padre(X, Z), padre(Z, Y).
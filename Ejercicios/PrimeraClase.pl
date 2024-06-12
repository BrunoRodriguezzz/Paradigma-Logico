esHombre(socrates). %socrates es un individuo
esHombre(juanPerez).

esPersonajeFiccion(darthvader).

esMortal(Alguien). %Alguien es una variable
esMortal(Alguien) :- esHombre(Alguien).

clima(lluvia,10).
%clima(sol,23).
%clima(lluvia,100).

seRego(pasto).
seRego(vereda).

alAireLibre(pasto).
alAireLibre(vereda).

seMojo(Lugar) :- seRego(Lugar).
%seMojo(Lugar) :- clima(lluvia,X).
seMojo(Lugar) :- alAireLibre(Lugar),clima(lluvia,X).
%seMojo(Lugar) :- alAireLibre(Lugar),clima(lluvia,X), X>20.

juegoSistemas(lol).

estudiaSistemas(Persona, Juego) :- juegoSistemas(Juego).

%Buen Ingeniero, si tiene titulo, sabe un idioma de un pais importante y que tenga mucha plata

esBuenIngeniero(Persona) :-
    tieneTitulo(Persona,ingeniero),
    sabeIdiomaImportante(Persona, ingles).
    tienePlata(Persona,Plata),
    Plata > 10000.

tieneTitulo(valen,ingeniero).
tieneTitulo(lucas,arquitecto).
tieneTitulo(marcos,matematico).

tienePlata(valen,1000).
tienePlata(lucas,10).

sabeIdiomaImportante(valen,ingles).
sabeIdiomaImportante(lucas,español).

%Discipulo (A,B), misma disciplina, edad en un rango, B experiencia

%Saber relaciones familiares


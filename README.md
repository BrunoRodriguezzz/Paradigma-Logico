# <p align = "center"> Paradigma-Logico </p>

A partir de ciertas premisas, vamos a generar conclusiones. Estas premisas o hechos son toda la informacion que va a tener el programa. No solo vamos a podes saber si algo cumple con una regla, tambien podemos saber que individuos (si existe alguno) cumplen esa condicion.

*Muestra uno solo, pero presionando r o ; en el terminal busca otro que cumpla*

> Por ejemplo si llueve puedo deducir que el pasto estaria mojado (es algo obvio) pero esa deduccion no la puede hacer el programa con lo cual tengo que aclarar que *Si llueve -> el pasto se moja*

El objetivo es que la definicion del problema sea la solucion del mismo.

- [ Paradigma-Logico ](#-paradigma-logico-)
  - [Universo Cerrado](#universo-cerrado)
  - [Individuos e incongnitas](#individuos-e-incongnitas)
  - [Sintaxis](#sintaxis)
  - [Cuantificion existencial](#cuantificion-existencial)
  - [Inverisibilidad](#inverisibilidad)
  - [Declarativo](#declarativo)
  - [Acoplamiento](#acoplamiento)
  - [Refactorizacion](#refactorizacion)

> Recomiendo leer por el final del paradigma el Modulo Logico 6 👍

Un resumen de los [errores mas frecuentes](https://wiki.uqbar.org/wiki/articles/errores-frecuentes-al-programar-en-logico.html).

## Universo Cerrado

Aquello que no se dice, lo que desconozco va a retornar Falso, lo que significa que no puede demostrar que sea verdadero. Entoces se genera una base de conocimientos a partir de hechos y reglas que forman el universo de lo que se conoce.

## Individuos e incongnitas

Los individuos son "cosas" que conozco de mi universo, lo importante es que empiece con minuscula.

Las incongnitas son "variables" que pueden ser varios individuos, lo importante es que empiece con MAYUSCULA.

## Sintaxis

`:-` significa si

`,` es como un y

`\=` Distinto

`not` Negacion

`limita/2` Indica que el predicado limita es de aridad 2 (que tiene dos parametros).

`is` Se usa para operaciones matematicas. Es como ligar la variable con ese valor. Resuelve.
``` SWI Prolog
X = 2 + 1 % Muestra X = 2+1.
X is 1 + 2 % Muestra X = 3.
```

`forall` Tiene dos parametros, es como para un todo. Recibe una condicion inicial y una postCondicion.

``` SWI Prolog
conquistarContinente(Continente, Color):-
    pais(_,Continente),         % En este caso utilizo pais y ocupa para poder ligar las variables desde antemano
    ocupa(Color,_,_),           % De esta forma garantizo la inversibilidad
    forall(pais(P,Continente), ocupa(P,Color,_)). % Recordar que el forall devuelve solo true o false
    % P solo esta ligado dentro del forall que es lo correcto, si no fuera necesario pondriamos _.
```
Lo que estoy haciendo en este caso es verificar que todos los Paises (P), dentro del Continente (C) son del Color (C).

`findall` Tienen 3 parametros: lo que busco, como lo busco y donde lo guardo. En resumen arma una lista de lo que busco.

> Un error comun es usar un findall y despues un member con la lista que genero, esta mal ya que son operaciones inversas.

## Cuantificion existencial

Existe algun elemento que cumple (cuando hay variables), pero siguen siendo un predicado por lo cual no "devuelve" el elemento solo lo muestra, la consulta es verdadera o falsa.

## Inverisibilidad

Muy resumido es ver si se le puede pasar variables en vez de parametros. Ver que si le mando solo variables funciona correctamente. 
Para poder lograrlo hay que ligar variables al comienzo y poner condiciones mas complejos al final. Es para evitar que aparazcan este tipo de cosas.
``` SWI prolog
A /= B
```
Que comparan dos varibles que no tienen valor (y devuelve false).

*Ningun predicado de orden superior liga valores, solo devuelven true o false, por lo que se que no es inversible.*

## Declarativo

Se separa el conocimiento de lo operativo. Que la descripcion del problema sea la solucion.
Una forma de darnos cuenta es ver que el orden no importa.

## Acoplamiento

El acoplamiento es el grado en que los componentes se conocen. Muy en resumen representa que si un predicado que esta vinculado a otros mas (Ejemplo: `conquistarContinente`), si tiene buen acoplamiento significa que si cambia algo en `pais` o en `ocupa`, no hay que modificar `conquistarContinente`.

## Refactorizacion

Consiste en mejorar nuestro codigo para que sea una solucion mas general o sea mas expresivo, aun cuando funcione. Ejemplo:
``` SWI prolog
todosSiguenA(Rey):-
	personaje(Rey),
	not((personaje(Personaje), not(sigueA(Personaje, Rey)))). 
```
>Si bien el codigo funciona y es inversible no se entiende mucho

Usando logica se puede simplificar y pasar de ∄x / p(x)  ∧ ￢q(x) a **∀x / p(x) ⇒ q(x)**, que en el codigo se ve asi:

``` SWI prolog
todosSiguenA(Rey) :-
	personaje(Rey),
	forall((personaje(Personaje), sigueA(Personaje, Rey))).
```
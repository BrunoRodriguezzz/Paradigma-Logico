# <p align = "center"> Paradigma-Logico </p>

A partir de ciertas premisas, vamos a generar conclusiones. Estas premisas o hechos son toda la informacion que va a tener el programa. No solo vamos a podes saber si algo cumple con una regla, tambien podemos saber que individuos (si existe alguno) cumplen esa condicion.

*Devuelve uno solo, pero presionando r o ; en el terminal busca otro que cumpla*

> Por ejemplo si llueve puedo deducir que el pasto estaria mojado (es algo obvio) pero esa deduccion no la puede hacer el programa con lo cual tengo que aclarar que *Si llueve -> el pasto se moja*

El objetivo es que la definicion del problema sea la solucion del mismo.

- [Universo Cerrado](#universo-cerrado)
- [Individuos e incongnitas](#individuos-e-incongnitas)
- [Sintaxis](#sintaxis)

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

`is` Se usa para operaciones matematicas. Es como ligar la variable con ese valor. Resuelve.
``` SWI Prolog
X = 2 + 1 % Muestra X = 2+1.
X is 1 + 2 % Muestra X = 3.
```

## Cuantificion existencial

Existe algun elemento que cumple (cuando hay variables).

## Inverisibilidad

Muy resumido es ver si se le puede pasar variables en vez de parametros. Ver que si le mando solo variables funciona correctamente. 
Para poder lograrlo hay que ligar variables al comienzo y poner condiciones mas complejos al final. Es para evitar que aparazcan este tipo de cosas.
``` SWI prolog
A /= B
```
Que comparan dos varibles que no tienen valor (y devuelve false).

## Declarativo

Se separa el conocimiento de lo operativo. Que la descripcion del problema sea la solucion.
Una forma de darnos cuentas es ver que el orden no importa.
herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

% 1
jugador(ana, [agua, vapor, tierra, hierro]).
jugador(beto, [agua, vapor, tierra, hierro]).
jugador(cata, [fuego, tierra, agua, aire]).

elemento(pasto, [agua, tierra]).
elemento(hierro, [fuego, agua, tierra]).
elemento(hueso, [pasto, agua]).
elemento(presion, [hierro, vapor]).
elemento(vapor, [agua, fuego]).
elemento(playStation, [silicio, hierro, plastico]).
elemento(silicio, [tierra]).
elemento(plastico, [hueso, presion]).

% 2
% tieneTodoEnSuInventario Saber si un inventario tiene todos los Ingredientes para construir un elemento
tieneTodoEnSuInventario(Inventario, Ingredientes):-
    intersection(Inventario, Ingredientes, Necesario),
    intersection(Ingredientes, Necesario,_).

% tieneIngredientesPara/2 Saber si un jugador tiene los ingredientes para construir un elemento
tieneIngredientesPara(Jugador, Elemento):-
    jugador(Jugador, Inventario),
    elemento(Elemento, Ingredientes),
    tieneTodoEnSuInventario(Inventario, Ingredientes).

% 3
% estaVivo/1 Saber si un elemento esta vivo 
estaVivo(agua). 
estaVivo(fuego).
estaVivo(Elemento):-
    elemento(Elemento, Ingredientes),
    estaVivoAlgunIngrediente(Ingredientes).

estaVivoAlgunIngrediente([Ingrediente|_]):-
    estaVivo(Ingrediente).

estaVivoAlgunIngrediente([Ingrediente|RestoIngredientes]):-
    not(estaVivo(Ingrediente)),
    estaVivoAlgunIngrediente(RestoIngredientes).

% 4
% tieneLasHerramientas/2 Saber si un jugador tiene las herramientas para construir un elemento
tieneLasHerramientas(Jugador, Elemento):-
    estaVivo(Elemento),
    herramienta(Jugador, libro(vida)).

tieneLasHerramientas(Jugador, Elemento):-
    not(estaVivo(Elemento)),
    herramienta(Jugador, libro(inerte)).

tieneLasHerramientas(Jugador, Elemento):-
    elemento(Elemento, Ingrediente),
    length(Ingrediente, CantIngredientes),
    herramienta(Jugador, Herramienta),
    soportaIngredientes(Herramienta, CantIngredientes).

% soportaIngredientes/2 Saber si una herramienta soporta la cantidad de ingredientes de un elemento
soportaIngredientes(cuchara(Longitud), CantIngredientes):-
    CantIngredientes < (Longitud/10) + 1.

soportaIngredientes(circulo(Diametro, Niveles), CantIngredientes):-
    CantIngredientes < ((Diametro/100) * Niveles) + 1.

% puedeConstruir/2 Saber si una persona puede construir un elemento
puedeConstruir(Jugador, Elemento):-
    tieneIngredientesPara(Jugador, Elemento),
    tieneLasHerramientas(Jugador, Elemento).

% 5
algunoSePuedeCrear([Elemento]):-
    elemento(Elemento, _).

algunoSePuedeCrear([Elemento|_]):-
    elemento(Elemento, _).

algunoSePuedeCrear([Elemento|RestoElementos]):-
    not(elemento(Elemento, _)),
    algunoSePuedeCrear(RestoElementos).

% tieneTodosLosElementosPrimitivos/1 Saber si un jugador tiene todos los elementos que no se pueden construir a partir de nada
tieneTodosLosElementosPrimitivos(Jugador):-
    jugador(Jugador, Inventario),
    not(algunoSePuedeCrear(Inventario)).

% todoPoderoso/1 Saber si un jugador tiene todos los elementos primitivos y cuenta con herramientas que le permita construir todos los elementos que no tiene
todoPoderoso(Jugador):-
    tieneTodosLosElementosPrimitivos(Jugador),
    forall(elemento(Elemento, _), puedeConstruir(Jugador, Elemento)).

% 6
construyoMas(Jugador1, Jugador2):-
    jugador(Jugador1, _),
    findall(Elemento1, puedeConstruir(Jugador1, Elemento1), ListaElementos1),
    findall(Elemento2, puedeConstruir(Jugador2, Elemento2), ListaElementos2),
    length(ListaElementos1, Cant1),
    length(ListaElementos2, Cant2),
    Cant1 > Cant2.

% quienGana/1 Saber quien puede construir mas cosas
quienGana(Jugador):-
    jugador(Jugador, _),
    not(construyoMas(_, Jugador)).
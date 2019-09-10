# Arquitectura de la app
La app cuenta con una capa simple de **persistencia** MovieRepository, la cual se utiliza para que la app funcione offline.

La capa de **red** esta conformada por la clase NetworkConnector, la cual permite la comunicación con la api. También cuenta con un enum NetworkConfigurator, implementado en MovieConfiguration, en donde se configuran los endpoints, sus métodos, parámetros, headers, etc.

En la carpeta models podemos encontrar las entidades de la capa de red y persistencia.

La app se hizo siguiendo el patrón de diseño VIPER para las pantallas Movie List y Movie Detail, y patrón MVVM para la pantalla Search Movie.
Dentro de la carpeta Scene podemos encontrar cada pantalla con la siguiente división:
**Movie Detail y Movie List**:
**Interactors**: es la capa encargada de acceder a los repositorios, ya sea por red u offline
**Presenter**: es la capa encargada de efectuar las acciones generadas en la capa de vista y brindarle los datos
**Vista**: es la capa de interaccion con el usuario
**Router**: es la capa encargada de la navegació

**Search Movie**:
**View Model**: es la capa encargada de acceder a los repositorios y preparar los datos para la vista
**Vista**: es la capa de interacción con el usuario
**Router**: es la capa encargada de la navegación

La app se hizo casi 100% protocol oriented y con inyección de dependencia, esto facilita la generación de casos de prueba.

# Principio de responsabilidad única

Consiste en que cada clase tenga una sola responsabilidad.
Por ejemplo, las clases **Iterator** solo se encargan de comunicarse con la capa de red o persistencia para obtener los datos solicitados, o la clase NetworkConector tiene como responsabilidad comunicarse con la API.

# Código limpio

Un código limpio debe:
* Ser fácil de entender, para eso es importante que sus métodos y propiedades sean claros y expliquen el sentido de los mismo (auto-documentado) o en caso de operaciones complejas, que tenga las anotaciones adecuadas.
* Las clases deben tener una única responsabilidad, deben ser pequeñas y encapsuladas. Deben exponer las propiedades y métodos adecuadas.
* Los métodos deben ser bien descriptivos, cortos, y tener una sola responsabilidad.
* Usar inyección de dependencias.
* Pensar las clases y métodos para que sean sencillas de testear, usando los principios anteriores se facilita mucho esa tarea.
* En lo posible, tener el proyecto libre de warnings.

# Aclaraciones

* Los test que hice fueron muy pocos, la idea era mostrar cómo con inyección de dependencia y programación orientada a protocolos ayuda, ya que no se usó ningún framework para realizar los test.
* Faltó realizar el listado de TV, el mismo puede ser desarrollado replicando lo hecho con Movies, y agregando un tab bar con dos items.
* La persistencia es muy básica, se persiste la última interacción del usuario del acumulado de páginas de cada categoría en disco, en archivos distintos para cada categoría. No se persiste el detalle.
* UI/UX:
  * El manejo de errores/loadings y los mensajes de errores son muy básicos.
  * Las celdas y el detalle de las películas son muy simples, se puede agregar mucha información extra.
  * Mejorar el buscador en los resultados de categoría, al ser un servicio paginado, solo se realiza la búsqueda en las páginas disponibles.

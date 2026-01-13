# Draftea Pokedex 📱

![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)


---

## 🏗️ Cómo está organizado el código

Para que el proyecto sea escalable, me apoyé en **Clean Architecture**. La idea es que la lógica de negocio no dependa de si los datos vienen de una API o de una base de datos local, ni de cómo se ven los widgets.

```text
lib/
├── core/                  # Lo que usamos en toda la app (router, inyección de dependencias, diseño)
├── pokedex/               # Todo lo relacionado a la Pokedex específicamente
│   ├── data/              # Los modelos que vienen de la API y cómo los guardamos
│   ├── domain/            # El "corazón" de la app: qué es un Pokemon y qué acciones podemos hacer
│   └── ui/                # Lo que ve el usuario: pantallas, cubits y widgets
├── app.dart               # Configuración base de la aplicación
├── bootstrap.dart         # El arranque (logs, errores, inicialización de servicios)
└── main_*.dart            # Diferentes sabores (dev, production, staging)
```

---

## 🚀 Decisiones técnicas y por qué las tomé

### 1. Arquitectura y Web 🌐
**Clean Architecture** con **BLoC** para el estado. para que que la app sea una web súper compleja, toda la lógica del "Dominio" se queda igual. Solo tendríamos que retocar la capa de UI.

Para que la experiencia en **Web** use el paquete `responsive_grid_list` en la [Home Page](./lib/pokedex/ui/pages/pokedex_home.dart). Esto permite que la grilla de Pokemons se adapte segun el width de la pantalla.

Además, se realizó un **rediseño moderno** de la interfaz con un enfoque en la simplicidad y fluidez visual, priorizando una experiencia de usuario intuitiva y atractiva.

### 2. Paquetes usados
En el [pubspec.yaml](./pubspec.yaml) vas a ver algunas dependencias clave:
*   **Hive**: Lo elegí para el almacenamiento local porque es increíblemente rápido y está hecho para Flutter. Ideal para guardar los datos de los Pokemons y que la app abra al instante.
*   **Dio**: Para las peticiones HTTP. Es mucho más potente que el `http` estándar, permitiendo interceptores (clave si después querés agregar auth o logs).
*   **Freezed**: Para los modelos de datos. Me ahorra escribir cientos de líneas de código repetitivo.
*   **GetIt + Injectable**: Para la inyección de dependencias. Esto hace que sea fácil cambiar una implementación.
*   **CachedNetworkImage**: Para que las fotos se guarden en caché.

### 3. Modo offline
primero intentamos obtener los datos de la API para obtener datos actualiazdos, si no los obtenemos, obtenemos los datos de **Hive** guardados en cache anteriormente. 
Como generalmente los datos en esta api no cambian no implemente un sistema de expiración muy complejo.

### 4. Calidad🧼
*   **Inversión de dependencias**: No creo los objetos a mano dentro de las clases. Uso `GetIt` para que las piezas encajen solas.
*   **Responsabilidad única**: Los DataSources solo se encargan de hablar con internet, no mezclan lógica de si el Pokemon es de tipo agua o fuego.
*   **UI Declarativa**: Gracias a BLoC, la interfaz es una función del estado. Si el estado cambia, la UI se actualiza sola de forma predecible.

### 5. Trade-offs
Al tener poco tiempo, decidí enfocarme 100% en que la **UX sea fluida** que es mi fuerte y el código sea sólida.
 **Peticiones paralelas**: Hago una llamada para la lista y luego 20 paralelas para los detalles. Consume un poco más de datos al principio, pero la recompensa es ver los tipos y las imágenes de una sin esperar.

No terminé de implementar sistemas de búsquedas o filtros para enfocarme en que la UX sea fluida más estética y demostrar con información básica detalles del pokemon. **Nota importante**: Actualmente, ni los filtros ni el buscador en la página de inicio funcionan aún, están presentes únicamente como elementos de UI para futuras implementaciones.

Ademas obviamente para acelerar el proceso de desarrollo me apoye del uso de  **IA** para ayudarme a estructurar el proyecto, planificarlo y minimizar el boilerplate de codigo.


---

## 🛠️ Pendientes (Lo que agregaría después)
1.  **Animaciones**: Sumar efectos de entrada fluidos y animaciones al pasar el mouse (hovers) por las cartas en Web.
2.  **Búsqueda avanzada**: Filtros por tipos y parámetros de URL para poder compartir un link directo a un Pokemon.
3.  **DeepLinks**: Configurar el router para que `pokedex.com/pokemon/25` te lleve directo a Pikachu.
4.  **Tests**: Aunque la arquitectura está lista para testear, agregarle tests unitarios a los Cubits y Repositorios sería el siguiente paso lógico.
5. **Offline images**: Las imagenes se cachean con la dependencia pero sin conexión no se muestran.

---

# 🔴 Draftea Pokedex

Una aplicación de Pokedex moderna y de alto rendimiento construida con Flutter, siguiendo los principios de **Clean Architecture** para garantizar escalabilidad, testabilidad y un desacoplamiento total entre la UI y los datos.

## 🏗️ Arquitectura del Proyecto

El proyecto está organizado en tres capas principales que siguen la regla de dependencia hacia adentro (la UI y la Data dependen del Dominio, pero el Dominio no depende de nadie).

### 1. Dominio (Domain Layer) 🏛️
Es el corazón de la aplicación. Contiene la lógica de negocio pura y es totalmente independiente de frameworks o librerías externas.
- **Entities**: Objetos de negocio puros (`Pokemon`, `PokemonStats`, `PokemonType`).
- **Use Cases**: Encapsulan la lógica de negocio específica (`GetPokemonListUseCase`, `GetPokemonDetailsUseCase`).
- **Repositories Interfaces**: Contratos que definen qué datos necesita el dominio, sin saber de dónde vienen.

### 2. Datos (Data Layer) 💾
Responsable de la obtención y persistencia de datos.
- **Models**: Representaciones de datos para la API o Base de Datos (`PokemonDetail`, `PokemonListResponse`) con lógica de serialización.
- **Repositories Implementation**: Implementa las interfaces del dominio, coordinando el flujo entre fuentes remotas y locales.
- **DataSources**: Comunicación directa con APIs (Dio) o persistencia local (Hive).
- **Mappers**: Transforman modelos de datos en entidades de dominio para evitar filtraciones de la capa de datos hacia la UI.

### 3. Presentación (UI Layer) 🎨
Se encarga de mostrar la información y reaccionar a las interacciones.
- **BLoC/Cubit**: Gestión de estado reactiva basada en `flutter_bloc`. Los Cubits ahora dependen de los **Use Cases**, no de los repositorios directamente.
- **Pages & Widgets**: Componentes visuales desacoplados que consumen únicamente entidades del dominio.

## 🛠️ Tecnologías Utilizadas

- **Estado**: `flutter_bloc` (Cubit).
- **Inyección de Dependencias**: `get_it` e `injectable`.
- **Navegación**: `go_router`.
- **Networking**: `dio`.
- **Persistencia**: `hive_ce`.
- **Modelado**: `freezed` y `equatable`.
- **UI**: Fuentes de Google (Jakarta Sans) y diseño responsivo.

## 🚀 Mejoras Seleccionadas

- **Desacoplamiento UI-Data**: La vista nunca conoce la estructura de la API.
- **Batch Processing**: Carga optimizada de detalles de Pokémon utilizando un `BatchExecutor` en la capa de datos.
- **Clean Domain**: Implementación completa de entidades y casos de uso para una lógica de negocio robusta.

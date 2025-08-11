# NelumboTest

## 📋 Instrucciones para correr el proyecto
1. Clonar este repositorio:
   ```bash
   git clone <https://github.com/NicolayMD/TestNelumbo.git>
   ```
2. Abrir el proyecto en **Xcode 15 o superior**.
3. Seleccionar un simulador o dispositivo físico con **iOS 15+**.
4. Ejecutar con `Product > Run` o `Cmd + R`.

> El proyecto no requiere configuración adicional ni dependencias externas.

---

## 📦 Dependencias
Este proyecto no utiliza gestores de dependencias externos.  
Todo el código está implementado en **Swift 5** usando únicamente frameworks nativos de iOS.

---

## 🏗 Arquitectura elegida
Se ha implementado **MVVM (Model-View-ViewModel)** organizada por módulos de funcionalidad, con carpetas separadas para mantener una estructura clara y escalable:

- **Comments/**: manejo del chat y comentarios de solicitudes.
- **Commons/**: componentes y vistas reutilizables (botones, banners, headers, etc.).
- **Details/**: pantalla de detalle de solicitud y vista de más información.
- **List/**: listado de solicitudes y filtros.
- **MoreDetail/**: secciones adicionales dentro del detalle.
- **Network/**: capa de red, servicios, modelos y persistencia local (cache).

**Características de la arquitectura:**
- **Separación de responsabilidades**: cada módulo contiene su `ViewController`, `ViewModel` y modelos relacionados.
- **Reutilización**: componentes UI comunes centralizados en `Commons/`.
- **Persistencia local**: se utiliza `UserDefaults` para almacenar la última lista de solicitudes y comentarios, permitiendo funcionamiento offline.
- **Escalabilidad**: fácil incorporación de nuevas funcionalidades sin romper módulos existentes.

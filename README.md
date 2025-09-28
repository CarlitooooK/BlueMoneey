# Blue Money 💙💰

Blue Money es una aplicación móvil desarrollada en **Flutter** para la gestión personal de finanzas.
Permite al usuario **registrar ingresos y gastos**, llevar un control de **tarjetas de débito y crédito**, visualizar **gráficas dinámicas** y hasta crear su **lista del supermercado**, que puede integrarse directamente a los gastos.

---

## ✨ Características principales

* 📊 **Vista general** de ingresos y gastos con gráficos tipo *doughnut* animados.
* 📝 **Vista detallada** para agregar, editar y eliminar transacciones.
* 💳 **Control de tarjetas** de débito y crédito:

  * Registro de gastos por tarjeta.
  * Límites de crédito configurables.
  * Fechas de corte y notificaciones.
* 📈 **Gráficas dinámicas** con desglose de ingresos, gastos y categorías.
* 🚺 **Lista del súper**: el usuario puede organizar sus compras y convertirlas en gastos registrados con un solo clic.
* 🌈 **Animaciones fluidas** y transiciones elegantes para una experiencia moderna.

---

## 🛠️ Tecnologías utilizadas

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* Persistencia inicial en almacenamiento local (archivos `.txt`).
* Migración planificada hacia **Hive** o **SQLite**.

---

## 🚀 Instalación y uso

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/tuusuario/bluemoney.git
   cd bluemoney
   ```
2. Instalar dependencias:

   ```bash
   flutter pub get
   ```
3. Ejecutar en dispositivo/emulador:

   ```bash
   flutter run
   ```

---

## 📂 Estructura del proyecto

```
lib/
├── main.dart               # Punto de entrada
├── features/pages/         # Vistas principales (general, detalle, tarjetas, gráficas, lista super)
├── constants/              # Temas de la app y paleta de colores
├── models/                 # Modelos de datos (transacción, tarjeta, producto, etc.)
└── services/               # Manejo de almacenamiento local y lógica de negocio
└── shared/widgets          # Widgets de la app
└── assets/                 # Recursos visuales

```

---

## 🤝 Contribuciones

¡Contribuciones son bienvenidas! 🎉
Si quieres colaborar, por favor abre un **issue** o un **pull request**.

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Puedes usarlo libremente respetando la misma.

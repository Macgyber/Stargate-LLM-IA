# 🌌 STARGATE PHILOSOPHICAL CHARTER
# "LEGO, Not Glue"

Este documento codifica la Arquitectura Moral del proyecto Stargate-HUB. Es la ley que rige la relación entre el Soberano, el Mundo y el Humano.

## 1. El Axioma de la Confederación
> "Cada pieza funciona sola. Juntas se potencian. Ninguna asume control."

En Stargate, las librerías son **Piezas de Rompecabezas (Puzzle Pieces)**, no órganos cautivos. Una pieza es ortogonal si puede ser extraída del sistema sin que el resto colapse, aunque la experiencia pierda una dimensión.

## 2. Los Tres Pilares

### 🛡️ Soberanía: Stargate (El Kernel)
Stargate es el sistema nervioso, no el músculo.
- **Observa e Interpone**: Su función es medir, vigilar y garantizar la causalidad.
- **Invisibilidad**: No debe dictar cómo se dibuja un sprite o cómo se mueve un personaje.
- **Protección**: Intercepta el `tick` para asegurar que el motor sobreviva a la lógica del juego.

### 🌉 Ortogonalidad: Piezas Independientes (LDtk, Visibility, etc.)
Las librerías son herramientas, no dictadores.
- **Comunicación mediante Estado**: Se comunican a través del bus semántico `args.state` (p.ej., `args.state.ldtk`).
- **Sin Dependencias Cruzadas**: LDtk no sabe qué es Visibility. Visibility no sabe quién cargó el mapa.
- **Modo Púlso**: Las piezas ofrecen un método `pulse` o `tick` que el orquestador llama voluntariamente.

### 🧭 Orquestación: El Humano (El Altar)
El usuario es el Soberano de la Lógica.
- **Ensamblador Consciente**: El archivo `main.rb` es el altar donde el humano decide el orden de las piezas.
- **Cero Magia Invasiva**: Las librerías no deben secuestrar el ciclo de vida de forma automática si un humano desea orquestar.

## 3. El Contrato del Bus Semántico
Para garantizar la ortogonalidad, las piezas publican su "Verdad" en rutas estandarizadas:

- `args.state.ldtk`: Contiene el modelo del mundo, la cámara y los metadatos del nivel actual.
- `args.state.player`: Contiene la identidad y posición del avatar.

---
*Escrito en mármol digital para que ningún desarrollador futuro rompa esta paz.*
🛡️🌉🧩

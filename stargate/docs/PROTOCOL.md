# 📜 STARGATE SEMANTIC PROTOCOL 0.1.0-alpha
# Namespace: `args.state.ldtk`

Este protocolo define el contrato de comunicación entre el **Bridge** (Proveedor) y las **Piezas** (Consumidores) como Visibility o Debug.

## 1. El Estado Maestro (`args.state.ldtk`)

| Campo | Tipo | Descripción |
| :--- | :--- | :--- |
| `version` | String | Versión del protocolo (SemVer). |
| `status` | Symbol | Estado actual: `:loading`, `:active`, `:error`, `:atlas_missing`. |
| `diagnostics`| Array<Str> | Mensajes de estado legibles para el humano. |
| `camera` | Hash | `{ x: Float, y: Float }`. Posición proyectada. |
| `world` | Hash | `{ px_width: Int, px_height: Int, tile_size: Int }`. |
| `entities` | Array | Lista de entidades mapeadas visualmente. |

## 2. Diagnósticos de Consola
El Bridge debe emitir señales visuales automáticas cuando detecte cambios en la integridad del mundo.

### Señales Estándar:
- `✅ World: [NOMBRE] cargado con éxito.`
- `⚠️ Atlas: [PATH] no encontrado o ilegible.`
- `🚫 Bridge Error: [MENSAJE_TECNICO]`

## 3. Reglas de Oro para Consumidores
1. **Verificación de Existencia**: Nunca asumas que `args.state.ldtk` existe.
2. **Defensa ante Errors**: Si `status == :error`, la pieza debe desactivarse o renderizar un estado seguro.
3. **Inmutabilidad**: Las piezas consumidoras NUNCA escriben en el bus de otra pieza.

---
🛡️📜🧩

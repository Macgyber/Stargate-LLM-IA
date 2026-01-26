# <img src="images/logo.png" width="120" height="120" align="right" /> 🌌 Stargate-LLM-IA
### *Programación Causal: De archivos de texto a mapas de intención.*

---

> **"Recuperando la magia de los sistemas vivos del pasado para que la voluntad humana siempre sea la dueña de la tecnología."**

---
## ⚡ El Pitch
**Stargate** no es una herramienta para escribir código, es una herramienta para **no perderse nunca**. 

Cuando usas IA para programar, el proyecto suele volverse un caos de archivos que nadie entiende. Stargate obliga a la IA y al humano a seguir un **Mapa Causal**: un diagrama lógico donde cada línea de código tiene una *razón de ser* física y explícita. Si no hay razón, no hay código. 

**Resultado:** Puedes escalar proyectos infinitamente con IA sin que el código se rompa o se vuelva "basura".

---

## 🧩 Concepto Central
Imagina que construir software es como armar un **LEGO gigante de 10,000 piezas** con un asistente, o como instalar un **Mod de Minecraft**:
*   **Sin Stargate:** El asistente pone piezas sin orden. Al final, tienes una estructura que se ve bien, pero si mueves algo, todo se cae y nadie sabe por qué.
*   **Con Stargate:** Usas un **manual de instrucciones vivo** (dentro de la carpeta `stargate/`). Cada pieza está vinculada a una página del manual. Si quieres cambiar algo, el sistema sabe exactamente qué tocar y qué debe permanecer intacto. Igual que cuando cambias una carpeta de un Mod para añadir una función nueva sin romper el juego.

> [!TIP]
> **En resumen:** Stargate es el motor de orden que permite escalar a máxima velocidad sin perder el control.

---

---

## 🚀 Instalación "Plug & Play" (Estilo Mod)
> [!IMPORTANT]
> **LOS 2 ELEMENTOS MÁGICOS:** Para activar Stargate, solo tienes que copiar y pegar estos 2 elementos en la carpeta principal de tu juego:
> 1.  📂 **`stargate_AI/`**: La carpeta con el cerebro, el mapa y las guías.
> 2.  📜 **`.cursorrules`**: Las instrucciones "sagradas" para la IA.

**Debe verse así dentro de tu carpeta de juego (donde está `app/`):**

```text
dragonruby/ (o donde lo tengas instalado)
└── mygame/         <-- (TU CARPETA DE JUEGO)
    ├── app/        <-- (donde está tu main.rb)
    ├── stargate_AI/ <-- (carpeta que copias)
    └── .cursorrules <-- (archivo que copias)
```

### 📋 Paso Único: Activa el código
Copia estas dos líneas al principio de tu función `tick` en `app/main.rb`:

```ruby
def tick(args)
  require "stargate_AI/core.rb" # 👈 Paso 1
  Stargate.activate!(args)      # 👈 Paso 2
  
  # Tu juego empieza aquí...
end
```

---

## 🤖 Cómo hablar con la IA
Copia y pega este mensaje en el chat para que tu asistente sepa qué hacer:

```text
Hola. Estamos usando el protocolo Stargate-LLM-IA. Lee el archivo .cursorrules y mira el mapa en stargate_AI/index.yaml. A partir de ahora, cada cambio que hagas debe quedar escrito en el mapa. ¿Entendido?
```

---

## 🛠️ Acceso Rápido

*   🚀 **[¿CÓMO FUNCIONA? (DETALLES TÉCNICOS)](stargate_AI/docs/TECHNICAL_DETAILS.md)**: Todo sobre la instalación y el motor interno.
*   🧠 **[FILOSOFÍA Y ARQUITECTURA](stargate_AI/docs/architecture/CAUSAL_EDITING_MODEL.md)**: El porqué detrás del sistema.
*   🔄 **[RESET DEL SISTEMA](stargate_AI/bin/stargate-reset)**: Herramienta para sincronizar el mapa y el código.

---

## 🏛️ Inspiración
Reviviendo la era dorada de las herramientas creativas:
*   **[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk)**
*   **[HyperCard](https://en.wikipedia.org/wiki/HyperCard)**
*   **[Spore](https://en.wikipedia.org/wiki/Spore_(2008_video_game))**
*   **[Tomorrow Corporation Tech Demo](https://www.youtube.com/watch?v=72y2EC5fkcE)**

**Desarrollando a la velocidad del pensamiento.** 🌌🐉🟦


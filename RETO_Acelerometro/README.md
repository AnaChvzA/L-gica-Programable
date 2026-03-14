# Ana Cristina Chávez Acosta - A01742237  
## RETO — Brazo Robótico con Acelerómetro, PWM, Memoria y VGA (DE10-Lite)

### Objetivo
Diseñar e implementar un sistema completo en **Verilog** sobre la FPGA **DE10-Lite** para controlar un **brazo robótico** usando el **acelerómetro integrado (GSensor)** como entrada principal.  
El sistema convierte las lecturas del acelerómetro a **ángulos (0–180°)** y genera señales **PWM** para mover **3 servos** (ejes X, Y, Z) y una **garra**. Además, se implementa:

- **Suavizado de movimiento** con rampa (evita cambios bruscos)
- **Modo automático** con **memoria** para guardar y reproducir posiciones
- Salida **VGA** para desplegar en pantalla las coordenadas/ángulos (X, Y, Z)
- Visualización adicional en **7 segmentos** y LEDs

---

## Materiales necesarios
- Tarjeta FPGA **DE10-Lite (MAX10)**
- Acelerómetro integrado **GSENSOR** (en la DE10-Lite)
- Servos (3 para ejes + 1 para garra)
- Cables Dupont / conexión a pines (PWM a servos)
- Monitor con entrada **VGA** + cable VGA
- Cable **USB Blaster**
- **Intel Quartus Prime Lite**

---

## Descripción general del funcionamiento
1. El módulo del acelerómetro (`accel.v`) lee continuamente los valores **X, Y, Z** mediante **SPI**.
2. Los datos se calibran y convierten a un rango de **0 a 180°** con `CONVERTIDOR.v`.
3. Para que el movimiento sea suave, se pasa cada eje por un módulo de rampa (`RAMPA.v`).
4. Los ángulos resultantes generan **PWM** para cada servo (X, Y, Z y garra).
5. Se implementa una memoria interna para:
   - Guardar posiciones (manual)
   - Reproducir posiciones automáticamente (modo automático)
6. Se despliegan los valores:
   - En **VGA** como texto “X: ###, Y: ###, Z: ###”
   - En **7 segmentos** (dependiendo del modo)
   - En **LEDR** (muestra bits de `data_z` como referencia)

---

## Entradas y salidas (nivel sistema)

### Controles principales (RETO_w / RETO)
- `KEY[0]` → **Reset**
- `KEY[1]` → **Guardar posición**
- `SW[0]` → **Modo automático (modo_auto)**
- `SW[1]` → **Ejecutar / reproducir (ejecutar)**
- `SW[2]` → **Control de garra** (abre/cierra)

### Salidas
- `pwm_x`, `pwm_y`, `pwm_z` → PWM a servos de los ejes
- `pwm_garra` → PWM para la garra
- `VGA_HS`, `VGA_VS`, `VGA_pixel[2:0]` → salida VGA
- `HEX0..HEX5` → displays (valores/estado según modo)
- `LEDR[9:0]` → LEDs (referencia de data Z)

---

## Módulos principales

### 1) `accel.v` (Interfaz con acelerómetro)
- Usa un **PLL** para generar relojes internos (25 MHz y 2 MHz para SPI)
- Se comunica con el acelerómetro por SPI mediante `spi_control`
- Entrega:
  - `data_update`
  - `data_x`, `data_y`, `data_z` (16 bits)

Además, se hace un muestreo más lento (2 Hz) para mostrar información en displays/LEDs.

---

### 2) `CONVERTIDOR.v` (Calibración y conversión a grados)
- Trata los datos como **signed** (complemento a dos)
- Aplica offsets:
  - `OFFSET_X`, `OFFSET_Y`, `OFFSET_Z`
- Escala para convertir a ángulos aproximados (0–180) y centra en 90°
- Limita salida a **0..180**
- Produce:
  - `data_out_x`, `data_out_y`, `data_out_z` (10 bits)

---

### 3) `RAMPA.v` (Suavizado)
Evita que el servo salte de un ángulo a otro instantáneamente:
- Se mueve hacia `target` por pasos (`STEP`)
- Se actualiza con un reloj más lento (`clk_rampa`)

---

### 4) `pwm` (Servo PWM)
Genera el PWM para el servo usando como entrada el ángulo (0–180).  
(La instancia se repite para X, Y, Z y garra).

---

### 5) Modo automático con memoria (`CONTADOR.v` + memoria en `RETO.v`)
- Se guarda una posición como:
  - `{x_smooth, y_smooth, z_smooth}` (30 bits totales)
- `CONTADOR.v` administra:
  - Posición de escritura (`pos_escritura`)
  - Posición de lectura (`pos_lectura`)
  - Número de posiciones guardadas (`num_guardadas`)
  - Señal de escritura (`we`)
- En ejecución automática:
  - recorre las posiciones guardadas usando un temporizador (50 MHz)
  - repite en loop cuando llega al final

Un MUX selecciona qué valores van al PWM:
- Manual: `x_smooth / y_smooth / z_smooth`
- Auto: `x_mem / y_mem / z_mem`

---

### 6) VGA (`VGACounterDemo.v`, `hvsync_generator.v`, `font_rom.v`)
- Genera sincronización VGA 640×480 @ 60 Hz
- `VGACounterDemo.v` dibuja texto con fuente 8×16:
  - “X: ###”
  - “Y: ###”
  - “Z: ###”
- `font_rom.v` lee la fuente desde `font_rom.hex`

---

## Displays de 7 segmentos (HEX0..HEX5)
En `RETO.v` se muestra diferente información según el modo:

- **Modo manual:** muestra unidades/decenas de X, Y, Z (valores suavizados)
- **Modo automático:** muestra:
  - `pos_lectura` y `num_guardadas` (para visualizar la reproducción)

---

## Pruebas realizadas
Este reto fue probado principalmente en **hardware real**, verificando:
- Movimiento de servos con inclinación del acelerómetro
- Suavizado con rampa
- Guardado y reproducción automática de posiciones
- Salida VGA mostrando X, Y, Z en pantalla

---

## Evidencias 

### Video Final Reto

https://drive.google.com/file/d/1EIxWVR7jxFPT9iA_LXzwg4iYGDzH1S9N/view?usp=sharing

---

## Archivos principales del reto
- `RETO_Acelerometro/RETO_w.v` — Wrapper top: acelerómetro + lógica + VGA + PWM
- `RETO_Acelerometro/RETO.v` — Lógica principal (manual/auto, memoria, PWM, displays)
- `RETO_Acelerometro/accel.v` — Interfaz acelerómetro (SPI + PLL)
- `RETO_Acelerometro/CONVERTIDOR.v` — Calibración y conversión a 0..180°
- `RETO_Acelerometro/RAMPA.v` — Suavizado
- `RETO_Acelerometro/CONTADOR.v` — Control de guardado/reproducción
- `RETO_Acelerometro/VGACounterDemo.v` — Texto X/Y/Z en VGA
- `RETO_Acelerometro/hvsync_generator.v` — Sync VGA
- `RETO_Acelerometro/font_rom.v` — ROM de fuente (usa `font_rom.hex`)
- `RETO_Acelerometro/seg7.v` — Decoder 7 segmentos
- `RETO_Acelerometro/PLL.v`, `PLL_2.v` y archivos `_bb.v` — IP de PLL
- `RETO_Acelerometro/Accelerometer.tcl` — asignación de pines (Quartus)
- `RETO_Acelerometro/memory_RAM.v` — módulo RAM (si se usa/considera en versiones)

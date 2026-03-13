# Ana Cristina Chávez Acosta - A01742237  
## Detección de Números Primos con 4 bits en FPGA (DE10-Lite) — Práctica #1

### Objetivo
Implementar un sistema en **Verilog** que lea el valor de **4 switches** de la FPGA (SW[3:0]), interprete su valor como un número binario (0 a 15) y determine si el número es **primo**.  
El resultado se mostrará encendiendo un **LED** cuando el número sea primo.

---

## Materiales necesarios
- Tarjeta FPGA **DE10-Lite**
- Cable **USB Blaster** para la programación
- **Intel Quartus Prime Lite**
- Archivos en Verilog del módulo y su testbench

---

## Descripción del funcionamiento
- Los **4 switches** representan un número en binario (SW[3:0]).
- El módulo compara el valor de entrada y decide si es primo.
- Si el número es primo, el **LED se enciende**; en otro caso, permanece apagado.

**Números primos detectados (0–15):**  
- 2, 3, 5, 7, 11, 13

---

## Desarrollo de la práctica

### 1) Definir entradas y salidas
- **Entradas:** `SW[3:0]` (switches)
- **Salida:** `LED`

### 2) Descripción del módulo
El módulo **`Practica_1_Numeros_primos`** recibe `SW[3:0]` y genera `LED`:

- `LED = 1` → el número (SW) **es primo**
- `LED = 0` → el número (SW) **no es primo**

La lógica está implementada mediante un `case(SW)` donde se enciende el LED únicamente para los valores correspondientes a números primos.

---

## Testbench
Se desarrolló el testbench **`Practica_1_Numeros_primos_tb`** para verificar el funcionamiento del módulo, probando **todas las combinaciones** posibles de entrada:

- Se recorren los valores de `SW` desde `0000` hasta `1111` (0 a 15)
- Se monitorea la salida `LED` en consola con `$monitor`

---

## Evidencias (agrega tus imágenes aquí)

### Diagrama RTL
**RTL:** [imagen]

### Simulación (Waveform)
**Waveform:** [imagen]

### FPGA en funcionamiento
**DE10-Lite funcionando:** [imagen]

---

## Archivos del proyecto
- `Practica1_ NumerosPrimos/Practica_1_Numeros_primos.v` (módulo principal)
- `Practica1_ NumerosPrimos/Practica_1_Numeros_primos_tb.v` (testbench)

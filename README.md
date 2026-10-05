# htb-machines-cli
 
Buscador en Bash para consultar desde la terminal las máquinas de Hack The Box publicadas en [htbmachines.github.io](https://htbmachines.github.io/). Permite buscar por nombre o IP, obtener el enlace al vídeo de resolución en YouTube y filtrar por dificultad, sistema operativo, skill o certificación.
 
El script descarga el fichero `bundle.js` de la web, lo formatea y trabaja sobre esa copia local, así que las consultas son instantáneas y no necesitan conexión una vez descargado.
 
## Requisitos
 
- Bash
- `curl`
- `js-beautify`
- `sponge` (incluido en el paquete `moreutils`)
- Utilidades habituales: `awk`, `grep`, `sed`, `tr`, `column`, `md5sum`, `tput`
En Debian, Ubuntu, Kali o Parrot:
 
```bash
sudo apt install curl moreutils node-js-beautify
```
 
Si tu distribución no tiene el paquete `node-js-beautify`, puedes instalarlo con npm:
 
```bash
npm install -g js-beautify
```
 
## Instalación
 
```bash
git clone <url-del-repositorio>
cd <carpeta-del-repositorio>
chmod +x htbmachines.sh
./htbmachines.sh -u
```
 
El último comando descarga `bundle.js` en el directorio actual. Es obligatorio ejecutarlo antes de la primera búsqueda.
 
## Uso
 
```bash
./htbmachines.sh [opción] [argumento]
```
 
| Opción | Argumento | Descripción |
|--------|-----------|-------------|
| `-h` | | Muestra el menú de ayuda |
| `-u` | | Descarga los datos o comprueba si hay actualizaciones |
| `-m` | nombre | Muestra las propiedades de una máquina |
| `-i` | IP | Muestra el nombre de la máquina con esa IP |
| `-y` | nombre | Muestra el enlace de YouTube con la resolución de la máquina |
| `-d` | dificultad | Lista las máquinas de esa dificultad |
| `-o` | sistema operativo | Lista las máquinas con ese sistema operativo |
| `-s` | skill | Lista las máquinas que requieren esa skill |
| `-c` | certificación | Lista las máquinas recomendadas para esa certificación |
 
Sin opciones, el script muestra el menú de ayuda.
 
## Ejemplos
 
Descargar o actualizar los datos:
 
```bash
./htbmachines.sh -u
```
 
Ver las propiedades de una máquina:
 
```bash
./htbmachines.sh -m Tentacle
```
 
```
[+] Listando propiedades de la maquina Tentacle:
 
name -> Tentacle
ip -> <dirección IP>
so -> <sistema operativo>
dificultad -> <dificultad>
skills -> <técnicas necesarias>
like -> <certificaciones relacionadas>
youtube -> <enlace al vídeo>
```
 
Buscar una máquina por su IP:
 
```bash
./htbmachines.sh -i 10.10.10.224
```
 
Obtener el enlace de YouTube (pregunta después si quieres abrirlo):
 
```bash
./htbmachines.sh -y Tentacle
```
 
Filtrar por dificultad:
 
```bash
./htbmachines.sh -d Insane
```
 
Filtrar por sistema operativo:
 
```bash
./htbmachines.sh -o Linux
```
 
Combinar dificultad y sistema operativo:
 
```bash
./htbmachines.sh -d Media -o Windows
```
 
Filtrar por skill (entre comillas si contiene espacios):
 
```bash
./htbmachines.sh -s "Active Directory"
```
 
Filtrar por certificación:
 
```bash
./htbmachines.sh -c OSCP
```
 
## Notas
 
- **Una opción por ejecución.** La única combinación admitida es `-d` junto con `-o`. Mezclar otras opciones produce resultados inesperados.
- **Mayúsculas y tildes.** El nombre de la máquina, la dificultad y el sistema operativo deben escribirse tal y como aparecen en los datos (`Tentacle`, no `tentacle`). Las búsquedas por skill y certificación no distinguen mayúsculas.
- **Valores válidos.** Si indicas una dificultad o un sistema operativo que no existe, el script lista los valores disponibles.
- **Directorio de trabajo.** `bundle.js` se guarda y se lee en el directorio desde el que lanzas el script, así que ejecútalo siempre desde la misma carpeta.
- **Abrir el enlace de YouTube.** La opción `-y` usa el comando `open`. En macOS funciona directamente; en Linux puede que tengas que sustituirlo por `xdg-open` dentro del script.
## Cómo funciona
 
1. `-u` descarga `bundle.js` desde htbmachines.github.io y lo pasa por `js-beautify` para dejar cada propiedad en su propia línea.
2. En ejecuciones posteriores, `-u` descarga una copia temporal y compara su hash MD5 con el de la copia local. Solo la reemplaza si ha cambiado.
3. El resto de opciones filtran el fichero local con `grep`, `awk`, `sed` y `tr`.
## Créditos
 
Los datos provienen de [htbmachines.github.io](https://htbmachines.github.io/).

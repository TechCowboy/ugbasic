/* <usermanual>
@keyword IF (function)

@english

The ''IF'' function allows you to evaluate whether a certain expression is ''TRUE'' (not 0) or ''FALSE''. 
(0). Depending on that check, the function will return the second (if ''TRUE'') or third (if ''FALSE'') 
argument. 

This function evaluates the expression at compile time: it follows that the return 
value does not change at runtime. There are three versions of this function, one for each 
type of value that can be returned. There is a version that returns integers, one for 
floating point numbers, and one for strings.

This function is particularly useful for carrying out a conditional evaluation of constants which, 
otherwise, would require evaluation at runtime, wasting time and occupying useless space.

@italian
La funzione IF consente di valutare se una certa espressione è vera o falsa. A seconda di 
tale controllo, la funzione restituirà il secondo argomento (se vero) o il terzo (se falso). 

Questa funzione valuta l'espressione la momento della compilazione: ne consegue che il valore
restituito non cambia in fase di runtime. Esistono tre versioni di questa funzione, una per 
ogni tipo di valore che può essere restituito. Esiste la versione che restituisce numeri interi, 
una per i numeri in virgola mobile e una per le stringhe.

Questa funzione è particolarmente utile per effettuare una valorizzazione condizionata di costanti 
che, altrimenti, richiederebbero una valutazione a runtime, con perdita di tempo e occupazione 
di spazio inutile.

@syntax = IF (exp, valueTrue, valueFalse )


@example pictureToUse = IF(SCREEN WIDTH > 160, "large.png", "small.png" )
</usermanual> */

/* <usermanual>
@keyword FONT WIDTH (constant)

@english
This function allows you to obtain the width of the current font, expressed in pixels. 
The width depends on the currently selected graphics mode, and it can change at runtime.

There is also a compile-level function for this keyword, which is called when the value 
is used to initialize a constant. In this case, the value is that taken from inspecting 
the instructions at the time of compilation.

@italian
Questa funzione permette di ottenere la larghezza del font corrente, 
espressa in pixels. La larghezza dipende dall'attuale modalità grafica 
selezionata, e può cambiare in sede di esecuzione.

Di questa parola chiave esiste anche una funzione a livello di compilazione, 
che viene richiamata quando il valore viene utilizzato per inizializzare una 
costante. In tal caso, il valore è quello desunto dall'ispezione delle 
istruzioni al momento della compilazione.

@syntax = FONT WIDTH

@example fontSize = FONT WIDTH

@seeAlso FONT HEIGHT (constant)

</usermanual> */

/* <usermanual>
@keyword FONT HEIGHT (constant)

@english
This function allows you to obtain the height of the current font, expressed in pixels. 
The height depends on the currently selected graphics mode, and it can change at runtime.

There is also a compile-level function for this keyword, which is called when the value 
is used to initialize a constant. In this case, the value is that taken from inspecting 
the instructions at the time of compilation.

@italian
Questa funzione permette di ottenere l'altezza del font corrente, 
espressa in pixels. L'altezza dipende dall'attuale modalità grafica 
selezionata, e può cambiare in sede di esecuzione.

Di questa parola chiave esiste anche una funzione a livello di compilazione, 
che viene richiamata quando il valore viene utilizzato per inizializzare una 
costante. In tal caso, il valore è quello desunto dall'ispezione delle 
istruzioni al momento della compilazione.

@syntax = FONT HEIGHT

@example fontSize = FONT HEIGHT

@seeAlso FONT WIDTH (constant)

</usermanual> */

/* <usermanual>
@keyword BLACK (constant)

@english
This keyword represents the color black. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(0,0,0)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore nero. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(0,0,0)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = BLACK

@example PEN BLACK

@usedInExample control_loops_01.bas
@usedInExample graphics_clip_01.bas
@usedInExample graphics_plot_01.bas
@usedInExample graphics_plot_02.bas

@target all
</usermanual> */

/* <usermanual>
@keyword WHITE (constant)

@english
This keyword represents the color white. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(255,255,255)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore bianco. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(255,255,255)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

Qui di seguito si forniscono le componenti cromatiche per ogni target e chipset:

@syntax = WHITE

@example PEN WHITE

@usedInExample control_loops_01.bas
@usedInExample graphics_clip_01.bas
@usedInExample graphics_plot_01.bas
@usedInExample graphics_plot_02.bas

@target all
</usermanual> */

/* <usermanual>
@keyword RED (constant)

@english
This keyword represents the color red. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(255,0,0)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore rosso. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(255,0,0)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = RED

@example PEN RED

@usedInExample control_loops_02.bas
@usedInExample control_loops_03.bas
@usedInExample graphics_color_01.bas
@usedInExample graphics_plot_03.bas

@target all
</usermanual> */

/* <usermanual>
@keyword CYAN (constant)

@english
This keyword represents the color cyan. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(170,255,230)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore ciano. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(170,255,230)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = CYAN

@example PEN CYAN

@target all
</usermanual> */

/* <usermanual>
@keyword VIOLET (constant)

@english
This keyword represents the color violet. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(204,68,204)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore viola. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(204,68,204)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = VIOLET

@example PEN VIOLET

@target all
</usermanual> */

/* <usermanual>
@keyword GREEN (constant)

@english
This keyword represents the color green. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(0,204,85)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore verde. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(0,204,85)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = GREEN

@example PEN GREEN

@usedInExample control_loops_02.bas
@usedInExample control_loops_03.bas
@usedInExample screens_cls_03.bas

@target all
</usermanual> */

/* <usermanual>
@keyword BLUE (constant)

@english
This keyword represents the color blue. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(0,0,170)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore blue. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(0,0,170)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = BLUE

@example PEN BLUE

@usedInExample screens_cls_03.bas
@usedInExample texts_options_06.bas

@target all
</usermanual> */

/* <usermanual>
@keyword YELLOW (constant)

@english
This keyword represents the color yellow. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(238,238,119)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore giallo. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(238,238,119)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = YELLOW

@example PEN YELLOW

@usedInExample control_loops_01.bas
@usedInExample control_loops_02.bas
@usedInExample control_loops_03.bas
@usedInExample graphics_color_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword ORANGE (constant)

@english
This keyword represents the color orange. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(161, 104, 60)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore arancio. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(161, 104, 60)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = ORANGE

@example PEN ORANGE

@usedInExample control_loops_01.bas
@usedInExample control_loops_02.bas
@usedInExample control_loops_03.bas
@usedInExample graphics_color_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword BROWN (constant)

@english
This keyword represents the color brown. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space, usually ''(221, 136, 101)''. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore marrone. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB, di solito ''(221, 136, 101)''. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = BROWN

@example PEN BROWN

@target all
</usermanual> */

/* <usermanual>
@keyword LIGHT RED (constant)

@english
This keyword represents the color light red. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore rosso chiaro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = LIGHT RED

@example PEN LIGHT RED

@target all
</usermanual> */

/* <usermanual>
@keyword DARK GREY (constant)

@english
This keyword represents the color dark grey. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore grigio scuro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = DARK GREY

@example PEN DARK GREY

@alias DARK GRAY (constant)

@target all
</usermanual> */

/* <usermanual>
@keyword DARK GRAY (constant)

@english

@italian

@syntax = DARK GRAY

@example PEN DARK GRAY

@alias DARK GREY (constant)

</usermanual> */

/* <usermanual>
@keyword GREY (constant)

@english
This keyword represents the color grey. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore grigio. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = GREY

@example PEN GREY

@alias GRAY (constant)

@target all
</usermanual> */

/* <usermanual>
@keyword GRAY (constant)

@english

@italian

@syntax = GRAY

@example PEN GRAY

@alias GREY (constant)

@target all
</usermanual> */

/* <usermanual>
@keyword LIGHT GREEN (constant)

@english
This keyword represents the color light green. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore verde chiaro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = LIGHT GREEN

@example PEN LIGHT GREEN

@target all
</usermanual> */

/* <usermanual>
@keyword LIGHT BLUE (constant)

@english
This keyword represents the color light blue. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore blu chiaro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = LIGHT BLUE

@example PEN LIGHT BLUE

@target all
</usermanual> */

/* <usermanual>
@keyword LIGHT GREY (constant)

@english
This keyword represents the color light grey. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore grigio chiaro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = LIGHT GREY

@example PEN LIGHT GREY

@target all
</usermanual> */

/* <usermanual>
@keyword DARK BLUE (constant)

@english
This keyword represents the color dark blue. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore blu scuro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = DARK BLUE

@example PEN DARK BLUE

@target all
</usermanual> */

/* <usermanual>
@keyword MAGENTA (constant)

@english
This keyword represents the color magenta. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore magenta. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = MAGENTA

@example PEN MAGENTA

@target all
</usermanual> */

/* <usermanual>
@keyword PURPLE (constant)

@english
This keyword represents the color purple. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore viola. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = PURPLE

@example PEN PURPLE

@target all
</usermanual> */

/* <usermanual>
@keyword LAVENDER (constant)

@english
This keyword represents the color lavender. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore lavanda. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = LAVENDER

@example PEN LAVENDER

@target all
</usermanual> */

/* <usermanual>
@keyword GOLD (constant)

@english
This keyword represents the color gold. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore oro. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = GOLD

@example PEN GOLD

@target all
</usermanual> */

/* <usermanual>
@keyword TURQUOISE (constant)

@english
This keyword represents the color turquoise. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore turchese. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = TURQUOISE

@example PEN TURQUOISE

@target all
</usermanual> */

/* <usermanual>
@keyword TAN (constant)

@english
This keyword represents the color tan. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore tanno. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = TAN

@example PEN TAN

@target all
</usermanual> */

/* <usermanual>
@keyword YELLOW GREEN (constant)

@english
This keyword represents the color yellow green. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore giallo verde. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = YELLOW GREEN

@example PEN YELLOW GREEN

@target all
</usermanual> */

/* <usermanual>
@keyword OLIVE GREEN (constant)

@english
This keyword represents the color olive green. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore verde olive. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = OLIVE GREEN

@example PEN OLIVE GREEN

@target all
</usermanual> */

/* <usermanual>
@keyword PINK (constant)

@english
This keyword represents the color pink. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore rosa. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = PINK

@example PEN PINK

@target all
</usermanual> */

/* <usermanual>
@keyword PEACH (constant)

@english
This keyword represents the color peach. Depending on the methodology and technique, 
as well as the available hardware, it can correspond to a specific color in the RGB 
space. However, not all computers have this color. In which case, 
it is approximated by the closest color available, which is usually also used in 
decoding images to identify the color to use.

@italian
Con questa parola chiave si rappresenta il colore pesca. A seconda della metodologia 
e della tecnica, nonché dell'hardware disponibile, può corrispondere a uno specifico 
colore nello spazio RGB. Tuttavia, non tutti i computer 
dispongono di un colore di questo tipo. Nel qual caso, viene approssimato dal 
colore più vicino, che di solito viene utilizzato anche nella decodifica delle 
immagini per individuare il colore da utilizzare.

@syntax = PEACH

@example PEN PEACH

@target all
</usermanual> */

/* <usermanual>
@keyword array operator

@english
In ugBASIC, arrays are accessed using the parenthesis operator (''('' and '')'') next to the name 
of the variable that contains the array. The indices must be inserted inside the brackets to 
access the individual elements of the array. 

There is no limit to the number of dimensions: 
however, the cardinality of indices must be the same as the one used when defining the
array itself. There is, also, a limit related to memory availability. Furthermore, 
access to locations is not controlled and therefore particular care must be taken not to exceed
the boundaries of the area intended to hold the information on the array.

When an array is accessed, it can be done in two ways: to retrieve a value (read access) 
or to set a value (write access). Read access occurs any time the array is used in an 
expression. Conversely, for write access, the indexed array must be used as the target variable.

In accessing the array, as in any other variable, the dollar sign (''$'') can be juxtaposed 
to indicate that you want to access a variable of type string. In this case, a further 
type check will be carried out during the compilation, to avoid referring to a variable
of numerical type.

@italian
In ugBASIC, si accede agli array utilizzando l'operatore parentesi (''('' e '')''), aggiunto
accanto al nome della variabile che contiene l'array. Gli indici devono essere inseriti 
all'interno delle parentesi per accedere ai singoli elementi dell'array. 

Non c'è limite al numero di dimensioni: tuttavia, la cardinalità degli indici deve essere la stessa 
di quella utilizzata nella definizione della matrice stessa. Esiste, inoltre, un limite 
relativo alla disponibilità di memoria. Per di più, l'accesso agli elementi non è controllato 
e pertanto si deve prestare particolare attenzione a non eccedere i confini dell'area 
destinata a contenere le informazioni sull'array.

Quando si accede a un array lo si può fare in due modi: per recuperare un valore 
(accesso in lettura) o per impostare un valore (accesso in scrittura). 
L'accesso in lettura avviene in qualsiasi momento l'array sia utilizzato in una 
espressione. Al contrario, per accedere in scrittura bisogna utilizzare l'array 
indicizzato come variabile di destinazione.

Nell'accesso all'array, come in qualsiasi altra variabile, può essere giustapposto il 
simbolo del dollaro (''$''), per indicare che si vuole accedere a una variabile di 
tipo stringa. In tal caso, un ulteriore controllo di tipo sarà svolto in sede di 
compilazione, per evitare di far riferimento a una variabile di tipo numerico.

@syntax ... = var( o1 [, i2 [, ...] ] )
@syntax var( o1 [, i2 [, ...] ] ) = expr
@syntax ... = var$( o1 [, i2 [, ...] ] )
@syntax var$( o1 [, i2 [, ...] ] ) = expr$

@example readElement = a(42,3)
@example b(1,1) = 42
@example word = words$(42)
@example words$(1) = "ok!"

@target all
</usermanual> */

/* <usermanual>
@keyword local task variable operator

@english
To guarantee the use of local variables within parallel procedures, since the procedure does 
not have a stack, it is necessary to prepare an array to contain this type of information. 
Therefore, using the array access operator, it is then possible to access the individual 
variables, using the task identifier as an index.

ugBASIC provides a compact form to indicate this type of access. Instead of writing ''v(THREAD)''
you can write ''[v]''. This operator, called the "local task variable operator", can be used 
anywhere, and in any expression, and can be used as the target of the variable.

In accessing the array, as in any other variable, the dollar sign (''$'') can be juxtaposed 
to indicate that you want to access a variable of type string. In this case, a further 
type check will be carried out during the compilation, to avoid referring to a variable
of numerical type.

@italian
Per garantire l'utilizzo di variabili locali all'interno di procedure parallele, essendo 
la procedura priva di uno stack, è necessario predisporre un array per contenere questo 
tipo di informazione. Utilizzando, quindi, l'operatore di accesso agli array, è quindi 
possibile accedere alle singole variabili, utilizzando come indice l'identificativo del task.

ugBASIC fornisce una forma compatta per indicare questo tipo di accesso. Invece di scrivere 
''v(THREAD)'' si può scrivere ''[v]''. Questo operatore, chiamato "local task variable operator", 
può essere utilizzato dovunque, e in qualsiasi espressione, e può essere utilizzato come 
destinazione della variabile.

Nell'accesso all'array, come in qualsiasi altra variabile, può essere giustapposto il 
simbolo del dollaro (''$''), per indicare che si vuole accedere a una variabile di 
tipo stringa. In tal caso, un ulteriore controllo di tipo sarà svolto in sede di 
compilazione, per evitare di far riferimento a una variabile di tipo numerico.

@syntax = [variable]
@syntax [variable] = expression
@syntax = [variable$]
@syntax [variable$] = expression

@example PUT IMAGE token AT [x],[y]
@example [x] = [x] + 1
@example PRINT [word$]
@example [word$] = "ok!"

@usedInExample multitasking_example_06.bas

@target all
</usermanual> */

/* <usermanual>
@keyword buffer definition

@english
ugBASIC is able to define a byte buffer "in line", ie directly in the code. 
This can be useful in those occasions where it is necessary to include 
binary data, not being able to access an external file. 

The definition of a buffer occurs with the sequence of the hash operator (''#'') 
followed by the opening square bracket (''[''), by the hexadecimal couples and, 
optionally, terminated by the closing square bracket.

@italian
ugBASIC è in grado di definire un buffer di byte "in linea", cioè direttamente nel codice. 
Questo può essere utile in quelle occasioni dove sia necessario includere un dato binario, 
non potendo accedere a un file esterno. 

La definizione di un buffer avviene con la sequenza dell'operatore hash (''#'') seguita 
dalla parentesi quadra aperta (''[''), dalle coppie esadecimali e, opzionalmente, 
terminata dalla parentesi quadra chiusa.

@syntax ... = #[xx...
@syntax ... = #[xx...]

@example y = #[424280
@example x = #[424280]

@usedInExample buffers_definition_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword SIZE

@english
To get the (static) size of a buffer you can use the ''SIZE'' command. This command 
will restore, in bytes, the size of the given buffer. It is possible to apply this 
command to any type of static data, such as ''BUFFER'', ''IMAGE'', ''IMAGES'' and 
constant strings.

@italian
Per ottenere la dimensione (statica) di un buffer è possibile utilizzare il comando ''SIZE''. 
Tale comando ripristinare, in bytes, la dimensione del buffer dato. E' possibile applicare 
questo comando a qualsiasi tipo di dato statico, quali ''BUFFER'', ''IMAGE'', ''IMAGES'' e
stringe costanti.

@syntax ... = SIZE([resource])

@example PRINT SIZE(image)

@usedInExample buffers_definition_02.bas
@usedInExample buffers_definition_03.bas

@target all
</usermanual> */

/* <usermanual>
@keyword FREE

@english
Retrieves the free space still available for strings, in terms of bytes. 
This is how many characters are still available to be stored. The maximum 
value when calling this function is that indicated by the 
''DEFINE STRING SPACE'' statement. The default value for string 
storage is 1024 bytes. The command implicitly invokes garbage collection.

@italian
Recupera lo spazio libero ancora disponibile per le stringhe, in termini di bytes. 
Equivale a quanti caratteri sono ancora disponibili per essere memorizzati. Il 
valore massimo, nel richiamare questa funzione, è quello indicato 
dall'istruzione ''DEFINE STRING SPACE'', ed è pari a 1024 bytes se non viene
impostato diversamente. Il comando invoca implicitamente una garbage collection.

@syntax ... = FREE

@example PRINT FREE

</usermanual> */

/* <usermanual>
@keyword SCREEN

@english
Retrieves a bitmask with screen characteristics, such as whether or 
not TILE or BITMAP mode is available.

^ BIT POSITION ^ SYMBOL  ^ MEANING            ^
| 0            | TILEMAP | Is tilemap native? |
| 1            | BITMAP  | Is bitmap native?  |

This can be verified with a simple bitwise comparison.

@italian
Recupera una maschera di bit con le caratteristiche dello schermo, quali la 
disponibilità o meno della modalità TILE o BITMAP.

^ POSIZIONE BIT ^ SIMBOLO  ^ SIGNIFICATO                 ^
| 0             | TILEMAP  | Supporto al tilemap nativo? |
| 1             | BITMAP   | Supporto al bitmap nativo?  |

Si può verificare con un semplice confronto bit a bit.

@syntax ... = SCREEN

@example IF SCREEN IS TILEMAP THEN: PRINT "tilemap is native!": ENDIF

@usedInExample screens_bitmap_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword TILEMAP

@english
This is the bitmask used to select the TILE mode.

@italian
Questa è la maschera di bit per indicare la modalità TILE.

@syntax ... = TILEMAP

@example IF SCREEN IS TILEMAP THEN: PRINT "tilemap is native!": ENDIF

@usedInExample screens_bitmap_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword BITMAP

@english
This is the bitmask used to select the BITMAP mode.

@italian
Questa è la maschera di bit per indicare la modalità BITMAP.

@syntax ... = BITMAP

@example IF SCREEN IS BITMAP THEN: PRINT "bitmap is native!": ENDIF

@usedInExample screens_bitmap_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword CONST

@english
Using the ''CONST'' command allows you to define one or more constants, which will be used later 
in the program. Constants have the advantage of being calculated once and for 
all, at compile time, directly by the compiler and can be used to initialize 
variables. Furthermore, the constants are global, that is, they are always visible 
everywhere, both in the main program and within the procedures. Finally, constants 
do not take up memory space.

In the definition of the constants itself it is possible to indicate whether it must 
be positive or not, with the keyword ''POSITIVE''. This check is carried out at  
compilation time and, in the event of a negative result, it will result in a 
compilation error. This condition is useful to ensure that the preconditions related to
the hardware are respected (as happens, for example, when calculating the margins 
in the case of a screen smaller than the expected minimum).

It is also possible to define a validity range of the values that will be represented
in the constant. This interval is defined in a similar way to intervals in mathematics: 
using the square bracket means that the extremes (minimum, maximum) are included, 
while a round bracket means that the extremes are excluded.

@italian
L'uso del comando ''CONST'' permette di definire una costante, che sarà utilizzata 
successivamente nel programma. Le costanti hanno il vantaggio di essere calcolate 
una volta per tutte, al momento della compilazione, direttamente dal compilatore e 
possono essere usate per inizializzare le variabili. Inoltre, le costanti sono globali, 
cioè sono sempre visibili dovunque, sia nel programma principale che all'interno 
delle procedure. Infine, le costanti non occupano spazio in memoria.

Nella definizione stessa delle costanti è possibile indicare se la stessa deve 
essere o meno positiva (con la parola chiave ''POSITIVE''). Tale controllo viene 
svolto al momento della compilazione, e in caso dia esito negativo, darà luogo a 
un errore di compilazione. Tale condizione è utile per garantire che le precondizioni 
legate all'hardware siano rispettate (come avviene, ad esempio, calcolando i margini 
in caso di uno schermo più piccolo del minimo atteso).

E' anche possibile definire un intervallo di validità dei valori che saranno rappresentati 
nella costante. Tale intervallo viene definito con una modalità analoga agli intervalli 
in matematica: usando la parentesi quadra si intende che gli estremi (minimo, massimo) 
sono inclusi, mentre una parentesi tonda si intende che gli estremi sono esclusi.

@syntax [POSITIVE] CONST identifier = value
@syntax CONST identifier IN (min,max) = value
@syntax CONST identifier IN "[" min,max) = value
@syntax CONST identifier IN (min,max "]" = value
@syntax CONST identifier IN "[" min,max "]"" = value

@example CONST x = 42
@example POSITIVE CONST y = -42: ' this raises an error!
@example CONST width IN (0,320] = 128

@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias SHARED CONST
@alias CONST SHARED
@alias GLOBAL CONST
@alias CONST GLOBAL

@target all
</usermanual> */

/* <usermanual>
@keyword DIM (array)

@english

The ''DIM'' command is used to reserve a specific space in the computer's 
memory to hold data that you will use during the execution of your program. 
In practice, it is like reserving empty boxes where you can store objects
(data) of different sizes and types.

The ''DIM'' command is used primarily to create arrays, which are data 
structures that allow you to group multiple values under a single name, 
accessing each value through a numeric index. You can  define both
vectors (mono dimensional array) or a multidimensional array of values, 
and to initialize this array with the preferred values. You must also
specify the size of the array, that is, the number of elements it can contain.
When you declare an array with ''DIM'', you reserve a portion of memory 
sufficient to hold all the elements of the array.

The simplest syntax is that which defines a vector of a single dimension: 
in this case, it is sufficient to indicate the number of elements in 
parentheses. With the keyword ''AS'' you can indicate the data type 
of each single element. 

You can, of course, define a matrix (i.e. 
a vector with two or more dimensions). In this case it is sufficient to
indicate the number of elements for each dimension, separating them 
with a comma.

By definition, the array will be initialized with a value of zero 
for each element. You can change this behavior by specifying an 
initialization by assignment. The initialization can be done by 
indicating a single initialization value, each single value 
of each single element, with the same type of data with which 
the matrix was created (with the ''# {...}'' syntax), or by 
describing the memory area that will occupy the array, 
byte by byte (with the ''# [...]'' syntax ).

Arrays allow you to organize data in a structured way, making it easier 
to access and manipulate. By declaring arrays before using them, you 
define a specific size of the data. The ''DIM'' command makes code 
more readable, because it explicitly declares the data structures 
used.

@italian

Il comando ''DIM'' serve per riservare uno spazio specifico nella
memoria del computer per contenere i dati che utilizzerai durante 
l'esecuzione del tuo programma. In pratica, è come riservare delle 
caselle vuote in cui puoi memorizzare oggetti (dati) di diverse 
dimensioni e tipi.

Il comando ''DIM'' serve principalmente per creare array, che 
sono strutture dati che consentono di raggruppare più valori 
sotto un unico nome, accedendo a ciascun valore tramite un indice 
numerico. Puoi definire sia vettori (array monodimensionale) sia un 
array multidimensionale di valori e inizializzare questo array con
i valori preferiti. Devi anche specificare la dimensione dell'array,
ovvero il numero di elementi che può contenere. Quando dichiari un array
con ''DIM'', riservi una porzione di memoria sufficiente a contenere tutti gli elementi dell'array.

La sintassi più semplice è quella che definisce un vettore di 
una sola dimensione: in questo caso, è sufficiente indicare il numero di
elementi tra parentesi. Con la parola chiave ''AS'' puoi indicare il tipo 
di dati di ogni singolo elemento.

Puoi, naturalmente, definire una matrice (cioè un vettore con due o 
più dimensioni). In questo caso è sufficiente indicare il numero di elementi
per ogni dimensione, separandoli con una virgola.

Per definizione, l'array verrà inizializzato con un valore pari a zero 
per ogni elemento. Puoi modificare questo comportamento specificando 
un'inizializzazione tramite assegnazione. L'inizializzazione può essere 
effettuata indicando un singolo valore di inizializzazione, ogni singolo 
valore di ogni singolo elemento, con lo stesso tipo di dati con cui è 
stata creata la matrice (con la sintassi ''# {...}''), oppure descrivendo 
l'area di memoria che occuperà l'array, byte per byte (con la sintassi 
''# [...]'').

Gli array consentono di organizzare i dati in modo strutturato,
rendendoli più facili da accedere e manipolare. Dichiarando gli array 
prima di utilizzarli, definisci una dimensione specifica dei dati. 
Il comando ''DIM'' rende il codice più leggibile, perché dichiara 
esplicitamente le strutture dati utilizzate.

@syntax DIM name [AS type] (d1[,d2[,...]])
@syntax DIM name [AS type] (d1[,d2[,...]]) = #"["hex"]"
@syntax DIM name [AS type] (d1[,d2[,...]]) = #{v,v,...}
@syntax DIM name [AS type] WITH v (d1[,d2[,...]])

@example DIM x(42)
@example DIM values AS DWORD(20,20)
@example DIM y AS BYTE(8) = #[ff80ff80ff80ff80]
@example DIM z AS BYTE(8) = _
@example              #{ 255, 128, 255, 128, 255, 128, 255, 128 }
@example DIM scores WITH 0 (2)

@example DIM x(42)
@example DIM y(4) AS BYTE = #{ 1, 2, 3, 4 }

@usedInExample arrays_examples_01.bas
@usedInExample arrays_examples_02.bas
@usedInExample arrays_examples_03.bas
@usedInExample arrays_examples_04.bas
@usedInExample arrays_examples_05.bas
@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@seeAlso DIM (variable)

@target all
</usermanual> */

/* <usermanual>
@keyword DIM (variable)

@english

The ''DIM'' command is used to reserve a specific space in the computer's 
memory to hold data that you will use during the execution of your program. 
In particular, you can use ''DIM'' for a single variable

Declaring variables explicitly makes your code more readable and understandable,
especially in longer programs. Specifying the data type prevents type errors 
when your program runs. You can initialize a variable when you declare it, 
giving it an initial value different by 0 (the ugBASIC default value).
Moreover, when you need to use a particular data type (e.g. ''FLOAT'' 
for scientific calculations), it is advisable to explicitly declare the variable.

The scope of a variable declared with ''DIM'' depend on the context in which 
it is declared. It may be local to a procedure or global to the entire program.
It is always a good practice to declare all variables at the beginning of a 
program or procedure to improve readability and maintainability of the code, and
ugBASIC gives you the ''OPTION EXPLICIT'' directive to ensure that you use
only defined variables.

Note that ugBASIC language, as other BASIC dialect, do not need to use ''DIM'' to 
declare a variable. The data type and scope is inferred from the context in which 
the variable is first used.

@italian

Il comando ''DIM'' viene utilizzato per riservare uno spazio specifico nella 
memoria del computer per contenere i dati che utilizzerai durante l'esecuzione 
del tuo programma.

In particolare, puoi utilizzare ''DIM'' per una singola variabile. Dichiarare 
le variabili in modo esplicito rende il tuo codice più leggibile e comprensibile, 
specialmente nei programmi più lunghi. Specificare il tipo di dati impedisce 
errori di tipo quando il tuo programma viene eseguito. Puoi inizializzare una 
variabile quando la dichiari, assegnandole un valore iniziale diverso da 0 
(il valore predefinito di ugBASIC).

Inoltre, quando hai bisogno di utilizzare un particolare tipo di dati (ad 
esempio ''FLOAT'' per calcoli scientifici), è consigliabile dichiarare 
esplicitamente la variabile.

L'ambito di una variabile dichiarata con ''DIM'' dipende dal contesto in cui 
viene dichiarata. Può essere locale a una procedura o globale all'intero 
programma. È sempre una buona norma dichiarare tutte le variabili all'inizio 
di un programma o di una procedura per migliorare la leggibilità e la 
manutenibilità del codice, e ugBASIC fornisce la direttiva ''OPTION EXPLICIT'' 
per garantire che vengano utilizzate solo variabili definite.

Nota che il linguaggio ugBASIC, come altri dialetti BASIC, non ha bisogno di 
usare ''DIM'' per dichiarare una variabile. Il tipo di dati e l'ambito vengono 
dedotti dal contesto in cui la variabile viene utilizzata per la prima volta.

@syntax DIM name [AS type] [= v][,name [AS type] [= v][, ...]]

@example DIM x AS INTEGER = 42, y AS BYTE = 21

@usedInExample arrays_examples_01.bas
@usedInExample arrays_examples_02.bas
@usedInExample arrays_examples_03.bas
@usedInExample arrays_examples_04.bas
@usedInExample arrays_examples_05.bas
@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias VAR
@seeAlso DIM (array)

@target all
</usermanual> */

/* <usermanual>
@keyword VAR

@english

@italian

@alias DIM (variable)

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE MAX X

@english
This constant allows us to know which is the largest abscissa 
(x) that can assume the horizontal position of a sprite. It 
may or may not coincide with the horizontal resolution of the 
screen, in the sense that some graphics chipsets can move 
sprites far beyond what is representable (example: border 
management on the VIC-II).

@italian
Questa costante permette di sapere qual è l'ascissa (x) più 
grande che può assumere la posizione orizzontale di uno sprite.
Può o meno coincidere con la risoluzione orizzontale dello 
schermo, nel senso che  alcuni chipset grafici possono muovere 
sprite ben oltre quello che è rappresentabile (esempio: 
la gestione dei bordi sul VIC-II).

@syntax = SPRITE MAX X

@example maxX = SPRITE MAX X

@target c64
</usermanual> */

/* <usermanual>
@keyword SPRITE MIN X

@english
This constant allows us to know which is the smallest abscissa 
(x) that can assume the horizontal position of a sprite. It 
may or may not coincide with zero of the 
screen, in the sense that some graphics chipsets can move 
sprites far beyond what is representable (example: border 
management on the VIC-II).

@italian
Questa costante permette di sapere qual è l'ascissa (x) più 
piccola che può assumere la posizione orizzontale di uno sprite.
Può o meno coincidere con la risoluzione orizzontale dello 
schermo, nel senso che  alcuni chipset grafici possono muovere 
sprite ben oltre quello che è rappresentabile (esempio: 
la gestione dei bordi sul VIC-II).

@syntax = SPRITE MIN X

@example minX = SPRITE MIN X

@target c64
</usermanual> */

/* <usermanual>
@keyword SPRITE MAX Y

@english
This constant allows us to know which is the largest ordinate
(y) that can assume the vertical position of a sprite. It 
may or may not coincide with the horizontal resolution of the 
screen, in the sense that some graphics chipsets can move 
sprites far beyond what is representable (example: border 
management on the VIC-II).

@italian
Questa costante permette di sapere qual è l'ordinata (y) più 
grande che può assumere la posizione verticale di uno sprite.
Può o meno coincidere con la risoluzione verticale dello 
schermo, nel senso che  alcuni chipset grafici possono muovere 
sprite ben oltre quello che è rappresentabile (esempio: 
la gestione dei bordi sul VIC-II).

@syntax = SPRITE MAX Y

@example maxY = SPRITE MAX Y

@target c64
</usermanual> */

/* <usermanual>
@keyword SPRITE MIN Y

@english
This constant allows us to know which is the smallest ordinate 
(y) that can assume the vertical position of a sprite. It 
may or may not coincide with zero of the 
screen, in the sense that some graphics chipsets can move 
sprites far beyond what is representable (example: border 
management on the VIC-II).

@italian
Questa costante permette di sapere qual è l'ordinata (y) più 
piccola che può assumere la posizione verticale di uno sprite.
Può o meno coincidere con lo zero dello 
schermo, nel senso che  alcuni chipset grafici possono muovere 
sprite ben oltre quello che è rappresentabile (esempio: 
la gestione dei bordi sul VIC-II).

@syntax = SPRITE MIN Y

@example minX = SPRITE MIN Y

@target c64
</usermanual> */

/* <usermanual>
@keyword WAIT FIRE

@english
This instruction allows you to wait for the pressure of the FIRE key on the 
joystick. If the port number is not indicated, it means the first available 
(the one with index 0). If the keyword ''RELEASE'' is appended,
the instruction will wait for the release of the key, as well.

@italian
Questa istruzione consente di attendere la pressione del tasto FIRE del
joystick. Se non viene indicato il numero della porta, si intende il
primo disponibile (quello con indice 0). Se viene aggiunta la parola chiave
''RELEASE'', l'istruzione attenderà anche il rilascio del tasto.

@syntax WAIT FIRE [(port)] [RELEASE]

@example WAIT FIRE

@target all
</usermanual> */

/* <usermanual>
@keyword WAIT KEY

@english
This instruction allows you to wait for any key to be pressed
key on the keyboard. If the keyword ''RELEASE'' is appended,
the instruction will wait for the release of the key, as well.

@italian
Questa istruzione consente di attendere la pressione di un qualsiasi
tasto sulla tastiera. Se viene aggiunta la parola chiave
''RELEASE'', l'istruzione attenderà anche il rilascio del tasto.

@syntax WAIT KEY [RELEASE]

@example WAIT KEY

@target all
</usermanual> */

/* <usermanual>
@keyword WAIT KEY OR FIRE

@english
This instruction allows you to wait for the pressure of the FIRE key on the 
joystick or any key from keyboard. If the port number is not indicated, it means the first available 
(the one with index 0). If the keyword ''RELEASE'' is appended,
the instruction will wait for the release of the key / fire button, as well.

@italian
Questa istruzione consente di attendere la pressione del tasto FIRE del
joystick, oppure di un tasto sulla tastiera. Se non viene indicato il numero della porta, si intende il
primo disponibile (quello con indice 0). Se viene aggiunta la parola chiave
''RELEASE'', l'istruzione attenderà anche il rilascio di entrambi i tasti.

@syntax WAIT KEY OR FIRE [([port])] [RELEASE]

@example WAIT KEY OR FIRE

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE MIN Y

@english
This constant allows us to know which is the smallest ordinate 
(y) that can assume the vertical position of a sprite. It 
may or may not coincide with zero of the 
screen, in the sense that some graphics chipsets can move 
sprites far beyond what is representable (example: border 
management on the VIC-II).

@italian
Questa costante permette di sapere qual è l'ordinata (y) più 
piccola che può assumere la posizione verticale di uno sprite.
Può o meno coincidere con lo zero dello 
schermo, nel senso che  alcuni chipset grafici possono muovere 
sprite ben oltre quello che è rappresentabile (esempio: 
la gestione dei bordi sul VIC-II).

@syntax = SPRITE MIN Y

@example minX = SPRITE MIN Y

@target c64
</usermanual> */

/* <usermanual>
@keyword OPTION EXPLICIT

@english
When ''OPTION EXPLICT'' or ''OPTION EXPLICIT ON'' appears in a source file,
the programmer must explicitly declare all variables by using the ''VAR'' or
''DIM'' statements. 

If the programmer tries to use an undeclared variable 
name, an error occurs at compile time. The ''OPTION EXPLICT OFF'' statement 
allows implicit declaration of variables. If used, the ''OPTION EXPLICT'' 
statement can appear everywhere in a source file, before any other source 
code statements to check.

Setting ''OPTION EXPLICT OFF'' is generally not a good practice. The programmer
could misspell a variable name in one or more locations, which would cause 
unexpected results when the program is run.

@italian
Quando ''OPTION EXPLICT'' o ''OPTION EXPLICIT ON'' appare in un file sorgente, 
il programmatore deve dichiarare esplicitamente tutte le variabili usando le 
istruzioni ''VAR'' o ''DIM''.

Se il programmatore tenta di utilizzare un nome di variabile non dichiarato, 
si verifica un errore in fase di compilazione. L'istruzione ''OPTION EXPLICT OFF'' 
consente la dichiarazione implicita di variabili. Se utilizzata, l'istruzione 
''OPTION EXPLICT'' può apparire ovunque in un file sorgente, prima di qualsiasi 
altra istruzione del codice sorgente da controllare.

L'impostazione di ''OPTION EXPLICT OFF'' generalmente non è una buona pratica. 
Il programmatore potrebbe digitare in modo errato un nome di variabile in una 
o più posizioni, il che causerebbe risultati imprevisti durante l'esecuzione 
del programma.

@syntax OPTION EXPLICT [ON]
@syntax OPTION EXPLICT OFF

@example OPTION EXPLICIT ON

@target all
</usermanual> */

/* <usermanual>
@keyword ORIGIN

@english
The ''ORIGIN'' command can be used to set the origin of the cartesian axes with 
respect to which drawing instructions will operate. The command accepts the 
coordinates ''x, y'' of the origin, and the indication whether the Y axis is 
oriented upwards (''UP'') or downwards (''DOWN''). If not used, the reference 
system by default is placed at the top left with the Y axis downwards.

@italian
Il comando ''ORIGIN'' può essere utilizzato per impostare l'origine degli assi 
cartesiani rispetto ai quali opereranno le istruzioni di disegno. Il comando 
accetta le coordinate ''x, y'' dell'origine, e l'indicazione se l'asse delle 
Y è orientato verso l'alto (''UP'') oppure verso il basso (''DOWN''). 
Se non utilizzato, il sistema di riferimento per default viene posto in alto a 
sinistra con l'asse delle Y verso il basso. 

@syntax ORIGIN x, y UP
@syntax ORIGIN x, y [DOWN]

@example ORIGIN 100, 100 UP

@target all
</usermanual> */

/* <usermanual>
@keyword RESOLUTION

@english
This keyword allows to have a "virtual" resolution. Even when you select a graphical mode with only 
160 pixel x 200 pixel, the graphical instructions execute the same thing, the only difference is that 
the pixels will be proportional to virtual resolution. The choice to add this instruction is guided 
by mathematical ratio, since 640x400 pixels gives 1,6 where 640x200 gives 3,2. 1.6 isn't a perfect 
4/3 ratio but at least it's closer. By default, the virtual resolution will be set equal to the 
resolution given by ''BITMAP ENABLE''. Then, after ''RESOLUTION'', the graphical instructions 
will use this virtual resolution.

@italian
Questa parola chiave permette di avere una risoluzione "virtuale". Anche quando si seleziona una 
modalità grafica con soli 160 pixel x 200 pixel, le istruzioni grafiche funzioneranno con le
stesse identiche dimensioni. L'unica differenza è che i pixel saranno proporzionali alla 
risoluzione virtuale. La scelta di aggiungere questa istruzione è guidata dal rapporto matematico, 
poiché 640x400 pixel dà 1,6 dove 640x200 dà 3,2. 1.6 non è un perfetto rapporto 4/3 ma almeno è più 
vicino. Di default, la risoluzione virtuale sarà impostata uguale alla risoluzione data da 
''BITMAP ENABLE''. Quindi, dopo ''RESOLUTION'', le istruzioni grafiche utilizzeranno 
questa risoluzione virtuale.

@syntax RESOLUTION width, height

@example RESOLUTION 100, 100

@target all
</usermanual> */

/* <usermanual>
@keyword FONT LOAD

@english
The ''FONT LOAD'' command allows you to load an image and to convert it into
a font.

The command support a set of modern image format, like:

  * JPEG baseline & progressive
  * PNG 1/2/4/8/16-bit-per-channel
  * TGA
  * BMP (non-1bpp, non-RLE)
  * PSD (composited view only, no extra channels, 8/16 bit-per-channel)
  * GIF
  * HDR (radiance rgbE format)
  * PIC (Softimage PIC)
  * PNM (PPM and PGM binary only)

The image will be converted into a way that can be efficiently drawn
on the screen using the default characters.

It is also possible to indicate the index from which to start loading the various characters. 
The index is not the ASCII code but the screen code.

@italian
Il comando ''FONT LOAD'' permette di caricare un file immagine, e di convertirlo
in una serie di caratteri (font). 

Il comando supporta una serie di formati moderni:

  * JPEG baseline & progressive

  * PNG 1/2/4/8/16-bit-per-canale

  * TGA

  * BMP (non-1bpp, non-RLE)

  * PSD (vista composita, nessun canale extra, 8/16 bit-per-canale)

  * GIF

  * HDR (formato radiance rgbE)

  * PIC (Softimage PIC)

  * PNM (solo formato binario PPM e PGM)
  
L'immagine verrà convertita in un modo che possa essere disegnata in modo efficiente
sullo schermo. Potrebbe essere convertita in una tavolozza indicizzata, e potrebbe essere
anche ridimensionata.

E' inoltre possibile indicare l'indice da cui iniziare a caricare i vari caratteri. 
L'indice non è il codice ASCII ma lo screen code.

@syntax FONT LOAD filename [TO index]

@example FONT LOAD "digit0.png" TO 48

@target all
</usermanual> */
/* <usermanual>
@keyword REM

@english

In BASIC, the ''REM'' keyword (also abbreviated by the single quotation character (')) 
is used to insert comments into code. A comment is a note or explanation that is added 
to code to make it easier for the developer to understand, as well as for other
programmers who may read it in the future. 

When the computer compile the ugBASIC program, it completely ignores everything that follows 
the ''REM'' keyword on the same line. The word ''REM'' can be placed at the beginning of a line
or after a colon. In either case, the rest of the line will be treated as a comment.
To comment out multiple lines of code, you can use ''REM'' at the beginning of each line.
Note that you cannot continue a ''REM'' statement by using a line-continuation sequence 
(''_''). This means that, for a multiple-line comment, you need to use as many ''REM''s
statements as the lines you comment.

Comments have the role to describe the purpose of a particular section of code 
or individual statement, and it provide information about the program, who created it, 
when it was created, and what changes were made. They make code easier to understand, 
even for people who didn write the program: when you return to code after some time, 
comments help you remember the purpose of different parts of the program.

Moreover, it is the best way to disable
a piece of code without deleting it, simply add ''REM'' to the beginning of the line.

The main guidelines in using ''REM'' it to use simple, direct language to explain the code,
avoiding long or complicated sentences. Generally, they should be used on parts of the code 
that are not obvious. You do not need to comment on every single line.

@italian
In BASIC, la parola chiave ''REM'' (abbreviata anche con il carattere di virgoletta 
singola (')) viene utilizzata per inserire commenti nel codice. Un commento è una nota 
o una spiegazione che viene aggiunta al codice per renderlo più facile da comprendere per 
lo sviluppatore, così come per altri programmatori che potrebbero leggerlo in futuro.

Quando il computer compila il programma ugBASIC, ignora completamente tutto ciò che segue 
la parola chiave ''REM'' sulla stessa riga. La parola ''REM'' può essere posizionata 
all'inizio di una riga o dopo i due punti. In entrambi i casi, il resto della riga verrà 
trattato come un commento. Per commentare più righe di codice, puoi usare ''REM'' all'inizio 
di ogni riga.

Nota che non puoi continuare un'istruzione ''REM'' usando una sequenza di continuazione 
di riga (''_''). Ciò significa che per un commento multiriga, devi usare tante istruzioni
''REM'' quante sono le righe che stai commentando.

I commenti vengono utilizzati per descrivere lo scopo di una particolare sezione 
di codice o di una singola istruzione e forniscono informazioni sul programma, 
chi lo ha creato, quando è stato creato e quali modifiche sono state apportate. 
Rendono il codice più facile da capire, anche per chi non ha scritto il programma: 
quando si torna al codice dopo un po' di tempo, i commenti aiutano a ricordare 
lo scopo delle diverse parti del programma.

Inoltre, è il modo migliore per disabilitare un pezzo di codice senza eliminarlo, 
basta aggiungere ''REM'' all'inizio della riga. Le linee guida principali 
nell'uso di ''REM'' sono di usare un linguaggio semplice e diretto per spiegare 
il codice, evitando frasi lunghe o complicate. In genere, dovrebbero essere 
utilizzati su parti del codice che non sono ovvie. Non è necessario commentare 
ogni singola riga.

@syntax REM [comment]
@syntax ' [comment]

@example REM this is a comment
@example ' and this is a comment
@example PRINT "ok": REM I am printing ok

@target all
</usermanual> */

/* <usermanual>
@keyword defining labels

@english

In ugBASIC it is possible to indicate the position within a program with the use of 
so-called "labels". The labels can be represented in the BASIC standard, i.e. with numeric 
labels, or with alphanumeric labels, and are used to jump within specific positions of the program.

@italian

In ugBASIC è possibile indicare la posizione all'interno di un programma con l'utilizzo delle cosiddette
"etichette". Le etichette possono essere rappresentate nello standard BASIC, ovvero con etichette numeriche,
oppure con etichetta alfanumeriche, e servono per saltare all'interno di specifiche posizioni del programma.

@syntax number instruction
@syntax label: instruction
@syntax [label:] instruction

@example 100 PRINT "oK!": GOTO 100
@example begin: PRINT "OK!" : GOTO begin
@example [begin:] PRINT "OK!" : GOTO begin

@usedInExample contrib_cube_10lines.bas

@target all
@verified
</usermanual> */

/* <usermanual>
@keyword separating instructions

@english

In ugBASIC, the instructions are separated using a colon character ('':''). Since this character
is used also as a suffix for a label, you have to use the ''[label:]'' variant, to avoid to
consider ''label'' as a instruction.

@italian

In ugBASIC, le istruzioni sono separate utilizzando i due punti ('':''). Poiché questo carattere 
viene utilizzato anche come suffisso per un'etichetta, è necessario utilizzare la variante ''[label:]'',
per evitare di considerare ''label'' come una istruzione.

@syntax instruction1 : instruction2 : ...

@example PRINT : CLS : PRINT

@target all
@verified
</usermanual> */

/* <usermanual>
@keyword RGB

@english

The ''RGB'' function allows you to obtain the equivalent value of a color, given its red, green and blue 
components. The value of this function, where it is supported by the target, can be used in place of a 
nominal color. Where it is not defined, it always returns a value of zero, which may (or may not) correspond 
to a valid color.

@italian

La funzione ''RGB'' consente di ottenere il valore equivalente di un colore, date le sue componenti secondo
rosso, verde e blu. Il valore di questa funzione, laddove è supportata dal target, può essere utilizzata al
posto di un colore nominale. Laddove non è definita, restituisce sempre un valore di zero, che può (o meno)
corrispondere a un colore valido.

@syntax = RGB( red, green, blue )

@example red = RGB( 255, 0, 0 )

@usedInExample graphics_color_04.bas
@usedInExample graphics_palette_01.bas
@usedInExample images_get_03.bas

@seeAlso COLOR
@seeAlso SHADES (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword AFTER...CALL

@english

The ''AFTER...CALL'' command implement a countdown timer for your program.
It is a very useful tool for making a piece of code run after a specific interval, 
essentially turning your program into a countdown. You must specifying the length 
of time to wait, measured in ''TICKS''. 

When the timer reaches the specified timer, the program stops executing the current 
code and jumps to the ''PROCEDURE'' indicated by the label. After executing the 
routine, the program returns to where it left off and resumes execution. After the call, 
the timer is disabled. You must use, again, the ''AFTER...CALL'' to enable again the mechanism. 

There are 8 delay timers from 0 to 7 which can be specified with ''timer''
parameter. If omitted, ''timer'' will be considered as 0. In the case of parallel 
timers, 0 will be the highest and 7 the lowest priority. 

With ''EVERY OFF'' and ''EVERY ON'' you can disable or enable the timed 
calls. It is important to know or realise that low-priority-procedures 
which occurs simultanously to higher-priority-procedures are not lost. 
Their task remains or handled again after finishing the higher-prio interrupt.

Finally, note that the accuracy of the timer can vary depending on hardware and operating system,
and it can be used to create animations, simulate real-time events, or simply to execute 
tasks after a specific time.

@italian
Il comando ''AFTER...CALL'' implementa un timer di conto alla
rovescia per il programma.

È uno strumento molto utile per far sì che un pezzo di codice venga eseguito 
dopo un intervallo specifico, trasformando essenzialmente il tuo programma 
in un conto alla rovescia. Devi specificare la durata del tempo di attesa,
 misurata in ''TICKS''.

Quando il timer raggiunge il tempo specificato, il programma interrompe 
l'esecuzione del codice corrente e passa alla ''PROCEDURE'' indicata 
dall'etichetta. Dopo aver eseguito la routine, il programma torna al punto 
in cui si era interrotto e riprende l'esecuzione. Dopo la chiamata, 
il timer viene disabilitato. Devi usare, di nuovo, ''AFTER...CALL'' 
per abilitare nuovamente il meccanismo.

Ci sono 8 timer di ritardo da 0 a 7 che possono essere specificati con il 
parametro ''timer''. Se omesso, ''timer'' verrà considerato come 0. 
Nel caso di timer paralleli, 0 sarà la priorità più alta e 7 la priorità 
più bassa.

Con ''EVERY OFF'' e ''EVERY ON'' puoi disabilitare o abilitare le 
chiamate temporizzate. È importante sapere o realizzare che le procedure 
a bassa priorità che si verificano simultaneamente alle procedure a 
priorità più alta non vengono perse. Il loro compito rimane o viene gestito 
di nuovo dopo aver terminato l'interruzione a priorità più alta.

Infine, nota che la precisione del timer può variare a seconda dell'hardware
e del sistema operativo e può essere utilizzato per creare animazioni, 
simulare eventi in tempo reale o semplicemente per eseguire attività dopo un 
tempo specifico.

@syntax AFTER value[,timer] TICKS CALL identifier

@example AFTER 50 TICKS CALL changeBorderColor
@example AFTER 50,2 TICKS CALL changeBorderColor

@usedInExample control_after_01.bas

@target all
</usermanual> */

/* <usermanual>
@keyword AFTER...GOSUB

@english
Define the call of a subroutine after a specific time, without 
interfering with the main program. You must specifying the length of time 
to wait, measured in TICKS. The ugBASIC branches to the 
subroutine after ''value''/''TICKS PER SECONDS'' seconds.

There are 8 delay timers from 0 to 7 which can be specified with ''timer''. 
If omitted ''timer'' defaults to 0. In the case of parallel task has 0 the 
highest and 8 the lowest priority.

With ''EVERY OFF'' and ''EVERY ON'' you can disable or enable the timed
calls. It is important to know or realise that 
low-priority-subroutines which occurs simultanously to higher-priority-subroutines 
are not lost. Their task remains or handled again after finishing the higher-prio interrupt.

@italian
Introduce la chiamata di una subroutine dopo un certo tempo, senza interferire 
con il programma principale. È necessario specificare il tempo da attendere, 
misurato in ''TICKS''. Il compilatore ugBASIC passa alla subroutine 
dopo ''value''/''TICKS PER SECOND'' secondi.

Vi sono 8 timer di ritardo da 0 a 7 che possono essere specificati con ''timer''. 
Se omesso, il valore predefinito ''timer'' è 0. Nel caso di attività parallela, 
0 ha la priorità più alta e 8 la priorità più bassa.

Con ''EVERY OFF'' e ''EVERY ON'' è possibile disabilitare o abilitare le chiamate 
temporizzate. 
È importante sapere o realizzare che le subroutine a bassa priorità che si 
verificano contemporaneamente alle subroutine a priorità più alta non vanno perse. 
Il loro compito rimane o viene gestito nuovamente dopo aver terminato 
l'interruzione con priorità più alta.

@syntax AFTER value[,timer] TICKS GOSUB label

@example AFTER 50 TICKS GOSUB 100
@example AFTER 50,2 TICKS GOSUB label

@usedInExample control_after_02.bas

@target all
</usermanual> */

/* <usermanual>
@keyword UBOUND

@english

The ''UBOUND'' command (short for "upper bound") is used to determine the 
highest index of an array. In other words, it tells you how far up 
the array goes.

Imagine you have a box of numbered chocolates. ''UBOUND'' tells you what 
the number of the last chocolate is. This is useful when you need to 
iterate over all the elements of an array, because it gives you the end 
point of the loop.

''UBOUND'' and ''LBOUND'' are often used together to define the bounds 
of a ''FOR'' loop, and are complementary commands: they allow you to obtain 
complete information about the structure of an array. Knowing these two 
values, you can iterate over all the elements of the array, calculate 
its total size, and perform many other operations.

@italian

Il comando ''UBOUND'' (abbreviazione di "upper bound") viene utilizzato 
per determinare l'indice più alto di un array. In altre parole, ti dice 
come funziona la composizione dell'array.

Immagina di avere una scatola di cioccolatini numerati. ''UBOUND'' ti dice
qual è il numero dell'ultimo cioccolatino. Questo è utile quando devi 
scorrere tutti gli elementi di un array, perché ti fornisce il punto finale 
del ciclo.

''UBOUND'' e ''LBOUND'' vengono spesso utilizzati insieme per definire
i limiti di un ciclo ''FOR'' e sono comandi complementari: ti consentono
di ottenere informazioni complete sulla struttura di un array. Conoscendo
questi due valori, puoi scorrere tutti gli elementi dell'array, calcolarne
la dimensione totale ed eseguire molte altre operazioni.

@syntax = UBOUND( array [, dimension])

@example DIM a(10,20)
@example PRINT UBOUND(a,1) : REM it will print 20

</usermanual> */

/* <usermanual>
@keyword LBOUND

@english

The ''LBOUND'' command (short for "lower bound") is used to determine the
lowest index of an array. In other words, it tells you where the count 
of elements in an array begins.

Imagine an array as a cabinet with many numbered drawers. ''LBOUND'' tells you 
what the number of the first drawer is. This is useful when you need to 
iterate through all the elements of an array, because it gives you the 
starting point of the loop.

If you have an array with multiple dimensions, you can specify the dimension 
for which you want to find the lower bound:

''LBOUND'' is essential when you write ''FOR'' loops to iterate through all 
the elements of an array. It allows you to set the initial value of the loop 
counter correctly. 

@italian

Il comando ''LBOUND'' (abbreviazione di "lower bound") viene utilizzato per
determinare l'indice più basso di un array. In altre parole, ti dice dove
inizia il conteggio degli elementi in un array.

Immagina un array come un mobile con molti cassetti numerati. ''LBOUND'' ti dice
qual è il numero del primo cassetto. Questo è utile quando devi scorrere tutti
gli elementi di un array, perché ti fornisce il punto di partenza del ciclo.

Se hai un array con più dimensioni, puoi specificare la dimensione per cui 
vuoi trovare il limite inferiore: ''LBOUND'' è essenziale quando scrivi cicli 
''FOR'' per scorrere tutti gli elementi di un array. Ti consente di impostare 
il valore iniziale corretto del contatore del ciclo.

@syntax = LBOUND( array [, dimension])

@example DIM a(10,20)
@example PRINT LBOUND(a) : REM it will print 0

</usermanual> */

/* <usermanual>
@keyword BIG ENDIAN (constant)

@english

The ''BIG ENDIAN'' is a constant that values non zero if the rappresentation
of data on the local CPU is in big endian. Endianness is a concept that concerns 
the order in which the bytes of a multi-byte number are stored in memory. 

Imagine having an integer that spans more than one byte. Endianness determines 
whether the most significant byte (the one that represents the highest digit) 
is stored first (at the lowest memory address) or last. In this case, the most 
significant byte is stored first. It is like reading a book from left to right, 
starting with the most important word. 

Endianness is a fundamental aspect of computer architecture, as it affects how
data is interpreted and manipulated. Different architectures use different 
endianness conventions. For example: Motorola 6809 is ''BIG ENDIAN'',
MOS 6502 is ''LITTLE ENDIAN''. 

In 8-bit computers, endianness was a crucial consideration, especially when 
it came to managing integers across multiple bytes. Since these computers 
had limited memory, it was essential to maximize storage space.

With limited memory available, it was essential to use each byte efficiently, and
endianess directly affected arithmetic operations on multi-byte numbers, such as 
addition and subtraction. Moreover, when exchanging data between systems with 
different endianness, appropriate conversions is needed.

If you are writing code that directly manipulates memory, it is essential to know 
the endianness of the system to avoid data interpretation errors.  If you are 
developing software that needs to run on different platforms, you need to account 
for endianness differences and implement data conversion mechanisms, for data
that are not manager by ugBASIC itself.

@italian

La costante ''BIG ENDIAN'' ha un valore diverso da zero se la rappresentazione
dei dati sulla CPU locale è in big endian. L'endianness è un concetto che 
riguarda l'ordine in cui i byte di un numero multi-byte vengono memorizzati nella memoria.

Immagina di avere un intero che si estende su più di un byte. L'endianness 
determina se il byte più significativo (quello che rappresenta la cifra più alta) 
viene memorizzato per primo (all'indirizzo di memoria più basso) o per ultimo. 
In questo caso, il byte più significativo viene memorizzato per primo. È come 
leggere un libro da sinistra a destra, iniziando dalla parola più importante.

L'endianness è un aspetto fondamentale dell'architettura dei computer, 
poiché influisce sul modo in cui i dati vengono interpretati e manipolati. 
Architetture diverse utilizzano diverse convenzioni di endianness. Ad esempio: 
Motorola 6809 è ''BIG ENDIAN'', MOS 6502 è ''LITTLE ENDIAN''.

Nei computer a 8 bit, l'endianness era una considerazione cruciale, soprattutto 
quando si trattava di gestire interi su più byte. Poiché questi computer 
avevano una memoria limitata, era essenziale massimizzare lo spazio di archiviazione.

Con una memoria limitata disponibile, era essenziale utilizzare ogni byte in
modo efficiente e l'endianness influenzava direttamente le operazioni aritmetiche 
su numeri multi-byte, come addizione e sottrazione. Inoltre, quando si scambiavano 
dati tra sistemi con endianness diversa, erano necessarie conversioni appropriate.

Se si scrive codice che manipola direttamente la memoria, è essenziale conoscere 
l'endianness del sistema per evitare errori di interpretazione dei dati. Se si 
sviluppa software che deve essere eseguito su piattaforme diverse, è necessario 
tenere conto delle differenze di endianness e implementare meccanismi di 
conversione dei dati, per i dati che non sono gestiti da ugBASIC stesso.

@syntax = BIG ENDIAN

@example IF BIG ENDIAN THEN 
@example    PRINT "This CPU is big endian"
@example ENDIF

@seeAlso LITTLE ENDIAN (constant)

@target all
</usermanual> */

/* <usermanual>
@keyword LITTLE ENDIAN (constant)

@english

The ''LITTLE ENDIAN'' is a constant that values non zero if the rappresentation
of data on the local CPU is in little endian. Endianness is a concept that concerns 
the order in which the bytes of a multi-byte number are stored in memory. 

Imagine having an integer that spans more than one byte. Endianness determines 
whether the most significant byte (the one that represents the highest digit) 
is stored first (at the lowest memory address) or last. In this case, the least 
significant byte is stored first. It is like reading a book from right to left, 
starting with the least important word. 

Endianness is a fundamental aspect of computer architecture, as it affects how
data is interpreted and manipulated. Different architectures use different 
endianness conventions. For example: Motorola 6809 is ''BIG ENDIAN'',
MOS 6502 is ''LITTLE ENDIAN''. 

In 8-bit computers, endianness was a crucial consideration, especially when 
it came to managing integers across multiple bytes. Since these computers 
had limited memory, it was essential to maximize storage space.

With limited memory available, it was essential to use each byte efficiently, and
endianess directly affected arithmetic operations on multi-byte numbers, such as 
addition and subtraction. Moreover, when exchanging data between systems with 
different endianness, appropriate conversions is needed.

If you are writing code that directly manipulates memory, it is essential to know 
the endianness of the system to avoid data interpretation errors.  If you are 
developing software that needs to run on different platforms, you need to account 
for endianness differences and implement data conversion mechanisms, for data
that are not manager by ugBASIC itself.

@italian

''LITTLE ENDIAN'' è una costante che ha un valore diverso da zero se la rappresentazione
dei dati sulla CPU locale è in little endian. L'endianità è un concetto che riguarda
l'ordine in cui i byte di un numero multi-byte vengono archiviati nella memoria.

Immagina di avere un intero che si estende su più di un byte. L'endianità determina
se il byte più significativo (quello che rappresenta la cifra più alta)
viene archiviato per primo (all'indirizzo di memoria più basso) o per ultimo. 
In questo caso, il byte meno significativo viene archiviato per primo. È come 
leggere un libro da destra a sinistra, iniziando dalla parola meno importante.

L'endianità è un aspetto fondamentale dell'architettura dei computer, poiché 
influenza il modo in cui i dati vengono interpretati e manipolati. Architetture 
diverse utilizzano diverse convenzioni di endianità. Ad esempio: Motorola 6809 
è ''BIG ENDIAN'', MOS 6502 è ''LITTLE ENDIAN''.

Nei computer a 8 bit, l'endianness era una considerazione cruciale, soprattutto 
quando si trattava di gestire interi su più byte. Poiché questi computer avevano 
una memoria limitata, era essenziale massimizzare lo spazio di archiviazione. 
Con una memoria limitata disponibile, era essenziale utilizzare ogni byte in modo
efficiente e l'endianness influenzava direttamente le operazioni aritmetiche su 
numeri multi-byte, come l'addizione e la sottrazione. Inoltre, quando si scambiano 
dati tra sistemi con endianness diversa, sono necessarie conversioni appropriate. 
Se si scrive codice che manipola direttamente la memoria, è essenziale conoscere 
l'endianness del sistema per evitare errori di interpretazione dei dati. Se si 
sviluppa un software che deve essere eseguito su piattaforme diverse, è necessario 
tenere conto delle differenze di endianness e implementare meccanismi di conversione 
dei dati, per i dati che non sono gestiti da ugBASIC stesso.

@syntax = LITTLE ENDIAN

@example IF LITTLE ENDIAN THEN 
@example    PRINT "This CPU is little endian"
@example ENDIF

@seeAlso BIG ENDIAN (constant)

@target all
</usermanual> */

/* <usermanual>
@keyword VARBANK

@english
Returns the bank assigned for the given variable, -1 if the variable is on resident memory.

@italian
Restituisce il banco della memoria espansa assegnato per la data variabile, oppure -1
se la variabile è posta sulla memoria residente.

@syntax = VARBANK( variable )

@example DIM x as INTEGER: DIM largeArray( 100, 100 ) AS INTEGER BANKED
@example x = 42
@example BANK WRITE VARBANK( largeArray ) FROM VARPTR( x ) TO VARBANKPTR( largeArray ) SIZE 2

@target all
</usermanual> */

/* <usermanual>
@keyword VARBANKPTR

@english
Returns the address assigned for the given variable inside a bank of memory expansion.

@italian
Restituisce l'indirizzo di memoria assegnato all'interno del banco di memoria espansa.

@syntax = VARBANKPTR( variable )

@example DIM x as INTEGER: DIM largeArray( 100, 100 ) AS INTEGER BANKED
@example x = 42
@example BANK WRITE VARBANK( largeArray ) FROM VARPTR( x ) TO VARBANKPTR( largeArray ) SIZE 2

@target all
</usermanual> */

/* <usermanual>
@keyword ENABLE INTERRUPT

@english

An interrupt is a signal that temporarily stops the normal execution of a program, 
allowing the processor to handle external events or internal exceptions. These events can be
a key being pressed on the keyboard, data arriving from a serial port or a timer reaching zero.

Interrupts allow the processor to respond quickly and efficiently to external events, 
avoiding delays in processing, so that you can handle events that occur independently 
of the main program execution and so the computer can communicate with external devices 
such as keyboard.

This instruction will change the specific register of the main processor, so that interrupts will
be served again.

@italian

Un interrupt è un segnale che interrompe temporaneamente la normale esecuzione di un programma, 
consentendo al processore di gestire eventi esterni o eccezioni interne. Questi eventi possono 
essere la pressione di un tasto sulla tastiera, l'arrivo di dati da una porta seriale o un timer 
che raggiunge lo zero.

Gli interrupt consentono al processore di rispondere in modo rapido ed efficiente agli eventi 
esterni, evitando ritardi nell'elaborazione, in modo da poter gestire eventi che si verificano 
indipendentemente dall'esecuzione del programma principale e in modo che il computer possa 
comunicare con dispositivi esterni come la tastiera.

Questa istruzione modificherà il registro specifico del processore principale, in modo che 
gli interrupt vengano nuovamente serviti.

@syntax ENABLE INTERRUPT

@example ENABLE INTERRUPT

@seeAlso DISABLE INTERRUPT

@target all
</usermanual> */

/* <usermanual>
@keyword DISABLE INTERRUPT

@english

An interrupt is a signal that temporarily stops the normal execution of a program, 
allowing the processor to handle external events or internal exceptions. These events can be
a key being pressed on the keyboard, data arriving from a serial port or a timer reaching zero.

Interrupts allow the processor to respond quickly and efficiently to external events, 
avoiding delays in processing, so that you can handle events that occur independently 
of the main program execution and so the computer can communicate with external devices 
such as keyboard.

This instruction will change the specific register of the main processor, so that interrupts will
not be served anymore.

@italian

Un interrupt è un segnale che interrompe temporaneamente la normale esecuzione di un programma, 
consentendo al processore di gestire eventi esterni o eccezioni interne. Questi eventi possono 
essere la pressione di un tasto sulla tastiera, l'arrivo di dati da una porta seriale o un timer 
che raggiunge lo zero.

Gli interrupt consentono al processore di rispondere in modo rapido ed efficiente agli eventi 
esterni, evitando ritardi nell'elaborazione, in modo da poter gestire eventi che si verificano 
indipendentemente dall'esecuzione del programma principale e in modo che il computer possa 
comunicare con dispositivi esterni come la tastiera.

Questa istruzione modificherà il registro specifico del processore principale, in modo che 
gli interrupt non siano più serviti.

@syntax DISABLE INTERRUPT

@example DISABLE INTERRUPT

@seeAlso ENABLE INTERRUPT

</usermanual> */

/* <usermanual>
@keyword JOY

@english
Read the value from the joystick port. 

@italian
Leggi il valore della porta del joystick.

@syntax = JOY( port )

@example x = JOY(0)

@target all
</usermanual> */

/* <usermanual>
@keyword JUP

@english
Read the joystick port and check for "direction up" bit.

@italian
Leggi il valore della porta del joystick, e controlla il bit in "direzione su".

@syntax = JUP( port )

@example x = JUP(0)

@target all
</usermanual> */

/* <usermanual>
@keyword JDOWN

@english
Read the joystick port and check for "direction down" bit.

@italian
Leggi il valore della porta del joystick, e controlla il bit in "direzione giù".

@syntax = JDOWN( port )

@example x = JDOWN(0)

@target all
</usermanual> */

/* <usermanual>
@keyword JLEFT

@english
Read the joystick port and check for "direction left" bit.

@italian
Leggi il valore della porta del joystick, e controlla il bit in "direzione sinistra".

@syntax = JLEFT( port )

@example x = JLEFT(0)

@target all
</usermanual> */

/* <usermanual>
@keyword JRIGHT

@english
Read the joystick port and check for "direction right" bit.

@italian
Leggi il valore della porta del joystick, e controlla il bit in "direzione destra".

@syntax = JRIGHT( port )

@example x = JRIGHT(0)

@target all
</usermanual> */

/* <usermanual>
@keyword JFIRE

@english
Read the joystick port and check for "fire button" bit.

@italian
Leggi il valore della porta del joystick, e controlla il bit "fuoco".

@syntax = JFIRE( port )

@example x = JFIRE(0)

@target all
</usermanual> */

/* <usermanual>
@keyword FIRE (function)

@english

Read the joystick port and check for "fire button" bit.

@italian

Leggi il valore della porta del joystick, e controlla il bit "FIRE".

@syntax = FIRE( port )

@example x = FIRE(0)
</usermanual> */

/* <usermanual>
@keyword FIRE (constant)

@english

Return the bitmask for joystick's fire bit.

@italian

Restituisce il bitmask per il bit FIRE del joystick.

@syntax = FIRE

@example x = FIRE

@alias JOY FIRE (constant)
</usermanual> */

/* <usermanual>
@keyword JOY FIRE (constant)

@english

@italian

@syntax = JOY FIRE

@example x = JOY FIRE

@alias FIRE (constant)
</usermanual> */

/* <usermanual>
@keyword JOY COUNT (constant)

@english
Read the number of joysticks installed into the system.

@italian
Recupera il numero di porte joystick installate nel sistema.

@syntax = JOY COUNT

@example x = JOY COUNT

@alias JOYCOUNT
</usermanual> */

/* <usermanual>
@keyword JOYCOUNT

@english
Read the number of joysticks installed into the system.

@italian
Recupera il numero di porte joystick installate nel sistema.

@syntax = JOYCOUNT

@example x = JOYCOUNT

@alias JOY COUNT

</usermanual> */

/* <usermanual>
@keyword JOY X

@english
Read the horizontal axys of an analogical joystick, if it is present.
A negative value means "left" while a positive one means "right".
The value near 0 means "no direction".

@italian
Legge il valore dell'asse orizzontale di un joystick analogico, se presente.
Un valore negativo indica "sinistra" mentre un valore positivo indica "destra".
Un valore prossimo allo 0 significa "nessuna direzione".

@syntax = JOY X( port )

@example x = JOY X(0)

@target coco
@target coco3
@target d32
@target d64

@alias JOYX

</usermanual> */

/* <usermanual>
@keyword JOYX

@english

@italian

@syntax = JOYX( port )

@example x = JOYX(0)

@alias JOY X

@target coco
@target coco3
@target d32
@target d64
</usermanual> */

/* <usermanual>
@keyword JOYY

@english
Read the vertical axys of an analogical joystick, if it is present.
A negative value means "up" while a positive one means "down".
The value near 0 means "no direction".

@italian
Legge il valore dell'asse verticale di un joystick analogico, se presente.
Un valore negativo indica "su" mentre un valore positivo indica "giù".
Un valore prossimo allo 0 significa "nessuna direzione".

@syntax = JOY Y( port )

@example y = JOY Y(0)

@target coco
@target coco3
@target d32
@target d64

@alias JOYY

</usermanual> */

/* <usermanual>
@keyword JOYY

@english

@italian

@syntax = JOYY( port )

@example y = JOYY(0)

@alias JOY Y

@target coco
@target coco3
@target d32
@target d64
</usermanual> */

/* <usermanual>
@keyword BLOCK

@english

@italian

@syntax BLOCK x1, y1, x2, y2, fq

@example BLOCK x, y, x+29, y+19, 0

@usedInExample tsb_block_rec_01.bas

@alias BAR

@project tsb
</usermanual> */

/* <usermanual>
@keyword REC

@english

''REC'' draws a rectangle. The location of the top left corner is determined by the first two 
parameters ''x'' and ''y'', the width and height of the rectangle by parameters three and four 
(''sa'' and ''sb''). The color of the edge lines is determined by the last parameter (''fq'', 
color source). The four corners of the rectangle are always drawn.

Permissible values are 0..''SCREEN WIDTH'' for ''x'' and ''sa''. 
For ''y'' or ''sb'', values from 0 to ''SCREEN HEIGHT'' are permitted in both cases. The color also depends on
the graphics mode and refers to the color specifications behind ''HIRES'' on the one hand and 
''MULTI'' and ''LOW COL'' on the other. The point 0,0 is in the top left corner.

Note: If the edge lengths of the rectangle exceed the screen limits, rectangle will be clipped.

@italian

''REC'' disegna un rettangolo. La posizione dell'angolo in alto a sinistra è determinata dai
primi due parametri ''x'' e ''y'', la larghezza e l'altezza del rettangolo dai parametri tre e 
quattro (''sa'' e ''sb'' ). Il colore delle linee del bordo è determinato dall'ultimo parametro 
(''fq'', sorgente colore). Vengono sempre disegnati i quattro angoli del rettangolo.

I valori consentiti sono 0..''SCREEN WIDTH'' per ''x'' e ''sa''. Per ''y'' o ''sb'' sono ammessi 
in entrambi i casi i valori da 0 a ''SCREEN HEIGHT''. Il colore dipende anche dalla modalità 
grafica e si riferisce alle specifiche del colore date al comando ''HIRES'' da un lato e 
''MULTI'' e ''LOW COL'' dall'altro. Il punto 0,0 si trova nell'angolo in alto a sinistra.

Nota: se la lunghezza dei bordi del rettangolo supera i limiti dello schermo, il rettangolo
sarà ritagliato

@syntax REC x, y, sa, sb, fq

@example REC x, y, 29, 19, 1

@usedInExample tsb_block_rec_01.bas

@target c128
@project tsb
</usermanual> */

/* <usermanual>
@keyword HIRES

@english

`HIRES` is used to switch from text to high-resolution graphics mode and to use the specified colors: 
''ink'' for the writing color and ''paper'' for the background color (both with values from 0 to ''SCREEN COLORS'').
The graphics memory is deleted and preset with the specified colors. The color of the screen frame 
remains unaffected. The selected mode remains active until it is switched off or changed by a command 
(''MULTI'', ''CSET'' or ''NRM''). Important: the color specifications of almost all other graphics 
commands that use ''fg'' as color parameter refers to the colors specified here. If the color source ''0'' is specified in a graphics 
command, the color specified for ''paper'' is selected; if ''1'' is specified, the color for ''ink''
is selected; the color specification ''2'' inverts the controlled pixel (if in hires mode, 
otherwise see ''MULTI''). 

@italian

''HIRES'' serve per passare dalla modalità testo a quella grafica ad alta risoluzione e per
utilizzare i colori specificati: ''ink'' per il colore della scrittura e ''paper'' per il colore
dello sfondo (entrambi con valori da 0 a ''SCREEN COLORS''). La memoria grafica viene cancellata e
preimpostata con i colori specificati. Il colore della cornice dello schermo rimane inalterato. 
La modalità selezionata rimane attiva finché non viene spenta o modificata tramite un comando 
(''MULTI'', ''CSET'' o ''NRM''). Importante: le specifiche dei colori di quasi tutti gli altri
comandi grafici che usano ''fg'' come parametro del colore si riferiscono ai colori qui specificati. 
Se in un comando grafico viene specificata l'origine colore ''0'', viene selezionato il colore 
specificato per ''paper''; se viene specificato ''1'', viene selezionato il colore per 
''ink''; la specifica colore ''2'' inverte il pixel controllato (se in modalità ''HIRES'', altrimenti
vedi ''MULTI'').

@syntax HIRES ink, paper

@example HIRES 0, 1

@usedInExample tsb_block_rec_01.bas

@target c128
@project tsb
</usermanual> */

/* <usermanual>
@keyword DO NULL

@english

Wait for a keystroke. If a program comes to a ''DO NULL'' instruction, it waits until the user presses
a key. Differently from TSB, further commands can follow on the same BASIC line in the progra,
and it can be used in an ''IF'' line (after ''THEN'' or ''ELSE''). 

@italian

Aspetta la sequenza di tasti. Se un programma arriva a un'istruzione ''DO NULL'', attende finché l'utente
preme un tasto. A differenza di TSB, ulteriori comandi possono seguire sulla stessa riga BASIC nel programma,
e può essere utilizzata in una riga ''IF'' (dopo ''THEN'' o ''ELSE'').

@syntax DO NULL

@example DO NULL

@usedInExample tsb_block_rec_01.bas

@seeAlso WAIT KEY

@project tsb
</usermanual> */

/* <usermanual>
@keyword NRM

@english

''NRM'' resets the chipset to its default values: the graphic mode is switched off,
uppercase and lowercase font is activated, the extended color mode is switched off.

@italian

''NRM'' ripristina il chipset ai suoi valori predefiniti: la modalità grafica è 
disattivata, i caratteri maiuscoli e minuscoli sono attivati, la modalità colore 
estesa è disattivata.

@syntax NRM

@example NRM

@usedInExample tsb_block_rec_01.bas

@target c128
@project tsb
</usermanual> */

/* <usermanual>
@keyword INSERT (function)

@english

The ''INSERT'' command allows you to insert a substring into an existing string, 
at a specific position that you specify. ''INSERT'' inserts the character string 
''string'' (first argument) into the character string 
''alt'' (second argument) starting at the position ''pos'' (third argument), whereby 
the counting starts with ''1''. The resulting character string is as long as the sum of the two 
individual character strings.

You can use ''INSERT'' to join strings 
more precisely than simple concatenation with the ''+'' symbol. You can insert 
spaces, special characters, or other elements to format strings to your liking.
You can correct typos, add or remove text precisely. You can build complex strings 
by combining static and variable parts.

The position ''pos'' you specify must be an integer between 1 and the length 
of the main string plus 1. ''INSERT'' creates a copy of the final string.


@italian

Il comando ''INSERT'' consente di inserire una sottostringa in una stringa 
esistente, in una posizione specifica da te specificata. ''INSERT'' inserisce 
la stringa di caratteri ''string'' (primo argomento) nella stringa di caratteri
''alt'' (secondo argomento) a partire dalla posizione ''pos'' (terzo argomento), 
per cui il conteggio inizia con ''1''. La stringa di caratteri risultante è 
lunga quanto la somma delle due stringhe di caratteri individuali.

Puoi usare ''INSERT'' per unire stringhe in modo più preciso rispetto alla 
semplice concatenazione con il simbolo ''+''. Puoi inserire spazi, caratteri 
speciali o altri elementi per formattare le stringhe a tuo piacimento.
Puoi correggere errori di battitura, aggiungere o rimuovere testo in modo 
preciso. Puoi creare stringhe complesse combinando parti statiche e variabili.

La posizione ''pos'' specificata deve essere un numero intero compreso tra 
1 e la lunghezza della stringa principale più 1. ''INSERT'' crea una copia 
della stringa finale.

@syntax = INSERT( string, alt, pos ) 

@example c$=INSERT(a$,b$,9)

@usedInExample tsb_insert_01.bas

</usermanual> */

/* <usermanual>
@keyword COLORS (constant)

@english

This constant holds the maximum number of colors available for the target, for 
the current mode. Note that, although this is the number of colors available, 
it is not guaranteed that every single graphic or text element in the mode could 
assume this number independently. This depends on the specific characteristics 
of the video chipset available. Also, it is not guaranteed that the colors are 
changeable. This information is useful when you want to choose a random color 
from those available, or to perform loops on the actual availability of colors.

@italian

Questa costante mantiene il numero massimo di colori disponibili per il target, 
per la modalità corrente. Nota che, sebbene questo sia il numero di colori 
disponibili, non è detto che ogni singolo elemento grafico o testuale della 
modalità possa assumerlo in modo indipendente. Questo dipende dalle caratteristiche 
specifiche del chipset video a disposizione. Inoltre, non è detto che i colori 
siano modificabili. Questa informazione è utile laddove si voglia scegliere un 
colore a caso tra quelli disponibili, o effettuare cicli sulla effettiva 
disponibilità di colori.

@syntax = COLORS

@alias SCREEN COLORS (constant)
@alias COLORS COUNT (constant)
@alias COLOR COUNT (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN COLORS (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''.

@syntax = SCREEN COLORS

@alias COLORS (constant)
@alias COLORS COUNT (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword COLORS COUNT (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''.

@syntax = COLORS COUNT

@alias COLORS (constant)
@alias SCREEN COLORS (constant)
@alias COLOR COUNT (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword COLOR COUNT (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''.

@syntax = COLOR COUNT

@alias COLORS (constant)
@alias SCREEN COLORS (constant)
@alias COLORS COUNT (constant)
@target all
</usermanual> */


/* <usermanual>
@keyword COLOURS (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''

@syntax = COLOURS

@alias SCREEN COLOURS (constant)
@alias COLOURS COUNT (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN COLOURS (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''.

@syntax = SCREEN COLORS

@alias COLOURS (constant)
@alias COLOURS COUNT (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword COLOURS COUNT (constant)

@english

Alias for ''COLORS''.

@italian

Alias per ''COLORS''.

@syntax = COLOURS COUNT

@alias COLOURS (constant)
@alias SCREEN COLOURS (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword PEN COLORS (constant)

@english

This constant gives the number of colors that can be used with the ''PEN'' command. 
It usually represents the maximum number of colors that can be managed in text mode,
and has little to do with the actual number of colors available in the mode in use. 
For that, it is advisable to use the ''COLORS'' constant.

@italian

Questa costante fornisce il numero di colori utilizzabili con il comando ''PEN''. 
Di solito rappresenta il numero massimo di colori gestibili nella modalità testuale, 
e non ha molta attinenza con l'effettivo numero di colori disponibili nella 
modalità in uso. Per quello è consigliabile usare la costante ''COLORS''.

@syntax = PEN COLORS

@seeAlso COLORS (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword PAPER COLORS (constant)

@english

This constant gives the number of colors that can be used with the ''PAPER'' command. 
It usually represents the maximum number of colors that can be managed in text mode,
and has little to do with the actual number of colors available in the mode in use. 
For that, it is advisable to use the ''COLORS'' constant.

@italian

Questa costante fornisce il numero di colori utilizzabili con il comando ''PAPER''. 
Di solito rappresenta il numero massimo di colori gestibili nella modalità testuale, 
e non ha molta attinenza con l'effettivo numero di colori disponibili nella 
modalità in uso. Per quello è consigliabile usare la costante ''COLORS''.

@syntax = PAPER COLORS

@seeAlso COLORS (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword COLOR (data type)

@english

The ''COLOR'' data type holds enough information to represent a color on the target's 
video chipset. This type of information allows one of several possible colors to be 
selected, either predefined or redefined, depending on the targets' capabilities.

@italian

Il tipo di dato ''COLOR'' mantiene l'informazione sufficiente a rappresentare un colore 
sul chipset video del target. Questo tipo di informazione permette di selezionare uno 
dei colori possibili, predefiniti o ridefiniti, a seconda delle possibilità dei target.

@syntax DIM c AS COLOR
@syntax x = (COLOR) 42

@target all
</usermanual> */

/* <usermanual>
@keyword SHADES (constant)

@english

This constant holds the maximum number of shades available for the target, for 
the current mode. Note that, although this is the number of shades available, 
it is not guaranteed that every single graphic or text element in the mode could 
assume this value, independently. This depends on the specific characteristics 
of the video chipset available. 

@italian

Questa costante mantiene il numero massimo di sfumature disponibili per il target, 
per la modalità corrente. Nota che, sebbene questo sia il numero di sfumature 
disponibili, non è detto che ogni singolo elemento grafico o testuale della 
modalità possa assumere tale vlaore in modo indipendente. Questo dipende dalle 
caratteristiche specifiche del chipset video a disposizione. 

@syntax = SHADES

@alias SCREEN SHADES (constant)
@seeAlso COLOR
@seeAlso RGB
@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN SHADES (constant)

@english

Alias for ''SHADES''.

@italian

Alias per ''SHADES''.

@syntax = SCREEN SHADES

@alias SHADES (constant)
@seeAlso COLOR
@seeAlso RGB
@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN BORDER X (constant)

@english

Returns the width of the border of the screen, in the reference frame used by sprites. If no sprites 
are available, or if the border is not present, it is equal to ''0''. This constant should be used as
a horizontal offset, to ensure that the sprite is visible beyond the left screen border.

@italian

Restituisce la larghezza del bordo dello schermo, nel sistema di riferimento utilizzato dagli sprites. Se 
gli sprite non sono disponibili, oppure se il bordo non è presente, vale ''0''. Questa costante 
deve essere utilizzata come offset orizzontale, per garantire che lo sprite sia visibile oltre
il bordo sinistro dello schermo.

@syntax = SCREEN BORDER X

@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN BORDER Y (constant)

@english

Returns the height of the border of the screen, in the reference frame used by sprites. If no sprites 
are available, or if the border is not present, it is equal to ''0''. This constant should be used as
a vertical offset, to ensure that the sprite is visible beyond the top screen border.

@italian

Restituisce l'altezza del bordo dello schermo, nel sistema di riferimento utilizzato dagli sprites. Se 
gli sprite non sono disponibili, oppure se il bordo non è presente, vale ''0''. Questa costante 
deve essere utilizzata come offset verticale, per garantire che lo sprite sia visibile oltre
il bordo superiore dello schermo.

@syntax = SCREEN BORDER Y

@target all
</usermanual> */

/* <usermanual>
@keyword BORDER

@english

Alias for ''COLOR BORDER''.

@italian

Alias per ''COLOR BORDER''.

@syntax BORDER shade

@alias COLOR BORDER
@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE COUNT (constant)

@english

This constant allows you to know the number of hardware sprites available on the 
target considered. Note that this is the effective limit allowed by the video
chipset: however, ugBASIC can provide additional mechanisms to multiply the 
number of available sprites, such as the so-called "sprite multiplexing".

@italian

Questa costante permette di conoscere il numero di sprite hardware disponibili 
sul target considerato. Da notare che questo è l'effettivo limite concesso
dal chipset video: tuttavia, ugBASIC può dare meccanismi aggiuntivi per 
moltiplicare il numero di sprite disponibili, come il cosiddetto 
"sprite multiplexing".

@syntax = SPRITE COUNT

@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN SPRITE RATIO X (constant)

@english

This constant allows you to know the ratio (percentile) between the screen 
reference system and the sprite reference system. In other words, given a
coordinate according to the screen reference system, you can calculate the 
one according to the sprite reference system with the following proportion:

'''( SCREEN WIDTH * SCREEN SPRITE RATIO X ) / 100'''

@italian

Questa costante permette di conoscere il rapporto (percentile) tra il 
sistema di riferimento dello schermo e quello degli sprite. In altri termini, 
data una coordinata secondo il sistema di riferimento dello schermo, si può 
calcolare quella secondo il sistema di riferimento degli sprite con la 
seguente proporzione:

'''( SCREEN WIDTH * SCREEN SPRITE RATIO X ) / 100'''

@syntax = SCREEN SPRITE RATIO X

@target all
</usermanual> */

/* <usermanual>
@keyword SCREEN SPRITE RATIO Y (constant)

@english

This constant allows you to know the ratio (percentile) between the screen 
reference system and the sprite reference system. In other words, given a
coordinate according to the screen reference system, you can calculate the 
one according to the sprite reference system with the following proportion:

'''( SCREEN HEIGHT * SCREEN SPRITE RATIO Y ) / 100'''

@italian

Questa costante permette di conoscere il rapporto (percentile) tra il 
sistema di riferimento dello schermo e quello degli sprite. In altri termini, 
data una coordinata secondo il sistema di riferimento dello schermo, si può 
calcolare quella secondo il sistema di riferimento degli sprite con la 
seguente proporzione:

'''( SCREEN HEIGHT * SCREEN SPRITE RATIO Y ) / 100'''

@syntax = SCREEN SPRITE RATIO Y

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE HEIGHT (constant)

@english

This constant allows you to know the height of hardware sprites available on the 
target considered. Note that this is the effective limit allowed by the video
chipset: however, ugBASIC can provide additional mechanisms to increase the 
height of sprites, such as the so-called "sprite multiplexing".

@italian

Questa costante permette di conoscere l'altezza degli sprite hardware disponibili 
sul target considerato. Da notare che questo è l'effettivo limite concesso
dal chipset video: tuttavia, ugBASIC può dare meccanismi aggiuntivi per 
accrescere l'altezza degli sprite disponibili, come il cosiddetto 
"sprite multiplexing".

@syntax = SPRITE HEIGHT

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE WIDTH (constant)

@english

This constant allows you to know the width of hardware sprites available on the 
target considered. Note that this is the effective limit allowed by the video
chipset: however, ugBASIC can provide additional mechanisms to increase the 
width of sprites, such as the so-called "sprite multiplexing".

@italian

Questa costante permette di conoscere la larghezza degli sprite hardware disponibili 
sul target considerato. Da notare che questo è l'effettivo limite concesso
dal chipset video: tuttavia, ugBASIC può dare meccanismi aggiuntivi per 
accrescere la larghezza degli sprite disponibili, come il cosiddetto 
"sprite multiplexing".

@syntax = SPRITE WIDTH

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE X MIN (constant)

@english

This constant allows you to know the minimum value of horizontal position of hardware 
sprites available on the target considered. Note that this is the effective limit 
allowed by the video chipset.

@italian

Questa costante permette di conoscere il valor minimo della posizione X degli sprite 
hardware disponibili  sul target considerato.

@syntax = SPRITE X MIN
@syntax = SPRITE MIN X

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE Y MIN (constant)

@english

This constant allows you to know the minimum value of vertical position of hardware 
sprites available on the target considered. Note that this is the effective limit 
allowed by the video chipset.

@italian

Questa costante permette di conoscere il valor minimo della posizione Y degli sprite 
hardware disponibili sul target considerato.

@syntax = SPRITE Y MIN
@syntax = SPRITE MIN Y

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE X MAX (constant)

@english

This constant allows you to know the maximum value of horizontal position of hardware 
sprites available on the target considered. Note that this is the effective limit 
allowed by the video chipset.

@italian

Questa costante permette di conoscere il valor massimo della posizione X degli sprite 
hardware disponibili  sul target considerato.

@syntax = SPRITE X MAX
@syntax = SPRITE MAX X

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE Y MAX (constant)

@english

This constant allows you to know the maximum value of vertical position of hardware 
sprites available on the target considered. Note that this is the effective limit 
allowed by the video chipset.

@italian

Questa costante permette di conoscere il valor massimo della posizione Y degli sprite 
hardware disponibili sul target considerato.

@syntax = SPRITE Y MAX
@syntax = SPRITE MAX Y

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE (data type)

@english

This data type allows you to identify and use a hardware sprite resource. Its value is 
not directly usable by the programmer, who must consider the variable that contains 
it as a "placeholder" for the sprite. Furthermore, this data type is used by both 
native hardware sprites (''SPRITE'') and "composite" ones (''CSPRITE''), but it is 
not possible to mix their use.

@italian

Questo tipo di dato permette di individuare e utilizzare una risorsa di tipo 
sprite hardware. Il suo valore non è direttamente utilizzabile dal programmatore, 
che deve intendere la variabile che lo contiene come un "segnaposto" dello sprite.
Inoltre, questo tipo di dato è usato sia dagli sprite hardware nativi (''SPRITE'') 
che da quelli "compositi" (''CSPRITE''), ma non è possibile miscelarne l'uso.

@syntax DIM x AS SPRITE: x = SPRITE(xImage)

@target all
</usermanual> */

/* <usermanual>
@keyword SPRITE

@english

The ''SPRITE'' instructions can be used to prefix one or more commands on specific 
hardware sprites. Commands can be specified, one after the other, after specifying which 
sprite to refer to. If the sprite number is omitted, it is assumed that the 
operations will be performed on all hardware sprites.

@italian

L'istruzione ''SPRITE'' può essere utilizzata per premettere uno o più comandi su 
specifici sprite hardware. I comandi possono essere indicate, una dopo l'altra, 
dopo aver indicato a quale sprite si vuol far riferimento. Se viene omesso il 
numero dello sprite, si intende che le operazioni saranno svolte su tutti gli 
sprite hardware.

@syntax SPRITE index command1 [command2 [command3 ...]]
@syntax SPRITE command1 [command2 [command3 ...]]

@example SPRITE 1 ENABLE MULTICOLOR
@example SPRITE ON

@target c64
@target c64reu
@target c128
@target msx1
@target coleco
@target sc3000
@target sg1000
@seeAlso SPRITE (function)
@seeAlso SPRITE AT (command)
@seeAlso SPRITE COLOR (command)
@seeAlso SPRITE COMPRESS HORIZONTAL (command)
@seeAlso SPRITE COMPRESS VERTICAL (command)
@seeAlso SPRITE DISABLE (command)
@seeAlso SPRITE ENABLE (command)
@seeAlso SPRITE EXPAND HORIZONTAL (command)
@seeAlso SPRITE EXPAND VERTICAL (command)
@seeAlso SPRITE MONOCOLOR (command)
@seeAlso SPRITE MULTICOLOR (command)
</usermanual> */

/* <usermanual>
@keyword BITMAP (constant)

@english

The ''BITMAP'' constant represents the position (in terms of bits) that tracks 
whether the graphics chipset is capable of rendering graphics in "bitmap" mode, 
i.e. whether it is possible to address individual pixels on the screen. 

This constant can be used to query the ''SCREEN'' constant, in an attempt to 
understand whether the functionality is available or not.

@italian

La costante ''BITMAP'' rappresenta la posizione (in termini di bit) che traccia 
se il chipset grafico è in grado di rapprentare grafica nella modalità "bitmap", 
cioè se è possibile indirizzare singolarmente i singoli pixel sullo schermo. 

Questa costante può essere utilizzata per interrogare la costante ''SCREEN'', 
nel tentativo di comprendere se la funzionalità è disponibile o meno.

@syntax = BITMAP

@example IF BIT BITMAP OF SCREEN THEN: PRINT "bitmap is available!": ENDIF

@target all
@seeAlso SCREEN (constant)
</usermanual> */

/* <usermanual>
@keyword SCREEN (constant)

@english

The ''SCREEN'' constant represents the capabilities of video chipset.

@italian

La costante ''SCREEN'' rappresenta le capacità del chipset video.

@syntax = SCREEN

@example IF BIT BITMAP OF SCREEN THEN: PRINT "bitmap is available!": ENDIF

@target all
@seeAlso BITMAP (constant)
</usermanual> */

/* <usermanual>
@keyword SCREEN WIDTH (constant)

@english

The ''SCREEN WIDTH'' constant represents the actual width of the screen,
for the current video chipset and graphic / text mode, in terms of pixels.

@italian

La costante ''SCREEN WIDTH'' rappresenta la larghezza effettiva dello 
schermo, per l'attuale chipset video e la modalità grafica/testo, 
in termini di pixel.

@syntax = SCREEN WIDTH

@example IF SCREEN WIDTH > 128 THEN: PRINT "At least 128 pixels!!": ENDIF

@target all
@alias WIDTH (constant)
</usermanual> */

/* <usermanual>
@keyword WIDTH (constant)

@english

Alias for ''SCREEN WIDTH''.

@italian

Alias per ''SCREEN WIDTH''.

@syntax = WIDTH

@example IF WIDTH > 128 THEN: PRINT "At least 128 pixels!!": ENDIF

@target all
@alias SCREEN WIDTH (constant)
</usermanual> */

/* <usermanual>
@keyword SCREEN HEIGHT (constant)

@english

The ''SCREEN HEIGHT'' constant represents the actual height of the screen,
for the current video chipset and graphic / text mode, in terms of pixels.

@italian

La costante ''SCREEN HEIGHT'' rappresenta la larghezza effettiva dello 
schermo, per l'attuale chipset video e la modalità grafica/testo, 
in termini di pixel.

@syntax = SCREEN HEIGHT

@example IF SCREEN HEIGHT > 128 THEN: PRINT "At least 128 pixels!!": ENDIF

@target all
@alias HEIGHT (constant)
</usermanual> */

/* <usermanual>
@keyword HEIGHT (constant)

@english

Alias for ''SCREEN HEIGHT''.

@italian

Alias per ''SCREEN HEIGHT''.

@syntax = HEIGHT

@example IF HEIGHT > 128 THEN: PRINT "At least 128 pixels!!": ENDIF

@target all
@alias SCREEN HEIGHT (constant)
</usermanual> */

///////////////

/* <usermanual>
@keyword SCREEN TILES WIDTH (constant)

@english

The ''SCREEN TILES WIDTH'' constant represents the actual width of the screen,
for the current video chipset and graphic / text mode, in terms of tiles (characters).

@italian

La costante ''SCREEN TILES WIDTH'' rappresenta la larghezza effettiva dello 
schermo, per l'attuale chipset video e la modalità grafica/testo, 
in termini di tiles (caratteri).

@syntax = SCREEN TILES WIDTH

@example IF SCREEN TILES WIDTH > 40 THEN: PRINT "At least 40 columns!!": ENDIF

@target all
@alias TILES WIDTH (constant)
@alias SCREEN COLUMNS (constant)
</usermanual> */

/* <usermanual>
@keyword TILES WIDTH (constant)

@english

Alias for ''SCREEN TILES WIDTH''.

@italian

Alias per ''SCREEN TILES WIDTH''.

@syntax = TILES WIDTH

@example IF TILES WIDTH > 40 THEN: PRINT "At least 40 columns!!": ENDIF

@target all
@alias SCREEN TILES WIDTH (constant)
@alias SCREEN COLUMNS (constant)
</usermanual> */

/* <usermanual>
@keyword SCREEN COLUMNS (constant)

@english

Alias for ''SCREEN TILES WIDTH''.

@italian

Alias per ''SCREEN TILES WIDTH''.

@syntax = SCREEN COLUMNS

@example IF SCREEN COLUMNS > 40 THEN: PRINT "At least 40 columns!!": ENDIF

@target all
@alias SCREEN TILES WIDTH (constant)
@alias TILES WIDTH (constant)
</usermanual> */

//////////////

/* <usermanual>
@keyword SCREEN TILES HEIGHT (constant)

@english

The ''SCREEN TILES HEIGHT'' constant represents the actual width of the screen,
for the current video chipset and graphic / text mode, in terms of tiles (characters).

@italian

La costante ''SCREEN TILES HEIGHT'' rappresenta la larghezza effettiva dello 
schermo, per l'attuale chipset video e la modalità grafica/testo, 
in termini di tiles (caratteri).

@syntax = SCREEN TILES HEIGHT

@example IF SCREEN TILES HEIGHT > 10 THEN: PRINT "At least 10 rows!!": ENDIF

@target all
@alias TILES HEIGHT (constant)
@alias SCREEN COLUMNS (constant)
</usermanual> */

/* <usermanual>
@keyword TILES HEIGHT (constant)

@english

Alias for ''SCREEN TILES HEIGHT''.

@italian

Alias per ''SCREEN TILES HEIGHT''.

@syntax = TILES HEIGHT

@example IF TILES HEIGHT > 10 THEN: PRINT "At least 10 rows!!": ENDIF

@target all
@alias SCREEN TILES HEIGHT (constant)
@alias SCREEN COLUMNS (constant)
</usermanual> */

/* <usermanual>
@keyword SCREEN ROWS (constant)

@english

Alias for ''SCREEN TILES HEIGHT''.

@italian

Alias per ''SCREEN TILES HEIGHT''.

@syntax = SCREEN ROWS

@example IF SCREEN ROWS > 10 THEN: PRINT "At least 10 rows!!": ENDIF

@target all
@alias SCREEN TILES HEIGHT (constant)
@alias TILES HEIGHT (constant)
</usermanual> */

/* <usermanual>
@keyword ADDRESS (data type)

@english

Data type ''ADDRESS'' represents a 16-bit address, that is used by processors to access 
computer's memory. The memory address is represented by a binary number 
of 16 digits (bits). With 16 bits, we can represent 2^16 = 65,536 different addresses.

@italian

Il tipo di dati ''ADDRESS'' rappresenta un indirizzo a 16 bit, utilizzato dai processori 
per accedere alla memoria del computer. L'indirizzo di memoria è rappresentato da un 
numero binario di 16 cifre (bit). Con 16 bit, possiamo rappresentare 2^16 = 65.536 
indirizzi diversi.

@syntax ... AS ADDRESS

@example DIM limit AS ADDRESS = &H8000

</usermanual> */

/* <usermanual>
@keyword LEFT ALT (constant)

@english

This constant represent the left "ALT" key, when used as bitmask
for ''KEY SHIFT'' instruction.

@italian

Questa costante rappresenta il tasto sinistro "ALT", quando utilizzato 
come maschera di bit per l'istruzione ''KEY SHIFT''.

@syntax = LEFT ALT

@example IF KEY SHIFT AND LEFT ALT THEN
@example    PRINT "LEFT ALT has been pressed!"
@example ENDIF

@alias ALT LEFT (constant)

</usermanual> */

/* <usermanual>
@keyword ALT LEFT (constant)

@english

This constant represent the left "ALT" key, when used as bitmask
for ''KEY SHIFT'' instruction.

@italian

Questa costante rappresenta il tasto sinistro "ALT", quando utilizzato 
come maschera di bit per l'istruzione ''KEY SHIFT''.

@syntax = LEFT ALT

@alias LEFT ALT (constant)

</usermanual> */

/* <usermanual>
@keyword RIGHT ALT (constant)

@english

This constant represent the left "ALT" key, when used as bitmask
for ''KEY SHIFT'' instruction.

@italian

Questa costante rappresenta il tasto sinistro "ALT", quando utilizzato 
come maschera di bit per l'istruzione ''KEY SHIFT''.

@syntax = RIGHT ALT

@example IF KEY SHIFT AND RIGHT ALT THEN
@example    PRINT "RIGHT ALT has been pressed!"
@example ENDIF

@alias ALT RIGHT (constant)

</usermanual> */

/* <usermanual>
@keyword ALT RIGHT (constant)

@english

This constant represent the left "ALT" key, when used as bitmask
for ''KEY SHIFT'' instruction.

@italian

Questa costante rappresenta il tasto sinistro "ALT", quando utilizzato 
come maschera di bit per l'istruzione ''KEY SHIFT''.

@syntax = RIGHT ALT

@alias RIGHT ALT (constant)

</usermanual> */

/* <usermanual>
@keyword ARRAY

@english

The ''ARRAY'' keyword allows you to copy a block of memory from a static definition
to an array at run time. In simple terms, it copies an array of bytes from the right
expression to a ''var''. It is especially useful when you want to initialize an 
array with a specific value or assign an entire array.

This method is generally faster than copying element by element,
 especially for large arrays. It provides a concise way to initialize an entire 
 array with a constant value.

If you want to initialize an array to a single byte, memset is more efficient.
For small arrays or when initializing elements with different values, direct 
assignment can be more readable.

@italian

La parola chiave ''ARRAY'' consente di copiare un blocco di memoria da una 
definizione statica a un array in fase di esecuzione. In parole povere, 
copia un array di byte dall'espressione corretta a una ''var''. 
È particolarmente utile quando si desidera inizializzare un array con un 
valore specifico o assegnare un intero array.

Questo metodo è generalmente più veloce della copia elemento per elemento, 
soprattutto per array di grandi dimensioni. Fornisce un modo conciso per 
inizializzare un intero array con un valore costante.

Se si desidera inizializzare un array a un singolo byte, memset 
è più efficiente. Per array di piccole dimensioni o quando si inizializzano 
elementi con valori diversi, l'assegnazione diretta può essere più 
leggibile.

@syntax ARRAY var = ...
@syntax ARRAY var := ...

@example DIM var(4) AS BYTE
@example ARRAY var = #{42424242}

</usermanual> */

/* <usermanual>
@keyword LEFT ARROW (constant)

@english

This constant represent the left arrow key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto freccia sinistra, quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = LEFT ARROW

@example IF SCANCODE = LEFT ARROW THEN
@example    PRINT "LEFT ARROW has been pressed!"
@example ENDIF

@alias ARROW LEFT (constant)

</usermanual> */

/* <usermanual>
@keyword ARROW LEFT (constant)

@english

This constant represent the left arrow key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto freccia sinistra, quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = ARROW LEFT

@example IF KET STATE(ARROW LEFT) THEN
@example    PRINT "LEFT ARROW has been pressed!"
@example ENDIF

@alias LEFT ARROW (constant)

</usermanual> */

/* <usermanual>
@keyword UP ARROW (constant)

@english

This constant represent the up arrow key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto freccia in alto, quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = UP ARROW

@example IF SCANCODE = UP ARROW THEN
@example    PRINT "UP ARROW has been pressed!"
@example ENDIF

@alias ARROW UP (constant)

</usermanual> */

/* <usermanual>
@keyword ARROW UP (constant)

@english

This constant represent the up arrow key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto freccia in alto, quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = ARROW UP

@example IF KET STATE(ARROW UP) THEN
@example    PRINT "UP ARROW has been pressed!"
@example ENDIF

@alias UP ARROW (constant)

</usermanual> */

/* <usermanual>
@keyword ASM

@english

The ''ASM'' command is a bridge between ugBASIC and the assembly language. 
It allows you to directly insert instructions in machine language or 
assembly language into the source code.

In some sections of the code, especially those that require maximum 
performance or very precise control over the hardware, writing directly 
in assembly can bring significant speed improvements. Assembly allows you
to interact directly with the registers and instructions of the CPU, 
offering granular control over the hardware.

When dealing with code that must run on different architectures, 
assembly can be used to write portions of code that are highly 
optimized for a specific platform. In some cases, you may need to 
interface with code written in assembly or with pre-existing libraries.

The first syntax allow to introduce a single machine code
for each line, while the second one allows to introduce multiple
lines, at once.

Note that assembly code is tightly coupled to the processor 
architecture. A block of assembly code written for a Zilog Z80
will not run on an MOS 6502. Moreover, it is less readable than
ugBASIC language, making it more difficult to maintain. Finally,
a single error in assembly can cause the program to crash,
and indiscriminate use of assembly can interact with compiler
optimizations.

Inline assembly should be used sparingly and only when 
absolutely necessary. It is best used for small sections of 
performance-critical code, for direct access to processor-specific 
registers or instructions and to Interface with legacy code or
specific hardware.

@italian

Il comando ''ASM'' è un ponte tra ugBASIC e il linguaggio assembly.
Consente di inserire direttamente istruzioni in linguaggio macchina 
o assembly nel codice sorgente.

In alcune sezioni del codice, in particolare quelle che richiedono 
le massime prestazioni o un controllo molto preciso sull'hardware, 
scrivere direttamente in assembly può apportare notevoli miglioramenti 
di velocità. L'assembly consente di interagire direttamente con i 
registri e le istruzioni della CPU, offrendo un controllo 
granulare sull'hardware.

Quando si ha a che fare con codice che deve essere eseguito su 
architetture diverse, l'assembly può essere utilizzato per scrivere 
porzioni di codice altamente ottimizzate per una piattaforma specifica. 
In alcuni casi, potrebbe essere necessario interfacciarsi con codice 
scritto in assembly o con librerie preesistenti.

La prima sintassi consente di introdurre un singolo codice macchina 
per ogni riga, mentre la seconda consente di introdurre più righe 
contemporaneamente.

Nota che il codice assembly è strettamente accoppiato all'architettura 
del processore. Un blocco di codice assembly scritto per uno Zilog Z80 
non funzionerà su un MOS 6502. Inoltre, è meno leggibile del linguaggio 
ugBASIC, il che lo rende più difficile da gestire. Infine, un singolo 
errore in assembly può causare l'arresto anomalo del programma e l'uso 
indiscriminato dell'assembly può interagire con le ottimizzazioni 
del compilatore.

L'assembly inline dovrebbe essere utilizzato con parsimonia e solo 
quando assolutamente necessario. È meglio utilizzarlo per piccole 
sezioni di codice critiche per le prestazioni, per l'accesso diretto 
a registri o istruzioni specifici del processore e per interfacciarsi 
con codice legacy o specifico per un hardware.

@syntax ASM line
@syntax BEGIN ASM
@syntax    ...
@syntax END ASM

@example BEGIN ASM
@example     LDA #02
@example     STA $D020
@example END ASM ON CPU6502

</usermanual> */

/* <usermanual>
@keyword ASTERISK (constant)

@english

This constant represent the asterisk key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto asterisco, quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = ASTERISK

@example IF KET STATE(ASTERISK) THEN
@example    PRINT "ASTERISK has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword AT (constant)

@english

This constant represent the "at" (@) key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto chiocciolina (@), quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = AT

@example IF KET STATE(AT) THEN
@example    PRINT "ASTERISK has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword ATLAS (data type)

@english

The ''ATLAS'' data type maintains a reference to the collection of images that
can be used to draw them on the screen.

@italian

Il tipo di dato ''ATLAS'' mantiene un riferimento alla collezione di immagini 
che può essere usata per disegnarle sullo schermo.

@syntax ... AS ATLAS

@target all

@alias IMAGES
</usermanual> */

/* <usermanual>
@keyword IMAGES (data type)

@english

@italian

@syntax ... AS IMAGES

@target all

@alias ATLAS

</usermanual> */

/* <usermanual>
@keyword BETA (constant)

@english

This constant is set to non-zero if the compiler used to generate the executable 
is in beta version. The beta version is not the final version of the compiler, 
and may contain bugs or run unstable. This constant helps to isolate the
part of codes that depends on aspects available on beta version only.

@italian

Questa costante è impostata su un valore diverso da zero se il compilatore 
utilizzato per generare l'eseguibile è in versione beta. La versione beta non 
è la versione finale del compilatore e potrebbe contenere bug o risultare instabile. 
Questa costante aiuta a isolare la parte di codice che dipende da aspetti disponibili 
solo nella versione beta.

@syntax = BETA

@example IF NOT BETA THEN
@example    PRINT "We are in a stable compiler."
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword BIT (data type)

@english

The ''BIT'' data type is the smallest unit of information in a computer,
it takes up very little memory, since ut is "packed" on the minimum 
number of bytes. This data type can be used to create compact and efficient 
data structures, such as "bitsets", just using them in an array.

@italian

Il tipo di dati ''BIT'' è la più piccola unità di informazione in un 
computer, occupa pochissima memoria, poiché è "impacchettato" sul numero 
minimo di byte. Questo tipo di dati può essere utilizzato per creare 
strutture di dati compatte ed efficienti, come i "bitset", semplicemente 
utilizzandoli in un array.

@syntax ... AS BIT

@target all

</usermanual> */

/* <usermanual>
@keyword BLIT (data type)

@english

This data type holds a reference to the blitting operation. It can be used 
as an argument to the blitting instruction, to specify how to manipulate 
the input channels.

@italian

Questo tipo di dati contiene un riferimento all'operazione di blitting. 
Può essere utilizzato come argomento per l'istruzione di blitting, 
per specificare come manipolare i canali di input.

@syntax ... AS BLIT

@example DIM x AS BLIT

@usedInExample blit_basic_mask.bas

@seeAlso BLIT (instruction)
@seeAlso BLIT IMAGE

@target all
</usermanual> */

/* <usermanual>
@keyword BUFFER (data type)

@english

This data type holds a reference to any generic buffer, that is
a memory area of any kind, from a spare memory to a specific and 
big resource. 

@italian

Questo tipo di dati contiene un riferimento a qualsiasi buffer 
generico, ovvero un'area di memoria di qualsiasi tipo, da una 
memoria di riserva a una risorsa specifica e di grandi dimensioni.

@syntax ... AS BUFFER

@example DIM x AS BUFFER

@target all
</usermanual> */

/* <usermanual>
@keyword BYTE (data type)

@english

The ''BYTE'' represent the data type for 8 bit numbers. This kind of data can
represent a single character, such as a letter or number, could be represented with a byte,
integers between 0 and 255 could be represented directly in a byte. 

@italian

Il ''BYTE'' rappresenta il tipo di dati per numeri a 8 bit. Questo tipo di dati 
può rappresentare un singolo carattere, come una lettera o un numero, potrebbe 
essere rappresentato con un byte, gli interi tra 0 e 255 potrebbero essere 
rappresentati direttamente in un byte.

@syntax ... AS BYTE

@example DIM x AS BYTE

@target all
</usermanual> */

/* <usermanual>
@keyword CAPS LOCK (constant)

@english

This constant represent the "CAPS LOCK" key, when used as bitmask
for ''KEY SHIFT'' instruction.

@italian

Questa costante rappresenta il tasto "CAPS LOCK", quando utilizzato 
come maschera di bit per l'istruzione ''KEY SHIFT''.

@syntax = CAPS LOCK

@example IF KEY SHIFT AND CAPS LOCK THEN
@example    PRINT "CAPS LOCK has been pressed!"
@example ENDIF

@alias CAPSLOCK (constant)

</usermanual> */

/* <usermanual>
@keyword CAPSLOCK (constant)

@english

@italian

@syntax = CAPSLOCK

@example IF KEY SHIFT AND CAPSLOCK THEN
@example    PRINT "CAPS LOCK has been pressed!"
@example ENDIF

@alias CAPS LOCK (constant)

</usermanual> */

/*
@tobe CHECK
 */

/* <usermanual>
@keyword CLEAR (constant)

@english

This constant represent the "CLEAR" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto "CLEAR", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = CLEAR

@example IF KET STATE(CLEAR) THEN
@example    PRINT "CLEAR has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword CMOB

@english

The ''CMOB'' instruction attribute the two colors that are the same for all multicolor 
sprites in VIC-II registers. Color for individual sprites are available with the 
''MOB SET'' command or, even, ''MOBCOL''. 

@italian

L'istruzione ''CMOB'' attribuisce i due colori che sono gli stessi per tutti gli 
sprite multicolor nei registri VIC-II. I colori per i singoli sprite sono disponibili 
con il comando ''MOB SET'' o, persino, ''MOBCOL''.

@syntax CMOB c1, c2

@example CMOB RED, BLUE

</usermanual> */

/* <usermanual>
@keyword COLUMNS (constant)

@english

This constant represents the number of columns present 
in the last defined console.

@italian

Questa costante rappresenta il numero di colonne presenti 
nell'ultima console definita.

@syntax = COLUMNS

@seeAlso SCREEN COLUMNS (constant)
@target all
</usermanual> */

/* <usermanual>
@keyword CONFIGURE

@english

The ''CONFIGURE'' command allow to customize hardware configuration, and 
gives the possibility of generating hardware selection menus via software. 
The configuration allows two types of manipulation: a ''STATIC'' one, 
which is adopted at compilation time (useful for development and 
unconventional startup) and a ''DYNAMIC'' one, which is adopted at 
execution time (useful for creating configuration menus).
Static changes must begin with the ''CONFIGURE STATIC'' keywords, 
while dynamic changes must begin with the ''CONFIGURE DYNAMIC'' keywords.
By default, the changes are to be considered static.

Each hardware change request must begin with the ''CONFIGURE'' keyword 
followed by the name of the hardware to be configured. Each request for 
hardware modification must concern one or more parameters prefixed by 
the ''SET'' command. The value that can be assigned to these 
variables must be consistent with the expected and acceptable values. 

Finally, it is possbile to assign multiple values consecutively, 
separating them with a comma, without using the ''SET'' command.

@italian

Il comando ''CONFIGURE'' consente di personalizzare la 
configurazione hardware e fornisce la possibilità di generare 
menu di selezione hardware tramite software.

La configurazione consente due tipi di manipolazione: una ''STATIC'',
che viene adottata in fase di compilazione (utile per lo sviluppo e
l'avvio non convenzionale) e una ''DYNAMIC'', che viene adottata 
in fase di esecuzione (utile per la creazione di menu di configurazione).

Le modifiche statiche devono iniziare con le parole chiave ''CONFIGURE STATIC'',
mentre le modifiche dinamiche devono iniziare con le parole chiave 
''CONFIGURE DYNAMIC''. Per impostazione predefinita, le modifiche 
sono considerate statiche.

Ogni richiesta di modifica hardware deve iniziare con la parola 
chiave ''CONFIGURE'' seguita dal nome dell'hardware da configurare. 
Ogni richiesta di modifica hardware deve riguardare uno o più 
parametri preceduti dal comando ''SET''. Il valore che può essere 
assegnato a queste variabili deve essere coerente con i valori 
previsti e accettabili.

Infine, è possibile assegnare più valori consecutivamente, 
separandoli con una virgola, senza utilizzare il comando ''SET''.

@syntax CONFIGURE STATIC hw SET p1 = v1 [, p2 = v2 [, ...]]
@syntax CONFIGURE DYNAMIC hw SET p1 = v1 [, p2 = v2 [, ...]]

@target all
</usermanual> */

/* <usermanual>
@keyword CONST SHARED

@english

@italian

@syntax [POSITIVE] CONST SHARED identifier = value
@syntax CONST SHARED identifier IN (min,max) = value
@syntax CONST SHARED identifier IN "[" min,max) = value
@syntax CONST SHARED identifier IN (min,max "]" = value
@syntax CONST SHARED identifier IN "[" min,max "]"" = value

@example CONST SHARED x = 42
@example POSITIVE CONST SHARED y = -42: ' this raises an error!
@example CONST SHARED width IN (0,320] = 128

@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias SHARED CONST
@alias SHARED
@alias GLOBAL CONST
@alias CONST GLOBAL

@target all
</usermanual> */

/* <usermanual>
@keyword SHARED CONST

@english

@italian

@syntax [POSITIVE] SHARED CONST identifier = value
@syntax SHARED CONST identifier IN (min,max) = value
@syntax SHARED CONST identifier IN "[" min,max) = value
@syntax SHARED CONST identifier IN (min,max "]" = value
@syntax SHARED CONST identifier IN "[" min,max "]"" = value

@example SHARED CONST x = 42
@example POSITIVE SHARED CONST y = -42: ' this raises an error!
@example SHARED CONST width IN (0,320] = 128

@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias SHARED
@alias CONST SHARED
@alias GLOBAL CONST
@alias CONST GLOBAL

@target all
</usermanual> */

/* <usermanual>
@keyword CONST GLOBAL

@english

@italian

@syntax [POSITIVE] CONST GLOBAL identifier = value
@syntax CONST GLOBAL identifier IN (min,max) = value
@syntax CONST GLOBAL identifier IN "[" min,max) = value
@syntax CONST GLOBAL identifier IN (min,max "]" = value
@syntax CONST GLOBAL identifier IN "[" min,max "]"" = value

@example CONST GLOBAL x = 42
@example POSITIVE CONST GLOBAL y = -42: ' this raises an error!
@example CONST GLOBAL width IN (0,320] = 128

@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias SHARED
@alias CONST SHARED
@alias SHARED CONST
@alias GLOBAL CONST

@target all
</usermanual> */

/* <usermanual>
@keyword GLOBAL CONST

@english

@italian

@syntax [POSITIVE] GLOBAL CONST identifier = value
@syntax GLOBAL CONST identifier IN (min,max) = value
@syntax GLOBAL CONST identifier IN "[" min,max) = value
@syntax GLOBAL CONST identifier IN (min,max "]" = value
@syntax GLOBAL CONST identifier IN "[" min,max "]"" = value

@example GLOBAL CONST x = 42
@example POSITIVE GLOBAL CONST y = -42: ' this raises an error!
@example GLOBAL CONST width IN (0,320] = 128

@usedInExample contrib_sierpinski.bas
@usedInExample contrib_sierpinski2.bas
@usedInExample contrib_sierpinski3.bas

@alias SHARED
@alias CONST SHARED
@alias SHARED CONST
@alias CONST GLOBAL

@target all
</usermanual> */

/* <usermanual>
@keyword CONTROL (constant)

@english

This constant represent the "CONTROL" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto "CONTROL", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = CONTROL

@example IF KET STATE(CONTROL) THEN
@example    PRINT "CONTROL has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword CRSR LEFT RIGHT (constant)

@english

This constant represent the "CRSR LEFT RIGHT" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto "CRSR LEFT RIGHT", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = CRSR LEFT RIGHT

@example IF KET STATE(CRSR LEFT RIGHT) THEN
@example    PRINT "CRSR LEFT RIGHT has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword CRSR UP DOWN (constant)

@english

This constant represent the "CRSR UP DOWN" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto "CRSR UP DOWNT", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = CRSR UP DOWN

@example IF KET STATE(CRSR UP DOWN) THEN
@example    PRINT "CRSR UP DOWN has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword DEGREE

@english

This command allows you to select the angle mode with 
trigonometric functions, setting it to 360 degrees.

@italian

Questo comando permette di selezionare la modalità 
degli angoli nelle funzioni trigonometriche, impostandola a gradi su 360. 

@syntax DEGREE

@example x1 = COS(3.1415)
@example DEGREE
@example x2 = COS(180)
@example PRINT x1;" ";x2

</usermanual> */


/* <usermanual>
@keyword RADIAN

@english

This command allows you to select the angle mode with 
trigonometric functions, setting it to radiants.

@italian

Questo comando permette di selezionare la modalità 
degli angoli nelle funzioni trigonometriche, impostandola a radianti

@syntax RADIAN

@example DEGREE
@example x1 = COS(180)
@example RADIAN
@example x2 = COS(3.1415)
@example PRINT x1;" ";x2

</usermanual> */

/* <usermanual>
@keyword DELETE (constant)

@english

This constant represent the "DELETE" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero.

@italian

Questa costante rappresenta il tasto "DELETE", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = DELETE

@example IF KET STATE(DELETE) THEN
@example    PRINT "DELETE has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword DOJOKA (data type)

@english

This data type holds a reference to a connection or communication 
port with the DOJO protocol.

@italian

Questo tipo di dato mantiene un riferimento a una connessione o
a una porta di comunicazione con il protocollo ''DOJO''.

@syntax ... AS DOJOKA

@example DIM accessId AS DOJOKA
@example accessId = LOGIN( "user", "password" )

</usermanual> */

/* <usermanual>
@keyword DOWN (constant)

@english

This constant represent the "DOWN" key (move cursor down), when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "DOWN" (muovi il cusorse in giù), quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = DOWN

@example IF KET STATE(DOWN) THEN
@example    PRINT "DOWN has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword DWORD (data type)

@english

The ''DWORD'' is a data type that allow to store a 32-bit word (''WORD''). 

@italian

''DWORD'' è un tipo di dati che consente di memorizzare una 
parola (''WORD'') a 32 bit.

@syntax ... AS DWORD

@example DIM parolaLunga AS DWORD

</usermanual> */

/* <usermanual>
@keyword EMPTY TILE

@english

This is a special parameter of ugBASIC, which allows you to change what 
is considered the "space" character on the screen. It is used, in text 
modes, to clear the screen.

@italian

Questo è un parametro speciale di ugBASIC, che consente di modificare 
quello che viene considerato il carattere "spazio" sullo schermo. 
Viene utilizzato, nelle modalità testuali, per cancellare lo schermo.

@syntax = EMPTY TILE
@syntax EMPTY TILE = ...

@example EMPTY TILE = 65
@example CLS

@alias EMPTYTILE

</usermanual> */

/* <usermanual>
@keyword EMPTYTILE

@english

@italian

@syntax = EMPTYTILE
@syntax EMPTYTILE = ...

@example EMPTYTILE = 65
@example CLS

@alias EMPTY TILE

</usermanual> */

/* <usermanual>
@keyword EQUAL (constant)

@english

This constant represent the "EQUAL" key (=), when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "UGUALE" (=), quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = EQUAL

@example IF KET STATE(EQUAL) THEN
@example    PRINT "EQUAL has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword FALSE (constant)

@english

This constant represent the boolean value for FALSE (0).

@italian

Questa costante rappresenta il valore booleano per FALSE (0).

@syntax = FALSE

@example IF v = FALSE THEN
@example    PRINT "V is false!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword FLOAT (data type)

@english

The ''FLOAT'' is a data type that allow to store a floating
point number.

@italian

''FLOAT'' è un tipo di dati che consente di memorizzare un
numero in virgola mobile.

@syntax ... AS FLOAT

@example DIM numero AS FLOAT

</usermanual> */

/* <usermanual>
@keyword GET

@italian

@syntax GET var

@example GET tasto

@alias INKEY

</usermanual> */

/* <usermanual>
@keyword GLOBAL

@english

When you write a program, variables are like containers that store data. 
Depending on where you declare them, these variables can have different "scopes," 
meaning they can be accessed from different parts of your code. The ''GLOBAL''
command allows to define a variable as accessible from everywhere.

You should use ''GLOBAL'' to store parameters that do not change during program execution,
to share the state between different parts of your code, and generally to improve performance,
but it is important to weigh the pros and cons carefully. In general, it is a good idea to limit 
the use of global variables and use local variables whenever possible.

You can use the name of variables to make them global, or a string with a "pattern"
to follow, to choose if a variable will be global or not. Pattern uses "wildcard"
to match any letter in name of the variables.

@italian

Quando scrivi un programma, le variabili sono come contenitori che memorizzano dati.
A seconda di dove le dichiari, queste variabili possono avere diversi "ambiti", 
ovvero possono essere accessibili da diverse parti del tuo codice. Il comando ''GLOBAL'' 
consente di definire una variabile come accessibile da qualsiasi luogo.

Dovresti usare ''GLOBAL'' per memorizzare parametri che non cambiano durante 
l'esecuzione del programma, per condividere lo stato tra diverse parti del tuo 
codice e in generale per migliorare le prestazioni, ma è importante soppesare 
attentamente i pro e i contro. In generale, è una buona idea limitare l'uso di 
variabili globali e usare variabili locali quando possibile.

Puoi usare il nome delle variabili per renderle globali o una stringa con un 
"pattern" da seguire, per scegliere se una variabile sarà globale o meno. 
Il pattern usa "carattere jolly" per abbinare qualsiasi lettera nel nome 
delle variabili.

@syntax GLOBAL var[, var[, ...]]
@syntax GLOBAL string

@example GLOBAL var42
@example GLOBAL "a*"

@seeAlso SHARED

</usermanual> */

/* <usermanual>
@keyword HOME (constant)

@english

This constant represent the "HOME" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "HOME", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = HOME

@example IF KET STATE(HOME) THEN
@example    PRINT "HOME has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword IMAGE (data type)

@english

The ''IMAGE'' data type maintains a reference to an image that
can be drawn on the screen

@italian

Il tipo di dato ''IMAGE'' mantiene un riferimento a una immagine
che può essere disegnata sullo schermo.

@syntax ... AS IMAGE

</usermanual> */

/* <usermanual>
@keyword INCLUDE

@english

The ''INCLUDE'' command allows you to insert a source from an external 
file. In practice, what happens is that the content of the file, without 
any interpretation, is copied "as is" at the point where the statement 
was inserted. All variables and scopes will be maintained.

@italian

Il comando ''INCLUDE'' consente di inserire una sorgente da un file esterno. 
In pratica, ciò che accade è che il contenuto del file, senza alcuna 
interpretazione, viene copiato "così com'è" nel punto in cui è stata inserita 
l'istruzione. Tutte le variabili e gli ambiti verranno mantenuti.

@syntax INCLUDE "filename"

</usermanual> */

/* <usermanual>
@keyword INSERT (constant)

@english

This constant represent the "INSERT" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "INSERT", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = INSERT

@example IF KET STATE(INSERT) THEN
@example    PRINT "INSERT has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword INT (data type)

@english

The ''INT'' is a data type that allow to store a signed 16-bit word.

@italian

Il tipo ''INT'' è un tipo di dati che consente di memorizzare una 
parola con segno a 16 bit.

@syntax ... AS INT

@example DIM parolaLunga AS INT

@alias INTEGER

</usermanual> */

/* <usermanual>
@keyword INTEGER (data type)

@english

@italian

@syntax ... AS INTEGER

@example DIM parolaLunga AS INTEGER

@alias INT

</usermanual> */

/* <usermanual>
@keyword JOY UP (constant)

@english

This constant represents the bitmask to use to identify the "up direction" 
bit for the value returned by the JOY function.

@italian

Questa costante rappresenta la bitmask da utilizzare per identificare il 
bit "direzione su" per il valore restituito dalla funzione JOY.

@syntax = JOY UP

@example IF JOY(0) AND JOY UP THEN
@example    PRINT "UP!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword JOY DOWN (constant)

@english

This constant represents the bitmask to use to identify the "down direction" 
bit for the value returned by the JOY function.

@italian

Questa costante rappresenta la bitmask da utilizzare per identificare il 
bit "direzione giù" per il valore restituito dalla funzione JOY.

@syntax = JOY DOWN

@example IF JOY(0) AND JOY DOWN THEN
@example    PRINT "DOWN!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword JOY LEFT (constant)

@english

This constant represents the bitmask to use to identify the "left direction" 
bit for the value returned by the JOY function.

@italian

Questa costante rappresenta la bitmask da utilizzare per identificare il 
bit "direzione sinistra" per il valore restituito dalla funzione JOY.

@syntax = JOY LEFT

@example IF JOY(0) AND JOY LEFT THEN
@example    PRINT "LEFT!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword JOY RIGHT (constant)

@english

This constant represents the bitmask to use to identify the "right direction" 
bit for the value returned by the JOY function.

@italian

Questa costante rappresenta la bitmask da utilizzare per identificare il 
bit "direzione destra" per il valore restituito dalla funzione JOY.

@syntax = JOY RIGHT

@example IF JOY(0) AND JOY RIGHT THEN
@example    PRINT "RIGHT!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword LEFT (constant)

@english

This constant represent the "LEFT" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "LEFT", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = LEFT

@example IF KET STATE(LEFT) THEN
@example    PRINT "LEFT has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword RIGHT (constant)

@english

This constant represent the "RIGHT" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "RIGHT", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = RIGHT

@example IF KET STATE(RIGHT) THEN
@example    PRINT "RIGHT has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword UP (constant)

@english

This constant represent the "UP" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "UP", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = UP

@example IF KET STATE(UP) THEN
@example    PRINT "UP has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword DOWN (constant)

@english

This constant represent the "DOWN" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "DOWN", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = DOWN

@example IF KET STATE(DOWN) THEN
@example    PRINT "DOWN has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword LONG (data type)

@english

The ''LONG'' is a data type that allow to store a signed 32-bit word. 

@italian

''LONG'' è un tipo di dati che consente di memorizzare una 
parola (''WORD'') a 32 bit con segno.

@syntax ... AS LONG

@example DIM parolaLunga AS LONG

</usermanual> */

/* <usermanual>
@keyword MINUS (constant)

@english

This constant represent the "MINUS" key, when used as a value
to compare with ''SCANCODE'',''KEY STATE'' and ''KEY PRESSED''. 
If the key does not exist in the corresponding target, the
value will be zero. 

@italian

Questa costante rappresenta il tasto "MINUS", quando 
viene utilizzata come valore da confrontare con ''SCANCODE'',
''KEY STATE'' and ''KEY PRESSED''. Se il tasto non esiste nel 
target corrispondente, il valore sarà zero.

@syntax = MINUS

@example IF KET STATE(MINUS) THEN
@example    PRINT "MINUS has been pressed!"
@example ENDIF

</usermanual> */

/* <usermanual>
@keyword MOB ON

@english

@italian

@syntax MOB ON

@alias SPRITE ENABLE

</usermanual> */

/* <usermanual>
@keyword MOB OFF

@english

@italian

@syntax MOB OFF

@alias SPRITE DISABLE

</usermanual> */

/* <usermanual>
@keyword MSPRITE (data type)

@english

The ''MSPRITE'' is a data type that allow to store a reference to a multiplexed
sprite.

@italian

''MSPRITE'' è un tipo di dati che consente di memorizzare il riferimento
a uno sprite multiplexed.

@syntax ... AS MSPRITE

@example DIM player AS MSPRITE

</usermanual> */

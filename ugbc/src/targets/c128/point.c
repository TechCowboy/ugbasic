/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *----------------------------------------------------------------------------
 * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
 * (la "Licenza"); è proibito usare questo file se non in conformità alla
 * Licenza. Una copia della Licenza è disponibile all'indirizzo:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Se non richiesto dalla legislazione vigente o concordato per iscritto,
 * il software distribuito nei termini della Licenza è distribuito
 * "COSÌ COM'È", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
 * implicite. Consultare la Licenza per il testo specifico che regola le
 * autorizzazioni e le limitazioni previste dalla medesima.
 ****************************************************************************/

/****************************************************************************
 * INCLUDE SECTION 
 ****************************************************************************/

#include "../../ugbc.h"

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

/**
 * @brief Emit code for <strong>POINT(...)</strong>
 * 
 * Emit code to get the color at a given point.
 * 
 * @param _environment Current calling environment
 * @param _x Abscissa of the pixel.
 * @param _y Coordinate of the pixel.
 * @return Variable* Color at the given coordinates 
 */
/* <usermanual>
@keyword POINT (function)

@english

The ''POINT'' function allows you to get the color presents a certain 
coordinate of the screen.

@italian

La funzione ''POINT'' permette di ottenere il colore presenta una certa 
coordinata dello schermo.

@syntax = POINT( x, y )

@example c = POINT ( 42, 42 )

@usedInExample graphics_plot_03.bas

@target c128
@verified
 </usermanual> */
Variable * point( Environment * _environment, char * _x, char * _y ) {

    Variable * result = variable_temporary( _environment, VT_COLOR, "(point's result)");

    vic2_pget_color_vars( _environment, _x, _y, result->name );

    return result;

}

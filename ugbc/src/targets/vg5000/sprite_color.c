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
 * @brief Emit ASM code for instruction <b>SPRITE [int] COLOR [int]</b>
 * 
 * This function emits a code capable of changing the specific color
 * for a given sprite.
 * 
 * @param _environment Current calling environment
 * @param _sprite Index of the sprite for which to change color
 * @param _color Index of the color
 */
void sprite_color( Environment * _environment, int _sprite, int _color ) {

}

/**
 * @brief Emit ASM code for instruction <b>SPRITE [int] COLOR [int]</b>
 * 
 * This function emits a code capable of changing the specific color
 * for a given sprite.
 * 
 * @param _environment Current calling environment
 * @param _sprite Expression with the index of the sprite for which to change color
 * @param _color Expression with the index of the color
 */
void sprite_color_vars( Environment * _environment, char * _sprite, char * _color ) {

    ef9345_sprite_color( _environment, _sprite, _color );

}
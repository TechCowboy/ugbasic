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

#include "../../../ugbc.h"

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

#if defined(__cpc__)

/**
 * @brief Emit ASM code for <b>SPRITE [int] EXPAND VERTICAL</b>
 * 
 * This function emits a code capable of expanding vertically a given sprite.
 * The index of sprite is given as a direct integer.
 * 
 * @param _environment Current calling environment
 * @param _sprite Index of the sprite to expand vertically (0...7)
 */
void sprite_expand_vertical( Environment * _environment, int _sprite ) {

    outline1("; SPRITE %d EXPAND VERTICAL (ignored)", _sprite);

}

/**
 * @brief Emit ASM code for <b>SPRITE [expression] EXPAND VERTICAL</b>
 * 
 * This function emits a code capable of expanding vertically a given sprite.
 * The index of sprite is given as an expression.
 * 
 * @param _environment Current calling environment
 * @param _sprite Expression with the index of the sprite to expand vertically (0...7)
 */
void sprite_expand_vertical_var( Environment * _environment, char * _sprite ) {

    outline1("; SPRITE %s EXPAND VERTICAL (ignored)", _sprite);

    cpc_sprite_expand_vertical( _environment, _sprite );

}

#endif

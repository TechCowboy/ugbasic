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

#if defined(__vic20__)

/**
 * @brief Emit ASM code for <b>SPRITE [int] MULTICOLOR</b>
 * 
 * This function emits a code capable of enabling multicolor for a given sprite.
 * The index of sprite is given as a direct integer.
 * 
 * @param _environment Current calling environment
 * @param _sprite Index of the sprite for which enable multicolor (0...7)
 */
void sprite_multicolor( Environment * _environment, int _sprite ) {

    char spriteString[MAX_TEMPORARY_STORAGE]; sprintf( spriteString, "#$%2.2x", _sprite );

    vic1_sprite_multicolor( _environment, spriteString );

}

/**
 * @brief Emit ASM code for <b>SPRITE [expression] MULTICOLOR</b>
 * 
 * This function emits a code capable of enabling multicolor for a given sprite.
 * The index of sprite is given as an expression.
 * 
 * @param _environment Current calling environment
 * @param _sprite Expression with index of the sprite for which enable multicolor (0...7)
 */
void sprite_multicolor_var( Environment * _environment, char * _sprite ) {

    _environment->bitmaskNeeded = 1;
    
    Variable * sprite = variable_retrieve( _environment, _sprite );

    vic1_sprite_multicolor( _environment, sprite->realName );

}

#endif

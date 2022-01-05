/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2022 Marco Spedaletti (asimov@mclink.it)
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
 * @brief Emit ASM code for <b>SPRITE [int] DATA FROM [int]</b>
 * 
 * This function emits a code capable of setting the starting address of the 
 * sprite _sprite to the value _address. This version is suitable when direct 
 * value is used.
 * 
 * @param _environment Current calling environment
 * @param _sprite Index of the sprite to define (0...7)
 * @param _address Address where the sprite data begins from
 */
/* <usermanual>
@keyword SPRITE DATA FROM

@english
Set the starting address of the sprite's graphical data.

@italian
Imposta l'indirizzo iniziale dei dati grafici dello sprite.

@syntax SPRITE # [integer] DATA FROM # [integer]

@example SPRITE #$1 DATA FROM #$0800

@target c64
</usermanual> */
void sprite_data_from( Environment * _environment, int _sprite, int _address ) {

    

    char spriteString[MAX_TEMPORARY_STORAGE]; sprintf(spriteString, "#$%2.2x", _sprite );
    char addressString[MAX_TEMPORARY_STORAGE]; sprintf(addressString, "#$%2.2x", (unsigned char)( _address / 0x40 ) );

    vic2_sprite_data_from( _environment, spriteString, addressString );

}

/**
 * @brief Emit ASM code for <b>SPRITE [expression] DATA FROM [expression]</b>
 * 
 * This function emits a code capable of setting the starting address of the 
 * sprite _sprite to the value _address. This version is suitable when expressions
 * are used.
 * 
 * @param _environment Current calling environment
 * @param _sprite Expression with the index of the sprite to define (0...7)
 * @param _address Expression with the address where the sprite data begins from
 */
/* <usermanual>
@keyword SPRITE DATA FROM

@syntax SPRITE [expression] DATA FROM [expression]

@example SPRITE starship DATA FROM starshipGraphicalData

@target c64
</usermanual> */
void sprite_data_from_vars( Environment * _environment, char * _sprite, char * _address ) {

    

    Variable * sprite = variable_retrieve( _environment, _sprite );

    Variable * address = variable_retrieve( _environment, _address );

    vic2_sprite_data_from( _environment, sprite->realName, address->realName );

}


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
 * @brief Emit code for <strong>TILE CLASS(...)</strong>
 * 
 * @param _environment Current calling environment
 * @param _tileset Tileset
 * @param _id Tile id
 */
/* <usermanual>
@keyword TILE PROBABILITY

@english

This function allows you to know the probability to which a certain tile will be
produced. Note that this information is available only at the time of compilation: 
therefore, the parameter with the tile identifier must be a constant.

@italian

Questa funzione permette di conoscere la probabilità a cui appartiene un determinato 
tile. Da notare che questa è una informazione disponibile unicamente al momento 
della compilazione: pertanto, il parametro con l'identificativo del tile dovrà 
essere una costante.

@syntax = TILE PROBABILITY( tileset, id )

@example tileProbability = TILE PROBABILITY(tileset, 29)

@usedInExample tileset_example_02.bas

@target all
@verified
</usermanual> */
Variable * tile_probability( Environment * _environment, char * _tileset, int _id ) {

    if ( _environment->emptyProcedure ) {
        Variable * probability = variable_temporary( _environment, VT_FLOAT, "(probability)");
        variable_store_float( _environment, probability->name, 0.0 );
        return probability;
    }

    Variable * tileset = NULL;

    tileset = variable_retrieve( _environment, _tileset );
    if ( tileset->type != VT_IMAGES || tileset->originalTileset == NULL ) {
        CRITICAL_TILE_PROBABILITY_NO_TILESET( _tileset );
    }

    if ( _id >= tileset->frameCount ) {
        CRITICAL_TILE_PROBABILITY_INVALID_ID( _id );
    }

    TsxTile * actual = tileset->originalTileset->tiles;

    while( actual ) {
        
        if ( actual->id == _id ) {
            break;
        }
        actual = actual->next;
    }

    if ( !actual ) {
        CRITICAL_TILE_PROBABILITY_INVALID_ID( _id );
    }

    Variable * probability = variable_temporary( _environment, VT_FLOAT, "(probability)");

    variable_store_float( _environment, probability->name, actual->probability );

    return probability;

}

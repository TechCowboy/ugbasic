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

extern char DATATYPE_AS_STRING[][16];

/**
 * @brief Return the height of a TILE on a TILESET
 * 
 * @param _environment Current calling environment
 * @param _tileset tileset
 */
/* <usermanual>
@keyword TILE HEIGHT

@english
This function allows you to obtain the height of a given ''TILE'' or a given
set of ''TILES''. The width is expressed in tiles. If the parameter is a
``TILESET``, this is the height of a single tile.

@italian
Questa funzione permette di ottenere l'altezza della tile (''TILE'') 
o delle tiles (''TILES'') date, espressa in tiles. Se il parametro è un
''TILESET'', questa sarà l'altezza di una singola tessera.

@syntax = TILE HEIGHT([tile])
@syntax = TILE HEIGHT([tileset])

@example starshipHeight = TILE HEIGHT( LOAD TILE("starship.png") )
@example singleTileHeight = TILE HEIGHT(LOAD TILESET("tileset.tsx"))

@target all
</usermanual> */
Variable * tileset_tile_get_height( Environment * _environment, char * _tileset ) {

    Variable * tileset = NULL;

    tileset = variable_retrieve( _environment, _tileset );
    if ( tileset->type != VT_IMAGES || tileset->originalTileset == NULL ) {
        CRITICAL_TILE_HEIGHT_NO_TILESET( _tileset );
    }

    Variable * height = variable_temporary( _environment, VT_BYTE, "(class)");

    variable_store( _environment, height->name, tileset->frameHeight );

    return height;

}


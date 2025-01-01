#ifndef __TSX__
#define __TSX__

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

typedef struct _TsxImage {

    char                *   source;
    int                     width;
    int                     height;

} TsxImage;

typedef struct _TsxTile {

    int                     id;
    char                *   type;
    double                  probability;

    struct _TsxTile     *   next;

} TsxTile;

typedef struct _TsxTileset {

    char                *   version;
    char                *   tiledversion;
    char                *   name;
    char                *   source;
    int                     tilewidth;
    int                     tileheight;
    int                     tilecount;
    int                     columns;
    int                     firstgid;
    int                     margin;
    int                     spacing;

    struct _TsxImage *      image;

    struct _TsxTile *       tiles;
    
    struct _TsxTileset *    next;

} TsxTileset;

TsxTileset * tsx_load( char * _filename );

#endif
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
 * @brief Emit ASM code for <b>PUT IMAGE [image] AT [int],[int]</b>
 * 
 * This function outputs a code that draws an image on a bitmap. 
 * 
 * @param _environment Current calling environment
 * @param _image Image to draw
 * @param _x Abscissa of the point to draw
 * @param _y Ordinate of the point
 */
void put_image_vars( Environment * _environment, char * _image, char * _x1, char * _y1, char * _x2, char * _y2, char * _frame, char * _sequence, char * _flags ) {

    if ( _environment->emptyProcedure ) {
        return;
    }

    Variable * image = variable_retrieve( _environment, _image );

    Resource * resource = build_resource_for_sequence( _environment, _image, _frame, _sequence );

    Variable * x1 = variable_retrieve_or_define( _environment, _x1, VT_POSITION, 0 );
    Variable * y1 = variable_retrieve_or_define( _environment, _y1, VT_POSITION, 0 );
    Variable * flags = variable_retrieve_or_define( _environment, _flags, VT_WORD, 0 );
    Variable * frame = NULL;
    if ( _frame) {
        frame = variable_retrieve_or_define( _environment, _frame, VT_BYTE, 0 );
    }
    Variable * sequence = NULL;
    if ( _sequence) {
        sequence = variable_retrieve_or_define( _environment, _sequence, VT_BYTE, 0 );
    }

    switch( resource->type ) {
        case VT_SEQUENCE:
            if ( !sequence ) {
                if ( !frame ) {
                    ef9345_put_image( _environment, resource, x1->realName, y1->realName, "", "", image->frameSize, image->frameCount, _flags );
                } else {
                    ef9345_put_image( _environment, resource, x1->realName, y1->realName, frame->realName, "", image->frameSize, image->frameCount, _flags );
                }
            } else {
                if ( !frame ) {
                    ef9345_put_image( _environment, resource, x1->realName, y1->realName, "", sequence->realName, image->frameSize, image->frameCount, _flags );
                } else {
                    ef9345_put_image( _environment, resource, x1->realName, y1->realName, frame->realName, sequence->realName, image->frameSize, image->frameCount, _flags );
                }
            }
            break;
        case VT_IMAGES:
            if ( !frame ) {
                ef9345_put_image( _environment, resource, x1->realName, y1->realName, "", NULL, image->frameSize, 0, _flags );
            } else {
                ef9345_put_image( _environment, resource, x1->realName, y1->realName, frame->realName, NULL, image->frameSize, 0, _flags );
            }
            break;
        case VT_IMAGE:
        case VT_TARRAY:
            ef9345_put_image( _environment, resource, x1->realName, y1->realName, NULL, NULL, 1, 0, _flags );
            break;
        default:
            CRITICAL_PUT_IMAGE_UNSUPPORTED( _image, DATATYPE_AS_STRING[image->type] );
    }
}

void put_image_vars_flags( Environment * _environment, char * _image, char * _x1, char * _y1, char * _x2, char * _y2, char * _frame, char * _sequence, int _flags ) {

    char flagsConstantName[MAX_TEMPORARY_STORAGE]; sprintf( flagsConstantName, "PUTIMAGEFLAGS%4.4x", _flags );
    char flagsConstantParameter[MAX_TEMPORARY_STORAGE]; sprintf( flagsConstantParameter, "PUTIMAGEFLAGS%4.4x", _flags );
    
    Constant * flagsConstant = constant_find( _environment->constants, flagsConstantName );
    
    if ( !flagsConstant ) {
        flagsConstant = malloc( sizeof( Constant ) );
        memset( flagsConstant, 0, sizeof( Constant ) );
        flagsConstant->name = strdup( flagsConstantName );
        flagsConstant->realName = strdup( flagsConstantName );
        flagsConstant->value = _flags;
        flagsConstant->type = CT_INTEGER;
        flagsConstant->next = _environment->constants;
        _environment->constants = flagsConstant;
    }

    put_image_vars( _environment, _image, _x1, _y1, _x2, _y2, _frame, _sequence, flagsConstantParameter );
}

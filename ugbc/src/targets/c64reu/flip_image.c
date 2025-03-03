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
 * @brief Emit ASM code for <b>FLIP IMAGE X/Y/XY/YX [image]</b>
 * 
 * This function outputs a code that flip an image
 * 
 * @param _environment Current calling environment
 * @param _image Image to draw
 */
/* <usermanual>
@keyword FLIP IMAGE
@target c64reu
</usermanual> */
void flip_image_vars( Environment * _environment, char * _image, char * _frame, char * _sequence, char * _direction ) {

    if ( _environment->emptyProcedure ) {
        return;
    }

    Variable * image = variable_retrieve( _environment, _image );

    Resource * resource = build_resource_for_sequence( _environment, _image, _frame, _sequence );

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
            if ( image->bankAssigned != -1 ) {

                Variable * frameSize = variable_temporary( _environment, VT_WORD, "(temporary)");
                variable_store( _environment, frameSize->name, image->frameSize );
                Variable * offset = variable_temporary( _environment, VT_ADDRESS, "(temporary)");

                if ( !sequence ) {
                    if ( !frame ) {
                        vic2_calculate_sequence_frame_offset(_environment, offset->realName, "", "", image->frameSize, image->frameCount );
                    } else {
                        vic2_calculate_sequence_frame_offset(_environment, offset->realName, "", frame->realName, image->frameSize, image->frameCount );
                    }
                } else {
                    if ( !frame ) {
                        vic2_calculate_sequence_frame_offset(_environment, offset->realName, sequence->realName, "", image->frameSize, image->frameCount );
                    } else {
                        vic2_calculate_sequence_frame_offset(_environment, offset->realName, sequence->realName, frame->realName, image->frameSize, image->frameCount );
                    }
                }

                Variable * address = variable_temporary( _environment, VT_ADDRESS, "(temporary)");
                variable_store( _environment, address->name, image->absoluteAddress );
                variable_add_inplace_vars( _environment, address->name, offset->name );

                Resource resource;
                resource.realName = strdup( address->realName );
                resource.bankNumber = image->bankAssigned;
                resource.isAddress = 1;

                vic2_flip_image( _environment, &resource, NULL, NULL, image->frameSize, 0, _direction );

            } else {
                if ( !sequence ) {
                    if ( !frame ) {
                        vic2_flip_image( _environment, resource, "", "", image->frameSize, image->frameCount, _direction );
                    } else {
                        vic2_flip_image( _environment, resource, frame->realName, "", image->frameSize, image->frameCount, _direction );
                    }
                } else {
                    if ( !frame ) {
                        vic2_flip_image( _environment, resource, "", sequence->realName, image->frameSize, image->frameCount, _direction );
                    } else {
                        vic2_flip_image( _environment, resource, frame->realName, sequence->realName, image->frameSize, image->frameCount, _direction );
                    }
                }
            }
            break;
        case VT_IMAGES:
            if ( image->bankAssigned != -1 ) {
                
                Variable * frameSize = variable_temporary( _environment, VT_WORD, "(temporary)");
                variable_store( _environment, frameSize->name, image->frameSize );
                Variable * offset = variable_temporary( _environment, VT_ADDRESS, "(temporary)");

                if ( !frame ) {
                    vic2_calculate_sequence_frame_offset(_environment, offset->realName, NULL, "", image->frameSize, 0 );
                } else {
                    vic2_calculate_sequence_frame_offset(_environment, offset->realName, NULL, frame->realName, image->frameSize, 0 );
                }

                Variable * address = variable_temporary( _environment, VT_ADDRESS, "(temporary)");
                variable_store( _environment, address->name, image->absoluteAddress );
                variable_add_inplace_vars( _environment, address->name, offset->name );

                Resource resource;
                resource.realName = strdup( address->realName );
                resource.bankNumber = image->bankAssigned;
                resource.isAddress = 1;

                vic2_flip_image( _environment, &resource, NULL, NULL, image->frameSize, 0, _direction );
                
            } else {
                if ( !frame ) {
                    vic2_flip_image( _environment, resource, "", NULL, image->frameSize, 0, _direction );
                } else {
                    vic2_flip_image( _environment, resource, frame->realName, NULL, image->frameSize, 0, _direction );
                }
            }
            break;
        case VT_IMAGE:
        case VT_TARRAY:
            if ( image->bankAssigned != -1 ) {

                Variable * address = variable_temporary( _environment, VT_ADDRESS, "(temporary)");
                variable_store( _environment, address->name, image->absoluteAddress );

                Resource resource;
                resource.realName = strdup( address->realName );
                resource.bankNumber = image->bankAssigned;
                resource.isAddress = 1;

                vic2_flip_image( _environment, &resource, NULL, NULL, 0, 0, _direction );
            } else {
                vic2_flip_image( _environment, resource, NULL, NULL, 0, 0, _direction );
            }
             break;
        default:
            CRITICAL_FLIP_IMAGE_UNSUPPORTED( _image, DATATYPE_AS_STRING[image->type] );
    }

    
}


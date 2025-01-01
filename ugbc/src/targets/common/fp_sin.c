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
#include <math.h>

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

/* <usermanual>
@keyword SIN

@english
This function will calculate the sine value of an angle. The sine of an acute
angle are defined in the context of a right triangle: for the specified angle, 
its sine is the ratio of the length of the side that is opposite that angle to 
the length of the longest side of the triangle (the hypotenuse), and the cosine
is the ratio of the length of the adjacent leg to that of the hypotenuse. 

More generally, the definitions of sine can be extended to any real 
value in terms of the lengths of certain line segments in a unit circle. 

The sine functions are commonly used to model periodic phenomena such
as sound and light waves, the position and velocity of harmonic oscillators, 
sunlight intensity and day length, and average temperature variations throughout 
the year.

@italian

Questa funzione calcolerà il valore del seno di un angolo. Il seno di un angolo 
acuto è definito nel contesto di un triangolo rettangolo: per l'angolo specificato, 
il suo seno è il rapporto tra la lunghezza del lato opposto a quell'angolo e la lunghezza 
del lato più lungo del triangolo (l'ipotenusa), e il coseno è il rapporto tra la lunghezza 
del cateto adiacente e quella dell'ipotenusa. Più in generale, le definizioni di seno possono 
essere estese a qualsiasi valore reale in termini di lunghezze di alcuni segmenti di linea in
una circonferenza unitaria.

Le funzioni sinusoidali sono comunemente utilizzate per modellare fenomeni periodici come 
onde sonore e luminose, la posizione e la velocità degli oscillatori armonici, l'intensità 
della luce solare e la durata del giorno e le variazioni di temperatura media durante tutto l'anno.

@syntax = SIN(angle)

@example x = SIN(PI/2)

@usedInExample float_sin.bas

@target all
</usermanual> */
Variable * fp_sin( Environment * _environment, char * _angle ) {

    Variable * angle = variable_retrieve_or_define( _environment, _angle, VT_FLOAT, 0 );
    Variable * result = variable_temporary( _environment, VT_FLOAT, "(sin)");

    switch( result->precision ) {
        case FT_FAST:
            if ( _environment->floatType.angle == FT_DEGREE ) {
                Variable * pi = variable_temporary( _environment, VT_FLOAT, "(float)" );
#if defined(__c128z__) || defined(__vg5000__) || defined(__zx__) || \
    defined(__coleco__) || defined(__cpc__) || defined(__sc3000__) || \
    defined(__sc3000__) || defined(__sg1000__) ||  defined(__msx1__)
                variable_store_float( _environment, pi->name, M_PI );
#else
                cpu_move_32bit( _environment, "PI", pi->realName );
#endif
                Variable * d180 = variable_temporary( _environment, VT_FLOAT, "(d180)" );
                variable_store_float( _environment, d180->name, 180.0 );
                Variable * radianAngle = variable_temporary( _environment, VT_FLOAT, "(sin)");
                cpu_float_fast_mul( _environment, angle->realName, pi->realName, radianAngle->realName );
                cpu_float_fast_div( _environment, radianAngle->realName, d180->realName, radianAngle->realName );
                cpu_float_fast_sin( _environment, radianAngle->realName, result->realName );
            } else {
                cpu_float_fast_sin( _environment, angle->realName, result->realName );
            }
            break;
        case FT_SINGLE:
            if ( _environment->floatType.angle == FT_DEGREE ) {
                Variable * pi = variable_temporary( _environment, VT_FLOAT, "(float)" );
#if defined(__c128z__) || defined(__vg5000__) || defined(__zx__) || \
    defined(__coleco__) || defined(__cpc__) || defined(__sc3000__) || \
    defined(__sc3000__) || defined(__sg1000__) ||  defined(__msx1__)
                variable_store_float( _environment, pi->name, M_PI );
#else
                cpu_move_32bit( _environment, "PI", pi->realName );
#endif
                Variable * d180 = variable_temporary( _environment, VT_FLOAT, "(d180)" );
                variable_store_float( _environment, d180->name, 180.0 );
                Variable * radianAngle = variable_temporary( _environment, VT_FLOAT, "(sin)");
                cpu_float_single_mul( _environment, angle->realName, pi->realName, radianAngle->realName );
                cpu_float_single_div( _environment, radianAngle->realName, d180->realName, radianAngle->realName );
                cpu_float_single_sin( _environment, radianAngle->realName, result->realName );
            } else {
                cpu_float_single_sin( _environment, angle->realName, result->realName );
            }
            break;
    }

    return result;

}

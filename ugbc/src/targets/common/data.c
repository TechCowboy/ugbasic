/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
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
 * @brief Emit code for <strong>DATA</strong> instruction (numeric values)
 * 
 * @param _environment Current calling environment
 * @param _value Numeric value to store
 */
 /* <usermanual>
@keyword DATA

@english

The ''DATA'' command is used to store constant information in the program code,
and is used with the BASIC-command ''READ''. Each ''DATA''-line can contain one
or more constants separated by commas. Expressions containing variables 
will not be evaluated here.

The instruction stores numeric data in an optimized way: so, if you enter a numeric
constant that can be represented by a single byte, it will be stored in the program
as a single byte. Floating point numbers are stored with default precision. 
Finally, strings are stored "as is". As a result, when you use the ''READ'' command, 
ugBASIC will implicitly perform the conversion if the same data type is not used,
and it is posssible. It is possible to avoid optimization by using the ''AS'' 
keyword with the data type.

The ''DATA'' values will be read from left to right, beginning with the first 
line containing a ''DATA'' statement. Each time a ''READ'' instruction is 
executed the saved ''DATA'' position of the last ''READ'' is advanced to the 
next value. Strings must be written in quotes, so characters 
like comma, space, colon, graphical ones or control characters has to be 
written inside double quotes like string constants. The ''RESTORE'' resets
the pointer of the current ''DATA'' position the program start so that 
next ''READ'' will read from the first ''DATA'' found from the beginning 
of the program.

In case ''READ'' uses the wrong variable type, variable will be untouched
and pointer will be left to the current position. There is no easy way
to get the position of the ''READ'' statement which is the real origin of 
the mismatch. 

''DATA'' lines may scattered over the whole program code. 

@italian

Il comando ''DATA'' viene utilizzato per memorizzare informazioni costanti 
nel codice del programma e viene utilizzato con il comando BASIC ''READ''. 
Ogni riga ''DATA'' può contenere una o più costanti separate da virgole. 
Le espressioni contenenti variabili non verranno valutate.

L'istruzione memorizza i dati numerici in modo ottimizzato: quindi, se 
si inserisce una costante numerica che può essere rappresentata da un
singolo byte, così sarà memorizzata nel programma. I numeri in virgola 
mobile sono memorizzati secondo la precisione di default. Infine, le stringhe
sono memorizzate "as is". Ne consegue che, quando si utilizzerà il comando 
''READ'', ugBASIC effettuerà implicitamente la conversione laddove 
non si utilizzi lo stesso tipo di dato, laddove possibile. Si può evitare
l'ottimizzazione utilizzando la parola chiave AS con il tipo di dato.

I valori ''DATA'' verranno letti da sinistra a destra, iniziando con la 
prima riga contenente un'istruzione ''DATA''. Ogni volta che viene eseguita 
un'istruzione ''READ'', la posizione ''DATA'' salvata dell'ultima ''READ'' 
viene avanzata al valore successivo. Le stringhe devono essere scritte tra 
virgolette, quindi caratteri come virgola, spazio, due punti, caratteri grafici 
o caratteri di controllo devono essere scritti tra virgolette doppie come le 
costanti di stringa. Il ''RESTORE'' reimposta il puntatore della posizione corrente 
dei ''DATA'' all'inizio del programma in modo che il successivo ''READ'' leggerà 
dal primo ''DATA'' trovato dall'inizio del programma.

Nel caso in cui ''READ'' utilizzi il tipo di variabile sbagliato, la variabile 
non verrà toccata e il puntatore verrà lasciato nella posizione corrente. 
Non esiste un modo semplice per ottenere la posizione dell'istruzione ''READ'' 
che è la vera origine della mancata corrispondenza.

Le righe ''DATA'' possono essere sparse nell'intero codice del programma.

@syntax DATA c1[, c2[, c3[, ...]]]
@syntax DATA AS type c1[, c2[, c3[, ...]]]

@example DATA 10, 20, "test"
@example DATA AS INTEGER 10, 20, 30

@usedInExample data_example_01.bas
@usedInExample data_example_02.bas
@usedInExample data_example_03.bas
@usedInExample data_example_05.bas

@target all
@verified
</usermanual> */
void data_numeric( Environment * _environment, int _value ) {

    VariableType type;

    if ( _environment->dataDataType ) {
        type = _environment->dataDataType;
    } else {
        type = variable_type_from_numeric_value( _environment, _value );
    }

    int bytes = VT_BITWIDTH( type ) >> 3;

    DataSegment * data;

    if ( _environment->lastDefinedLabel ) {
        if ( _environment->lastDefinedLabelIsNumeric ) {
            data = data_segment_define_or_retrieve_numeric( _environment, _environment->lastDefinedLabelNumeric );
        } else {
            data = data_segment_define_or_retrieve( _environment, _environment->lastDefinedLabel );
        }
    } else {
        data = data_segment_define_or_retrieve( _environment, "DATA" );
    }

    DataDataSegment * dataDataSegment = malloc( sizeof( DataDataSegment ) );
    memset( dataDataSegment, 0, sizeof( DataDataSegment ) );
    dataDataSegment->size = bytes;
    dataDataSegment->data = malloc( bytes );
    dataDataSegment->type = type;
#if defined(CPU_BIG_ENDIAN)
    char * value = (char *)&_value;
    for( int i=0; i<bytes; ++i ) {
        dataDataSegment->data[bytes-i-1] = value[i];
    }
#else
    memcpy( dataDataSegment->data, &_value, bytes );
#endif

    DataDataSegment * final = data->data;

    if ( final ) {
        while( final->next ) {
            final = final->next;
        }
        final->next = dataDataSegment;
    } else {
        data->data = dataDataSegment;
    }
    
    if (  _environment->dataDataType ) {
        data->type = _environment->dataDataType;
    }

}

/**
 * @brief Emit code for <strong>DATA</strong> instruction (float values)
 * 
 * @param _environment Current calling environment
 * @param _value Float value to store
 */
void data_floating( Environment * _environment, double _value ) {

    VariableType type = VT_FLOAT;

    int bytes = VT_FLOAT_BITWIDTH( _environment->floatType.precision ) >> 3;

    DataSegment * data;

    if ( _environment->lastDefinedLabel ) {
        if ( _environment->lastDefinedLabelIsNumeric ) {
            data = data_segment_define_or_retrieve_numeric( _environment, _environment->lastDefinedLabelNumeric );
        } else {
            data = data_segment_define_or_retrieve( _environment, _environment->lastDefinedLabel );
        }
    } else {
        data = data_segment_define_or_retrieve( _environment, "DATA" );
    }

    int result[32];
    cpu_float_single_from_double_to_int_array( _environment, _value, result );

    DataDataSegment * dataDataSegment = malloc( sizeof( DataDataSegment ) );
    memset( dataDataSegment, 0, sizeof( DataDataSegment ) );
    dataDataSegment->size = bytes;
    dataDataSegment->data = malloc( bytes );
    dataDataSegment->type = type;
    dataDataSegment->precision = _environment->floatType.precision;
    for( int i=0; i<bytes; ++i ) {
        dataDataSegment->data[i] = (char)(result[i] & 0xff );
    }

    DataDataSegment * final = data->data;

    if ( final ) {
        while( final->next ) {
            final = final->next;
        }
        final->next = dataDataSegment;
    } else {
        data->data = dataDataSegment;
    }
    
    if (  _environment->dataDataType ) {
        data->type = _environment->dataDataType;
    }

}

/**
 * @brief Emit code for <strong>DATA</strong> instruction (string values)
 * 
 * @param _environment Current calling environment
 * @param _value String value to store
 */
void data_string( Environment * _environment, char * _value ) {

    VariableType type = VT_STRING;

    int bytes;

    char * value = unescape_string( _environment, _value, 0, &bytes );

    DataSegment * data;

    if ( _environment->lastDefinedLabel ) {
        if ( _environment->lastDefinedLabelIsNumeric ) {
            data = data_segment_define_or_retrieve_numeric( _environment, _environment->lastDefinedLabelNumeric );
        } else {
            data = data_segment_define_or_retrieve( _environment, _environment->lastDefinedLabel );
        }
    } else {
        data = data_segment_define_or_retrieve( _environment, "DATA" );
    }

    DataDataSegment * dataDataSegment = malloc( sizeof( DataDataSegment ) );
    memset( dataDataSegment, 0, sizeof( DataDataSegment ) );
    dataDataSegment->size = bytes;
    dataDataSegment->data = malloc( bytes + 1 );
    memset( dataDataSegment->data, 0, bytes + 1 );
    dataDataSegment->type = type;
    memcpy( dataDataSegment->data, value, bytes );

    if (  _environment->dataDataType ) {
        data->type = _environment->dataDataType;
    }

    DataDataSegment * final = data->data;
    
    if ( final ) {
        while( final->next ) {
            final = final->next;
        }
        final->next = dataDataSegment;
    } else {
        data->data = dataDataSegment;
    }

}

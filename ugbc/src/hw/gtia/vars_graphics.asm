; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file except in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  * See the License for the specific language governing permissions and
;  * limitations under the License.
;  *----------------------------------------------------------------------------
;  * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
;  * (la "Licenza"); è proibito usare questo file se non in conformità alla
;  * Licenza. Una copia della Licenza è disponibile all'indirizzo:
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Se non richiesto dalla legislazione vigente o concordato per iscritto,
;  * il software distribuito nei termini della Licenza è distribuito
;  * "COSì COM'è", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
;  * implicite. Consultare la Licenza per il testo specifico che regola le
;  * autorizzazioni e le limitazioni previste dalla medesima.
;  ****************************************************************************/
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                      INTERNAL VARIABLES FOR GTIA HARDWARE                   *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

@EMIT frameBufferStart AS GTIAFBS
@EMIT frameBufferStart2 AS GTIAFBS2

PLOTVBASELO:
    .byte <(GTIAFBS+(0*320)),<(GTIAFBS+(1*320)),<(GTIAFBS+(2*320)),<(GTIAFBS+(3*320))
    .byte <(GTIAFBS+(4*320)),<(GTIAFBS+(5*320)),<(GTIAFBS+(6*320)),<(GTIAFBS+(7*320))
    .byte <(GTIAFBS+(8*320)),<(GTIAFBS+(9*320)),<(GTIAFBS+(10*320)),<(GTIAFBS+(11*320))
    .byte <(GTIAFBS+(12*320)),<(GTIAFBS+(13*320)),<(GTIAFBS+(14*320)),<(GTIAFBS+(15*320))
    .byte <(GTIAFBS+(16*320)),<(GTIAFBS+(17*320)),<(GTIAFBS+(18*320)),<(GTIAFBS+(19*320))
    .byte <(GTIAFBS+(20*320)),<(GTIAFBS+(21*320)),<(GTIAFBS+(22*320)),<(GTIAFBS+(23*320))
    .byte <(GTIAFBS+(24*320))

PLOTVBASEHI:
    .byte >(GTIAFBS+(0*320)),>(GTIAFBS+(1*320)),>(GTIAFBS+(2*320)),>(GTIAFBS+(3*320))
    .byte >(GTIAFBS+(4*320)),>(GTIAFBS+(5*320)),>(GTIAFBS+(6*320)),>(GTIAFBS+(7*320))
    .byte >(GTIAFBS+(8*320)),>(GTIAFBS+(9*320)),>(GTIAFBS+(10*320)),>(GTIAFBS+(11*320))
    .byte >(GTIAFBS+(12*320)),>(GTIAFBS+(13*320)),>(GTIAFBS+(14*320)),>(GTIAFBS+(15*320))
    .byte >(GTIAFBS+(16*320)),>(GTIAFBS+(17*320)),>(GTIAFBS+(18*320)),>(GTIAFBS+(19*320))
    .byte >(GTIAFBS+(20*320)),>(GTIAFBS+(21*320)),>(GTIAFBS+(22*320)),>(GTIAFBS+(23*320))
    .byte >(GTIAFBS+(24*320))

PLOT8LO:
    .byte <(0*8),<(1*8),<(2*8),<(3*8),<(4*8),<(5*8),<(6*8),<(7*8),<(8*8),<(9*8)
    .byte <(10*8),<(11*8),<(12*8),<(13*8),<(14*8),<(15*8),<(16*8),<(17*8),<(18*8),<(19*8)
    .byte <(20*8),<(21*8),<(22*8),<(23*8),<(24*8),<(25*8),<(26*8),<(27*8),<(28*8),<(29*8)
    .byte <(30*8),<(31*8),<(32*8),<(33*8),<(34*8),<(35*8),<(36*8),<(37*8),<(38*8),<(39*8)

PLOT8HI:
    .byte >(0*8),>(1*8),>(2*8),>(3*8),>(4*8),>(5*8),>(6*8),>(7*8),>(8*8),>(9*8)
    .byte >(10*8),>(11*8),>(12*8),>(13*8),>(14*8),>(15*8),>(16*8),>(17*8),>(18*8),>(19*8)
    .byte >(20*8),>(21*8),>(22*8),>(23*8),>(24*8),>(25*8),>(26*8),>(27*8),>(28*8),>(29*8)
    .byte >(30*8),>(31*8),>(32*8),>(33*8),>(34*8),>(35*8),>(36*8),>(37*8),>(38*8),>(39*8)

PLOT4LO:
    .byte <(0),<(1),<(2),<(3)
    .byte <(4),<(5),<(6),<(7)
    .byte <(8),<(9)
    

PLOT4HI:
    .byte >(0),>(1),>(2),>(3)
    .byte >(4),>(5),>(6),>(7)
    .byte >(8),>(9)

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 8 ) || ( currentMode == 9 ) )

PLOT4VBASELO:
    .byte <(GTIAFBS+(0*10)),<(GTIAFBS+(1*10)),<(GTIAFBS+(2*10)),<(GTIAFBS+(3*10))
    .byte <(GTIAFBS+(4*10)),<(GTIAFBS+(5*10)),<(GTIAFBS+(6*10)),<(GTIAFBS+(7*10))
    .byte <(GTIAFBS+(8*10)),<(GTIAFBS+(9*10)),<(GTIAFBS+(10*10)),<(GTIAFBS+(11*10))
    .byte <(GTIAFBS+(12*10)),<(GTIAFBS+(13*10)),<(GTIAFBS+(14*10)),<(GTIAFBS+(15*10))
    .byte <(GTIAFBS+(16*10)),<(GTIAFBS+(17*10)),<(GTIAFBS+(18*10)),<(GTIAFBS+(19*10))
    .byte <(GTIAFBS+(20*10)),<(GTIAFBS+(21*10)),<(GTIAFBS+(22*10)),<(GTIAFBS+(23*10))
    .byte <(GTIAFBS+(24*10)),<(GTIAFBS+(25*10)),<(GTIAFBS+(26*10)),<(GTIAFBS+(27*10))
    .byte <(GTIAFBS+(28*10)),<(GTIAFBS+(29*10)),<(GTIAFBS+(30*10)),<(GTIAFBS+(31*10))
    .byte <(GTIAFBS+(32*10)),<(GTIAFBS+(33*10)),<(GTIAFBS+(34*10)),<(GTIAFBS+(35*10))
    .byte <(GTIAFBS+(36*10)),<(GTIAFBS+(37*10)),<(GTIAFBS+(38*10)),<(GTIAFBS+(39*10))
    .byte <(GTIAFBS+(40*10)),<(GTIAFBS+(41*10)),<(GTIAFBS+(42*10)),<(GTIAFBS+(43*10))
    .byte <(GTIAFBS+(44*10)),<(GTIAFBS+(45*10)),<(GTIAFBS+(46*10)),<(GTIAFBS+(47*10))

PLOT4VBASEHI:
    .byte >(GTIAFBS+(0*10)),>(GTIAFBS+(1*10)),>(GTIAFBS+(2*10)),>(GTIAFBS+(3*10))
    .byte >(GTIAFBS+(4*10)),>(GTIAFBS+(5*10)),>(GTIAFBS+(6*10)),>(GTIAFBS+(7*10))
    .byte >(GTIAFBS+(8*10)),>(GTIAFBS+(9*10)),>(GTIAFBS+(10*10)),>(GTIAFBS+(11*10))
    .byte >(GTIAFBS+(12*10)),>(GTIAFBS+(13*10)),>(GTIAFBS+(14*10)),>(GTIAFBS+(15*10))
    .byte >(GTIAFBS+(16*10)),>(GTIAFBS+(17*10)),>(GTIAFBS+(18*10)),>(GTIAFBS+(19*10))
    .byte >(GTIAFBS+(20*10)),>(GTIAFBS+(21*10)),>(GTIAFBS+(22*10)),>(GTIAFBS+(23*10))
    .byte >(GTIAFBS+(24*10)),>(GTIAFBS+(25*10)),>(GTIAFBS+(26*10)),>(GTIAFBS+(27*10))
    .byte >(GTIAFBS+(28*10)),>(GTIAFBS+(29*10)),>(GTIAFBS+(30*10)),>(GTIAFBS+(31*10))
    .byte >(GTIAFBS+(32*10)),>(GTIAFBS+(33*10)),>(GTIAFBS+(34*10)),>(GTIAFBS+(35*10))
    .byte >(GTIAFBS+(36*10)),>(GTIAFBS+(37*10)),>(GTIAFBS+(38*10)),>(GTIAFBS+(39*10))
    .byte >(GTIAFBS+(40*10)),>(GTIAFBS+(41*10)),>(GTIAFBS+(42*10)),>(GTIAFBS+(43*10))
    .byte >(GTIAFBS+(44*10)),>(GTIAFBS+(45*10)),>(GTIAFBS+(46*10)),>(GTIAFBS+(47*10))

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 10 ) || ( currentMode == 11 ) || ( currentMode == 14 ) || ( currentMode == 12 ) )

PLOT5VBASELO:
    .byte <(GTIAFBS+(0*20)),<(GTIAFBS+(1*20)),<(GTIAFBS+(2*20)),<(GTIAFBS+(3*20))
    .byte <(GTIAFBS+(4*20)),<(GTIAFBS+(5*20)),<(GTIAFBS+(6*20)),<(GTIAFBS+(7*20))
    .byte <(GTIAFBS+(8*20)),<(GTIAFBS+(9*20)),<(GTIAFBS+(10*20)),<(GTIAFBS+(11*20))
    .byte <(GTIAFBS+(12*20)),<(GTIAFBS+(13*20)),<(GTIAFBS+(14*20)),<(GTIAFBS+(15*20))
    .byte <(GTIAFBS+(16*20)),<(GTIAFBS+(17*20)),<(GTIAFBS+(18*20)),<(GTIAFBS+(19*20))
    .byte <(GTIAFBS+(20*20)),<(GTIAFBS+(21*20)),<(GTIAFBS+(22*20)),<(GTIAFBS+(23*20))
    .byte <(GTIAFBS+(24*20)),<(GTIAFBS+(25*20)),<(GTIAFBS+(26*20)),<(GTIAFBS+(27*20))
    .byte <(GTIAFBS+(28*20)),<(GTIAFBS+(29*20)),<(GTIAFBS+(30*20)),<(GTIAFBS+(31*20))
    .byte <(GTIAFBS+(32*20)),<(GTIAFBS+(33*20)),<(GTIAFBS+(34*20)),<(GTIAFBS+(35*20))
    .byte <(GTIAFBS+(36*20)),<(GTIAFBS+(37*20)),<(GTIAFBS+(38*20)),<(GTIAFBS+(39*20))
    .byte <(GTIAFBS+(40*20)),<(GTIAFBS+(41*20)),<(GTIAFBS+(42*20)),<(GTIAFBS+(43*20))
    .byte <(GTIAFBS+(44*20)),<(GTIAFBS+(45*20)),<(GTIAFBS+(46*20)),<(GTIAFBS+(47*20))
    .byte <(GTIAFBS+(48*20)),<(GTIAFBS+(49*20)),<(GTIAFBS+(50*20)),<(GTIAFBS+(51*20))
    .byte <(GTIAFBS+(52*20)),<(GTIAFBS+(53*20)),<(GTIAFBS+(54*20)),<(GTIAFBS+(55*20))
    .byte <(GTIAFBS+(56*20)),<(GTIAFBS+(57*20)),<(GTIAFBS+(58*20)),<(GTIAFBS+(59*20))
    .byte <(GTIAFBS+(60*20)),<(GTIAFBS+(61*20)),<(GTIAFBS+(62*20)),<(GTIAFBS+(63*20))
    .byte <(GTIAFBS+(64*20)),<(GTIAFBS+(65*20)),<(GTIAFBS+(66*20)),<(GTIAFBS+(67*20))
    .byte <(GTIAFBS+(68*20)),<(GTIAFBS+(69*20)),<(GTIAFBS+(70*20)),<(GTIAFBS+(71*20))
    .byte <(GTIAFBS+(72*20)),<(GTIAFBS+(73*20)),<(GTIAFBS+(74*20)),<(GTIAFBS+(75*20))
    .byte <(GTIAFBS+(76*20)),<(GTIAFBS+(77*20)),<(GTIAFBS+(78*20)),<(GTIAFBS+(79*20))
    .byte <(GTIAFBS+(80*20)),<(GTIAFBS+(81*20)),<(GTIAFBS+(82*20)),<(GTIAFBS+(83*20))
    .byte <(GTIAFBS+(84*20)),<(GTIAFBS+(85*20)),<(GTIAFBS+(86*20)),<(GTIAFBS+(87*20))
    .byte <(GTIAFBS+(88*20)),<(GTIAFBS+(89*20)),<(GTIAFBS+(90*20)),<(GTIAFBS+(91*20))
    .byte <(GTIAFBS+(92*20)),<(GTIAFBS+(93*20)),<(GTIAFBS+(94*20)),<(GTIAFBS+(95*20))
    .byte <(GTIAFBS+(96*20)),<(GTIAFBS+(97*20)),<(GTIAFBS+(98*20)),<(GTIAFBS+(99*20))
    .byte <(GTIAFBS+(100*20)),<(GTIAFBS+(101*20)),<(GTIAFBS+(102*20)),<(GTIAFBS+(103*20))
    .byte <(GTIAFBS+(104*20)),<(GTIAFBS+(105*20)),<(GTIAFBS+(106*20)),<(GTIAFBS+(107*20))
    .byte <(GTIAFBS+(108*20)),<(GTIAFBS+(109*20)),<(GTIAFBS+(110*20)),<(GTIAFBS+(111*20))
    .byte <(GTIAFBS+(112*20)),<(GTIAFBS+(113*20)),<(GTIAFBS+(114*20)),<(GTIAFBS+(115*20))
    .byte <(GTIAFBS+(116*20)),<(GTIAFBS+(117*20)),<(GTIAFBS+(118*20)),<(GTIAFBS+(119*20))
    .byte <(GTIAFBS+(120*20)),<(GTIAFBS+(121*20)),<(GTIAFBS+(122*20)),<(GTIAFBS+(123*20))
    .byte <(GTIAFBS+(124*20)),<(GTIAFBS+(125*20)),<(GTIAFBS+(126*20)),<(GTIAFBS+(127*20))
    .byte <(GTIAFBS+(128*20)),<(GTIAFBS+(129*20)),<(GTIAFBS+(130*20)),<(GTIAFBS+(131*20))
    .byte <(GTIAFBS+(132*20)),<(GTIAFBS+(133*20)),<(GTIAFBS+(134*20)),<(GTIAFBS+(135*20))
    .byte <(GTIAFBS+(136*20)),<(GTIAFBS+(137*20)),<(GTIAFBS+(138*20)),<(GTIAFBS+(139*20))
    .byte <(GTIAFBS+(140*20)),<(GTIAFBS+(141*20)),<(GTIAFBS+(142*20)),<(GTIAFBS+(143*20))
    .byte <(GTIAFBS+(144*20)),<(GTIAFBS+(145*20)),<(GTIAFBS+(146*20)),<(GTIAFBS+(147*20))
    .byte <(GTIAFBS+(148*20)),<(GTIAFBS+(149*20)),<(GTIAFBS+(150*20)),<(GTIAFBS+(151*20))
    .byte <(GTIAFBS+(152*20)),<(GTIAFBS+(153*20)),<(GTIAFBS+(154*20)),<(GTIAFBS+(155*20))
    .byte <(GTIAFBS+(156*20)),<(GTIAFBS+(157*20)),<(GTIAFBS+(158*20)),<(GTIAFBS+(159*20))
    .byte <(GTIAFBS+(160*20)),<(GTIAFBS+(161*20)),<(GTIAFBS+(162*20)),<(GTIAFBS+(163*20))
    .byte <(GTIAFBS+(164*20)),<(GTIAFBS+(165*20)),<(GTIAFBS+(166*20)),<(GTIAFBS+(167*20))
    .byte <(GTIAFBS+(168*20)),<(GTIAFBS+(169*20)),<(GTIAFBS+(170*20)),<(GTIAFBS+(171*20))
    .byte <(GTIAFBS+(172*20)),<(GTIAFBS+(173*20)),<(GTIAFBS+(174*20)),<(GTIAFBS+(175*20))
    .byte <(GTIAFBS+(176*20)),<(GTIAFBS+(177*20)),<(GTIAFBS+(178*20)),<(GTIAFBS+(179*20))
    .byte <(GTIAFBS+(180*20)),<(GTIAFBS+(181*20)),<(GTIAFBS+(182*20)),<(GTIAFBS+(183*20))
    .byte <(GTIAFBS+(184*20)),<(GTIAFBS+(185*20)),<(GTIAFBS+(186*20)),<(GTIAFBS+(187*20))
    .byte <(GTIAFBS+(188*20)),<(GTIAFBS+(189*20)),<(GTIAFBS+(190*20)),<(GTIAFBS+(191*20))    

PLOT5VBASEHI:
    .byte >(GTIAFBS+(0*20)),>(GTIAFBS+(1*20)),>(GTIAFBS+(2*20)),>(GTIAFBS+(3*20))
    .byte >(GTIAFBS+(4*20)),>(GTIAFBS+(5*20)),>(GTIAFBS+(6*20)),>(GTIAFBS+(7*20))
    .byte >(GTIAFBS+(8*20)),>(GTIAFBS+(9*20)),>(GTIAFBS+(10*20)),>(GTIAFBS+(11*20))
    .byte >(GTIAFBS+(12*20)),>(GTIAFBS+(13*20)),>(GTIAFBS+(14*20)),>(GTIAFBS+(15*20))
    .byte >(GTIAFBS+(16*20)),>(GTIAFBS+(17*20)),>(GTIAFBS+(18*20)),>(GTIAFBS+(19*20))
    .byte >(GTIAFBS+(20*20)),>(GTIAFBS+(21*20)),>(GTIAFBS+(22*20)),>(GTIAFBS+(23*20))
    .byte >(GTIAFBS+(24*20)),>(GTIAFBS+(25*20)),>(GTIAFBS+(26*20)),>(GTIAFBS+(27*20))
    .byte >(GTIAFBS+(28*20)),>(GTIAFBS+(29*20)),>(GTIAFBS+(30*20)),>(GTIAFBS+(31*20))
    .byte >(GTIAFBS+(32*20)),>(GTIAFBS+(33*20)),>(GTIAFBS+(34*20)),>(GTIAFBS+(35*20))
    .byte >(GTIAFBS+(36*20)),>(GTIAFBS+(37*20)),>(GTIAFBS+(38*20)),>(GTIAFBS+(39*20))
    .byte >(GTIAFBS+(40*20)),>(GTIAFBS+(41*20)),>(GTIAFBS+(42*20)),>(GTIAFBS+(43*20))
    .byte >(GTIAFBS+(44*20)),>(GTIAFBS+(45*20)),>(GTIAFBS+(46*20)),>(GTIAFBS+(47*20))
    .byte >(GTIAFBS+(48*20)),>(GTIAFBS+(49*20)),>(GTIAFBS+(50*20)),>(GTIAFBS+(51*20))
    .byte >(GTIAFBS+(52*20)),>(GTIAFBS+(53*20)),>(GTIAFBS+(54*20)),>(GTIAFBS+(55*20))
    .byte >(GTIAFBS+(56*20)),>(GTIAFBS+(57*20)),>(GTIAFBS+(58*20)),>(GTIAFBS+(59*20))
    .byte >(GTIAFBS+(60*20)),>(GTIAFBS+(61*20)),>(GTIAFBS+(62*20)),>(GTIAFBS+(63*20))
    .byte >(GTIAFBS+(64*20)),>(GTIAFBS+(65*20)),>(GTIAFBS+(66*20)),>(GTIAFBS+(67*20))
    .byte >(GTIAFBS+(68*20)),>(GTIAFBS+(69*20)),>(GTIAFBS+(70*20)),>(GTIAFBS+(71*20))
    .byte >(GTIAFBS+(72*20)),>(GTIAFBS+(73*20)),>(GTIAFBS+(74*20)),>(GTIAFBS+(75*20))
    .byte >(GTIAFBS+(76*20)),>(GTIAFBS+(77*20)),>(GTIAFBS+(78*20)),>(GTIAFBS+(79*20))
    .byte >(GTIAFBS+(80*20)),>(GTIAFBS+(81*20)),>(GTIAFBS+(82*20)),>(GTIAFBS+(83*20))
    .byte >(GTIAFBS+(84*20)),>(GTIAFBS+(85*20)),>(GTIAFBS+(86*20)),>(GTIAFBS+(87*20))
    .byte >(GTIAFBS+(88*20)),>(GTIAFBS+(89*20)),>(GTIAFBS+(90*20)),>(GTIAFBS+(91*20))
    .byte >(GTIAFBS+(92*20)),>(GTIAFBS+(93*20)),>(GTIAFBS+(94*20)),>(GTIAFBS+(95*20))
    .byte >(GTIAFBS+(96*20)),>(GTIAFBS+(97*20)),>(GTIAFBS+(98*20)),>(GTIAFBS+(99*20))
    .byte >(GTIAFBS+(100*20)),>(GTIAFBS+(101*20)),>(GTIAFBS+(102*20)),>(GTIAFBS+(103*20))
    .byte >(GTIAFBS+(104*20)),>(GTIAFBS+(105*20)),>(GTIAFBS+(106*20)),>(GTIAFBS+(107*20))
    .byte >(GTIAFBS+(108*20)),>(GTIAFBS+(109*20)),>(GTIAFBS+(110*20)),>(GTIAFBS+(111*20))
    .byte >(GTIAFBS+(112*20)),>(GTIAFBS+(113*20)),>(GTIAFBS+(114*20)),>(GTIAFBS+(115*20))
    .byte >(GTIAFBS+(116*20)),>(GTIAFBS+(117*20)),>(GTIAFBS+(118*20)),>(GTIAFBS+(119*20))
    .byte >(GTIAFBS+(120*20)),>(GTIAFBS+(121*20)),>(GTIAFBS+(122*20)),>(GTIAFBS+(123*20))
    .byte >(GTIAFBS+(124*20)),>(GTIAFBS+(125*20)),>(GTIAFBS+(126*20)),>(GTIAFBS+(127*20))
    .byte >(GTIAFBS+(128*20)),>(GTIAFBS+(129*20)),>(GTIAFBS+(130*20)),>(GTIAFBS+(131*20))
    .byte >(GTIAFBS+(132*20)),>(GTIAFBS+(133*20)),>(GTIAFBS+(134*20)),>(GTIAFBS+(135*20))
    .byte >(GTIAFBS+(136*20)),>(GTIAFBS+(137*20)),>(GTIAFBS+(138*20)),>(GTIAFBS+(139*20))
    .byte >(GTIAFBS+(140*20)),>(GTIAFBS+(141*20)),>(GTIAFBS+(142*20)),>(GTIAFBS+(143*20))
    .byte >(GTIAFBS+(144*20)),>(GTIAFBS+(145*20)),>(GTIAFBS+(146*20)),>(GTIAFBS+(147*20))
    .byte >(GTIAFBS+(148*20)),>(GTIAFBS+(149*20)),>(GTIAFBS+(150*20)),>(GTIAFBS+(151*20))
    .byte >(GTIAFBS+(152*20)),>(GTIAFBS+(153*20)),>(GTIAFBS+(154*20)),>(GTIAFBS+(155*20))
    .byte >(GTIAFBS+(156*20)),>(GTIAFBS+(157*20)),>(GTIAFBS+(158*20)),>(GTIAFBS+(159*20))
    .byte >(GTIAFBS+(160*20)),>(GTIAFBS+(161*20)),>(GTIAFBS+(162*20)),>(GTIAFBS+(163*20))
    .byte >(GTIAFBS+(164*20)),>(GTIAFBS+(165*20)),>(GTIAFBS+(166*20)),>(GTIAFBS+(167*20))
    .byte >(GTIAFBS+(168*20)),>(GTIAFBS+(169*20)),>(GTIAFBS+(170*20)),>(GTIAFBS+(171*20))
    .byte >(GTIAFBS+(172*20)),>(GTIAFBS+(173*20)),>(GTIAFBS+(174*20)),>(GTIAFBS+(175*20))
    .byte >(GTIAFBS+(176*20)),>(GTIAFBS+(177*20)),>(GTIAFBS+(178*20)),>(GTIAFBS+(179*20))
    .byte >(GTIAFBS+(180*20)),>(GTIAFBS+(181*20)),>(GTIAFBS+(182*20)),>(GTIAFBS+(183*20))
    .byte >(GTIAFBS+(184*20)),>(GTIAFBS+(185*20)),>(GTIAFBS+(186*20)),>(GTIAFBS+(187*20))
    .byte >(GTIAFBS+(188*20)),>(GTIAFBS+(189*20)),>(GTIAFBS+(190*20)),>(GTIAFBS+(191*20))    

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 13 ) )

PLOT6VBASELO:
    .byte <(GTIAFBS+(0*40)),<(GTIAFBS+(1*40)),<(GTIAFBS+(2*40)),<(GTIAFBS+(3*40))
    .byte <(GTIAFBS+(4*40)),<(GTIAFBS+(5*40)),<(GTIAFBS+(6*40)),<(GTIAFBS+(7*40))
    .byte <(GTIAFBS+(8*40)),<(GTIAFBS+(9*40)),<(GTIAFBS+(10*40)),<(GTIAFBS+(11*40))
    .byte <(GTIAFBS+(12*40)),<(GTIAFBS+(13*40)),<(GTIAFBS+(14*40)),<(GTIAFBS+(15*40))
    .byte <(GTIAFBS+(16*40)),<(GTIAFBS+(17*40)),<(GTIAFBS+(18*40)),<(GTIAFBS+(19*40))
    .byte <(GTIAFBS+(20*40)),<(GTIAFBS+(21*40)),<(GTIAFBS+(22*40)),<(GTIAFBS+(23*40))
    .byte <(GTIAFBS+(24*40)),<(GTIAFBS+(25*40)),<(GTIAFBS+(26*40)),<(GTIAFBS+(27*40))
    .byte <(GTIAFBS+(28*40)),<(GTIAFBS+(29*40)),<(GTIAFBS+(30*40)),<(GTIAFBS+(31*40))
    .byte <(GTIAFBS+(32*40)),<(GTIAFBS+(33*40)),<(GTIAFBS+(34*40)),<(GTIAFBS+(35*40))
    .byte <(GTIAFBS+(36*40)),<(GTIAFBS+(37*40)),<(GTIAFBS+(38*40)),<(GTIAFBS+(39*40))
    .byte <(GTIAFBS+(40*40)),<(GTIAFBS+(41*40)),<(GTIAFBS+(42*40)),<(GTIAFBS+(43*40))
    .byte <(GTIAFBS+(44*40)),<(GTIAFBS+(45*40)),<(GTIAFBS+(46*40)),<(GTIAFBS+(47*40))
    .byte <(GTIAFBS+(48*40)),<(GTIAFBS+(49*40)),<(GTIAFBS+(50*40)),<(GTIAFBS+(51*40))
    .byte <(GTIAFBS+(52*40)),<(GTIAFBS+(53*40)),<(GTIAFBS+(54*40)),<(GTIAFBS+(55*40))
    .byte <(GTIAFBS+(56*40)),<(GTIAFBS+(57*40)),<(GTIAFBS+(58*40)),<(GTIAFBS+(59*40))
    .byte <(GTIAFBS+(60*40)),<(GTIAFBS+(61*40)),<(GTIAFBS+(62*40)),<(GTIAFBS+(63*40))
    .byte <(GTIAFBS+(64*40)),<(GTIAFBS+(65*40)),<(GTIAFBS+(66*40)),<(GTIAFBS+(67*40))
    .byte <(GTIAFBS+(68*40)),<(GTIAFBS+(69*40)),<(GTIAFBS+(70*40)),<(GTIAFBS+(71*40))
    .byte <(GTIAFBS+(72*40)),<(GTIAFBS+(73*40)),<(GTIAFBS+(74*40)),<(GTIAFBS+(75*40))
    .byte <(GTIAFBS+(76*40)),<(GTIAFBS+(77*40)),<(GTIAFBS+(78*40)),<(GTIAFBS+(79*40))
    .byte <(GTIAFBS+(80*40)),<(GTIAFBS+(81*40)),<(GTIAFBS+(82*40)),<(GTIAFBS+(83*40))
    .byte <(GTIAFBS+(84*40)),<(GTIAFBS+(85*40)),<(GTIAFBS+(86*40)),<(GTIAFBS+(87*40))
    .byte <(GTIAFBS+(88*40)),<(GTIAFBS+(89*40)),<(GTIAFBS+(90*40)),<(GTIAFBS+(91*40))
    .byte <(GTIAFBS+(92*40)),<(GTIAFBS+(93*40)),<(GTIAFBS+(94*40)),<(GTIAFBS+(95*40))
    .byte <(GTIAFBS+(96*40)),<(GTIAFBS+(97*40)),<(GTIAFBS+(98*40)),<(GTIAFBS+(99*40))
    .byte <(GTIAFBS+(100*40)),<(GTIAFBS+(101*40)),<(GTIAFBS+(102*40)),<(GTIAFBS+(103*40))
    .byte <(GTIAFBS+(104*40)),<(GTIAFBS+(105*40)),<(GTIAFBS+(106*40)),<(GTIAFBS+(107*40))
    .byte <(GTIAFBS+(108*40)),<(GTIAFBS+(109*40)),<(GTIAFBS+(110*40)),<(GTIAFBS+(111*40))
    .byte <(GTIAFBS+(112*40)),<(GTIAFBS+(113*40)),<(GTIAFBS+(114*40)),<(GTIAFBS+(115*40))
    .byte <(GTIAFBS+(116*40)),<(GTIAFBS+(117*40)),<(GTIAFBS+(118*40)),<(GTIAFBS+(119*40))
    .byte <(GTIAFBS+(120*40)),<(GTIAFBS+(121*40)),<(GTIAFBS+(122*40)),<(GTIAFBS+(123*40))
    .byte <(GTIAFBS+(124*40)),<(GTIAFBS+(125*40)),<(GTIAFBS+(126*40)),<(GTIAFBS+(127*40))
    .byte <(GTIAFBS+(128*40)),<(GTIAFBS+(129*40)),<(GTIAFBS+(130*40)),<(GTIAFBS+(131*40))
    .byte <(GTIAFBS+(132*40)),<(GTIAFBS+(133*40)),<(GTIAFBS+(134*40)),<(GTIAFBS+(135*40))
    .byte <(GTIAFBS+(136*40)),<(GTIAFBS+(137*40)),<(GTIAFBS+(138*40)),<(GTIAFBS+(139*40))
    .byte <(GTIAFBS+(140*40)),<(GTIAFBS+(141*40)),<(GTIAFBS+(142*40)),<(GTIAFBS+(143*40))
    .byte <(GTIAFBS+(144*40)),<(GTIAFBS+(145*40)),<(GTIAFBS+(146*40)),<(GTIAFBS+(147*40))
    .byte <(GTIAFBS+(148*40)),<(GTIAFBS+(149*40)),<(GTIAFBS+(150*40)),<(GTIAFBS+(151*40))
    .byte <(GTIAFBS+(152*40)),<(GTIAFBS+(153*40)),<(GTIAFBS+(154*40)),<(GTIAFBS+(155*40))
    .byte <(GTIAFBS+(156*40)),<(GTIAFBS+(157*40)),<(GTIAFBS+(158*40)),<(GTIAFBS+(159*40))
    .byte <(GTIAFBS+(160*40)),<(GTIAFBS+(161*40)),<(GTIAFBS+(162*40)),<(GTIAFBS+(163*40))
    .byte <(GTIAFBS+(164*40)),<(GTIAFBS+(165*40)),<(GTIAFBS+(166*40)),<(GTIAFBS+(167*40))
    .byte <(GTIAFBS+(168*40)),<(GTIAFBS+(169*40)),<(GTIAFBS+(170*40)),<(GTIAFBS+(171*40))
    .byte <(GTIAFBS+(172*40)),<(GTIAFBS+(173*40)),<(GTIAFBS+(174*40)),<(GTIAFBS+(175*40))
    .byte <(GTIAFBS+(176*40)),<(GTIAFBS+(177*40)),<(GTIAFBS+(178*40)),<(GTIAFBS+(179*40))
    .byte <(GTIAFBS+(180*40)),<(GTIAFBS+(181*40)),<(GTIAFBS+(182*40)),<(GTIAFBS+(183*40))
    .byte <(GTIAFBS+(184*40)),<(GTIAFBS+(185*40)),<(GTIAFBS+(186*40)),<(GTIAFBS+(187*40))
    .byte <(GTIAFBS+(188*40)),<(GTIAFBS+(189*40)),<(GTIAFBS+(190*40)),<(GTIAFBS+(191*40))    

PLOT6VBASEHI:
    .byte >(GTIAFBS+(0*40)),>(GTIAFBS+(1*40)),>(GTIAFBS+(2*40)),>(GTIAFBS+(3*40))
    .byte >(GTIAFBS+(4*40)),>(GTIAFBS+(5*40)),>(GTIAFBS+(6*40)),>(GTIAFBS+(7*40))
    .byte >(GTIAFBS+(8*40)),>(GTIAFBS+(9*40)),>(GTIAFBS+(10*40)),>(GTIAFBS+(11*40))
    .byte >(GTIAFBS+(12*40)),>(GTIAFBS+(13*40)),>(GTIAFBS+(14*40)),>(GTIAFBS+(15*40))
    .byte >(GTIAFBS+(16*40)),>(GTIAFBS+(17*40)),>(GTIAFBS+(18*40)),>(GTIAFBS+(19*40))
    .byte >(GTIAFBS+(20*40)),>(GTIAFBS+(21*40)),>(GTIAFBS+(22*40)),>(GTIAFBS+(23*40))
    .byte >(GTIAFBS+(24*40)),>(GTIAFBS+(25*40)),>(GTIAFBS+(26*40)),>(GTIAFBS+(27*40))
    .byte >(GTIAFBS+(28*40)),>(GTIAFBS+(29*40)),>(GTIAFBS+(30*40)),>(GTIAFBS+(31*40))
    .byte >(GTIAFBS+(32*40)),>(GTIAFBS+(33*40)),>(GTIAFBS+(34*40)),>(GTIAFBS+(35*40))
    .byte >(GTIAFBS+(36*40)),>(GTIAFBS+(37*40)),>(GTIAFBS+(38*40)),>(GTIAFBS+(39*40))
    .byte >(GTIAFBS+(40*40)),>(GTIAFBS+(41*40)),>(GTIAFBS+(42*40)),>(GTIAFBS+(43*40))
    .byte >(GTIAFBS+(44*40)),>(GTIAFBS+(45*40)),>(GTIAFBS+(46*40)),>(GTIAFBS+(47*40))
    .byte >(GTIAFBS+(48*40)),>(GTIAFBS+(49*40)),>(GTIAFBS+(50*40)),>(GTIAFBS+(51*40))
    .byte >(GTIAFBS+(52*40)),>(GTIAFBS+(53*40)),>(GTIAFBS+(54*40)),>(GTIAFBS+(55*40))
    .byte >(GTIAFBS+(56*40)),>(GTIAFBS+(57*40)),>(GTIAFBS+(58*40)),>(GTIAFBS+(59*40))
    .byte >(GTIAFBS+(60*40)),>(GTIAFBS+(61*40)),>(GTIAFBS+(62*40)),>(GTIAFBS+(63*40))
    .byte >(GTIAFBS+(64*40)),>(GTIAFBS+(65*40)),>(GTIAFBS+(66*40)),>(GTIAFBS+(67*40))
    .byte >(GTIAFBS+(68*40)),>(GTIAFBS+(69*40)),>(GTIAFBS+(70*40)),>(GTIAFBS+(71*40))
    .byte >(GTIAFBS+(72*40)),>(GTIAFBS+(73*40)),>(GTIAFBS+(74*40)),>(GTIAFBS+(75*40))
    .byte >(GTIAFBS+(76*40)),>(GTIAFBS+(77*40)),>(GTIAFBS+(78*40)),>(GTIAFBS+(79*40))
    .byte >(GTIAFBS+(80*40)),>(GTIAFBS+(81*40)),>(GTIAFBS+(82*40)),>(GTIAFBS+(83*40))
    .byte >(GTIAFBS+(84*40)),>(GTIAFBS+(85*40)),>(GTIAFBS+(86*40)),>(GTIAFBS+(87*40))
    .byte >(GTIAFBS+(88*40)),>(GTIAFBS+(89*40)),>(GTIAFBS+(90*40)),>(GTIAFBS+(91*40))
    .byte >(GTIAFBS+(92*40)),>(GTIAFBS+(93*40)),>(GTIAFBS+(94*40)),>(GTIAFBS+(95*40))
    .byte >(GTIAFBS+(96*40)),>(GTIAFBS+(97*40)),>(GTIAFBS+(98*40)),>(GTIAFBS+(99*40))
    .byte >(GTIAFBS+(100*40)),>(GTIAFBS+(101*40)),>(GTIAFBS+(102*40)),>(GTIAFBS+(103*40))
    .byte >(GTIAFBS+(104*40)),>(GTIAFBS+(105*40)),>(GTIAFBS+(106*40)),>(GTIAFBS+(107*40))
    .byte >(GTIAFBS+(108*40)),>(GTIAFBS+(109*40)),>(GTIAFBS+(110*40)),>(GTIAFBS+(111*40))
    .byte >(GTIAFBS+(112*40)),>(GTIAFBS+(113*40)),>(GTIAFBS+(114*40)),>(GTIAFBS+(115*40))
    .byte >(GTIAFBS+(116*40)),>(GTIAFBS+(117*40)),>(GTIAFBS+(118*40)),>(GTIAFBS+(119*40))
    .byte >(GTIAFBS+(120*40)),>(GTIAFBS+(121*40)),>(GTIAFBS+(122*40)),>(GTIAFBS+(123*40))
    .byte >(GTIAFBS+(124*40)),>(GTIAFBS+(125*40)),>(GTIAFBS+(126*40)),>(GTIAFBS+(127*40))
    .byte >(GTIAFBS+(128*40)),>(GTIAFBS+(129*40)),>(GTIAFBS+(130*40)),>(GTIAFBS+(131*40))
    .byte >(GTIAFBS+(132*40)),>(GTIAFBS+(133*40)),>(GTIAFBS+(134*40)),>(GTIAFBS+(135*40))
    .byte >(GTIAFBS+(136*40)),>(GTIAFBS+(137*40)),>(GTIAFBS+(138*40)),>(GTIAFBS+(139*40))
    .byte >(GTIAFBS+(140*40)),>(GTIAFBS+(141*40)),>(GTIAFBS+(142*40)),>(GTIAFBS+(143*40))
    .byte >(GTIAFBS+(144*40)),>(GTIAFBS+(145*40)),>(GTIAFBS+(146*40)),>(GTIAFBS+(147*40))
    .byte >(GTIAFBS+(148*40)),>(GTIAFBS+(149*40)),>(GTIAFBS+(150*40)),>(GTIAFBS+(151*40))
    .byte >(GTIAFBS+(152*40)),>(GTIAFBS+(153*40)),>(GTIAFBS+(154*40)),>(GTIAFBS+(155*40))
    .byte >(GTIAFBS+(156*40)),>(GTIAFBS+(157*40)),>(GTIAFBS+(158*40)),>(GTIAFBS+(159*40))
    .byte >(GTIAFBS+(160*40)),>(GTIAFBS+(161*40)),>(GTIAFBS+(162*40)),>(GTIAFBS+(163*40))
    .byte >(GTIAFBS+(164*40)),>(GTIAFBS+(165*40)),>(GTIAFBS+(166*40)),>(GTIAFBS+(167*40))
    .byte >(GTIAFBS+(168*40)),>(GTIAFBS+(169*40)),>(GTIAFBS+(170*40)),>(GTIAFBS+(171*40))
    .byte >(GTIAFBS+(172*40)),>(GTIAFBS+(173*40)),>(GTIAFBS+(174*40)),>(GTIAFBS+(175*40))
    .byte >(GTIAFBS+(176*40)),>(GTIAFBS+(177*40)),>(GTIAFBS+(178*40)),>(GTIAFBS+(179*40))
    .byte >(GTIAFBS+(180*40)),>(GTIAFBS+(181*40)),>(GTIAFBS+(182*40)),>(GTIAFBS+(183*40))
    .byte >(GTIAFBS+(184*40)),>(GTIAFBS+(185*40)),>(GTIAFBS+(186*40)),>(GTIAFBS+(187*40))
    .byte >(GTIAFBS+(188*40)),>(GTIAFBS+(189*40)),>(GTIAFBS+(190*40)),>(GTIAFBS+(191*40))    

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( currentMode == 15 )

PLOT6XVBASELO:
    .byte <(GTIAFBS+(0*40)),<(GTIAFBS+(1*40)),<(GTIAFBS+(2*40)),<(GTIAFBS+(3*40))
    .byte <(GTIAFBS+(4*40)),<(GTIAFBS+(5*40)),<(GTIAFBS+(6*40)),<(GTIAFBS+(7*40))
    .byte <(GTIAFBS+(8*40)),<(GTIAFBS+(9*40)),<(GTIAFBS+(10*40)),<(GTIAFBS+(11*40))
    .byte <(GTIAFBS+(12*40)),<(GTIAFBS+(13*40)),<(GTIAFBS+(14*40)),<(GTIAFBS+(15*40))
    .byte <(GTIAFBS+(16*40)),<(GTIAFBS+(17*40)),<(GTIAFBS+(18*40)),<(GTIAFBS+(19*40))
    .byte <(GTIAFBS+(20*40)),<(GTIAFBS+(21*40)),<(GTIAFBS+(22*40)),<(GTIAFBS+(23*40))
    .byte <(GTIAFBS+(24*40)),<(GTIAFBS+(25*40)),<(GTIAFBS+(26*40)),<(GTIAFBS+(27*40))
    .byte <(GTIAFBS+(28*40)),<(GTIAFBS+(29*40)),<(GTIAFBS+(30*40)),<(GTIAFBS+(31*40))
    .byte <(GTIAFBS+(32*40)),<(GTIAFBS+(33*40)),<(GTIAFBS+(34*40)),<(GTIAFBS+(35*40))
    .byte <(GTIAFBS+(36*40)),<(GTIAFBS+(37*40)),<(GTIAFBS+(38*40)),<(GTIAFBS+(39*40))
    .byte <(GTIAFBS+(40*40)),<(GTIAFBS+(41*40)),<(GTIAFBS+(42*40)),<(GTIAFBS+(43*40))
    .byte <(GTIAFBS+(44*40)),<(GTIAFBS+(45*40)),<(GTIAFBS+(46*40)),<(GTIAFBS+(47*40))
    .byte <(GTIAFBS+(48*40)),<(GTIAFBS+(49*40)),<(GTIAFBS+(50*40)),<(GTIAFBS+(51*40))
    .byte <(GTIAFBS+(52*40)),<(GTIAFBS+(53*40)),<(GTIAFBS+(54*40)),<(GTIAFBS+(55*40))
    .byte <(GTIAFBS+(56*40)),<(GTIAFBS+(57*40)),<(GTIAFBS+(58*40)),<(GTIAFBS+(59*40))
    .byte <(GTIAFBS+(60*40)),<(GTIAFBS+(61*40)),<(GTIAFBS+(62*40)),<(GTIAFBS+(63*40))
    .byte <(GTIAFBS+(64*40)),<(GTIAFBS+(65*40)),<(GTIAFBS+(66*40)),<(GTIAFBS+(67*40))
    .byte <(GTIAFBS+(68*40)),<(GTIAFBS+(69*40)),<(GTIAFBS+(70*40)),<(GTIAFBS+(71*40))
    .byte <(GTIAFBS+(72*40)),<(GTIAFBS+(73*40)),<(GTIAFBS+(74*40)),<(GTIAFBS+(75*40))
    .byte <(GTIAFBS+(76*40)),<(GTIAFBS+(77*40)),<(GTIAFBS+(78*40)),<(GTIAFBS+(79*40))
    .byte <(GTIAFBS+(80*40)),<(GTIAFBS+(81*40)),<(GTIAFBS+(82*40)),<(GTIAFBS+(83*40))
    .byte <(GTIAFBS+(84*40)),<(GTIAFBS+(85*40)),<(GTIAFBS+(86*40)),<(GTIAFBS+(87*40))
    .byte <(GTIAFBS+(88*40)),<(GTIAFBS+(89*40)),<(GTIAFBS+(90*40)),<(GTIAFBS+(91*40))
    .byte <(GTIAFBS+(92*40)),<(GTIAFBS+(93*40)),<(GTIAFBS+(94*40)),<(GTIAFBS+(95*40))

    .byte <(GTIAFBS2+(0*40)),<(GTIAFBS2+(1*40)),<(GTIAFBS2+(2*40)),<(GTIAFBS2+(3*40))
    .byte <(GTIAFBS2+(4*40)),<(GTIAFBS2+(5*40)),<(GTIAFBS2+(6*40)),<(GTIAFBS2+(7*40))
    .byte <(GTIAFBS2+(8*40)),<(GTIAFBS2+(9*40)),<(GTIAFBS2+(10*40)),<(GTIAFBS2+(11*40))
    .byte <(GTIAFBS2+(12*40)),<(GTIAFBS2+(13*40)),<(GTIAFBS2+(14*40)),<(GTIAFBS2+(15*40))
    .byte <(GTIAFBS2+(16*40)),<(GTIAFBS2+(17*40)),<(GTIAFBS2+(18*40)),<(GTIAFBS2+(19*40))
    .byte <(GTIAFBS2+(20*40)),<(GTIAFBS2+(21*40)),<(GTIAFBS2+(22*40)),<(GTIAFBS2+(23*40))
    .byte <(GTIAFBS2+(24*40)),<(GTIAFBS2+(25*40)),<(GTIAFBS2+(26*40)),<(GTIAFBS2+(27*40))
    .byte <(GTIAFBS2+(28*40)),<(GTIAFBS2+(29*40)),<(GTIAFBS2+(30*40)),<(GTIAFBS2+(31*40))
    .byte <(GTIAFBS2+(32*40)),<(GTIAFBS2+(33*40)),<(GTIAFBS2+(34*40)),<(GTIAFBS2+(35*40))
    .byte <(GTIAFBS2+(36*40)),<(GTIAFBS2+(37*40)),<(GTIAFBS2+(38*40)),<(GTIAFBS2+(39*40))
    .byte <(GTIAFBS2+(40*40)),<(GTIAFBS2+(41*40)),<(GTIAFBS2+(42*40)),<(GTIAFBS2+(43*40))
    .byte <(GTIAFBS2+(44*40)),<(GTIAFBS2+(45*40)),<(GTIAFBS2+(46*40)),<(GTIAFBS2+(47*40))
    .byte <(GTIAFBS2+(48*40)),<(GTIAFBS2+(49*40)),<(GTIAFBS2+(50*40)),<(GTIAFBS2+(51*40))
    .byte <(GTIAFBS2+(52*40)),<(GTIAFBS2+(53*40)),<(GTIAFBS2+(54*40)),<(GTIAFBS2+(55*40))
    .byte <(GTIAFBS2+(56*40)),<(GTIAFBS2+(57*40)),<(GTIAFBS2+(58*40)),<(GTIAFBS2+(59*40))
    .byte <(GTIAFBS2+(60*40)),<(GTIAFBS2+(61*40)),<(GTIAFBS2+(62*40)),<(GTIAFBS2+(63*40))
    .byte <(GTIAFBS2+(64*40)),<(GTIAFBS2+(65*40)),<(GTIAFBS2+(66*40)),<(GTIAFBS2+(67*40))
    .byte <(GTIAFBS2+(68*40)),<(GTIAFBS2+(69*40)),<(GTIAFBS2+(70*40)),<(GTIAFBS2+(71*40))
    .byte <(GTIAFBS2+(72*40)),<(GTIAFBS2+(73*40)),<(GTIAFBS2+(74*40)),<(GTIAFBS2+(75*40))
    .byte <(GTIAFBS2+(76*40)),<(GTIAFBS2+(77*40)),<(GTIAFBS2+(78*40)),<(GTIAFBS2+(79*40))
    .byte <(GTIAFBS2+(80*40)),<(GTIAFBS2+(81*40)),<(GTIAFBS2+(82*40)),<(GTIAFBS2+(83*40))
    .byte <(GTIAFBS2+(84*40)),<(GTIAFBS2+(85*40)),<(GTIAFBS2+(86*40)),<(GTIAFBS2+(87*40))
    .byte <(GTIAFBS2+(88*40)),<(GTIAFBS2+(89*40)),<(GTIAFBS2+(90*40)),<(GTIAFBS2+(91*40))
    .byte <(GTIAFBS2+(92*40)),<(GTIAFBS2+(93*40)),<(GTIAFBS2+(94*40)),<(GTIAFBS2+(95*40))


PLOT6XVBASEHI:
    .byte >(GTIAFBS+(0*40)),>(GTIAFBS+(1*40)),>(GTIAFBS+(2*40)),>(GTIAFBS+(3*40))
    .byte >(GTIAFBS+(4*40)),>(GTIAFBS+(5*40)),>(GTIAFBS+(6*40)),>(GTIAFBS+(7*40))
    .byte >(GTIAFBS+(8*40)),>(GTIAFBS+(9*40)),>(GTIAFBS+(10*40)),>(GTIAFBS+(11*40))
    .byte >(GTIAFBS+(12*40)),>(GTIAFBS+(13*40)),>(GTIAFBS+(14*40)),>(GTIAFBS+(15*40))
    .byte >(GTIAFBS+(16*40)),>(GTIAFBS+(17*40)),>(GTIAFBS+(18*40)),>(GTIAFBS+(19*40))
    .byte >(GTIAFBS+(20*40)),>(GTIAFBS+(21*40)),>(GTIAFBS+(22*40)),>(GTIAFBS+(23*40))
    .byte >(GTIAFBS+(24*40)),>(GTIAFBS+(25*40)),>(GTIAFBS+(26*40)),>(GTIAFBS+(27*40))
    .byte >(GTIAFBS+(28*40)),>(GTIAFBS+(29*40)),>(GTIAFBS+(30*40)),>(GTIAFBS+(31*40))
    .byte >(GTIAFBS+(32*40)),>(GTIAFBS+(33*40)),>(GTIAFBS+(34*40)),>(GTIAFBS+(35*40))
    .byte >(GTIAFBS+(36*40)),>(GTIAFBS+(37*40)),>(GTIAFBS+(38*40)),>(GTIAFBS+(39*40))
    .byte >(GTIAFBS+(40*40)),>(GTIAFBS+(41*40)),>(GTIAFBS+(42*40)),>(GTIAFBS+(43*40))
    .byte >(GTIAFBS+(44*40)),>(GTIAFBS+(45*40)),>(GTIAFBS+(46*40)),>(GTIAFBS+(47*40))
    .byte >(GTIAFBS+(48*40)),>(GTIAFBS+(49*40)),>(GTIAFBS+(50*40)),>(GTIAFBS+(51*40))
    .byte >(GTIAFBS+(52*40)),>(GTIAFBS+(53*40)),>(GTIAFBS+(54*40)),>(GTIAFBS+(55*40))
    .byte >(GTIAFBS+(56*40)),>(GTIAFBS+(57*40)),>(GTIAFBS+(58*40)),>(GTIAFBS+(59*40))
    .byte >(GTIAFBS+(60*40)),>(GTIAFBS+(61*40)),>(GTIAFBS+(62*40)),>(GTIAFBS+(63*40))
    .byte >(GTIAFBS+(64*40)),>(GTIAFBS+(65*40)),>(GTIAFBS+(66*40)),>(GTIAFBS+(67*40))
    .byte >(GTIAFBS+(68*40)),>(GTIAFBS+(69*40)),>(GTIAFBS+(70*40)),>(GTIAFBS+(71*40))
    .byte >(GTIAFBS+(72*40)),>(GTIAFBS+(73*40)),>(GTIAFBS+(74*40)),>(GTIAFBS+(75*40))
    .byte >(GTIAFBS+(76*40)),>(GTIAFBS+(77*40)),>(GTIAFBS+(78*40)),>(GTIAFBS+(79*40))
    .byte >(GTIAFBS+(80*40)),>(GTIAFBS+(81*40)),>(GTIAFBS+(82*40)),>(GTIAFBS+(83*40))
    .byte >(GTIAFBS+(84*40)),>(GTIAFBS+(85*40)),>(GTIAFBS+(86*40)),>(GTIAFBS+(87*40))
    .byte >(GTIAFBS+(88*40)),>(GTIAFBS+(89*40)),>(GTIAFBS+(90*40)),>(GTIAFBS+(91*40))
    .byte >(GTIAFBS+(92*40)),>(GTIAFBS+(93*40)),>(GTIAFBS+(94*40)),>(GTIAFBS+(95*40))

    .byte >(GTIAFBS2+(0*40)),>(GTIAFBS2+(1*40)),>(GTIAFBS2+(2*40)),>(GTIAFBS2+(3*40))
    .byte >(GTIAFBS2+(4*40)),>(GTIAFBS2+(5*40)),>(GTIAFBS2+(6*40)),>(GTIAFBS2+(7*40))
    .byte >(GTIAFBS2+(8*40)),>(GTIAFBS2+(9*40)),>(GTIAFBS2+(10*40)),>(GTIAFBS2+(11*40))
    .byte >(GTIAFBS2+(12*40)),>(GTIAFBS2+(13*40)),>(GTIAFBS2+(14*40)),>(GTIAFBS2+(15*40))
    .byte >(GTIAFBS2+(16*40)),>(GTIAFBS2+(17*40)),>(GTIAFBS2+(18*40)),>(GTIAFBS2+(19*40))
    .byte >(GTIAFBS2+(20*40)),>(GTIAFBS2+(21*40)),>(GTIAFBS2+(22*40)),>(GTIAFBS2+(23*40))
    .byte >(GTIAFBS2+(24*40)),>(GTIAFBS2+(25*40)),>(GTIAFBS2+(26*40)),>(GTIAFBS2+(27*40))
    .byte >(GTIAFBS2+(28*40)),>(GTIAFBS2+(29*40)),>(GTIAFBS2+(30*40)),>(GTIAFBS2+(31*40))
    .byte >(GTIAFBS2+(32*40)),>(GTIAFBS2+(33*40)),>(GTIAFBS2+(34*40)),>(GTIAFBS2+(35*40))
    .byte >(GTIAFBS2+(36*40)),>(GTIAFBS2+(37*40)),>(GTIAFBS2+(38*40)),>(GTIAFBS2+(39*40))
    .byte >(GTIAFBS2+(40*40)),>(GTIAFBS2+(41*40)),>(GTIAFBS2+(42*40)),>(GTIAFBS2+(43*40))
    .byte >(GTIAFBS2+(44*40)),>(GTIAFBS2+(45*40)),>(GTIAFBS2+(46*40)),>(GTIAFBS2+(47*40))
    .byte >(GTIAFBS2+(48*40)),>(GTIAFBS2+(49*40)),>(GTIAFBS2+(50*40)),>(GTIAFBS2+(51*40))
    .byte >(GTIAFBS2+(52*40)),>(GTIAFBS2+(53*40)),>(GTIAFBS2+(54*40)),>(GTIAFBS2+(55*40))
    .byte >(GTIAFBS2+(56*40)),>(GTIAFBS2+(57*40)),>(GTIAFBS2+(58*40)),>(GTIAFBS2+(59*40))
    .byte >(GTIAFBS2+(60*40)),>(GTIAFBS2+(61*40)),>(GTIAFBS2+(62*40)),>(GTIAFBS2+(63*40))
    .byte >(GTIAFBS2+(64*40)),>(GTIAFBS2+(65*40)),>(GTIAFBS2+(66*40)),>(GTIAFBS2+(67*40))
    .byte >(GTIAFBS2+(68*40)),>(GTIAFBS2+(69*40)),>(GTIAFBS2+(70*40)),>(GTIAFBS2+(71*40))
    .byte >(GTIAFBS2+(72*40)),>(GTIAFBS2+(73*40)),>(GTIAFBS2+(74*40)),>(GTIAFBS2+(75*40))
    .byte >(GTIAFBS2+(76*40)),>(GTIAFBS2+(77*40)),>(GTIAFBS2+(78*40)),>(GTIAFBS2+(79*40))
    .byte >(GTIAFBS2+(80*40)),>(GTIAFBS2+(81*40)),>(GTIAFBS2+(82*40)),>(GTIAFBS2+(83*40))
    .byte >(GTIAFBS2+(84*40)),>(GTIAFBS2+(85*40)),>(GTIAFBS2+(86*40)),>(GTIAFBS2+(87*40))
    .byte >(GTIAFBS2+(88*40)),>(GTIAFBS2+(89*40)),>(GTIAFBS2+(90*40)),>(GTIAFBS2+(91*40))
    .byte >(GTIAFBS2+(92*40)),>(GTIAFBS2+(93*40)),>(GTIAFBS2+(94*40)),>(GTIAFBS2+(95*40))

@ENDIF


CALCPOSG:

@IF !vestigialConfig.screenModeUnique 

    LDA CURRENTMODE
    CMP #8
    BNE CALCPOS8X
    JMP CALCPOS8
CALCPOS8X:
    CMP #9
    BNE CALCPOS9X
    JMP CALCPOS9
CALCPOS9X:
    CMP #10
    BNE CALCPOS10X
    JMP CALCPOS10
CALCPOS10X:
    CMP #11
    BNE CALCPOS11X
    JMP CALCPOS11
CALCPOS11X:
    CMP #12
    BNE CALCPOS12X
    JMP CALCPOS12
CALCPOS12X:
    CMP #13
    BNE CALCPOS13X
    JMP CALCPOS13
CALCPOS13X:
    CMP #14
    BNE CALCPOS14X
    JMP CALCPOS14
CALCPOS14X:
    CMP #15
    BNE CALCPOS15X
    JMP CALCPOS15
CALCPOS15X:
    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 8 ) )

CALCPOS8:

    TXA
    PHA
    
    LDA #2
    STA PATTERN

    LDA MATHPTR6
    ASL A
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    LDA PLOT4VBASELO,Y          ;table of $9C40 row base addresses
    ; ADC PLOT4LO,X              ;+ (4 * Xcell)
    STA PLOTDEST               ;= cell address

    LDA PLOT4VBASEHI,Y          ;do the high byte
    ; ADC PLOT4HI,X
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 9 ) )

CALCPOS9:

    TXA
    PHA
   

    LDA #1
    STA PATTERN

    LDA MATHPTR6
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT4VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT4VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 10 ) )

CALCPOS10:

    TXA
    PHA

    LDA #2
    STA PATTERN

    LDA MATHPTR6
    ASL A
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 11 ) )

CALCPOS11:

    TXA
    PHA
    
    LDA #1
    STA PATTERN

    LDA MATHPTR6
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 12 ) )

CALCPOS12:

    TXA
    PHA
    
    LDA #1
    STA PATTERN

    LDA MATHPTR6
    ; ASL A
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 13 ) )

CALCPOS13:

    TXA
    PHA
    
    LDA #2
    STA PATTERN

    LDA MATHPTR6
    ASL A
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT6VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT6VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 14 ) )

CALCPOS14:

    TXA
    PHA
    
    LDA #0
    STA PATTERN

    LDA MATHPTR6
    ; ASL A
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 15 ) )

CALCPOS15:

    TXA
    PHA
    
    LDA #0
    STA PATTERN

    LDA MATHPTR6
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA MATHPTR7
    CLC
    ; ADC #1
    ASL A
    ASL A
    ASL A
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT6XVBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT6XVBASEHI,Y          ;do the high byte
    STA PLOTDEST+1

    PLA
    TAX

    RTS

@ENDIF

CONSOLECALCULATE:
    LDA YCURSYS
    STA MATHPTR6
    LDA XCURSYS
    STA MATHPTR7
    JSR CALCPOSG
    STX CONSOLESA

    LDA CONSOLEW
    STA CONSOLEWB

    ASL CONSOLEWB
CONSOLECALCULATESKIPD:
    LDA CONSOLEH
    STA CONSOLEHB
    ASL CONSOLEHB
    ASL CONSOLEHB
    ASL CONSOLEHB

    RTS

*= $0801 "Basic Loader" 
        BasicUpstart2(start)

.label SCNKEY  = $FF9F
.label GETIN   = $FFE4
.label CHROUT  = $FFD2

start:

        ldx #25         // x will be the Fibonacci N number
        dex             // decrease x by 2 to compensate for 0 and 1 (plus_1 is 1)
        dex

loop:   

        // add plus1 and plus2 and stores result on fnumber
        LIBMATH_ADD32BIT($c00c,$c00d,$c00e,$c00f,       // plus 1
                $c010,$c011,$c012,$c013,                // plus 2
                $c000,$c001,$c002,$c003)                // fnumber
//        sta fnumber
        ldy #3
!loop_32bit:            // retrieve plus1 and store as plus2
        lda plus_1,y
        sta plus_2,y
        dey
        bne !loop_32bit-

        ldy #3
!loop_32bit:            // retrieve fnumber and store as plus1 for the next cycle
        lda fnumber,y 
        sta plus_1,y
        dey
        bne !loop_32bit-

        dex
        bne loop        // return and do the next N number
        
        ldy #3
printout:               // load the two last bytes of fnumber and 
        lda fnumber+2   // uses ROM routine to convert to decimal
        ldx fnumber+3
        jsr $BDCD

        rts


.macro LIBMATH_ADD32BIT(num1_32, num1_16, num1_8, num1_0, 
                        num2_32, num2_16, num2_8, num2_0, 
                        sum_32, sum_16, sum_8, sum_0) {
        clc
        lda num1_0
        adc num2_0
        sta sum_0
        lda num1_8
        adc num2_8
        sta sum_8
        lda num1_16
        adc num2_16
        sta sum_16
        lda num1_32
        adc num2_32
        sta sum_32      
}


*=$c000
fnumber: .byte 0,0,0,0
sum_1: .byte 0,0,0,0
sum_2: .byte 0,0,0,0
plus_1: .byte 0,0,0,1
plus_2: .byte 0,0,0,0



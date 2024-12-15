<Cabbage>
form caption("Untitled") size(355, 300), guiMode("queue"), pluginId("def1"), colour(255,255,255,255)
keyboard bounds(10, 198, 336, 95)


groupbox bounds(172, 8, 167, 177) channel("groupbox10006") colour(255, 255, 255, 255) text("X:damp Y:stif")

xypad bounds(182, 36, 147, 142) channel("damp", "stif1") rangeX(-5, 0, -0.02) rangeY(0, 5, 0.3)
rslider bounds(18, 30, 60, 60) channel("Mass") range(10, 15, 10, 1, 0.001) text("Mass") textColour(0, 0, 0, 255)
rslider bounds(96, 30, 60, 60) channel("Center") range(0, 1, 0.1, 1, 0.001) text("Center") textColour(0, 0, 0, 255)
rslider bounds(18, 112, 60, 60) channel("Pos") range(0, 1, 0.2, 1, 0.001) text("Pos") textColour(0, 0, 0, 255)
rslider bounds(96, 112, 60, 60) channel("Strength") range(0, 0.1, 0.005, 1, 0.001) text("Strength") textColour(0, 0, 0, 255)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 44100
ksmps = 32
nchnls = 2
;generating all bunch of tables needed
itmp ftgen 1, 0, 128, 7, 0, 64, 1,64, 0
itmp ftgen 2, 0, 128, -7, 1, 128, 1
itmp ftgen 3, 0, 16384, -23, "circularstring.matrix"
itmp ftgen 4, 0, 128,-7 ,0.5 ,128, 0
itmp ftgen 5, 0, 128, -7, 1, 128, 1
itmp ftgen 6, 0, 128, -7, 0, 128, 0
itmp ftgen 7, 0, 128, -7, .001, 128,128
;getting reverb and delay ready
gal init 0
gar init 0
garvbL init 0
garvbR init 0

instr 1
kpan randh 1, 3 ;random panning
kpan port kpan, 0.05 ;make the panning change not so quick
kpitch cpsmidib 12
ipitch cpsmidi
kenvm madsr 0.02, 0.6, 0.2, 1
kenv2 madsr 0.05, 0.6, 0.8, 1
kenv3 madsr 0.8, 0.6, 0.8, 1
kvib lfo 1, 5
ifnvel = 1
ifnmass = 2
ifnstif = 3
ifncentr = 4
ifndamp = 5
kstif1 chnget "stif1"
kstif = kstif1 + 0.1*kvib*kenv3
;kstif = 0.3 + 0.1*kvib*kenv3
kmass1 chnget "Mass"
kmass = kmass1-(5*kenvm) ;modulated mass
;kcentr = 0.1
kcentr chnget "Center"
kdamp chnget "damp"
;kdamp = -0.02
ileft = 0.2
iright = 0.8
;kpos = 0.2
kpos chnget "Pos"
;kstrngth = 0.005
kstrngth chnget "Strength"
;setups for scan synthesis
a2 madsr 0.002, 0.01, 0.001, 0 ;get a initial pick, but seemed like not working 
scanu 1, 0.1,ifnvel, ifnmass,ifnstif,ifncentr, ifndamp,kmass, kstif, kcentr, kdamp, ileft, iright,kpos,kstrngth, a2*0.5, 0.2, 1
a1 scans 200*kenv2, kpitch+kpitch*kvib*kenv3*0.01, 7, 1
a1 dcblock a1
a1	butterlp	a1, kpitch*8
a1	butterlp	a1, kpitch*12
al = a1*kpan
ar = a1*(1-kpan)

al dcblock al
ar dcblock ar

outs al, ar

vincr gal, al
vincr gar, ar
vincr garvbL, al
vincr garvbR, ar
endin

instr 2
abuf delayr 5
adl deltap 0.3
delayw gal + (adl * 0.2)

abuf delayr 5
adr deltap 0.4
delayw gal + (adr * 0.2)
outs adl, adr
clear gal
clear gar
endin

      instr verb
	denorm garvbL, garvbR
aL, aR freeverb garvbL, garvbR, 0.9, 0.4, sr, 0
	outs aL, aR
	clear garvbL, garvbR
	endin 

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
i2 0 3600
i "verb" 0 500000
</CsScore>
</CsoundSynthesizer>

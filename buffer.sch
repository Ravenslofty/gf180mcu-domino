v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {SIZE 1 = 0.30u
SIZE 2 = 0.66u
SIZE 3 = 1.02u
SIZE 4 = 1.41u} 660 -1560 0 0 0.4 0.4 {}
N 380 -1500 380 -1440 {lab=N0}
N 250 -1470 380 -1470 {lab=N0}
N 420 -1470 510 -1470 {lab=Z}
N 420 -1410 420 -1350 {lab=GND}
N 250 -1350 420 -1350 {lab=GND}
N 270 -1380 270 -1350 {lab=GND}
N 250 -1380 270 -1380 {lab=GND}
N 270 -1440 270 -1380 {lab=GND}
N 250 -1440 270 -1440 {lab=GND}
N 250 -1500 270 -1500 {lab=VDD}
N 270 -1530 270 -1500 {lab=VDD}
N 420 -1500 440 -1500 {lab=VDD}
N 440 -1530 440 -1500 {lab=VDD}
N 420 -1530 440 -1530 {lab=VDD}
N 420 -1350 440 -1350 {lab=GND}
N 440 -1440 440 -1350 {lab=GND}
N 420 -1440 440 -1440 {lab=GND}
N 160 -1380 210 -1380 {lab=CLK}
N 160 -1500 160 -1380 {lab=CLK}
N 160 -1500 210 -1500 {lab=CLK}
N 120 -1500 160 -1500 {lab=CLK}
N 340 -1580 340 -1530 {lab=VDD}
N 340 -1350 340 -1300 {lab=GND}
N 250 -1530 270 -1530 {lab=VDD}
N 270 -1530 300 -1530 {lab=VDD}
N 300 -1530 340 -1530 {lab=VDD}
N 340 -1530 420 -1530 {lab=VDD}
N 290 -1500 300 -1500 {lab=VDD}
N 280 -1500 290 -1500 {lab=VDD}
N 280 -1530 280 -1500 {lab=VDD}
N 340 -1500 360 -1500 {lab=Z}
N 360 -1550 360 -1500 {lab=Z}
N 360 -1550 460 -1550 {lab=Z}
N 460 -1550 460 -1470 {lab=Z}
C {symbols/nfet_03v3.sym} 230 -1440 0 0 {name=M1
L=0.28u
W=0.60u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 230 -1380 0 0 {name=M2
L=0.28u
W=0.60u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 230 -1500 0 0 {name=M3
L=0.28u
W=0.30u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 400 -1500 0 0 {name=M4
L=0.28u
W=0.41u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 400 -1440 0 0 {name=M5
L=0.28u
W=0.30u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {ipin.sym} 210 -1440 0 0 {name=p1 lab=A}
C {ipin.sym} 120 -1500 0 0 {name=p2 lab=CLK}
C {ipin.sym} 340 -1580 0 0 {name=p3 lab=VDD}
C {ipin.sym} 340 -1300 0 0 {name=p4 lab=GND}
C {opin.sym} 510 -1470 0 0 {name=p5 lab=Z}
C {lab_pin.sym} 360 -1470 1 0 {name=p6 sig_type=std_logic lab=N0}
C {symbols/pfet_03v3.sym} 320 -1500 0 1 {name=M6
L=0.28u
W=0.30u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}

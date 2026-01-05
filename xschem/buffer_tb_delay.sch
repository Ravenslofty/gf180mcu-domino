v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 800 -850 800 -810 {lab=A}
N 940 -790 940 -740 {lab=GND}
N 500 -740 880 -740 {lab=GND}
N 500 -790 500 -740 {lab=GND}
N 940 -900 940 -850 {lab=#net1}
N 500 -900 880 -900 {lab=#net1}
N 500 -900 500 -850 {lab=#net1}
N 680 -740 680 -720 {lab=GND}
N 940 -740 1240 -740 {lab=GND}
N 1240 -790 1240 -740 {lab=GND}
N 450 -740 500 -740 {lab=GND}
N 450 -750 450 -740 {lab=GND}
N 450 -810 500 -810 {lab=#net2}
N 390 -830 390 -810 {lab=VCLK}
N 390 -750 390 -740 {lab=GND}
N 390 -740 450 -740 {lab=GND}
N 390 -830 500 -830 {lab=VCLK}
N 330 -740 390 -740 {lab=GND}
N 330 -750 330 -740 {lab=GND}
N 330 -900 330 -810 {lab=#net1}
N 330 -900 500 -900 {lab=#net1}
N 840 -810 840 -790 {lab=A}
N 1240 -850 1270 -850 {lab=Z}
N 880 -900 940 -900 {lab=#net1}
N 880 -740 940 -740 {lab=GND}
N 820 -830 820 -800 {lab=CLK}
N 800 -810 880 -810 {lab=A}
N 820 -830 880 -830 {lab=CLK}
N 840 -850 840 -830 {lab=CLK}
N 390 -850 390 -830 {lab=VCLK}
C {buffer.sym} 1090 -820 0 0 {name=x2 WIDTH=1 GAMMA=1.35}
C {gnd.sym} 680 -720 0 0 {name=l1 lab=GND}
C {capa.sym} 1240 -820 0 0 {name=C1
m=1
value=1fF
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 450 -780 0 0 {name=Vput value=3 savecurrent=false}
C {vsource.sym} 390 -780 0 0 {name=Vclk value=3 savecurrent=false}
C {vsource.sym} 330 -780 0 0 {name=V3 value=3.3 savecurrent=false}
C {lab_pin.sym} 840 -790 0 1 {name=p1 sig_type=std_logic lab=A}
C {lab_pin.sym} 1270 -850 0 1 {name=p2 sig_type=std_logic lab=Z}
C {vsource.sym} 910 -810 3 1 {name=VA value=0}
C {code_shown.sym} 330 -670 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss"}
C {netlist.sym} 330 -580 0 0 {name=s1 value=".control
* [[CITE]] High Performance ASIC Design: Using Synthesizable Domino Logic in an ASIC Flow, by Razak Hossain.
let vdd = 3.0v $ 3.0v at ss, 3.3v at typical, 3.6v at ff
let vhi = vdd * 0.8
let vlo = vdd * 0.2
let vtrip_fall = vdd * 0.6
let vtrip_rise = vdd * 0.4
let delay = 400ps
let pulse = 1400ps
let clock_pulse = delay + pulse
let temp = -40 $ -40 at ss, 25 at typical, 125 at ff
let tnom = 25

option temp=$&temp tnom=$&tnom

* 3.5.1 Cell delay and output transition time measurement:
* - Initially, all inputs are kept high.
* - The clock is then forced low.
* - After 400ps, all the data inputs are also driven low.
* - The output of a domino only goes low when the clock falls.
*   The fall delay for the cell is measured from the falling edge of the clock input.
* - To measure the rise delay, the related pins rise with the clock.
*   All other data pins remain off.
*   The PUT rises 200ps later.
* - For rise delay measurement from the clock pin, all relative pins rise at the same time as the clock.
* - The maximum input and clock transition used for characterisation is 150ps.
*   (a 150ps transition from 20% to 80% of Vdd is equivalent to a 250ps 0V to Vdd transition)
* - The maximum cell load used is the maximum capacitance value for the particular drive.
*   The maximum capacitance value is the capacitance load that leads to a 400ps (0 to 100% of Vdd) falling transition for a domino cell.
* - The delay and transition simulations are done for five different output loads and five different input transition times.

* 3.5.2 Input pin capacitance measurement
* - The input pin capacitance is measured by taking the integral of the current of the PUT's driving source and dividing it by Vdd.
*   Current is measured only when the signal is rising, and is recorded for each of the 25 delay measurement runs.
*   The average of all these values is then used.

* find maximum capacitance value for the cell
* => binary search on output capacitance such that trans_fall = 400ps
let c_max = 0.2pF
let c_min = 0pF
let c_out = c_min

let target_time = 400ps
let tolerance = 0.1ps
repeat
  set transition_time = 250ps
  let c_test = \\\\\{(c_max + c_min) / 2\\\\\}
  alter C1 cap = $&c_test
  alter Vclk pulse = [ $&vdd 0.0v 0s $transition_time $transition_time $&clock_pulse 100ns ]
  alter Vclk1 pulse = [ $&vdd 0.0v 0s $transition_time $transition_time $&clock_pulse 100ns ]
  alter Vput pulse = [ $&vdd 0.0v $&delay $transition_time $transition_time $&pulse 100ns ]
  tran 1ps 3ns
  meas tran trans_fall TRIG v(z) VAL=vhi FALL=1 TARG v(z) VAL=vlo FALL=1
  let abs_diff = \\\\\{abs(trans_fall - target_time)\\\\\}
  if abs_diff < tolerance
    let c_out = c_test
    break
  end
  if trans_fall > target_time
    let c_max = c_test
  else
    let c_min = c_test
  end
  reset
  option temp=$&temp tnom=$&tnom
end

echo -n > out.csv

echo output_cap z \\\\\{$&c_out\\\\\} >> out.csv

* characterise rise and fall delay and transition times
foreach capacitance_mul 0.2 0.4 0.6 0.8 1.0
  foreach transition_time 50ps 100ps 150ps 200ps 250ps
* input pin characterisation
    let transition_time = $transition_time
    let cap = c_out * $capacitance_mul
    alter C1 cap = $&cap
    alter Vclk pulse = [ $&vdd 0.0v 0s $&transition_time $&transition_time $&clock_pulse 100ns ]
    alter Vclk1 pulse = [ $&vdd 0.0v 0s $&transition_time $&transition_time $&clock_pulse 100ns ]
    alter Vput pulse = [ $&vdd 0.0v $&delay $&transition_time $&transition_time $&pulse 100ns ]
    tran 1ps 3ns

    meas tran delay_rise TRIG v(a) VAL=vtrip_rise RISE=1 TARG v(z) VAL=vtrip_rise RISE=1
    meas tran trans_fall TRIG v(z) VAL=vhi FALL=1 TARG v(z) VAL=vlo FALL=1
    meas tran trans_rise TRIG v(z) VAL=vlo RISE=1 TARG v(z) VAL=vhi RISE=1
    meas tran rise_start WHEN v(a)=vlo RISE=1
    meas tran rise_stop WHEN v(a)=vhi RISE=1
    meas tran charge INTEG i(VA) FROM=rise_start TO=rise_stop

    let transition_time = $transition_time
    let output_cap = c_out * $capacitance_mul
    let input_cap = charge / (vhi - vlo)

    echo delay_rise a z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&delay_rise\\\\\} >> out.csv
    echo trans_fall a z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&trans_fall\\\\\} >> out.csv
    echo trans_rise a z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&trans_rise\\\\\} >> out.csv
    echo input_cap a \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&input_cap\\\\\} >> out.csv
    reset
    option temp=$&temp tnom=$&tnom

* clock characterisation
    let transition_time = $transition_time
    let cap = c_out * $capacitance_mul
    alter C1 cap = $&cap
    alter Vclk pulse = [ $&vdd 0.0v 0s $&transition_time $&transition_time $&clock_pulse 100ns ]
    alter Vclk1 pulse = [ $&vdd 0.0v 0s $&transition_time $&transition_time $&clock_pulse 100ns ]
    alter Vput pulse = [ $&vdd 0.0v 0s $&transition_time $&transition_time $&clock_pulse 100ns ]
    tran 1ps 3ns
    meas tran delay_fall TRIG v(clk) VAL=vtrip_fall FALL=1 TARG v(z) VAL=vtrip_fall FALL=1
    meas tran delay_rise TRIG v(clk) VAL=vtrip_rise RISE=1 TARG v(z) VAL=vtrip_rise RISE=1
    meas tran trans_fall TRIG v(z) VAL=vhi FALL=1 TARG v(z) VAL=vlo FALL=1
    meas tran trans_rise TRIG v(z) VAL=vlo RISE=1 TARG v(z) VAL=vhi RISE=1
    meas tran rise_start WHEN v(clk)=vlo RISE=1
    meas tran rise_stop WHEN v(clk)=vhi RISE=1
    meas tran charge INTEG i(VCLK_) FROM=rise_start TO=rise_stop

    let transition_time = $transition_time
    let output_cap = c_out * $capacitance_mul
    let input_cap = charge / (vhi - vlo)
    echo delay_fall clk z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&delay_fall\\\\\} >> out.csv
    echo delay_rise clk z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&delay_rise\\\\\} >> out.csv
    echo trans_fall clk z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&trans_fall\\\\\} >> out.csv
    echo trans_rise clk z \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&trans_rise\\\\\} >> out.csv
    echo input_cap clk \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&input_cap\\\\\} >> out.csv

    reset
    option temp=$&temp tnom=$&tnom
  end
end

* 3.5.3 Setup measurement of data input rising relative to the clock falling
* - The setup is defined to occur when the output fall delay decreases by 2.5% compared with the fall delays generated by a very large data setup time.
* - The clock initially goes low.
* - Related pins fall soon after.
* - Related pins and clock then rise simultaneously.
* - After a delay, the pin under test rises just before the clock falls.
* - This delay time when the PUT rises is then varied until the output fall delay is 97.5% of the original fall delay.

* characterise setup rise delay
* => binary search on setup such that pulse_width = delay_fall * 0.975
foreach transition_time 83ps 166ps 250ps
  foreach capacitance_mul 0.33 0.66 1.0
    set setup_max = 2000ps
    set setup_min = 260ps
    repeat 14 $ 0.106ps accuracy
      reset
      option temp=$&temp tnom=$&tnom

      let setup = ($setup_max + $setup_min) / 2.0
      let setup_time = 1400ps + (2000ps - setup)
      let transition_time = $transition_time
      let cap = c_out * $capacitance_mul
      alter C1 cap = $&cap
      alter Vclk pulse = [ $&vdd 0.0v 0s 250ps $&transition_time $&clock_pulse 3800ps ]
      alter Vclk1 pulse = [ $&vdd 0.0v 0s 250ps $&transition_time $&clock_pulse 3800ps ]
      alter Vput pulse = [ $&vdd 0.0v 400ps $&transition_time 250ps $&setup_time 100ns ]

      tran 1ps 5ns

      meas tran delay_fall TRIG v(clk) VAL=vtrip_fall FALL=1 TARG v(z) VAL=vtrip_fall FALL=1
      meas tran pulse_width TRIG v(z) VAL=vtrip_rise RISE=1 TARG v(z) VAL=vtrip_fall FALL=2
      meas tran setup_time TRIG v(a) VAL=vtrip_rise RISE=1 TARG v(clk) VAL=vtrip_fall FALL=2

      let pulse_width_target = delay_fall * 0.975
      let abs_diff = \\\\\{abs(pulse_width_target - pulse_width)\\\\\}
      if abs_diff < tolerance
        break
      end

      if pulse_width > pulse_width_target
        let _setup_max = ($setup_max + $setup_min) / 2.0
        set setup_max = $&_setup_max
      else
        let _setup_min = ($setup_max + $setup_min) / 2.0
        set setup_min = $&_setup_min
      end
    end

    let transition_time = $transition_time
    let output_cap = c_out * $capacitance_mul
    echo setup_rise_vs_clk_fall clk a \\\\\{$&output_cap\\\\\} \\\\\{$&transition_time\\\\\} \\\\\{$&setup_time\\\\\} >> out.csv
  end
end

* 3.5.5 Data pin hold falling measurement
* - The definition of hold time is the time between clock rising (measured at 40% of Vdd) and data input falling (measured at 60% of Vdd) that will cause the evaluation node of the PUT's cell just to drop below 20 mV.
* - The related pins are chosen to cause the longest delay for PUT.
* - The hold check is done using two extreme clock rise times and two extreme data fall times (four data points).
* - Output loading is set to the maximum cell loading to ensure worst-case tolerance.

* => binary search on hold time such that min(x2.n0) < 20mV
foreach clock_transition 12ps 250ps
foreach data_transition 12ps 250ps

set hold_max = 4000ps
set hold_min = 0ps
set hold_out = 4000ps

repeat 15 $ 0.122ps accuracy
  reset
  option temp=$&temp tnom=$&tnom

  let hold_time = ($hold_max + $hold_min) / 2.0
  alter C1 cap = $&c_out
  alter Vclk pulse = [ 0.0v $&vdd 1400ps $clock_transition $clock_transition 1000ps 100ns ]
  alter Vclk1 pulse = [ 0.0v $&vdd 2000ps $clock_transition $clock_transition 100ns 100ns ]
  alter Vput pulse = [ $&vdd 0.0v $&hold_time $data_transition $data_transition 100ns 100ns ]

  tran 1ps 5ns

  meas tran hold_time TRIG v(clk) VAL=vtrip_rise RISE=1 TARG v(a) VAL=vtrip_fall FALL=1
  meas tran n0_voltage_max MAX v(x2.n0) from=0ns
  meas tran n0_voltage_min MIN v(x2.n0) from=0ns

  let n0_voltage_target = 20mv

  if n0_voltage_min < n0_voltage_target
    let _hold_max = ($hold_max + $hold_min) / 2.0
    set hold_max = $&_hold_max
    if hold_time < $hold_out
      set hold_out = $&hold_time
    end
  else
    let _hold_min = ($hold_max + $hold_min) / 2.0
    set hold_min = $&_hold_min
  end
end

let clock_transition = $clock_transition
let data_transition = $data_transition
echo hold_fall_vs_clk_rise clk a \{$&c_out\} \{$&clock_transition\} \{$&data_transition\} \{$hold_out\} >> out.csv

end
end

* 3.5.6 Data pin setup falling [relative to the clock rising] measurement
* - The setup time is defined by measuring the distance between the input and clock pin of the cell so that they intersect at 20% of Vdd.
* - Two input data pin transition values and two values of clock rise transition times (four points) are used to build the setup table.

foreach clock_transition 12ps 250ps
  foreach data_transition 12ps 250ps

  set setup_max = 4000ps
  set setup_min = 0ps
  set setup_out = 1000ps

repeat 15 $ 0.122ps accuracy
  reset
  option temp=$&temp tnom=$&tnom

  let setup_time = ($setup_max + $setup_min) / 2.0
  let transition_time = 250ps
  alter C1 cap = $&c_out
  alter Vclk pulse = [ 0.0v $&vdd 1400ps $clock_transition $clock_transition 1000ps 100ns ]
  alter Vclk1 pulse = [ 0.0v $&vdd $&setup_time $clock_transition $clock_transition 100ns 100ns ]
  alter Vput pulse = [ 0.0v $&vdd 1600ps $data_transition $data_transition 100ns 100ns ]

  print setup_time
  tran 1ps 5ns

  let vdd20 = vdd * 0.2

  meas tran vclk20 WHEN v(clk)=$&vdd20 RISE=1
  meas tran va20 WHEN v(a)=$&vdd20 FALL=1
  meas tran setup_time TRIG v(a) VAL=vtrip_fall FALL=1 TARG v(clk) VAL=vtrip_rise RISE=1

  if vclk20 > va20
    let _setup_max = ($setup_max + $setup_min) / 2.0
    set setup_max = $&_setup_max
  else
    let _setup_min = ($setup_max + $setup_min) / 2.0
    set setup_min = $&_setup_min
  end
end

  let clock_transition = $clock_transition
  let data_transition = $data_transition
  echo setup_fall_vs_clk_rise clk a \{$&c_out\} \{$&clock_transition\} \{$&data_transition\} \{$&setup_time\} >> out.csv
  end
end

* 3.5.7 Minimum clock pulse width for low and high phases
* - For our purposes this check is characterized assuming the maximum clock transitions specified in the library and the maximum output loading for the cell in question.
* - The minimum pulse width checks are performed by initially setting high the data pins that cause the longest evaluation delay.
* - The clock is then forced high.
* - The MPWH is measured from when the clock reaches 40% of Vdd, until when the output of the domino cell reaches 95% of Vdd.
* - MPWL is measured from when the falling clock reaches 60% of Vdd until when the output reaches 5% of Vdd

reset
option temp=$&temp tnom=$&tnom

let setup_time = ($setup_max + $setup_min) / 2.0
let transition_time = 250ps
alter C1 cap = $&c_out
alter Vclk pulse = [ 0.0v $&vdd 400ps 250ps 250ps 2000ps 100ns ]
alter Vclk1 pulse = [ 0.0v $&vdd 650ps 250ps 250ps 1000ps 100ns ]
alter Vput dc = $&vdd

print setup_time
tran 1ps 5ns

let vdd40 = vdd * 0.40
let vdd60 = vdd * 0.60
let vdd95 = vdd * 0.95
let vdd05 = vdd * 0.05

meas tran mpwh TRIG v(clk) VAL=$&vdd40 RISE=1 TARG v(z) VAL=$&vdd95 RISE=1
meas tran mpwl TRIG v(clk) VAL=$&vdd60 FALL=1 TARG v(z) VAL=$&vdd05 FALL=1

echo min_pulse_width_high clk z \{$&mpwh\} >> out.csv
echo min_pulse_width_low clk z \{$&mpwl\} >> out.csv

* 3.5.10 Precharge sizing check
* - The precharge sizing check involves making sure that the internal node of the domino cells reaches at least 90% of Vdd at maximum frequency

foreach clock_transition 12ps 250ps

  reset
  option temp=$&temp tnom=$&tnom

  alter C1 cap = $&c_out
  alter Vclk dc = 0.0v
  alter Vclk1 pulse = [ $&vdd 0.0v 200ps $clock_transition $clock_transition 400ps 100ns ]
  alter Vput dc = 0.0v

  tran 1ps 1ns

  meas tran max_voltage MAX v(x2.n0) from=0ps

  let vdd90 = vdd * 0.9
  let clock_transition = $clock_transition
  let precharge_check = (max_voltage gt vdd90) ? 1 : 0
  echo precharge_check \{$&clock_transition\} \{$&precharge_check\} >> out.csv

end

rusage

exit

.endc"}
C {lab_pin.sym} 840 -850 0 1 {name=p3 sig_type=std_logic lab=CLK}
C {vsource.sym} 910 -830 3 1 {name=Vclk_ value=0}
C {vsource.sym} 820 -770 0 0 {name=Vclk1 value=3 savecurrent=false}
C {lab_pin.sym} 390 -850 0 1 {name=p4 sig_type=std_logic lab=VCLK}
C {buffer.sym} 650 -820 0 0 {name=x1 WIDTH=1 GAMMA=1.35}

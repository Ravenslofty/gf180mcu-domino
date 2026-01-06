namespace eval lofty {
  proc floorplan_cell {cell_height cell_width} {
    if {$cell_height <= 0} {
      return "cell height must be positive"
    }

    if {$cell_height % 2 == 0} {
      return "cell height must be odd"
    }

    if {$cell_width <= 0} {
      return "cell width must be positive"
    }

    if {$cell_width % 2 == 1} {
      return "cell width must be even"
    }

    # prepare
    grid on
    snap on
    grid 0.56um 0.56um
    box 0 0 0 0
  
    # power rails are 0.6um thick.

    # ground rail
    box 0g 0g "${cell_width}g" 0g
    box grow n 0.3um
    box grow s 0.3um
    paint metal1

    # ground rail: p substrate diffusion
    box 0g 0g "${cell_width}g" 0g
    box grow n 0.205um
    box grow s 0.205um
    paint psubdiff

    # ground rail: p substrate diffusion contacts
    for {set i 1} {$i < $cell_width} {incr i 2} {
      box "${i}g" 0g "${i}g" 0g
      box grow n 0.14um
      box grow e 0.14um
      box grow s 0.14um
      box grow w 0.14um
      paint psubdiffcont
    }

    # ground rail: label
    set label_x [expr {$cell_width - 0.5}]
    box "${label_x}g" 0g "${label_x}g" 0g
    label GND e
    port make

    # power rail
    box 0g "${cell_height}g" "${cell_width}g" "${cell_height}g"
    box grow n 0.3um
    box grow s 0.3um
    paint metal1

    # power rail: n substrate diffusion
    box 0g "${cell_height}g" "${cell_width}g" "${cell_height}g"
    box grow n 0.21um
    box grow s 0.21um
    paint nsubdiff

    # power rail: n substrate diffusion contact
    for {set i 1} {$i < $cell_width} {incr i 2} {
      box "${i}g" "${cell_height}g" "${i}g" "${cell_height}g"
      box grow n 0.14um
      box grow e 0.14um
      box grow s 0.14um
      box grow w 0.14um
      paint nsubdiffcont
    } 

    # power rail: label
    box "${label_x}g" "${cell_height}g" "${label_x}g" "${cell_height}g"
    label VDD e
    port make

    # n diffusion
    set ndiff_width_start 1
    set ndiff_width_end [expr {$cell_width - 1}]
    set ndiff_height 2
    box "${ndiff_width_start}g" "${ndiff_height}g" "${ndiff_width_end}g" "${ndiff_height}g"
    box grow n 0.14um
    box grow s 0.14um
    box grow e 0.28um
    box grow w 0.28um
    paint ndiffusion

    # p diffusion
    set pdiff_width_start 1
    set pdiff_width_end [expr {$cell_width - 1}]
    set pdiff_height [expr {$cell_height - 2}]
    box "${pdiff_width_start}g" "${pdiff_height}g" "${pdiff_width_end}g" "${pdiff_height}g"
    box grow n 0.14um
    box grow s 0.14um
    box grow e 0.28um
    box grow w 0.28um
    paint pdiffusion

    # p diffusion: n well
    box grow n 2g
    box grow n 0.43um
    box grow e 0.43um
    box grow s 0.43um
    box grow w 0.43um
    paint nwell

    # cell bounding box
    box 0g 0g "${cell_width}g" "${cell_height}g"
    property FIXED_BBOX [box values]

    # and then fix the viewport
    view
  }

  proc ndcontact {} {
    box grow n 0.14u
    box grow e 0.14u
    box grow s 0.14u
    box grow w 0.14u
    paint ndcontact

    box grow n 0.065u
    box grow e 0.065u
    box grow s 0.065u
    box grow w 0.065u
    paint ndiff
  }

  proc pdcontact {{width 0.28} {length 0.28}} {
    set half_width [expr {$width / 2}]
    set half_length [expr {$length / 2}]

    # width
    box grow n "${half_width}um"
    box grow s "${half_width}um"
    # length
    box grow e "${half_length}um"
    box grow w "${half_length}um"
    paint pdcontact

    # pdiff overlap [CO.4]
    box grow n 0.065u
    box grow e 0.065u
    box grow s 0.065u
    box grow w 0.065u
    paint pdiff

    # nwell overhang [DF.7]
    box grow n 0.43um
    box grow e 0.43um
    box grow s 0.43um
    box grow w 0.43um
    paint nwell
  }

  proc polycontact {} {
    box grow n 0.14u
    box grow e 0.14u
    box grow s 0.14u
    box grow w 0.14u
    paint polycontact

    box grow n 0.065u
    box grow e 0.065u
    box grow s 0.065u
    box grow w 0.065u
    paint poly
  }

  proc nfet {{width 0.28} {length 0.28}} {
    set half_width [expr {$width / 2}]
    set half_length [expr {$length / 2}]
    # nfet width
    box grow n "${half_width}um"
    box grow s "${half_width}um"
    # nfet length
    box grow e "${half_length}um"
    box grow w "${half_length}um"
    pushbox
    # poly overhang [PL.4]
    box grow n 0.22um
    box grow s 0.22um
    paint poly
    # ndiff overhang [DF.7]
    popbox
    box grow e 0.23um
    box grow w 0.23um
    paint ndiff
  }

  proc pfet {{width 0.28} {length 0.28}} {
    set half_width [expr {$width / 2}]
    set half_length [expr {$length / 2}]
    # pfet width
    box grow n "${half_width}um"
    box grow s "${half_width}um"
    # pfet length
    box grow e "${half_length}um"
    box grow w "${half_length}um"
    # poly overhang [PL.4]
    pushbox
    box grow n 0.22um
    box grow s 0.22um
    paint poly
    # pdiff overhang [DF.6]
    popbox
    box grow e 0.23um
    box grow w 0.23um
    paint pdiff
    # nwell overhang [DF.7]
    box grow n 0.43um
    box grow e 0.43um
    box grow s 0.43um
    box grow w 0.43um
    paint nwell
  }

  proc metal1_vertical {} {
    box grow e 0.115u
    box grow w 0.115u
    paint metal1
  }

  proc metal1_horizontal {} {
    box grow n 0.115u
    box grow s 0.115u
    paint metal1
  }

  proc metal1_junction {} {
    box grow n 0.115u
    box grow e 0.115u
    box grow s 0.115u
    box grow w 0.115u
    paint metal1
  }

  proc poly_vertical {} {
    box grow e 0.09u
    box grow w 0.09u
    paint poly
  }

  proc poly_horizontal {} {
    box grow n 0.09u
    box grow s 0.09u
    paint poly
  }

  proc poly_junction {} {
    box grow n 0.09u
    box grow e 0.09u
    box grow s 0.09u
    box grow w 0.09u
    paint poly
  }
}


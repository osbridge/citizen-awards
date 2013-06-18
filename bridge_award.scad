$fn=200;

use <Write.scad>

draw_white = 1;
draw_teal = 1;
draw_blue = 1;

module award_base() {
  difference() {
    color("white") cylinder(h=3, r=50);
    translate([0,0,1]) cylinder(h=3, r=45);
  }
}

module bridge_mark() {
  scale_factor = .2;
  scale_array = [scale_factor, scale_factor, 1];

  color("white") translate([-36.5, 7, 0 ]) {
    scale(scale_array) linear_extrude(height=3) import("Bridge-Mark.dxf");
    translate([14.5, -8, 0 ]) scale(scale_array) linear_extrude(height=3) import("Bridge-Text.dxf");
  }
}

module background() {
  color("black") translate([0,0,1]) cylinder(h=1, r=45);
}

module bar() {
  intersection() {
    color("white") translate([0, -15, 3]) cube([100, 20, 3], center=true);
    cylinder(h=3, r=50);
  }
}

module wedge(offset, angle=22) {
  difference() {
    rotate([0,0,offset]) cube([50,100,1]);
    rotate([0,0,offset-angle]) translate([0,0,-5]) cube([50,100,20]);

  }
}

module award(year) {
  if(draw_white==1) {
    award_base();
    difference() {
      bridge_mark();
      background();
    }
    difference() {
      bar();

      translate([0,-10,0]) {
        write("TRULY OUTSTANDING",font="orbitron.dxf", h=6,t=20, center=true); 
        translate([0, -9, 0]) write("OPEN SOURCE CITIZEN",font="orbitron.dxf", h=6,t=20, center=true); 
      }
      
      background();
    }
    difference() {
      translate([0,-34,1.5]) {
        color("white") write(year,font="orbitron.dxf", h=8,t=3, center=true);
      }
      background();
    }
  }

  if (draw_teal == 1 || draw_blue == 1) {
    difference() {
      intersection() {
        translate([0,-10,1]) {
          if(draw_teal == 1) {
            color("teal")   wedge(99);
            color("teal")    wedge(55);
            color("teal")   wedge(11);
            color("teal")   wedge(-33);
            color("teal")   wedge(-77);
          }
          if(draw_blue == 1) {
            color("DodgerBlue")   wedge(77);
            color("DodgerBlue")    wedge(33);
            color("DodgerBlue")    wedge(-11);
            color("DodgerBlue")    wedge(-55);
          }
        }
        color("black") translate([0,0,-50]) cylinder(h=100, r=45);
      }
      
      translate([0,-31.5,-1]) cube([100,50,20], center=true);
    }

    if (draw_blue == 1) intersection() {
      color("DodgerBlue") translate([0,-31.5,1.5]) cube([100,50,1], center=true);
      color("black") translate([0,0,-50]) cylinder(h=100, r=45);
    }
  }
}

difference() {
  award(year="2013");
  translate([0,43.4,0]) {
    cube([25,3.5,40], center=true);
    translate([25/2,0,0]) cylinder(h=40, r=3.5/2, center=true);
    translate([-25/2,0,0]) cylinder(h=40, r=3.5/2, center=true);
  }
}

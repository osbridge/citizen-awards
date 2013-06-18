$fn=200;

use <Write.scad>

color1 = "white";
color2 = "teal";
color3 = "DodgerBlue";

draw_color1 = 1;
draw_color2 = 1;
draw_color3 = 1;

module back_and_sides() {
  difference() {
    cylinder(h=3, r=50);
    translate([0,0,1]) cylinder(h=3, r=45);
  }
}

module background_area() {
  translate([0,0,1]) cylinder(h=1, r=45);
}

module bridge_mark() {
  scale_factor = .2;
  scale_array = [scale_factor, scale_factor, 1];

  translate([-36.5, 7, 0 ]) {
    difference() {
      union() {
        scale(scale_array) linear_extrude(height=3) import("Bridge-Mark.dxf");
        translate([14.5, -8, 0 ]) scale(scale_array) linear_extrude(height=3) import("Bridge-Text.dxf");
      }
    }
  }
}

module cross_bar_text() {
  write("TRULY OUTSTANDING",font="orbitron.dxf", h=6,t=20, center=true); 
  translate([0, -9, 0]) write("OPEN SOURCE CITIZEN",font="orbitron.dxf", h=6,t=20, center=true); 
}

module cross_bar() {
  difference() {
    intersection() {
      color("white") translate([0, -15, 3]) cube([100, 20, 3], center=true);
      cylinder(h=3, r=50);
    }

    translate([0,-10,0]) cross_bar_text();
  }
}

module wedge(offset, angle=22) {
  difference() {
    rotate([0,0,offset]) cube([50,100,1]);
    rotate([0,0,offset-angle]) translate([0,0,-5]) cube([50,100,20]);
  }
}

module year_label(year) {
  translate([0,-34,1.5]) {
    write(year,font="orbitron.dxf", h=8,t=3, center=true);
  }
}

module ribbon_hole() {
  translate([0,43.4,0]) {
    cube([25,3.5,40], center=true);
    translate([25/2,0,0]) cylinder(h=40, r=3.5/2, center=true);
    translate([-25/2,0,0]) cylinder(h=40, r=3.5/2, center=true);
  }
}

module award_base_and_text(year) {
  difference() {
    union() {
      back_and_sides();
      bridge_mark();
      cross_bar();
      year_label(year);
    }
    background_area();
  }
}

module background1() {
  difference() {
    intersection() {
      translate([0,-10,1]) for (o = [99, 55, 11, -33, -77]) wedge(o);
      translate([0,0,-50]) cylinder(h=100, r=45);
    }
    translate([0,-31.5,-1]) cube([100,50,20], center=true);
  }
}

module background2() {
  intersection() {
    union() {
      translate([0,-10,1]) for (o = [77, 33, -11, -55]) wedge(o);
      translate([0,-31.5,1.5]) cube([100,50,1], center=true);
    }
    translate([0,0,-50]) cylinder(h=100, r=45);
  }
}

module award(year) {
  difference() {
    union() {
      if(draw_color1==1) color(color1) award_base_and_text(year);
      if(draw_color2==1) color(color2) background1();
      if(draw_color3==1) color(color3) background2();
    }
    ribbon_hole();
  }
}

award(year="2013");

$fn=200;

color1 = "white";
color2 = "teal";
color3 = "DodgerBlue";

draw_color1 = 1;
draw_color2 = 1;
draw_color3 = 1;

// Font "din_black.dxf" converted using http://www.thingiverse.com/thing:96714

module letter(l,font="din_black.dxf",t=100,i=0, offset=0) {
  translate([offset, 0, 0]) linear_extrude(height=t) import(font, layer=l);
}

module word(wrd,font="din_black.dxf",t=100,i=0,offset=0) {
    if(wrd[i] != " ") {
      letter(wrd[i],font,t,i,offset);
    }
    if(i+1 < len(wrd)) {
      if(wrd[i] == " ") {
        word(wrd,font,t,i+1, dxf_dim(file=font, name="advx",layer="i") + offset);
      } else {
        word(wrd,font,t,i+1, dxf_dim(file=font, name="advx",layer=wrd[i]) + offset);
      }
    }
}

module back_and_sides() {
  difference() {
    cylinder(h=5, r=50);
    translate([0,0,1]) cylinder(h=6, r=45);
  }
}

module background_area() {
  translate([0,0,1]) cylinder(h=1, r=45);
}

module bridge_mark() {
  scale_factor = .224;
  scale_array = [scale_factor, scale_factor, 1];

  translate([-40.5, 4, 0 ]) {
    difference() {
      union() {
        scale(scale_array) linear_extrude(height=5) import("Bridge-Mark.dxf");
        translate([16.5, -7.5, 0 ]) scale(scale_array) linear_extrude(height=5) import("Bridge-Text.dxf");
      }
    }
  }
}

module cross_bar_text() {
  text_scale = 0.0018;
  translate([0, 0, -9]) scale([text_scale, text_scale, 1]) word("TRULY OUTSTANDING", t=20);
  translate([-1.5, -8, -9]) scale([text_scale, text_scale, 1]) word("OPEN SOURCE CITIZEN", t=20);
}

module cross_bar() {
  difference() {
    intersection() {
      color("white") translate([0, -15, 5]) cube([100, 20, 5], center=true);
      cylinder(h=5, r=50);
    }

    translate([-37.5,-13,0]) cross_bar_text();
  }
}

module wedge(offset, angle=22) {
  difference() {
    rotate([0,0,offset]) cube([50,100,1]);
    rotate([0,0,offset-angle]) translate([0,0,-5]) cube([50,100,20]);
  }
}

module year_label(year) {
  translate([-11,-37,2]) {
    scale([0.0025, 0.0025, 1]) word("2013", t=3);
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

scale([1.125, 1.125, 1]) award(year="2013");

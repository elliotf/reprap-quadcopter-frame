da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

module accurate_hole(diam, height, sides=6) {
  r = diam * 1 / cos(180 / sides) / 2;

  cylinder(r=r,h=height,center=true,$fn=sides);
}

left = -1;
right = 1;
front = -1;
rear = 1;
top = 1;
bottom = -1;

wall_thickness = 1.5;
wall_height    = 8;

motor_diam = 6;
motor_height = 18;

rotor_dist = 75;
rotor_diam = 50;

battery_width = 10;
board_width = 12;
board_length = 18;
board_thickness = 2;

module main() {
  for(mirrored=[0,1]) {
    mirror([mirrored,0,0]) {
      for(a=[1,3]) {
        rotate([0,0,a*90+45]) arm();
      }
    }
  }

  translate([0,0,wall_height/2]) {
    % cube([board_width,board_length,2],center=true);
  }
}

module arm() {
  brace_dist = motor_diam/2+wall_thickness/2;
  brace_thickness = 1;
  angled_len = sqrt(pow(brace_dist*2, 2)*2);
  num_braces = (rotor_dist/2 - motor_diam/2) / (brace_dist*2);
  num_brace_remain = num_braces - floor(num_braces);

  module body() {
    translate([0,rotor_dist/2,0])
      rotate([0,0,11.25])
        accurate_hole(motor_diam+wall_thickness*2,wall_height,16);

    for(side=[left,right]) {
      translate([brace_dist*side,rotor_dist/4,0])
        cube([wall_thickness,rotor_dist/2,wall_height],center=true);
    }


    for(y=[1:floor(num_braces)]) {
      translate([0,y*brace_dist*2+brace_dist*num_brace_remain/2,0])
        rotate([0,0,45*(1-floor(y%2)*2)])
          cube([brace_thickness,angled_len,wall_height],center=true);
    }
  }

  module holes() {
    translate([0,rotor_dist/2,0])
      cylinder(r=motor_diam/2,h=wall_height+1,center=true);
  }

  difference() {
    body();
    holes();
  }
}

main();
//arm();

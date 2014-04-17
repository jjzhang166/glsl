// Edited so that the camera follows the "car" 
// Left hand drive cos I'm Australian

// recolor by @fernozzle

#ifdef GL_ES
precision mediump float;
#endif

#define BLUR 0.4

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float speed = 5.0;
float lift = 0.5;
float shift = 0.0;
float wobbly (float x) {
    return sin(x/1.5)/1.3 + sin(x/2.)/1.5 + sin(x/3.)/6. + sin(x/10.0)*5.;
}
float blur (float x, float flt) {
	flt *= 0.25;
	x = fract (x);
	if (x < flt) {
		x = x / flt * 0.25;
	} else if (x < 0.5 - flt) {
		x = 0.25;
	} else if (x < 0.5 + flt) {
		x = (x - 0.5) / flt * 0.25 + 0.5;
	} else if (x < 1.0 - flt) {
		x = 0.75;
	} else {
		x = (x - 1.0) / flt * 0.25 + 1.0;
	}
	return sin (x * 6.28318530718) * 0.5 + 0.5;
}

void main(void) {
    vec2 position = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
    vec2 p= position;
    p.y -= shift;            // shift camera down
    p.y *= lift;            // lift camera up
    float t = speed*time;
    
    p.y += sin(p.x*2.+time*0.4)*0.01;
    p.y += sin(p.x*4.-time*0.9)*0.01;
    p.y += sin(p.x*20.-time*1.)*0.002;
    p.y += pow (p.x, 2.) * 0.1;
	
    vec3 skycolor = mix(vec3(2.0, 1.7, 1.0), vec3(0.1, 0.1, 0.2), pow(distance(p, vec2(0.0)), 0.5)*0.9);
    vec3 col;            // pixel color
    if(p.y > 0.0) {
       col = skycolor;
    } else {
        // perspective transformation:
        float u = -1.2+p.x/p.y;
        float v = 0.1/p.y;
        v -= t;                // move road in time
        
        float road_u = wobbly(v);        // generate a wobbly road line
        float road_width = 1.5;
        
        // point of car:
        float car_v = -0.5/((1.0+shift)*lift);
        car_v -= t;
        float car_u = wobbly(car_v);
        // center about car:
        u += car_u + 2.;            // magic number: 1.2 for center, 2 is offset for left lane
        
        col = vec3(0.0, 0.05*cos(v*2.)+0.9, 0.0); // grass
        bool road;
        if(u >= road_u-road_width-0.1 && u <= road_u+road_width+0.1) { 
	    col = mix (vec3(1.), vec3(1., 0., 0.), blur (v, BLUR));
	    road = true;
        }
        if(u >= road_u-road_width && u <= road_u+road_width) {
              col = vec3(0.3);        // road
	    road = true;
        }
        if (u >= road_u-0.01 && u <= road_u+0.025) {
		col = mix (col, vec3(1.0, 0.8, 0.), blur (v, BLUR)); 
        }
        col = col * vec3(0.15, 0.17, 0.3);
        // blend to sky
	float powmult = road ? 1.3: 1.;
        col.r = mix(skycolor.r, col.r, pow(min(1., -p.y*12.),1.*powmult));
        col.g = mix(skycolor.g, col.g, pow(min(1., -p.y*6.),0.4*powmult));
        col.b = mix(skycolor.b, col.b, pow(min(1., -p.y*5.),0.4*powmult));
    }
    float vig = pow(length(p), 2.) * 0.1;
    col -= vec3(vig);
    gl_FragColor = vec4(col, 1.0);
}

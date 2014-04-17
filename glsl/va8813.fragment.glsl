// Edited so that the camera follows the "car" 
// Left hand drive cos I'm Australian

#ifdef GL_ES
precision mediump float;
#endif

// Have fun:
#define TRIP_OUT

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float speed = 5.0;
float lift = 0.5;
float shift = 0.0;
float wobbly (float x) {
    return sin(x/1.5)/1.3 + sin(x/2.)/1.5 + sin(x/3.)/6. + sin(x/10.0)*5.;
}

void main(void) {
    vec3 skycolor = vec3(0.3, 0.6, 1.0);
    vec2 position = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
    vec2 p= position;
    p.y -= shift;			// shift camera down
    p.y *= lift;			// lift camera up
    float t = speed*time;
    
    // perspective transformation:
    float u = -1.2+p.x/p.y;
    float v = 0.5/p.y;
    v -= t;				// move road in time
    
    float road_u = wobbly(v);		// generate a wobbly road line
    float road_width = 1.5;
    
    // point of car:
    float car_v = -0.5/((1.0+shift)*lift);
    car_v -= t;
    float car_u = wobbly(car_v);
    // center about car:
    u += car_u + 2.;			// magic number: 1.2 for center, 2 is offset for left lane
    
    vec3 col;			// pixel color
    
    col = vec3(0.0, 0.1*cos(v)+0.9, 0.0); // grass
    
    if(u >= road_u-road_width-0.1 && u <= road_u+road_width+0.1) { 
        if(mod(v, 0.4) >= 0.2) {
	          col = vec3(1.);	    // white stripes
        } else {
	          col = vec3(1., 0., 0.); // red stripes
        }
    }
    if(u >= road_u-road_width && u <= road_u+road_width) {
	      col = vec3(0.3);		// road
    }
    if (u >= road_u-0.01 && u <= road_u+0.025) {
	if(mod(v, 1.) >= 0.5) {
	      col = vec3(1.0, 0.8, 0.); // yellow dashes
        }
    }
    col = mix(skycolor, col, min(1., -p.y*50.));	// blend to sky
    if(p.y > 0.0) {
       col = skycolor;
    }
#ifdef TRIP_OUT
    col *= vec3(0.6+0.4*sin(t/10.), 0.6+0.4*cos(t/5.), 0.6+0.4*sin(-t/20.));
#endif
    gl_FragColor = vec4(col, 1.0);
}

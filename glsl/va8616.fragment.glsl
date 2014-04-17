
// idea from Lou's pseudo 3d page http://www.gorenfeld.net/lou/pseudo/
// Expanded ternary ifs and improved readability

precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float wobbly (float x) {
    return  sin(x)/2. + sin(x/2.)*1.5 + sin(x*3.)/6.;
}

void main(void) {
    vec3 skycolor = vec3(0.3, 0.6, 1.0);
    vec2 position = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
    vec2 p= position;
    p.y *= .4;		// lift camera up

    vec2 uv = vec2(-1.2+p.x/p.y, 0.5/p.y);	// perspective transformation
    float t = time;
    uv.y -= t;			// move road in time

    vec3 col;			// pixel color
    float road_x = wobbly(uv.y);		// generate a wobbly road line
    float road_width = 1.5;
    
    if(mod(uv.y, 2.) >= 1.) {
        col = vec3(0., 0.8, 0.);	// light green grass
    } else {
	col = vec3(0., 0.65, 0.); // dark green grass
    }
    if(uv.x >= road_x-road_width-0.1 && uv.x <= road_x+road_width+0.1) { 
        if(mod(uv.y, 0.4) >= 0.2) {
	    col = vec3(1.);	    // white stripes
        } else {
	    col = vec3(1., 0., 0.); // red stripes
        }
    }
    if(uv.x >= road_x-road_width && uv.x <= road_x+road_width) {
	col = vec3(0.3);		// road
    }
    if (uv.x >= road_x-0.01 && uv.x <= road_x+0.025 && mod(uv.y, 1.) >= 0.5) {
	col = vec3(1.0, 0.8, 0.); // yellow dashes
    }
    col = mix(skycolor, col, min(1., -p.y*10.));	// blend to sky
    if(position.y > 0.0) {
       col = skycolor;
    }
    gl_FragColor = vec4(col, 1.0);
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
vec4 sky_color = vec4(0.0,0.4,0.6,1.0);


float day_cycle(float t) {
    return 0.8-0.2*sin(t*2.0);
}

float random(vec2 seed){
    return fract(sin(dot(seed.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 draw_star(vec2 pos, float size, float shine_size, int num_blades,  float fade, float shine) {
    vec2 position = resolution*pos;
    vec2 diff = gl_FragCoord.xy - position;
    float blade = clamp(pow(sin(atan(diff.x, diff.y)*float(num_blades)), 7.0), 0.0, 1.0);
    float dist = length(diff);
    float val = size /(30.0*pow(dist, fade));
    float shine_val = shine_size /(30.0*pow(dist, shine));
    return val*vec4(1.0) + shine_val*vec4(1., 1., 1., 1.0)*min(0.5, blade);
}

void main( void ) {
    
    float t = 13.;//time/2.0;
    vec4 color = sky_color*(0.5+0.5*sin(t/3.0));

//    color += draw_star(vec2(0.5, 1.0*sin(t/3.0)), 8.0, 0.7*day_cycle(-t)*resolution.x, day_cycle(t), 9.5, 1.2);
    //color += draw_star(vec2(0.5, 1.0*sin(t/3.0)), 5.1*resolution.x, 0.25, 6., 1.0, 1.2);
    for(float i = 1.; i < 50.; i ++) {
	float x = random(vec2(i, 3.*i));
	float y = random(vec2(3.0*i+6., 5.+i));
	float s = random(vec2(i/4.+1., 1.+i/8.));
	float b = random(vec2(i/5.+5., 3.+i));
        color += draw_star(vec2(x, y), 0.1*s*resolution.x, 1.0*s*resolution.x, int(3.*b+4.), 3.0, 3.0);
    }

    gl_FragColor = vec4(color);
}
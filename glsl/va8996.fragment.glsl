// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float day_cycle(float t) {
    return sin(t*2.0);
}

void main( void ) {

    float t = time;

    float size = (0.8-0.2*day_cycle(t))*resolution.x;

    vec2 position = resolution / 2.0;
    position.x += sin(time)*resolution.x/3.0;
    position.y += cos(time)*resolution.y/3.0;

    float dist = length(gl_FragCoord.xy - position);
    float val = size /(abs(sin(time*13.0)*3.0+17.0)*pow(dist, 0.75));

    vec3 color = vec3(0.0, 0.4, 0.5);
    color += vec3(val, val*(0.8+0.2*day_cycle(t)), val*(0.8+0.2*day_cycle(t)));
	
    vec3 vignette = vec3(0.0, 0.0, 0.0);
    float l = sin(gl_FragCoord.x*abs(cos(sin(time))*0.1+.1)+time*abs(cos(sin(time*0.002)*4.0)*15.0));
    vignette += vec3(l*abs(cos(time*7.1*gl_FragCoord.y)), l*abs(cos(time*3.0)), l*abs(cos(time*2.71)));

    vec3 final_color = mix(color, vignette, 0.5);
    final_color *= mod(gl_FragCoord.x, 2.0);
    gl_FragColor = vec4(final_color, 1.0);
}
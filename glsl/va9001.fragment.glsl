// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float day_cycle(float t) {
    return sin(t*57.3);
}

void main( void ) {

    float t = time;

    float size = (0.9-0.2*day_cycle(t))*resolution.x;

    vec2 position = resolution / 2.0;
    position.x += sin(time*sin(time*2.1))*sin(cos(time*1.4))*sin(time*3.1)*6.0;
    position.y += 0.0;

    float dist = length(gl_FragCoord.xy - position);

    float val = size /(5.0*pow(dist, 0.75));

    vec3 color = vec3(1.0, 0.4, 0.5);
    color += vec3(val, val*(0.8+0.2*day_cycle(t)), 4.9*val*(0.8+0.2*day_cycle(t)));
	
    vec3 vignette = vec3(0.0, 0.0, 0.0);
    float l = sin(gl_FragCoord.y*abs(cos(sin(time))*0.01+.1205)+time*1.9);
    vignette += vec3(l*abs(cos(time*37.1*gl_FragCoord.y)), l*abs(cos(time*6.0)), l*abs(cos(time*51.71)));

    vec3 final_color = mix(color, vignette, 0.5);
    final_color *= mod(gl_FragCoord.y, 2.0);
    final_color = final_color*0.035;
    gl_FragColor = vec4(final_color, 1.0);
}
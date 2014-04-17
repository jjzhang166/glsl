// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float t = time;
    
    vec2 position = resolution / 2.0;
    position.x += sin(time*1.2)*resolution.x/3.0;
    position.y += cos(time*1.1)*resolution.y/3.0;
        
    float xsize = resolution.x-(cos(sin(time*1.04))*resolution.x*5.0-resolution.x);
    float ysize = resolution.y-(cos(sin(time*1.09))*resolution.y*5.0-resolution.y);
    float distx = length(gl_FragCoord.x - position.x);
    float disty = length(gl_FragCoord.y - position.y);
    
    vec3 color = vec3(abs(cos(time*2.1)), 0.0, 0.0);
    float valx = xsize / (abs(sin(time)*10.0+5.0)*pow(distx, 0.911));
    float valy = ysize / (abs(cos(time)*10.0+5.0)*pow(disty, 0.911));
    color += vec3(valx*valy, valy, valx);
    color = clamp(vec3(10.0), vec3(0.0), color);
    color = mix(color, vec3(0.0, 0.4, 0.0), 0.90);
    color = vec3(color.r+color.g+color.b)/abs(sin(time)*5.1+6.0);
    color *= mod(gl_FragCoord.y, 2.0);
    gl_FragColor = vec4(color, 1.0);
}
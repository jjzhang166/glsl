#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 colour = vec4(vec3(0.2, 0.5, 0.9), 1.0);
vec4 white = vec4(vec3(1.0, 1.0, 1.0),1.0);
float lightness = 10.0; //doesn't really work


void main(void){
       vec2 position = (gl_FragCoord.xy/resolution.xy)*2.0 - 1.0 + (mouse*2.0 - 1.0)/4.0;
       float dist = distance(vec2(0.0, 0.0), position.xy);
       float t = time * 10.0;
       float color = 0.0;
       color += dist;
       color -= sin(dist);
       color += cos(dist);
       gl_FragColor = vec4(vec3(color*(sin(time)+0.9)*lightness, cos(color*t)*lightness, sin(color*t)*lightness), 1.0);
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 white = vec4(vec3(1.0, 1.0, 1.0),1.0);
void main(void){
       vec2 position = (gl_FragCoord.xy/resolution.xy)*2.0 - 1.0;
       float dist = sqrt(pow(position.x, 2.0)+pow(position.y, 2.0));
       gl_FragColor = white - sin(dist*time);
}
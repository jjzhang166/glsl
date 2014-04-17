#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 col = vec3(0.0,rand(position),0.0);

	gl_FragColor = vec4( col, 1.0 );

}
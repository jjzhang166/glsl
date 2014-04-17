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
	vec2 pos = vec2(position.x - mod(position.x, 6.0/resolution.x), position.y - mod(position.y, 6.0/resolution.y));
	vec3 col = vec3(0.15,rand(pos)/4.0+0.5,0.0);

	gl_FragColor = vec4( col, 1.0 );

}
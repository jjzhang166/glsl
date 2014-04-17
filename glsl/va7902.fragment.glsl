#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	
	float c = sin(uv.y * 3.131592 * 10.0 * sin(time*5.0)*10.0);

	gl_FragColor = vec4( c*255.0, c*255.0, c*0.0, 1.0 );

}
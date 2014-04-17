#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float kzo = 4.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 col1;
	if(mod(gl_FragCoord.x,kzo) < 1.0)col1=vec4(1.0,1.0,1.0,1.0);
	else col1 = vec4(0.0,0.0,0.0,1.0);
	if(mod(gl_FragCoord.y,kzo) < 1.0)col1=vec4(1.0,1.0,1.0,1.0);

	

	gl_FragColor = col1;

}
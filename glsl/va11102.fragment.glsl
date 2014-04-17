#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float mx = min(resolution.x,resolution.y);
	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5)  / mx ) + mouse * 0.1;

	float x = 2.5*(position.x);
	float y = 2.5*(position.y);
	float z = sin(time);
	float ex = 8.0;

	float d = pow(x,ex)+pow(y,ex)+pow(z,ex);
	vec3 dr = vec3( pow(x,ex-1.0), pow(y,ex-1.0), pow(z,ex-1.0) );
	dr = normalize(dr);
	
	float color = 0.0;
	if( d < 1.0 )
		color = 1.0;
	gl_FragColor = vec4( color, dr.xy, 1.0 );

}
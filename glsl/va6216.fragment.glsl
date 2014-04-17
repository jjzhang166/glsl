#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float randA(vec2 co){
    return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5);
}

float randB(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//note: try all resolutions, different structures become apparent
void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x += mod(time,10.0) * 0.1;
	float r;
	vec2 co = floor(position*resolution);
	if(position.y>.5)
		r = randA(co);
	else
		r = randB(0.1*co);
	gl_FragColor = vec4(r, r, r, 1.0);
	
	if ( abs(gl_FragCoord.y/resolution.y-0.5)<0.01 )
		gl_FragColor = vec4( 1, 1, 1, 1 );
}
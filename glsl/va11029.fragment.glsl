#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random( vec2 co )
{
    return fract(tan(dot(co.xy ,vec2(114.9898,74.233))) * 34.114);
}

void main( void )
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float r1 = random(vec2(random(gl_FragCoord.xy)/time, random(gl_FragCoord.xy)/time));
	float r2 = random(vec2(random(gl_FragCoord.xy)/time, random(gl_FragCoord.xy)/time));
	//r2 = r1/r2;
	
	float dist = distance(position.xy, vec2(r1, r2));
	gl_FragColor = vec4( vec3( mouse.x, mouse.y, dist ), 1.0 );
}
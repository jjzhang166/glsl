#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = acos(0.0);
float COS1_DIV_SIN1 = cos(1.0)/sin(1.0);

float cone(float x, float y)
{ 
	return sqrt(x*x+y*y)*COS1_DIV_SIN1; 
}

float conewave(float x, float y, float count)
{
	return sin(count*2.0*PI*cone(x-0.5, y-0.5)+time*1.0);
}

void main( void ) {

	float scale = min(resolution.y, resolution.x);
	vec2 position = ( gl_FragCoord.xy / scale ) - (mouse*vec2(1.1/*!!!*/, 1.0) - vec2(0.5, 0.5))*4.0;
	
	float color = 0.0;
	color += conewave( position.x+0.15, position.y, 220.0 );
	color += conewave( position.x-0.15, position.y, 220.0 );
	color = color / 2.0 + 1.0;
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	//gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}
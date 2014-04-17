#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


struct ray
{ float origin;
 float destination;
};


vec2 opU( vec2 d1, vec2 d2 )
{
	return (d1.x<d2.x) ? d1 : d2;
}

float sdPlane( vec3 p )
{
	return p.y+0.2;
}

float sdSphere( vec3 p, float s )
{
    return length(p)-s;
}

vec2 map( in vec3 pos )
{
	
	float r = sdSphere(pos, 0.1);
		
    	vec2 res = opU( vec2( sdPlane(     pos), 1.0 ), vec2(r, (abs(pos.y) * 200.0 + 700.0)));
	
    	return res;
}
	
	


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );


	gl_FragColor = vec4(0.3,0.3,0.3,1.0);

}
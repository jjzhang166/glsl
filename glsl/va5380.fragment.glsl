#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere( in vec3 ro, in vec3 rd)
{
	float r = 1.0;
	float b = 2.0*dot( ro, rd );
	float c = dot(ro, ro) - r*r;
	float h = b*b - 4.0*c;
	
	if( h < 0.0 ) return -1.0;
	
	float t = (-b - sqrt(h))/2.0;
	return t;
	     
	
}


float intersect( in vec3 ro, in vec3 rd )
{
	float t = iSphere( ro, rd ); // intersect with a sphere
	return t;
}

void main( void ) {
	
	vec2 uv = gl_FragCoord.xy/resolution * 2.0 - 1.0;
	uv.x *= resolution.x / resolution.y;
	// we generate a ray with origin ro and direction rd
	vec3 ro = vec3( 0.0, 0.0, 2.);
	vec3 rd = normalize( vec3( uv, -1.0) );
	
	// we intersect the ray with the 3d ray
	float id = intersect( ro, rd );
	
	// we draw black, by default
	vec3 col = vec3( 0.0 );
	if( id>0.0 )
	{
		// if we hit something, we draw white
		col = vec3( 1.0);
	}
	
	gl_FragColor = vec4( col, 1.0 );

}
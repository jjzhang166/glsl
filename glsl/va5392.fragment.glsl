#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere( in vec3 ro, in vec3 rd, in vec4 sph)
{
	vec3 oc = ro - sph.xyz;
	float b = 2.0*dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w;
	float h = b*b - 4.0*c;
	
	if( h < 0.0 ) return -1.0;
	
	float t = (-b - sqrt(h))/2.0;
	return t;
}

vec3 nSphere( in vec3 pos, in vec4 sph )
{
	return ( pos-sph.xyz)/sph.w;
}

float iPlane( in vec3 ro, in vec3 rd)
{
	return -ro.y/rd.y;
}

vec3 nPlane( in vec3 pos )
{
	return vec3(0.0, 1.0, 0.0);
}


vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0);
float intersect( in vec3 ro, in vec3 rd, out float resT )
{
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere ( ro, rd, sph1); // intersect with a sphere
	float tpla = iPlane ( ro, rd); // intersect with a plane
	if( tsph > 0.0 )
	{
		id = 1.0;
		resT = tsph;
	}
	if ( tpla > 0.0 && tpla < resT )
	{
		id = 2.0;
		resT = tpla;
	}
	
	return id;
}

void main( void ) {
	
	vec2 uv = (gl_FragCoord.xy/resolution);
	vec3 lightp = vec3(3.0 * sin(time), 3.0, 2.0 * cos(time)); //"hardcoded" light
	// we generate a ray with origin ro and direction rd
	vec3 ro = vec3(0.0, 0.5, 3.0);
	vec3 rd = normalize( vec3( -1.0+2.0*uv  * vec2(1.55, 1.0), -1.0) );
	
	// we intersect the ray with the 3d ray
	float t;
	float id = intersect( ro, rd, t );
	
	// we draw black, by default
	vec3 col = mix(vec3(0.0, 0.5, 1.0), vec3(0.4, 0.5, 1.0), uv.y + 0.5);
	if( id>0.5 && id < 1.5 )
	{
		// if we hit a sphere
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		vec3 lightTo = normalize(lightp - pos);
		
		col = vec3(0.3,0.6, 0.7) * max(0.0, dot(nor, lightTo));
	}
	else if ( id > 1.5 )
	{
		// we hit the plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		vec3 lightTo = normalize(lightp - pos);
		col = vec3(0.7,0.2, 0.1) * max(0.0, dot(nor, lightTo));
	}
	
	gl_FragColor = vec4( col, 1.0 );

}
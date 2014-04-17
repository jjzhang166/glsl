// writing a basic raytracer by Iñigo Quilez 
// http://www.youtube.com/watch?v=9g8CdctxmeU
// tutorial steps are followed by @erucipe
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0);

// lets write a small raytracer from scratch
float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	// so, a sphere cenetered at the origin has equation |xyz| = r
	// meaning, |xyz|^2 = r^2, meaning <xyz,xyz> = r^2
	// now, xyz = ro + t + rd, therefore |ro|^2 + t^2 + 2<ro,rd>t - r^2 = 0
	// which is a quardrating equation, so
	vec3 oc = ro - sph.xyz;
	float b = 2.0 * dot( oc, rd );
	float c = dot( oc, oc ) - sph.w * sph.w;
	float h = b * b - 4.0 * c;
	if(h < 0.0 ) return -1.0;
	float t = (-b - sqrt( h ) ) / 2.0;
	return t;
}

vec3 nSphere( in vec3 pos, in vec4 sph ) {
	return ( pos - sph.xyz ) / sph.w;
}

float iPlane( in vec3 ro, in vec3 rd ) {
	// equation of a plane, y = 0 = ro.y + t * rd.y
	return -ro.y / rd.y;
}

vec3 nPlane( in vec3 pos ) {
	return vec3( 0.0, 1.0, 0.0 );
}

float intersect ( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); // intersect with a sphere
	float tpla = iPlane( ro, rd ); // intersect with a plane
	if( tsph > 0.0 ) {
		id = 1.0;
		resT = tsph;
	}
	if( tpla > 0.0 && tpla < resT ) {
		id = 2.0;
		resT = tpla;
	}
	return id;
}

void main( void ) {
	vec3 light = normalize( vec3(0.57703) );
	// uv are the pixel coordinates, from 0 to 1
	vec2 uv = (gl_FragCoord.xy / resolution);
	
	// let's move that sphere...
	sph1.x = 0.5 * cos( time );
	sph1.z = 0.5 * sin( time );
	
	
	// we generate a ray with origin ro and direction rd
	vec3 ro = vec3( 0.0, 0.5, 3.0 );
	vec3 rd = normalize( vec3( ( -1.0 + 2.0 * uv ) * vec2( resolution.x / resolution.y, 1.0 ), -1.0 ) );
	
	// we need to do some lighting
	// and for that we need normals...
	vec3 col = vec3(0.7);
	
	// we intersect the ray with the 3d scene
	float t;
	float id = intersect( ro, rd, t );
	if( id > 0.5 && id < 1.5 ) {
		// we hit the sphere
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0 );
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3( 0.9, 0.8, 0.6 ) * dif * ao + vec3( 0.1, 0.2, 0.4 ) * ao;
	}
	else if( id > 1.5 ) {
		// we hit the plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot( nor, light ), 0.0, 1.0 );
		float amb = smoothstep( 0.0, 2.0 * sph1.w, length( pos.xz - sph1.xz ) );
		col = vec3( amb * 0.7 );
	}
	col = sqrt(col);
	
	gl_FragColor = vec4(col, 1.0);

}
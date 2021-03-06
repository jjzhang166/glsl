/*
 * Following iQ live coding tutorial on writing a basic raytracer
 * http://www.youtube.com/watch?v=9g8CdctxmeU
 *
 * @blurspline
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float rand(vec2 co){  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	vec3 oc = ro - sph.xyz; // looks like we are going place sphere from an offset from ray origin, which is = camera
	float r = 0.5;
	float b = 2.0*dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w; // w should be size
	float h = b*b - 4.0 *c;
	if (h<0.0 ) return -1.0;
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}

vec3 nSphere( in vec3 pos, in vec4 sph ) {
	return ( pos / rand(pos.xy) - sph.xyz )/ sph.w;
}

float iPlane( in vec3 ro, in vec3 rd ) {
	return -ro.y / rd.y;
}

vec3 nPlane( in vec3 pos ) {
	return vec3 (0.0, 1.0, 0.0);
}


vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0);

float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 + rand(rd.xy) / 100. ); 
	float tpla = iPlane( ro, rd ); // intersect with a plane
	
	if ( tsph>0.0 ) {
		id = 1.0;
		resT = tsph;
	}
	
	if (tpla > 0.0 && tpla <resT ) {
		id = 2.0;
		resT = tpla;
	}
		
	return id;
}


void main( void ) {
	vec3 light = normalize( vec3(0.5773) );
	// ok, here we come, GLSL raytacing!
	// this is the pixel coords
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );  // alrihgT! :)
	
	// move sphere
	sph1.x = 0.5 * cos( time );
	sph1.z = 0.5 * sin( time );
	
	// generate a ray with 
	vec3 ro = vec3( 0.0, 0.5, 3.0 );
	vec3 rd = normalize( vec3( -1.0 + 2.0*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	
	
	// we intersect ray with 3d scene
	float t;
	float id = intersect( ro, rd, t );
	
	vec3 col = vec3(0.65); // wow, pretty nice!! :)
	
	if ( id>0.5 && id<1.5 ) {
		// sphere
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0); // diffuse light
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3( 0.9, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	} else if ( id>1.5 ) {
		// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		col = vec3 (amb * 0.7);
	}
		
	col = sqrt(col);
	
	gl_FragColor = vec4( col, 1.0 );

}
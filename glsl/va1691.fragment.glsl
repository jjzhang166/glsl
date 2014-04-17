/* Following iQ live coding tutorial on writing a basic raytracer http://www.youtube.com/watch?v=9g8CdctxmeU @blurspline */
precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0);
vec3 debug = vec3(0.0,0.0,0.0); // made a panel at footer for figuring this stuff out. What should newbies read to understand all this? tips?
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
float iPlane( in vec3 ro, in vec3 rd ) { return -ro.y / rd.y; }
vec3 nSphere( in vec3 pos, in vec4 sph ) { return ( pos - sph.xyz )/ sph.w; }
vec3 nPlane( in vec3 pos ) { return vec3 (0.0, 1.0, 0.0); }
float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tplane = iPlane( ro, rd ); // intersect with a plane	
	if ( tsph>0.0 ) {
		id = 1.0;
		resT = tsph;
	}
	if (tplane > 0.0 && tplane <resT ) {
		id = 2.0;
		resT = tplane;
	}
	return id;
}
void main( void ) {
	vec3 light = normalize( vec3(0.5773) );
	sph1.x = 1. * cos( time );
	sph1.z = 0.8 * sin( time );
	vec3 rayorigin = vec3( 0.0, 0.5, 3.0 );
	vec3 raydest = normalize( vec3( -1.0 + 2.0* ( gl_FragCoord.xy/resolution.xy ) * vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	float t;
	float id = intersect( rayorigin, raydest, t ); // t is 'resT' from intersect's 'out'.
	vec3 col = vec3(.45); // mix(vec3(0.4, 1.0, 0.0), vec3(.65), .8); 
	if (t > .85) { debug.g = 1.0;} // so seems t doesn't time vary.
        debug.b = id / 4.;
        if ( id>0.5 && id<1.5 ) {  // sphere		
		vec3 pos = rayorigin + t * raydest;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0); // diffuse light
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3( 0.9, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	} else if ( id>1.5 ) { 	// plane
		vec3 pos = rayorigin + t * raydest;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		col = mix(vec3 (amb * 0.7), vec3(1.), .2);
	}	
	col = sqrt(col);
	if ((gl_FragCoord.y) < 100. ) { gl_FragColor = vec4( debug, 1.0 ); } else { gl_FragColor = vec4( col, 1.0 ); }	
}
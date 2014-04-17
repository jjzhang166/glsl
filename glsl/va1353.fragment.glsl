/*
 * Following iQ live coding tutorial on writing a basic raytracer
 * http://www.youtube.com/watch?v=9g8CdctxmeU
 *
 * @blurspline
 * added more shit= @gtoledo3
 */

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	vec3 oc = ro - sph.xyz; // looks like we are going place sphere from an offset from ray origin, which is = camera
	float r = 1.0;
	float b = 2.0*dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w; // w should be size
	float h = b*b - 4.0 *c;
	if (h<0.0 ) return -1.0;
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}

vec3 nSphere( in vec3 pos, in vec4 sph ) {
	return ( pos - sph.xyz )/ sph.w;
}

vec3 lSphere( in vec3 pos, in vec4 sph ) {
	vec3 right = normalize(vec3(sin(-time), 0, cos(-time)));
	vec3 fwd = normalize(cross(right, vec3(0.0, 1.0, 0.0)));
	
	mat4 world = mat4(
		right.x,	right.y,	right.z,	0.0,
		0.0,		1.0,		0.0,		0.0,
		fwd.x,		fwd.y,		fwd.z,		0.0,
		0.0,		0.0,		0.0,		1.0);
	vec3 q = vec3(cos(-time * 5.0), sin(-time * 5.0), 0.0);
	vec4 r = (world * vec4(q.x, q.y, q.z, 1.0));
	float fv = acos(dot(nSphere(pos, sph), r.xyz / r.w));
	if(mod(fv, 0.7) > 0.35)
		return vec3( 0.9, 0.8, 0.6);
	return vec3(0.2, 0.2, 0.2);
	//return vec3( 0.9, 0.8, 0.6);	
}

float iPlane( in vec3 ro, in vec3 rd ) {
	return -ro.y / rd.y;
}

vec3 nPlane( in vec3 pos ) {
	return vec3 (0.0, 1.0, 0.0);
}



vec4 sph1 = vec4( 0.7, .5, 0.0, .5);
vec4 sph2 = vec4( 0.8, .5, 0.4, .3);
vec4 sph3 = vec4( 0.5, .5, 0.2, .4);

float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tsph2 = iSphere( ro, rd, sph2 ); 
	float tsph3 = iSphere( ro, rd, sph3 ); 
	float tpla = iPlane( ro, rd ); // intersect with a plane


	if ( tsph>0.0 ) {
		id = 1.0;
		resT = tsph;
	}

	// ok, started adding another sphere, ... 
	if ( tsph2>0.0 && tsph2 < resT ) {
		id = 1.333;
		resT = tsph2;
	}
	
	if ( tsph3>0.0 && tsph3 < resT ) {
		id = 1.4;
		resT = tsph3;
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
	sph1.x = cos( time * 2.2 )+.2;
	sph1.z = -sin( time * 2.5 ) -.3;
	
	
	// and another
	
	sph2.x =  ( 1.1 * cos( time * 1.0 )) +.1;
	sph2.z = (3. * sin( time)) + .2 ;
	
	sph3.x =  ( 3.9 * cos( time * 1.0 )) +.5;
	sph3.y =  ( .2 * cos( time * 3.0 )) +.6;
	sph3.z = fract(2. * sin( time)) - 1.2 ;//<fract makes the jump stutter._gt
	
	
	// generate a ray with 
	vec3 ro = vec3( 0.0, 0.5, 3.0 );
	vec3 rd = normalize( vec3( -1.0 + 2.0*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	
	
	// we intersect ray with 3d scene
	float t;
	float id = intersect( ro, rd, t );
	
	vec3 col = vec3(0.65); // wow, pretty nice!! :)
	
	if ( id>0.5 && id<1.50 ) {
		// sphere
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.2, 1.0); // diffuse light
		vec3 lmb = lSphere(pos, sph1);	// lambda
		float ao = 0.5 + 0.5 * nor.y;
		col = lmb * dif * ao + vec3(0.05, 0.1, 0.2) * ao;

		if (id == 1.333) { 
		
			/// messing around, ... how to control ordering/depth here? 
			vec3 pos = ro + t * rd;
			vec3 nor2 = nSphere( pos, sph2 );
			float dif = clamp( dot( nor2, light ), 0.2, 1.0); // diffuse light
			vec3 lmb = lSphere(pos, sph2);	// lambda
			float ao = 0.5 + 0.5 * nor2.y;
			col = lmb * dif * ao + vec3(0.05, 0.5, 0.4) * ao;
//			col.rb = vec2(0.2,0.2);
//			col.g = .3;
		}
	
		
		if (id == 1.4) { 
		
			vec3 pos = ro + t * rd;
			vec3 nor3 = nSphere( pos, sph3 );
			float dif = clamp( dot( nor3, light ), 0.2, 1.0); // diffuse light
			vec3 lmb = lSphere(pos, sph3);	// lambda
			float ao = 0.5 + 0.5 * nor3.y;
			col = lmb * dif * ao + vec3(0.9, 0.1, 0.2) * ao;	
		}
	
	} else if (  id ==2.0  ) {
		// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		amb *= smoothstep( 0.0, sph2.w * 2.0, length(pos.xz - sph2.xz) );
		amb *= smoothstep( 0.0, sph3.w * 2.0, length(pos.xz - sph3.xz) );
		col = vec3 (amb * 0.3);
	}
	
	col = sqrt(col);
	
	gl_FragColor = vec4( col, 1.0 );

}
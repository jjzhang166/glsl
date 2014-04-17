/*
 * Following iQ live coding tutorial on writing a basic raytracer
 * http://www.youtube.com/watch?v=9g8CdctxmeU
 *
 * @blurspline
 */

#ifdef GL_ES
precision mediump float;
#endif

float bspeed = 0.5;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float atm1 = 3.2;
const float atm2 = 2.5;

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
//thinking about changing shape, redundant now. _gt
float iSphere2( in vec3 ro, in vec3 rd, in vec4 sph ) {
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
	vec3 right = normalize(vec3(sin(-time * bspeed), 0, cos(-time * bspeed)));
	vec3 fwd = normalize(cross(right, vec3(0.0, 1.0, 0.0)));
	
	mat4 world = mat4(
		right.x,	right.y,	right.z,	0.0,
		0.0,		1.0,		0.0,		0.0,
		fwd.x,		fwd.y,		fwd.z,		0.0,
		0.0,		0.0,		0.0,		1.0);
	vec3 q = vec3(cos(-time  * bspeed), sin(-time  * bspeed), 0.0);
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

float iPlane2( in vec3 ro, in vec3 rd ) {
	return -(ro.y - 0.8) / rd.y;
}

vec3 nH2(in vec2 pos)
{
	float height = 0.0;
	
	
	
	return vec3(pos.x, height, pos.y);	
}

vec3 nPlane2( in vec3 pos ) {
	float dist = distance(vec2(pos.x, pos.z), vec2(cos(time * bspeed), sin(time * bspeed)));
	vec2 p = pos.xz;
	vec3 h0 = nH2(p), h1 = nH2(p + vec2(0.01, 0.0)), h2 = nH2(p + vec2(0.0, 0.01));
	
	vec3 ripple = normalize(cross(h0 - h1, h0 - h2));
	return normalize(ripple
			-
			normalize(vec3(pos.x - cos(time * bspeed), 0.0, pos.z - sin(time * bspeed))) 
			 * max(3.0 - dist, 0.0)* max(3.0 - dist, 0.0)* max(3.0 - dist, 0.0) * 0.03 * sin(dist * 10.0 - time * 6.0));
}




vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0);
vec4 sph2 = vec4( 0.0, 1.0, 0.0, 1.0);
vec3 light1 = vec3(4.0, 4.0, 5.0);
vec3 light2 = vec3(-2.0, 3.0, 4.0);

float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tsph2 = iSphere2( ro, rd, sph2 ); 
	float tpla = iPlane( ro, rd ); // intersect with a plane
	float twtr = iPlane2( ro, rd );
	
	if ( tsph>0.0 ) {
		id = 1.0;
		resT = tsph;
	}
	
	if ( tsph2>0.0 ) {
		id = 1.4;
		resT = tsph2;
	}
	
	if (tpla > 0.0 && tpla <resT ) {
		id = 2.0;
		resT = tpla;
	}
	
	if (twtr > 0.0 && twtr <resT ) {
		id = 3.0;
		resT = twtr;
	}
	
	return id;
}

float intersect2( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tsph2 = iSphere2( ro, rd, sph2 ); 
	float tpla = iPlane( ro, rd ); // intersect with a plane
	
	if ( tsph>0.0 ) {
		id = 1.0;
		resT = tsph;
	}
	
	if ( tsph2>0.0 ) {
		id = 1.4;
		resT = tsph2;
	}
	
	if (tpla > 0.0 && tpla <resT ) {
		id = 2.0;
		resT = tpla;
	}
	

	return id;
}

vec3 lerp(vec3 a, vec3 b, float c)
{
	return a + (b - a) * c;	
}

vec3 raytrace2(vec3 ro, vec3 rd)
{
	float t;
	float id = intersect2( ro, rd, t );
	
	float h = pow(2.5 - (acos(dot(vec3(0.0, 1.0, 0.0), rd)) + clamp(pow(clamp(dot(normalize(vec3(0.6, 0.0, -1.0)), rd), 0.0, 1.0),3.0) * 0.3 - 0.2, 0.0, 1.0)), 1.0);
	
	vec3 col = lerp(vec3(0.4, 0.55, 0.63), vec3(0.0, 0.05, 0.17), clamp(rd.y * 1.4, 0.0, 1.0)); // wow, pretty nice!! :)

	col += (pow(clamp(atm1 - h * atm2, 0.0, 2.5), 3.0) + pow(clamp(atm1 -h *  atm2, 0.0, 1.0), 2.0) * vec3(1.0, 1.0, 0.0)) * 0.3;
	
	if (id>0.5 && id<1.3 ) {
		// sphere
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light1 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += clamp( dot( nor, light2 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += 0.2;
		vec3 lmb = lSphere(pos, sph1);	// lambda
		float ao = 0.5 + 0.5 * nor.y;
		float spec = dot(reflect(rd, nor), normalize(pos - light1));
		spec = max(spec, 0.0);
		col = lmb * dif * ao + vec3(0.05, 0.1, 0.2) * ao + spec * vec3(1.0);
	}
	

	if ( id==1.4 ) {
		// sphere. id controls draw order. _gt
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph2 );
		float dif = clamp( dot( nor, light1 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += clamp( dot( nor, light2 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += 0.2;
		vec3 lmb = lSphere(pos, sph2);	// lambda
		float ao = 0.5 + 0.5 * nor.y;
		float spec = dot(reflect(rd, nor), normalize(pos - light1));
		spec = max(spec, 0.0);
		col = lmb * dif * ao + vec3(0.5, 0.1, 0.2) * ao + spec * vec3(1.0);
	}
	
	else if ( id>1.5 ) {
		// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float st = iSphere(pos, normalize(light1 - pos), sph1);
		st *= iSphere2(pos, normalize(light1 - pos), sph2);
		float shd =  st < -0.5 ? 0.4 : min(st * 0.1, 0.4);
		st = iSphere(pos, normalize(light2 - pos), sph1);
		st *= iSphere2(pos, normalize(light2 - pos), sph2);
		shd += st < -0.5 ? 0.4 : min(st * 0.1, 0.4);
		//shd += max(max(iSphere(pos, normalize(light2 - pos), sph1), 0.0), 0.0);
		//shd = pow(shd, 3.5);
		//shd *= shd;
		//float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		amb *= smoothstep( 0.0, sph2.w * 2.0, length(pos.xz - sph2.xz) ); // shadows under the sphere
		//col = vec3 (amb * 0.7);
		col =  vec3(amb * 0.4 + shd * 0.4);
	}	
	return col;
}


vec3 raytrace(vec3 ro, vec3 rd)
{
	float t;
	float id = intersect( ro, rd, t );
	float h = pow(2.5 - (acos(dot(vec3(0.0, 1.0, 0.0), rd)) + clamp(pow(clamp(dot(normalize(vec3(0.6, 0.0, -1.0)), rd), 0.0, 1.0),3.0) * 0.3 - 0.2, 0.0, 1.0)), 1.0);
	vec3 col = lerp(vec3(0.4, 0.55, 0.63), vec3(0.0, 0.05, 0.17), clamp(rd.y * 1.4, 0.0, 1.0)); // wow, pretty nice!! :)

	col += (pow(clamp(atm1 - h * atm2, 0.0, 2.5), 3.0) + pow(clamp(atm1 -h *  atm2, 0.0, 1.0), 2.0) * vec3(1.0, 1.0, 0.0)) * 0.3;
	
	if (id>0.5 && id<1.3 ) {
		// sphere
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light1 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += clamp( dot( nor, light2 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += 0.2;
		vec3 lmb = lSphere(pos, sph1);	// lambda
		float ao = 0.5 + 0.5 * nor.y;
		vec3 ref = raytrace2(pos, reflect(rd, nor));
		col = lerp(lmb * dif * ao + vec3(0.05, 0.1, 0.2) * ao, ref, (1.0 - dot(-rd, nor)) * 0.8);
		
	} 
	if ( id==1.4 ) {
		// sphere
		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph2 );
		float dif = clamp( dot( nor, light1 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += clamp( dot( nor, light2 ), 0.0, 1.0) * 0.8; // diffuse light
		dif += 0.2;
		vec3 lmb = lSphere(pos, sph2);	// lambda
		float ao = 0.5 + 0.5 * nor.y;
		vec3 ref = raytrace2(pos, reflect(rd, nor));
		col = lerp(lmb * dif * ao + vec3(0.5, 0.1, 0.2) * ao, ref, (1.0 - dot(-rd, nor)) * 0.8);
		
	}
	else if ( id > 1.5 && id<2.5 ) {
		// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float shd = iSphere(pos, normalize(light1 - pos), sph1) > 0.0 ? 0.0 : 0.1;
		shd *= iSphere2(pos, normalize(light1 - pos), sph2) > 0.0 ? 0.0 : 0.1;
		shd += iSphere(pos, normalize(light2 - pos), sph1) > 0.0 ? 0.0 : 0.1;
		shd *= iSphere2(pos, normalize(light2 - pos), sph2) > 0.0 ? 0.0 : 0.1;
		//float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) + 0.1 ); // shadows under the sphere
		amb = smoothstep( 0.0, sph2.w * 2.0, length(pos.xz - sph2.xz) + 0.1 ); // shadows under the sphere
		//col = vec3 (amb * 0.7);
		col = lerp(raytrace2(pos, reflect(vec3(rd.x, rd.y, rd.z), nPlane(pos))), vec3(amb * 0.7 + shd), dot(rd, vec3(0.0, -1.0, 0.0)) * 0.6 + 0.4);
	}	
	else if( id > 2.5) 
	{
		// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane2( pos );
		/*float shd = iSphere(pos, normalize(light1 - pos + nor * 0.2), sph1) > 0.0 ? 0.0 : 0.1;
		shd += iSphere(pos, normalize(light2 - pos + nor * 0.2), sph1) > 0.0 ? 0.0 : 0.1;*/
		//float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		amb *= smoothstep( 0.0, sph2.w * 2.0, length(pos.xz - sph2.xz) ); // shadows under the sphere
		//col = vec3 (amb * 0.7);
		col = lerp(lerp(raytrace2(pos, reflect(vec3(rd.x, rd.y, rd.z), nor)), raytrace2(pos, reflect(vec3(rd.x, -rd.y * 2.0, rd.z), nor)), 0.), vec3(0.05, 0.1, 0.3) * amb, 0.2);
		
	}
	return col;
}

void main( void ) {
	
	// ok, here we come, GLSL raytacing!
	// this is the pixel coords
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );  // alrihgT! :)
	
	// move sphere
	sph1.x = 1.0 * cos( time * bspeed );
	sph1.z = 1.0 * sin( time * bspeed );
	
	sph2.x = 5.0 * cos( time * bspeed )+7.2;
	sph2.y = 1.0 * cos( time * bspeed )+3.2;
	sph2.z = 2.0 * sin( time * bspeed )-5.3;
	// generate a ray with 
	vec3 ro = vec3( mouse.x, mouse.y + 2.0, 4.0 );
	vec3 rd = normalize( vec3( -1.0 + 2.0*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	
	
	// we intersect ray with 3d scene
	vec3 col = raytrace(ro, rd);

	gl_FragColor = vec4( col, 1.0 );

}
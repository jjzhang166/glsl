#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

#define PI 3.14159265358979
#define TWOPI 6.28318530717958
#define PI_2 1.57079632679489661

const float dMax = 32.0;

float sBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

float sSphere( vec3 p, float r ) {
	return length(p) - r;	
}

float sCylinder( vec3 p, vec3 c )
{
  return length(p.xz-c.xy)-c.z;
}

float sTorus( vec3 p, vec2 r) {
	vec2 q = vec2( length(p.xz)-r.x, p.y );
	return length(q) - r.y;
}

float opUnion( float d1, float d2 ){
    return min(d1,d2);
}

float opInt(float obj1, float obj2) {
	return max(obj1, obj2);	
}

float opBlend( float obj1, float obj2, float k ) {
	float a = smoothstep(-k, k, obj1 - obj2);
	return mix(obj1, obj2, a);			
}	

vec4 quaternion ( vec3 axis, float angle ) {
	angle *= 0.5;
	float sinAngle = sin(angle);
	return vec4(axis.x * sinAngle,
		    axis.y * sinAngle,
		    axis.z * sinAngle,
		    cos(angle));
}

vec3 rotate (vec3 p, vec4 q ) {
	vec3 temp = cross(q.xyz, p) + q.w * p;
	return cross(temp, -q.xyz) + dot(q.xyz, p) * q.xyz + q.w * temp;	
}

vec2 map ( vec3 p ) {
	
	float dMin = dMax; // nearest intersection
	float d; // distance to next object
	float mID = -1.0; // material ID
	
	
	d = sBox(p + vec3(0.0, 3.0, 0.0), vec3(20.0, 1.0, 20.0));
	if(d<dMin) {
		dMin = d;
		mID = 0.0;
	}
	
	d = sBox(p + vec3(-0.5, 2.0, 0.5), vec3(1.0, 1.0, 1.0));
	if(d<dMin) {
		dMin = d;
		mID = 1.0;
	}
	
	d = opBlend(d, sSphere(p + vec3(-1.5, 1.0, 1.5), 0.8), 0.9);
	if(d<dMin) {
		dMin = d;
		mID = 1.0;
	}
	
	// blended object
	vec4 quat; vec3 p2;
	
	quat = quaternion(vec3(0.0, 1.0, 0.0), mod(0.5 * time, TWOPI));
	p += 0.5 * sin(0.5*time);
	p = rotate(p, quat);
	
	
	d = sTorus(p, vec2(1.0, 0.08));
	
	quat = quaternion(vec3(1.0, 0.0, 0.0), PI_2);
	p2 = rotate(p, quat);
	
	d = opBlend(d, 
		    opInt(sCylinder(p2, vec3(0.0, 0.0, .05)), 
			  sBox(p2, vec3(1., 1., 1.))),
		    0.01);
	
	quat = quaternion(vec3(0.0, 0.0, 1.0), PI_2);
	p2 = rotate(p, quat);
	
	d = opBlend(d, 
		    opInt(sCylinder(p2, vec3(0.0, 0.0, .05)), 
			  sBox(p2, vec3(1., 1., 1.))),
		    0.01);
	
	d = opBlend(d, 
		    sSphere(p, 0.3),
		    0.05);

	if (d<dMin) { 
		dMin = d;
		mID = 1.;
	}
	
	return vec2(dMin, mID);
}

vec2 castRay( vec3 ro, vec3 rd) {
	const float p = 0.001; // precision
	float t = 0.0; // distance
	float h = p * 2.0; // step size
	float m = -1.0;
	for (int i=0; i<64; i++) {
		if (abs(h)>p || t<dMax ) {
			t += h; // next step
			vec2 res = map(ro + rd*t); // get nearest intersection
			h = res.x; // get distance
			m = res.y; // get material
		} 
		else break;
	}
	if (t>dMax) m = -1.0; // if we found no interstion, material ID is -1.0;
	return vec2(t, m);
}

vec3 calcNormal( vec3 p ) {
	const vec3 eps = vec3(0.001, 0.0, 0.0);
	return normalize( vec3(map(p+eps.xyy).x - map(p-eps.xyy).x,
			       map(p+eps.yxy).x - map(p-eps.yxy).x,
			       map(p+eps.yyx).x - map(p-eps.yyx).x) );
}

float shadow ( vec3 ro, vec3 rd, float tMin, float tMax, float k ) {
	float res = 1.0; // result
	float t = tMin; // step
	float d;
	for (int i=0; i<64; i++) {
		if (t<tMax) {
			d = map(ro+rd*t).x; // get nearest intersection
			res = min(res, k*d/t); 
			t += clamp(d, 0.04, 0.1); // next step
		}
		else break;
	}
	return clamp(res, 0.0, 1.0);
}

vec3 render( vec3 ro, vec3 rd ) {
	vec3 color = vec3(0.0);
	vec2 res = castRay(ro, rd);
	
	// mat -1 = nothing
	if (res.y < -0.5 ) { return color; }
	
	vec3 pos = ro + rd*res.x;
	vec3 nor = calcNormal(pos);
	vec3 lPos = normalize( vec3(-0.5, 0.5, 0.5) ); // light position
	
	// mat 0 = floor
	if (res.y > -0.5 && res.y < 0.5) {
		float lAmb = clamp( 0.5 + 0.5 * nor.y, 0.0, 1.0); // ambient
		float lDif = clamp( dot( nor, lPos ), 0.0, 1.0); // diffuse
		lDif *= shadow( pos, lPos, 0.02, 32.0, 50.0); // shadow
		
		color += vec3(0.2, 0.2, 0.5);
		color += (0.2 * lAmb) * vec3(0.5, 0.5, 0.5);
		color += (1.2 * lDif) * vec3(0.5, 0.5, 0.5);
	}
	
	// mat1 = primitive
	if (res.y > 0.5 ) { 
		
		float lAmb = clamp( 0.5 + 0.5 * nor.y, 0.0, 1.0); // ambient
		float lDif = clamp( dot( nor, lPos ), 0.0, 1.0); // diffuse
		lDif *= shadow( pos, lPos, 0.02, 32.0, 32.0); // shadow

		color += vec3(0.1, 0.1, 0.1);
		color += 0.2 * lAmb * vec3(0.5, 0.5, 0.5);
		color += 1.2 * lDif * vec3(1.0, 0.9, 0.7);
	}
		
	return color;
}

void main( void ) {

	vec2 pos = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0; // bound screen coords to [0, 1]
	pos.x *= resolution.x / resolution.y; // correct for aspect ratio
	
	// camera
	const vec3 cUp = vec3(0., 1., 0.); // up 
	vec3 cLook = vec3(0.0); // lookAt
	//float x = 4.*cos(0.1*time);
	//float y = 2.;//*sin(0.33*time);
	//float z = 4. *sin(0.1*time);
	vec3 cPos = vec3(3.0, 2.0, 5.0); // position
	
	// camera matrix
	vec3 ww = normalize( cLook-cPos ); // lookAt - position
	vec3 uu = normalize( cross(ww, cUp) );
	vec3 vv = normalize( cross(uu, ww) );
	
	vec3 rd = normalize( pos.x*uu + pos.y*vv + 2.0*ww );
	
	// render
	vec3 color = render(cPos, rd);
	

	gl_FragColor = vec4( color, 0.0 );

}
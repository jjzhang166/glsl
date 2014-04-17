#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265359;
const float PI_H = 3.14159265359 / 2.0;
const float PI_2 = 3.14159265359 * 2.0;

struct Ray {
	vec3 origin;
	vec3 direction;
};

float length8(vec2 p) {
	p *= p; p *= p; p *= p; 
	return pow(p.x + p.y, 1.0 / 8.0);
}

float sdSphere( vec3 p, float s ) {
  return length(p)-s;
}

float sdTorus82( vec3 p, vec2 t ) {
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length8(q)-t.y;
}

float sdBox( vec3 p, vec3 b ) {
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

float Plane(vec3 p) {
	return p.y;
}
vec3 scale(vec3 p, float s, float x, float y, float z) {
	return vec3(0.0);
}

vec3 rotation(vec3 p, float a, float x, float y, float z) {
	//c = cos (a); s = sin (a);
	return vec3(0.0);
}

vec3 rX(vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.y = c * q.y - s * q.z;
	p.z = s * q.y + c * q.z;
	return p;
}

float Scene(vec3 p) {
	float dist = 999.9999;
	
	// Central sphere
	dist = min(dist, max(-sdBox(p - vec3(0.4, 0.0, 0.0), vec3(0.2, 2.0, 2.0)), sdSphere(p - vec3(0.0), 2.0)));
	dist = max(dist, -sdBox(p - vec3(1.1, 0.0, 0.0), vec3(0.15, 2.0, 2.0)));
	dist = max(dist, -sdBox(p - vec3(-1.1, 0.0, 0.0), vec3(0.15, 2.0, 2.0)));
	dist = max(dist, -sdBox(p - vec3(-0.4, 0.0, 0.0), vec3(0.15, 2.0, 2.0)));
	
	// Main torus
	dist = min(dist, sdTorus82(rX(p, PI_H) - vec3(0.0), vec2(2.5, 0.1)));
	dist = min(dist, sdTorus82(rX(p, PI_H) - vec3(0.0), vec2(3.0, 0.1)));
	dist = min(dist, sdTorus82(rX(p, PI_H) - vec3(0.0), vec2(3.5, 0.1)));
	
	// Little boxes outside
	float angle = 0.1;
	float inc = PI_2 / 30.0;
	//for(int i = 0; i < 30; ++i) {
	//	dist = min(dist, sdBox(p - vec3(sin(angle) * 4.4, cos(angle) * 4.4, 0.0), vec3(0.3, 0.2, 0.1)));
	//	angle += inc;
	//}
	
	return dist;
}

float ComputeAO(vec3 p, vec3 n) {
	float totao = 0.0;
    	float sca = 1.0;
    	for( int aoi=0; aoi<5; aoi++ ) {
        float hr = 0.01 + 0.05*float(aoi);
		vec3 aopos =  n * hr + p;
		float dd = Scene( aopos );
		totao += -(dd-hr)*sca;
		sca *= 0.75;
	}
	return clamp( 1.0 - 4.0*totao, 0.0, 1.0 );
}


vec3 ComputeNormal( vec3 pos ) {
	vec3 eps = vec3( 0.001, 0.0, 0.0 );
	vec3 nor = vec3(
	    Scene(pos+eps.xyy) - Scene(pos-eps.xyy),
	    Scene(pos+eps.yxy) - Scene(pos-eps.yxy),
	    Scene(pos+eps.yyx) - Scene(pos-eps.yyx));
	return normalize(nor);
}

float March(Ray ray) {
	vec3 position = ray.origin;
	float dist;
	for (int i = 0; i < 64; ++i) {
		dist = Scene(position);
		if (dist < 0.001) {
			break;
		}
		position += ray.direction * dist;
	}
	return dist;
}

void main( void ) {
	vec3 color = vec3(0.0);
	
	// Fragment position
	vec2 pixel = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pixel.x *= (resolution.x / resolution.y);
	
	// Camera ray
	Ray ray;
	ray.origin = vec3(0.0, 0.0, 5.0);
	vec3 ta = vec3( 0.0, 0.0, 0.0 );
	vec3 cw = normalize( ta-ray.origin );
	vec3 cp = vec3( 0.0, 1.0, 0.0 );
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
	ray.direction = normalize( pixel.x*cu + pixel.y*cv + 1.0*cw );
	
	float dist = March(ray);
	
	// Our 3D pixel
	if ( dist > -0.5) {
		vec3 position = ray.origin + ray.direction * dist;
		vec3 normal = ComputeNormal(position);
		
		// Light
		float ao = ComputeAO(position, normal);
		
		vec3 light = vec3(sin(time) * 1.0, 4.0, cos(time) * 1.0);
		vec3 light_dir = normalize(light - position);
		
		float amb = clamp( 0.5+0.5*normal.y, 0.0, 1.0 );
	        float dif = clamp( dot( normal, light_dir ), 0.0, 1.0 );
        	float bac = clamp( dot( normal, normalize(vec3(-light.x,0.0,-light.z))), 0.0, 1.0 )*clamp( 1.0-position.y,0.0,1.0);
	
		color = vec3(1.0, 0.0, 0.0) * dif;
	}
	
	gl_FragColor = vec4( color, 1.0 );
}
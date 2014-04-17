#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 200.0
#define EPSILON 0.1
#define SCREEN_RATIO (resolution.y/resolution.x)
#define PI 3.141592653589

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float object;	// which object did the raymarch hit

// from iq
float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

void rX(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.y = c * q.y - s * q.z;
	p.z = s * q.y + c * q.z;
}

void rY(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x + s * q.z;
	p.z = -s * q.x + c * q.z;
}

void rZ(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x - s * q.y;
	p.y = s * q.x + c * q.y;
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float f(in vec3 p) {
	float dist = 10000.0;	// a huge big number
	float new;	// not? used when comparing new distance to the old one
	float radius, thickness;
	//float object = 0.0;	 // which object did we hit (0 = floor);
	
	//dist = sdPlane(p + vec3(0.0, 3.9, 0.0), normalize(vec4(0.1, 0.4, 0.0, 1.0)));
	
	
	// we substract this from p
	p-= vec3(0.0, 5.0, -35.0);
	rX(p, 0.2 * (sin(time*0.6)) - 0.3);
	dist = p.y - 2.0;
	//rX(p, time);
	//p-= vec3(5.0, 0.0, 0.0);
	//rZ(p, time * 0.9);
	vec3 dir = vec3(0.0, 1.0, 0.0);
	
	float tt = time * 3.0;
	
	object = 0.0;
	
	for (float u=0.0;u<4.0;u++) {
		float phase = tt + u*0.5;
		float fat = (abs(sin(phase + 0.1)) * 0.2) ;
		
		radius = 2.0 + fat ;
		thickness = 0.1 + radius/3.0 + 0.5*sin(phase)*sin(tt*6.0)*(0.1/(u+1.0));
		float spacing = 1.7;
		new = sdTorus(p + dir*u*spacing + vec3(0.0, -7.5 - abs(sin(phase)) * 2.0, 0.0), vec2(radius, thickness));
		if (new < dist) {
			object = 1.0;	
		}
		dist = min(dist, new);
	}
	
	
	
	//dist = 2.0 + p.y + sin(p.z) * sin(p.x) ;
	return dist;	
}

// normal
vec3 g(vec3 p) {
	vec2 e = vec2(0.01, 0.0);
	return (vec3(f(p+e.xyy),f(p+e.yxy),f(p+e.yyx))-f(p))/e.x;
}
	
// tips from iq
vec3 mars(inout vec3 p, inout vec3 d, float stepsize, float limit) {
	vec3 start = p;
	float l, iterations;
	iterations = 1.0;
	
	for (float i=0.0;i<MAX_ITER;i++) {
		l = f(p);
		p+=d*l*stepsize;	
		
		
		if (l < (limit)/(l+1.0)) {
			iterations = i;
			break;	
		}
	}
	
	return vec3(l, iterations, length(start-p));
}

float shadow(inout vec3 p, vec3 n, vec3 sun) {
	float l;
	for (float o=0.0;o<50.0;o++) {
			l = f(p);
			p = p -sun*l*1.0;
		
			if (l > EPSILON) {
				return 0.1;
			}
		}
	
	return 1.0;
	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	// scene
	// sun light direction
	vec3 sun = normalize(vec3(-0.5, -0.7, -0.2));
	
	//camera

	// position
	vec3 p = vec3(position.x - 0.5, (position.y - 0.5) * SCREEN_RATIO, -1.0);
	// direction
	vec3 d = normalize(p);
	
	float shade = 0.1;
	object = 0.0; 	// we assume the floor	
	
	//p += vec3(sin(time), 8.0, sin(time * 2.0) * 10.0 );
	p += vec3(0.0, 13.0, 0.0);
	vec3 col = vec3(0.1);	// background color
	
	// raymarching function
	// mars(vec3 position, vec3 direction, float stepsize, float limit
	vec3 dist = mars(p , d, 1.00, EPSILON);
	if (dist.x < EPSILON) {
		// p.z pitäisi olla etäisyys
		
		vec3 n = g(p);
		float lighty = dot(n, vec3(0.5, 1.0, 0.5));
		shade = (1.0 + lighty) * 0.5 + 0.1;	
		shade += p.z * 0.009;
		shade += dist.y * 0.1;
		
		// get the dot out of the surface
		p += n * EPSILON * 1.1;
		
		//shadows
		//float shadowratio = shadow(p, n, sun);
		float shadowratio = 1.0;
		float o = 0.0;
		/*
		do {
			float l = f(p);
			p = p -sun*l*1.0;
		
			if (l > EPSILON) {
				shadowratio = 0.1;
			}
			
			o++;
		} while (o < 50.0);
		*/
		float red = object * lighty*0.5;
		float glass = pow(lighty * 0.8, 9.0) * object;
		col = vec3(shade + red + glass, shade - red*0.25 + glass, shade - red*0.25 + glass);
	}
	
	
	
	
	gl_FragColor = vec4( col, 1.0 );

}
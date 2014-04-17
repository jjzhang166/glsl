// @Author: Kil4h
// Raymarched prezi logo

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// Code is verbose on purpose for others to read


// Some useful constants
const float PI = 3.14159265359;
const float PI_H = PI / 2.0;
const float PI_2 = PI * 2.0;
const float MIN_MARCH = 0.001;
const float MAX_MARCH = 100.0;

struct Ray {
	vec3 origin;
	vec3 direction;
};
	
struct Light {
	vec3 position;
	vec3 direction;
};

// The purpose of this struct is to allow returning more values while mapping
struct Trace {
	float distance;
};

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float length8(vec2 p) {
	p *= p; p *= p; p *= p; 
	return pow(p.x + p.y, 1.0 / 8.0);
}

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdSphere( vec3 p, float s ) {
  return length(p)-s;
}

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdTorus82( vec3 p, vec2 t ) {
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length8(q)-t.y;
}

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdBox( vec3 p, vec3 b ) {
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

// http://pyopengl.sourceforge.net/documentation/manual-3.0/glRotate.xhtml
vec3 rotate(vec3 p, float a, float x, float y, float z) {
	float c = cos (a); float s = sin (a);
	vec3 axis = normalize(vec3(x,y,z));
	x = axis.x; y = axis.y; z = axis.z;
	mat3 rot = mat3(
		x*x*(1.0-c)+c,		x*y*(1.0-c)-z*s,	x*z*(1.0-c)+y*s,
		y*x*(1.0-c)+z*s,	y*y*(1.0-c)+c,		y*z*(1.0-c)-x*s,
		x*z*(1.0-c)-y*s,	y*z*(1.0-c)+x*s,	z*z*(1.0-c)+c
	);
	return p * rot;
}

// Main scene
Trace Scene(vec3 p) {
	float dist = 99999.0;
	
	// Canvas
	dist = min(dist, sdBox(p, vec3(20, 20, 0.2)));


	// Central sphere
	dist = min(dist, sdSphere(p - vec3(0.0, 0.0, -0.6), 1.5));
	dist = max(dist, -sdBox(p - vec3(0.75, 0.0, 0.7), vec3(0.12, 1.2, 0.45)));
	dist = max(dist, -sdBox(p - vec3(0.25, 0.0, 0.7), vec3(0.12, 1.2, 0.45)));
	dist = max(dist, -sdBox(p - vec3(-0.25, 0.0, 0.7), vec3(0.12, 1.2, 0.45)));
	dist = max(dist, -sdBox(p - vec3(-0.75, 0.0, 0.7), vec3(0.12, 1.2, 0.45)));
	
	// Torus around
	dist = max(dist, -sdTorus82(rotate(p, PI_H, 1.0, 0.0, 0.0) - vec3(0.0, -0.1, 0.0), vec2(2.0, 0.25)));
	dist = max(dist, -sdTorus82(rotate(p, PI_H, 1.0, 0.0, 0.0) - vec3(0.0, -0.1, 0.0), vec2(3.0, 0.25)));
	dist = max(dist, -sdTorus82(rotate(p, PI_H, 1.0, 0.0, 0.0) - vec3(0.0, -0.1, 0.0), vec2(4.0, 0.25)));

	// Little boxes outside
	float angle = 0.1;
	float inc = PI_2 / 30.0;
	for(int i = 0; i < 30; ++i) {
		dist = max(dist, -sdBox(rotate(p - vec3(sin(angle) * 5., cos(angle) * 5., 0.15), angle - PI_H, .0, 0.0, 1.0), vec3(0.38, 0.25, 0.2)));
		angle += inc;
	}

	Trace hit;
	hit.distance = dist;
	return hit;
}

// http://www.pouet.net/topic.php?which=7931&page=1&x=29&y=6
float ComputeAO(vec3 p, vec3 n, float k) {
	float ao = 1.0;
	for (float i = 0.; i < 4.; ++i) {
		ao -= (i*k-abs(Scene(p+n*i*k).distance))/pow(2.,i);
	}
	return ao;
}

// http://www.pouet.net/topic.php?which=7931&page=1&x=29&y=6
vec3 ComputeNormal( vec3 pos ) {
	vec3 eps = vec3( 0.001, 0.0, 0.0 );
	vec3 nor = vec3(
	    Scene(pos+eps.xyy).distance - Scene(pos-eps.xyy).distance,
	    Scene(pos+eps.yxy).distance - Scene(pos-eps.yxy).distance,
	    Scene(pos+eps.yyx).distance - Scene(pos-eps.yyx).distance);
	return normalize(nor);
}

// Marching core
Trace March(Ray ray, out vec3 position) {
	position = ray.origin;
	Trace hit;
	hit.distance = 0.0;
	for (int i = 0; i < 12; ++i) {
		hit = Scene(position);
		if (abs(hit.distance) < MIN_MARCH || hit.distance > MAX_MARCH) {
			break;
		}
		position += ray.direction * hit.distance;
	}
	return hit;
}

void main( void ) {

	vec2 pixel = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pixel.x *= (resolution.x / resolution.y);
	
	// Camera ray
	Ray ray;
	ray.origin = vec3(0.0, 0.0, 6.0);
	ray.direction = vec3(pixel, -1.0);
	
	// Our 3D pixel
	vec3 position;
	Trace hit = March(ray, position);
	
	// Background color
	vec3 color = vec3(0.0);
	
	if ( hit.distance < MAX_MARCH ) {
		// 3D normal
		vec3 normal = ComputeNormal(position);
		
		// Color
		color = vec3(1.0);

		// Guess... :)
		Light light;
		light.position = vec3(sin(time)*10.0, cos(time)*10.0, 10.0);
		light.direction = normalize(light.position - position);
		
		// Ilumination
		vec3 amb = 0.8 * color;
		vec3 dif = color * dot(normal, light.direction);
		
		// AO
		float ao = ComputeAO(position, normal, 0.25);
		color = (amb + dif * 0.15) * ao;
	}
	
	gl_FragColor = vec4( color, 1.0 );
}
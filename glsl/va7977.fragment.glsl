#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Camera											// A camera struct that holds all relevant camera parameters
{
	vec3 position;
	vec3 lookAt;
	vec3 rayDir;
	vec3 forward, up, left;
};

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
	
	
float or(float a, float b){
	return min(a, b);
}
float sphere(vec3 p, float r) {
	return length(p) - r;	
}
float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}
void rotate(inout vec2 v, float angle) {
  v = vec2(cos(angle)*v.x+sin(angle)*v.y,-sin(angle)*v.x+cos(angle)*v.y);
}

const float PI = 3.14;

float DE(vec3 p) {
	float  a =3.;
	float b = -7.;
	float polyfoldOrder = 4.;
	float R1 = 5.;
	float R2 = .3;
	float R3 = 2.;
	float mobius = (a+b/polyfoldOrder) * atan(p.y,p.x);
	p.x = length(p.xy)-R1;
	rotate(p.xz,mobius);	
	float m = polyfoldOrder/(2.*PI);
	float angle = floor(.5+m*(PI/2.-atan(p.x,p.z)))/m;
	rotate(p.xz,angle);
	p.x =p.x - R3;
	return length(p.xz)-R2;
}
float scene(in vec3 p){
	return DE(p) ;//+ 0.1*snoise(p.xy*3.);
	//return or(sdBox(p, vec3(1.0, 0.5, 1.2)), sphere(p, 1.0));
}
	
void main( void ) {

	vec2 vPos = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0;
	float ratio = resolution.x / resolution.y;
	vec3 color = vec3(0.0);// vec3(position.x, position.y, 0.0);
	float t = time;
	//Camera setup
	Camera cam;
  	cam.lookAt = vec3(0,0,0);								// The point the camera is looking at
	cam.position = vec3(sin(t)*7.0, sin(t) * 7.0, cos(t)*7.0);						// The position of the camera
	cam.up = vec3(0,1,0);									// The up vector, change to make the camera roll, in world space
  	cam.forward = normalize(cam.lookAt-cam.position);					// The camera forward vector, pointing directly at the lookat point
  	cam.left = cross(cam.forward, cam.up);							// The left vector, which is perpendicular to both forward and up
 	cam.up = cross(cam.left, cam.forward);	
	
						// The recalculated up vector, in camera space
 
	vec3 screenOrigin = (cam.position+cam.forward); 					// Position in 3d space of the center of the screen
	vec3 screenHit = screenOrigin + vPos.x*cam.left*ratio + vPos.y*cam.up; 	// Position in 3d space where the camera ray intersects the screen
  
	cam.rayDir = normalize(screenHit-cam.position);	
	// Ray marching
	const float MIN_DISTANCE = 0.0001;								// Distance to scene that we will count as a hit
	const float MAX_DEPTH=20.0;								// Distance from camera that we will count as a miss
	const int MAX_STEPS = 56;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	
  	float dScene = 1.0;								// Initial distance to scene, should be initialized as 1
	float dCam = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 rpos;
	for(int i = 0; i < MAX_STEPS; i++){
		if(abs(dScene) < MIN_DISTANCE || dCam > MAX_DEPTH) break;
		dCam += dScene * 0.8;
		rpos = cam.position + cam.rayDir*dCam;
		dScene = scene(rpos);
	}
	
	if(dCam < MAX_DEPTH){
		color = vec3(1.0);
		vec3 e = vec3(0.0001, 0.0, .0);
		vec3 n = normalize(vec3(dScene - scene(rpos + e.xyy),
					dScene - scene(rpos + e.yxy),
					dScene - scene(rpos + e.yyx))); 
		vec3 diffuse = vec3(0.1, 0.5, 0.9);
		float l = max(dot(n, cam.rayDir),0.);
		vec3 spec = pow(l,95.0)*2.5 * vec3(1.0);
		color = diffuse * l + spec;
	}
	
	gl_FragColor = vec4(color, 1.0);
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 hsv_to_rgb(float h, float s, float v, float a)
{
	float c = v * s;
	h = mod((h * 6.0), 6.0);
	float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
	vec4 color;
 
	if (0.0 <= h && h < 1.0) {
		color = vec4(c, x, 0.0, a);
	} else if (1.0 <= h && h < 2.0) {
		color = vec4(x, c, 0.0, a);
	} else if (2.0 <= h && h < 3.0) {
		color = vec4(0.0, c, x, a);
	} else if (3.0 <= h && h < 4.0) {
		color = vec4(0.0, x, c, a);
	} else if (4.0 <= h && h < 5.0) {
		color = vec4(x, 0.0, c, a);
	} else if (5.0 <= h && h < 6.0) {
		color = vec4(c, 0.0, x, a);
	} else {
		color = vec4(0.0, 0.0, 0.0, a);
	}
 
	color.rgb += v - c;
 
	return color;
}
vec3 rotXaxis(vec3 p, float rad) {
	float z2 = cos(rad) * p.z - sin(rad) * p.y;
	p.y = sin(rad) * p.z + cos(rad) * p.y;
	p.z = z2;
	return p;
}

vec3 rotYaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.z;
	float z2 = sin(rad) * p.x + cos(rad) * p.z;
	p.x = x2;
	p.z = z2;
	return p;
}
vec3 rotZaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.y;
	float y2 = sin(rad) * p.x + cos(rad) * p.y;
	p.x = x2;
	p.y = y2;
	return p;
}
float Torus(vec3 p, vec2 t)
{
	vec2 q = vec2(length(p.xz)-t.x, p.y);
    	return length(q)-t.y;
}
float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}
float map(vec3 position) {
	
	float tor = Torus(rotXaxis(position,3.1415/2.), vec2(0.04,0.015));
	position.z += 20.5;
	float plane = sdPlane(position, vec4(1.0,1.0,1.0,1.));
	
	return min(tor, plane);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy*2. - resolution.xy ) / resolution.y;
	
	vec3 camTarget = vec3(0.,0.,0.);
	vec3 camPos = vec3(0.,0.,0.2);
	vec3 camDir = normalize(camTarget - camPos);
	vec3 camUp = normalize(vec3(0.,1.,0.));
	vec3 camSide = normalize(cross(camDir, camUp));
	
	vec3 rayDir = normalize(position.x * camSide + position.y * camUp + camDir * 2.);
	vec3 ray = camPos;
	
	float c;
	int steps;
	const int MAXMARCH = 64;
		
	//the raymach
	for (int march = 0 ; march < MAXMARCH ; march++) {
		float dist = map(ray);
		ray += rayDir * dist;
		steps = march + 1;
		if (abs(dist) < 0.001) {
			c = 1.;
			break;
		}
		
	}
	vec4 result = hsv_to_rgb(float(steps) / float(MAXMARCH),1.,c,1.);
	gl_FragColor = result;
	
	
}
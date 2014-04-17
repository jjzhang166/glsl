#ifdef GL_ES
precision highp float;
#endif

#define PI 3.141592653589793238462643383279
#define TWO_PI 6.28318531

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 _scale = vec3(1.0);
vec3 _position = vec3(0.0);
vec4 _color = vec4(1.0);
float _lineWidth = 0.004;

// unormalize and shift coordinates to the center
vec4 frag;
vec2 coord = (gl_FragCoord.xy / resolution.y - vec2((resolution.x/resolution.y)/2.0, 0.5)) * vec2(2); 


/**
* Projects a 3D point intto 2D space.
* Applies current _scale and _position. 
**/
vec3 computePoint(vec3 point){
	point += _position;
	point *= _scale;
	point.xy *= point.z + 2.0;	
	
	return point;
}

vec4 face(vec3 p0, vec3 p1, vec3 p2){
	p0 = computePoint(p0);
	p1 = computePoint(p1);
	p2 = computePoint(p2);
	
	vec4 color;
	
	// Compute vectors        
	vec2 v0 = p1.xy - p0.xy;
	vec2 v1 = p2.xy - p0.xy;
	vec2 v2 = coord - p0.xy;
		
	// Compute dot products
	float dot00 = dot(v0, v0);
	float dot01 = dot(v0, v1);
	float dot02 = dot(v0, v2);
	float dot11 = dot(v1, v1);
	float dot12 = dot(v1, v2);
	
	// Compute barycentric coordinates
	float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

	// Check if point is in triangle
	if ((u >= 0.0) && (v >= 0.0) && (u + v < 1.0)){
		color = vec4(1.0);
	}
	else color =  vec4(0.0);
	
	color *= _color;
	
	return color;
}

vec4 circle(vec3 center, float radius){
	vec4 color;
	float size = TWO_PI / float(20);
	for(int i = 0; i<20; i++){
		float a = size * float(i);
		float b = size * float(i+1);
		color += face(center, center+vec3(sin(a)*radius, cos(a)*radius, 0.0), center+vec3(sin(b)*radius, cos(b)*radius, 0.0));
	}
	return color;
}


void main( void ) {
	
	frag += circle(vec3(0.0), 0.2);
	
	gl_FragColor = frag;
}
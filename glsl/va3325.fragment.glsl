/* Normal Map Stuff */
/* By: Flyguy */
/* With help from http://stackoverflow.com/q/5281261 */

// fancified a bit by psonice

// slimified a bit by kabuto

// mod by ME //uncomment at line 52!

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float heightmap(vec2 position)
{
	float height = 0.0;
	float f = .002;
	vec2 timevec = vec2(.1,.13);
	float g = sqrt(1.25)+.5;
	position *= f;
	float c = cos(2.*PI*g);
	float s = sin(2.*PI*g);
	mat2 matcs = mat2(c,s,-s,c)*g;
	for (int i = 0; i < 13; i++) {
		vec2 v = fract(position + noise(vec2(timevec.x, timevec.y)))-.5;
		//uncomment me!
		//v += mod(noise(vec2(position.x*position.y)) / float(i), float(i));
		//v += mod(noise(vec2(position.x-position.y)) / float(i), float(s));
		//v += mod(noise(vec2(position.x-position.y)) / float(i), float(c));
		//v += mod(noise(vec2(position.x-position.y)) * float(i), float(g));
		float dots = max(0.,.1-dot(v,v))/f*0.15;
		height += dots*dots;//max(height,dots);
		f *= g;
		position *= (matcs + noise(vec2(dots * 0.1, -g * 0.1)));
	}
	
	return sqrt(height);
}
	
float n1,n2,n3,n4;
vec2 size = vec2(-0.1,0.0);
vec2 n = vec2(0,0);
void main( void ) {

	vec2 mousePosition = (mouse - ( gl_FragCoord.xy / resolution )) * surfaceSize + surfacePosition;
	
	vec2 pos = surfacePosition * 100.0;

	vec2 off = vec2(pos.x,pos.y-1.0);
	
	n1 = heightmap(off);
	
	off = vec2(pos.x-1.0,pos.y);
	
	n2 = heightmap(off);
	
	off = vec2(pos.x+1.0,pos.y);
	
	n3 = heightmap(off);
	
	off = vec2(pos.x,pos.y+1.0);
	
	n4 = heightmap(off);
	
	vec3 va = normalize(vec3(size.xy,n2-n3));
	vec3 vb = normalize(vec3(size.yx,n1-n4));
	vec3 normal = vec3(cross(va,vb));
	
	vec3 p2mr = vec3(1.0, 0.0, 0.0);
	vec3 p2mg = vec3(0.0, 1.0, 0.0);	
	vec3 p2mb = vec3(0.0, 0.0, 1.0);	
	
	float r = dot(normal.xyz, normalize(p2mr));
	float g = dot(normal.xyz, normalize(p2mg));
	float b = dot(normal.xyz, normalize(p2mb));
	
	vec3 color = normalize(vec3(r,g,b));
	
	gl_FragColor = vec4( color, 1.0 );

}
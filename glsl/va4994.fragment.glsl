/* Normal Map Stuff */
/* By: Flyguy */
/* With help from http://stackoverflow.com/q/5281261 */

// fancified a bit by psonice

// slimified a bit by kabuto

// played with by knaut
 
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592 
#define NOTPI .1

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

float heightmap(vec2 position)
{
	float s1a = 1.0;
	float s1 = sin(s1a*.5*.5);
	for (int i = 0; i < 10; i++ ) {
		s1a += .9;
	}
	
	float height = 0.0;
	float f = .001;		// seems to control range of dot size
	vec2 timevec = time*vec2(.11,s1);	//controls time and, thus, speed, and alternately, direction
	float g = sqrt(10.)+.76;
	position *= f;
	float c = cos(2.*NOTPI*g);
	float s = sin(2.*NOTPI*g);
	mat2 matcs = mat2(c,s,-s,c)*g;
	for (int i = 0; i < 13; i++) {
		vec2 v = fract(position + timevec)-.5;
		float dots = max(0.,.12-dot(v,v));
		dots = dots*dots*dots/f*8.;
		height += dots*dots*2.;//max(height,dots);
		f *= g;
		position *= matcs;
	}
	
	return sqrt(height);
}
	
float n1,n2,n3,n4;
vec2 size = vec2(-0.4,0.0);
void main( void ) {

	vec2 pos = gl_FragCoord.xy;

	n1 = heightmap(vec2(pos.x,pos.y-1.0));
	n2 = heightmap(vec2(pos.x-1.0,pos.y));
	n3 = heightmap(vec2(pos.x+1.0,pos.y));
	n4 = heightmap(vec2(pos.x,pos.y+1.0));
	
	vec3 p2m = vec3(0.,1.,1.);	
	
	vec3 normal = normalize(vec3(n2-n3, n1-n4, .5));		// smooths out the bumps
	
	float color = dot(normal, normalize(p2m))*1.;
	vec3 colorvec = vec3(pow(color,1.),pow(color,1.),pow(color,.5));
	
	float brightness = gl_FragCoord.y / resolution.y;
	
	gl_FragColor = vec4( colorvec + brightness*vec3(0.2, .1, .8) - 1.0 + vec3(0.2, 0.5, 0.2), 1.0 );	// play with colors

}
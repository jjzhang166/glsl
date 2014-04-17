/* Normal Map Stuff */
/* By: Flyguy */
/* With help from http://stackoverflow.com/q/5281261 */

// fancified a bit by psonice

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

float heightmap(vec2 position)
{
	float height = 0.0;
	
	height = sin(position.x*0.0625);
	height = clamp(height,0.0,0.5);
	height += clamp(sin(position.y*0.0625),0.0,1.0);
	height = clamp(height,0.0,0.5);
	height = 1.0 - height * sin(time) * 1.0;
	vec2 lx = sin(position.xy*0.015);
	vec2 x = vec2(sqrt(lx.x*lx.x+lx.y*lx.y),atan(lx.y,lx.x));
	
	float groove1 = sin( x.y * 50. - PI * .5) + cos(x.y * 50. + PI);
	float groove2 = sin(x.x * 50. - PI * .5) + cos(x.x * 50. + PI);
	float groove = 1.-max(max(groove1, groove2)-1.,0.) * .2;
	float dots = max(sin(position.x * .5 + PI * .5) + cos(time*position.y * .5 - PI *2.), 1.) - 1.;
	
	height = min(height, groove);
	
	height = max(height, dots*0.25 + .5);
	
	return height;
}
	
float n1,n2,n3,n4;
vec2 size = vec2(-0.4,0.0);
void main( void ) {

	vec2 pos = gl_FragCoord.xy;

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
	
	vec3 p2m = vec3(-((pos/resolution)-mouse)*resolution,164.0);	
	
	vec3 normal = vec3(cross(va,vb));
	
	float color = dot(normal.xyz, normalize(p2m))*.5+.5;
	vec3 colorvec = vec3(pow(color,10.),pow(color,5.),pow(color,2.5));
	
	float brightness = 1.;///sqrt(1.+pow(distance(mouse*resolution,pos)/resolution.x*4.,2.));
	
	gl_FragColor = vec4( colorvec*brightness, 1.0 );

}
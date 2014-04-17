/* Normal Map Stuff */
/* By: Flyguy */
/* With help from http://stackoverflow.com/q/5281261 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

vec3 heightmap(vec2 position)
{
	float height = 0.0;
	
	height = sin(position.x*0.0625);
	height = clamp(height,0.0,0.5);
	height += clamp(sin(position.y*0.0625),0.0,1.0);
	height = clamp(height,0.0,0.5);
	height = 1.0 - height;

	
	return vec3(position,height);
}
	
vec3 n1,n2,n3,n4;
vec2 size = vec2(-0.4,0.0);
void main( void ) {

	vec2 pos = gl_FragCoord.xy;;

	vec3 color = vec3(0.0);
	
	vec2 off = vec2(pos.x,pos.y-1.0);
	
	n1 = heightmap(off);
	
	off = vec2(pos.x-1.0,pos.y);
	
	n2 = heightmap(off);
	
	off = vec2(pos.x+1.0,pos.y);
	
	n3 = heightmap(off);
	
	off = vec2(pos.x,pos.y+1.0);
	
	n4 = heightmap(off);
	
	vec3 va = normalize(vec3(size.xy,n2.z-n3.z));
	vec3 vb = normalize(vec3(size.yx,n1.z-n4.z));
	
	vec3 p2m = vec3(-((pos/resolution)-mouse)*resolution,64.0);	
	
	vec3 normal = vec3(cross(va,vb));
	
	color = vec3(dot(normal.xyz, p2m)/96.0);
	
	color *= vec3(clamp(1.0-distance(mouse*resolution,pos)/resolution.x*2.0,0.0,1.0));
	
	gl_FragColor = vec4( vec3( color ), 1.0 );

}
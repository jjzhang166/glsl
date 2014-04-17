/* Normal Map Stuff */
/* By: Flyguy */
/* With help from http://stackoverflow.com/q/5281261 */

// fancified a bit by psonice

// playing with noise and some params

#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

const mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

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

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}


vec3 heightmap(vec2 position)
{
	float height = fbm(position * 0.1);
	height = 1.0-sin(position.x*0.0625) / (fbm(position * 0.5) * 0.5);
	height = clamp(height * 2.,0.0,(fbm(position) * 1.5)) * 0.25;
	height += clamp(sin(position.y*0.0625) + ((fbm(position * 0.75)) * 0.25),0.0,0.6);
	height = clamp(height,0.0, 0.5);
	height = 1.0 - height;
	height += height == 1.0 ? (max(sin(position.x * .25 - PI * .5) + cos(position.y * .25 + PI), 1.5) - 1.5) * .5 : 0.;
	height += height == 0.5 ? (max(sin(position.x * .5 + PI * .5) + cos(position.y * .5 - PI * 2.), 1.25) - 1.) * .25 : 0.;
	return vec3(position,height);
}
vec3 n1,n2,n3,n4;
vec2 size = vec2(-0.2,0.0);
void main( void ) {

	vec2 pos = gl_FragCoord.xy;
	
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
	vec3 p2m = vec3(vec2(0.0),64.0);
	vec3 normal = vec3(cross(va,vb));
	color = vec3(dot(normal.xyz, p2m)/96.0) * 1.5;
	gl_FragColor = vec4( vec3( color ), 1.0 );

}
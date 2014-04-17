// based on 'Shapes' by iq (2011)
// by rotwang 
// @mod+ leaf function with parameters

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;
float aspect = resolution.x / resolution.y;
vec2 unipos = ( gl_FragCoord.xy / resolution );
vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);

float usin(float t)
{
	return sin(t)*0.5+0.5;
}

vec3 leaf( vec2 p, float jags, float smooth, float rota )
{
    float a = atan(p.x,p.y)+rota;
    float r = length(p);
    float ta =jags*a;
	
    float s = usin(ta);
	
	float m = 0.85;
	float invm = 1.0-m;
    float d = invm + m*sqrt(s);
	
    float h = pow(r/d, d);
    float f = 1.0-smoothstep( 0.92, 0.98, h );

	
    return mix( vec3(0.0), vec3(0.3*h,0.2+0.6*h,0.99), f );
}



void main( void ) {

	vec3 clr = leaf(pos,3.0, 0.015, PI/6.0 );
	gl_FragColor = vec4( clr, 1.0 );

}
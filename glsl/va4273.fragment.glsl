// based on 'Shapes' by iq (2011)
// by rotwang 
// @mod+ leaf function with parameters
// small changes: RH2

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

vec3 leaf( vec2 p, float jags, float smooth, float rota, float mulOne, float offsetOne,float red,float green,float blue )
{
    float a = atan(p.x,p.y)+rota;
    float r = length(p);
    float ta =jags*a;
	
    float s = usin(ta);
	
	float m = tan(time*0.1)*1.0*(sin(time*0.9)+2.0*cos(time));
	float invm = 1.0-m;
    float d = invm + m*sqrt(s);
	
    float h = pow(r/d, d);
    float f = 1.09-smoothstep(abs(0.5*sin(time*mulOne)+offsetOne)*1.92, 0.98, h );

	
    return mix( vec3(0.0), vec3(red*h,green*h,blue*h), f );
}



void main( void ) {
	vec3 f1 = leaf(pos, 3.0,1.2,PI/6.0,2.0,2.2,  1.0,1.0,0.6);
	vec3 f2 = leaf(pos, 6.0,2.2,PI/2.3,0.2,1.1,  0.8,0.5,0.0);
	vec3 f3 = leaf(pos, .0,1.2,PI/2.3,0.2,1.1,  0.9,0.5,0.2);

	gl_FragColor = vec4(f1, 2.0)-vec4(f2,2.0)+vec4( f3, 2.0 );
	//gl_FragColor= vec4( clr, 1.0 );
	//gl_FragColor= vec4(thingTwo, 1.0);
}
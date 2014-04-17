// by rotwang 

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


float shape( vec2 p, float r )
{
    float a = atan(p.x,p.y);
    float len = 1.0-length(p);
	
	float ba = sin(a*10.0)*r;
	float bb = sin(a*5.0)*r;
float sa = sqrt(len+ba + len-bb ) + len;
	
    return sa;
}


void main( void ) {

	float sa = shape(pos*1.25, 0.25);
	vec3 clr = vec3(sa*0.2, sa*0.6, sa); 
	gl_FragColor = vec4( clr, 1.0 );

}
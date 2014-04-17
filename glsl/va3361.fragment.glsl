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
    float ta =jags*a + time;
	
    float s = usin(ta);
    float g = sin(1.57+ta);
    float d = 0.25 + 0.25*sqrt(s) + 0.5*g*g;
	
    float h = pow(r/d, 2.0*d);
    float f = 1.0-smoothstep( 0.9, 1.0, h );

	// details:
  //  h *= 1.0-0.5*(1.0-h)*smoothstep(0.95+0.05*h,1.0,sin(ta));
	
    return mix( vec3(0.0), vec3(0.4*h,0.2+0.3*h,0.0), f );
}


vec3 star( vec2 p, float jags, float smooth, float rota )
{
    float a = atan(p.x,p.y)+rota;
    float r = length(p); 

    float s = usin(a*jags);
    float d = 0.5 + 0.4*pow(s,16.0 );
    float h = r/d;

    float shade = 1.0-smoothstep(d-smooth,d+smooth,r);
	

    vec3 clr = mix(vec3(0.0),vec3(0.9,0.6,0.0),shade);
	
	return clr;
}

void main( void ) {
	
	//vec3 clr = star(pos,3.0, 0.015, PI/6.0 );
	vec3 clr = leaf(pos,3.0, 0.015, PI/6.0 );
	gl_FragColor = vec4( clr, 1.0 );

}
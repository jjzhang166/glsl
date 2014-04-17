// by rotwang, some tests for Krysler(2012)

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

float ucos(float t)
{
	return cos(t)*0.5+0.5;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


float Krysler_635( vec2 p, float jags )
{
    float a = atan(p.x,p.y)+ PI/(jags*2.0);
    float r = length(p); 
	
   	float n = max(abs(p.y), 0.0);
	vec2 pn = floor(p*n);
	float sta = step(0.5, rand(p-pn*r));
	
	
    float smsta = smoothstep(0.4,0.5,sta);
	
    float us = usin(a*jags)*smsta;
	
    float uc = ucos(a*jags + time);
	
    float d = 0.5*pow(us,8.0) + 0.5*pow(uc,64.0);
    float h = pow(r, 16.0)/d;
//h += rand(p+r)*0.1;	
    float w = mix(us,uc,d*3.0);
    float shade = w-h; 
	
    return shade;
}

void main( void ) {
	
	float jags = 3.0; 
	float shade = Krysler_635(pos,jags);

	vec3 clr = vec3(0.2,0.6,1.0)*shade;
  	
	gl_FragColor = vec4( clr, 1.0 );

}
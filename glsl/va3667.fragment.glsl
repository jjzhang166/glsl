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

// smooth no yet used
float Krysler_612( vec2 p, float jags, float smooth )
{
    float a = atan(p.x,p.y)+ PI/(jags*2.0);
    float r = length(p); 

    float us = usin(a*jags);
    float uc = ucos(a*jags);
	
    float d = 0.5*pow(us,8.0) + 0.5*pow(uc,64.0);
    float h = pow(r, 16.0)/d;
    float w = mix(us,uc,d*3.0);
    float shade = w-h; 
	
    return shade;
}

float Krysler_613( vec2 p, float jags, float smooth )
{
    float a = atan(p.x,p.y)+ PI/(jags*2.0);
    float r = length(p); 

    float us = usin(a*jags);
    float uc = ucos(a*jags);
	
    float d = 1.0*pow(us,8.0) + 0.75*pow(uc,8.0);
    float h = pow(r, 64.0)/d;
    float w = mix(us,uc,d*3.0);
    float shade = w-h; 
	
    return shade;
}

float Krysler_614( vec2 p, float jags, float smooth )
{
    float a = atan(p.x,p.y)+ PI/(jags*2.0);
    float b = atan(p.x,p.y)+a;
    float r = length(p); 

    float us = usin(a*jags);
    float uc = ucos(b*jags*1.5);
	
    float d = 1.0*pow(us,4.0) + 0.5*pow(uc,2.0);
    float h = pow(r, 128.0)/d;
    float w = mix(us,uc,d*3.0);
    float shade = w-h; 
	
    return shade;
}

float Krysler_615( vec2 p, float jags, float smooth )
{
    float a = atan(p.x,p.y)+ PI/(jags*2.0);
    float b = atan(p.x,p.y)+a;
    float r = length(p); 

    float us = usin(a*jags);
    float uc = ucos(b*jags*2.0);
	
    float d = pow(us,4.0);
    float e = 1.0 - uc*r;
	
    float h = pow(r*e, 2.0);
    
    float w = mix(us,uc,d*3.0) ;
    float shade = e*smoothstep(-1.0,1.0,w*e-h); 
	
    return shade;
}


void main( void ) {
	
	float jags = 5.0; 
	float shade = Krysler_615(pos,jags, 0.013);

	vec3 clr = vec3(0.2,0.6,1.0)*shade;
  	
	gl_FragColor = vec4( clr, 1.0 );

}
// by rotwang, WIP testing some functions for hills

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}

float max4(float a,float b,float c, float d)
{
	return max(a, max3(b,c,d));
}


/*
float sinx( vec2 p, float f, float a)
{
	float h = sin(p.x*f)*0.125;
	vec2 v = vec2(p.x,h);
	float d = distance(p,v);
	//d = smoothstep(h, h+0.56, d); 
	return 1.0-d;
}
*/

float shade( vec2 p, float f, float a)
{
	float d = min(1.0, 1.0+p.y) ;
	return d;
}

float shade_cosy( vec2 p, float f, float a)
{
	float d = cos(p.y*PI*0.5) ;
	return d;
}


	
float cosy_step_upper( vec2 p)
{
	return cos( p.y*PI*0.5) * step(0.0,p.y);
}

float cosy_step_lower( vec2 p)
{
	return cos( p.y*PI*0.5) * step(p.y,0.0);
}

float cosy_step_upper_sinx( vec2 p, float f, float a, float offy, float phasex)
{
	p.y -=offy;
	float h = 2.0-sin(p.x*f + phasex)*a;
	float y = p.y*h;
	
	float d = cos( y*PI*0.5);
	
	d -= smoothstep(y-0.5,y-0.6,d*d);
	return d;
}

float cosy_step_lower_sinx( vec2 p)
{
	float h = 2.0-sin(p.x*4.0);
	float y = p.y*h;
	float d = cos( y*PI*0.5) * step(p.y,0.0);
	return d;
}



void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	pos.x += time*0.1;
	
	
	float d1 = cosy_step_upper_sinx(pos,6.0, 0.8, -0.33, 0.0 )*0.4; 
	float d2 = cosy_step_upper_sinx(pos,4.0, 0.6, -0.4, 1.5 )*0.6; 
	float d3 = cosy_step_upper_sinx(pos,3.0, 0.5, -0.5, 0.5 )*0.8; 
	float d4 = cosy_step_upper_sinx(pos,2.0, 1.4, -0.7, 0.2 )*0.9; 
	
	float d =  max4(d1,d2,d3,d4);
	
	//d -= dot(vec2(0.0,0.5),pos);
	vec3 clr1 = vec3(0.0,1.0,0.4) *d; 
			
	
	vec3 clr = clr1 ;
	
	gl_FragColor = vec4( clr , 1.0 );

}
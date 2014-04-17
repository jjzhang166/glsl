// by gundeep
//locate the exact screen centre

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


float rect(vec2 p, vec2 s ){
	vec2 dist = abs(p)-s;
	return step(dist.x,0.)*step(dist.y,0.0);
}

float metaballContribution( vec2 position, vec2 center ) {	
	vec2 delta = position - center;
	return 1.0 / ( delta.x * delta.x + delta.y * delta.y );
}

float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return d;
}

float sphere(vec3 p, float r)
{
    return length(p) - r;
}

void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 centeredMouse = 2.0 * ( mouse - vec2( 0.5, 0.5 ));
	vec2 pos = -(mouse*unipos*6.0-1.0);
	vec2 pos2= -(mouse-0.5)*6.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float flash = sin(8.0);
	float uflash = flash*0.5+0.5;
	
	
	
	// scroll
	//pos.x -= sin(time*0.5)*1.0;
	vec2 p = vec2(pos2);
	
	
	float d1 = rect(centeredMouse, vec2(0.04,0.04)); 
	vec3 clr1 = vec3(0.2,0.6,1.0) *d1; 
	//int k=0;
	
	//if( pos==vec2(k,k))
	{
	//	clr1=vec3(1.0,0.0,0.0);	
	}
	
	for(int k=0;k<100;k++)
	{
		
		if( pos==length(vec2(k,k)/1000.0))
		{
			clr1= vec3(1.0,0.0,0.0);	
		}
		
	}
	
		
	vec3 clr = clr1;
	if (clr.x==clr.y)
	{
		//clr=vec3 (1.0,0.0,0.0);	
	}
	gl_FragColor = vec4( clr , 1.0 );

}
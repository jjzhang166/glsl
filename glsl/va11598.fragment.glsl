#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 5205.14
#define amp 0.2
#define iter 5.0
#define offsety 0.5

void line(vec2 aa)
{	
	float c = abs(distance(gl_FragCoord.xy, aa));
		gl_FragColor = vec4( 18./c,29./c,30./c,.3);	
}
void main( void ) {
	if (gl_FragCoord.y > 270.) 
	{ 		                            
	        line(vec2(resolution.x / 2.,270.));	
		gl_FragColor.b /= (gl_FragCoord.y - 270.)/110.;		
	}
	else
	{
	vec2 pos =  gl_FragCoord.xy/resolution ;

	float r=0.0,g=0.0,b=0.0;
	for(float i=1.0;i<2.0;i++){
		float offsetx=i+time*i*0.5;
		
		float amt=1.0-pow(abs(abs(pos.y-1.0)*amp*sin(iter*2.0*PI*pow(pos.y,3.0)+offsetx)+offsety-pos.x),0.09);
		g+=amt*abs(atan(time*0.1+abs(pos.x-0.5)*3.0));
		b+=amt*abs(atan(time*0.1+4.0+abs(pos.x-0.5)*3.0));
	}	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );
	}
}


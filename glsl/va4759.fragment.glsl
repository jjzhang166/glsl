#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TAU 6.28318

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float arc(vec2 pos,vec4 btrir,float ang,vec2 p);

//MOD! 

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	float color = 0.0;
	
	color += arc(resolution/2.,vec4(0.0,PI/2.,32,48),time*1.25,p);
	color += arc(resolution/2.,vec4(0.0,PI/2.,48,64),time,p);
	color += arc(resolution/2.,vec4(0.0,PI/2.,64,80),time/2.25,p);
	color += arc(resolution/2.,vec4(0.0,PI/2.,80,96),time/2.5,p);
	color += arc(resolution/2.,vec4(0.0,PI/2.,96,112),time/1.75,p);
	color += arc(resolution/2.,vec4(0.0,PI/2.,112,128),time/2.0,p);
	
	float bg = length(gl_FragCoord.xy/resolution.xy);
	gl_FragColor = vec4(vec3(bg*0.9 + color*0.0 + 0.3, bg*0.5 + color*0.4 + 0.2, bg*0.3 + color*1.5 + 0.2),1.0);
}

float arc(vec2 pos,vec4 btrir,float ang,vec2 p)
{
	vec2 c = resolution/2.;
	
	float d = max(abs(p.x-vec2(c).x), abs(p.y-vec2(c).y));
	
	float a = atan(p.x-c.x,p.y-c.y)+PI+ang;
	d += sin(ang*2.)*10.;
	d += sin(a*4.)*5.;
	
	a = mod(a,TAU);
	
	if(a > btrir.x && a < btrir.y && d > btrir.z && d < btrir.w)
	{
		float diff = d-btrir.z;
		float rtrn = smoothstep(0.0,1.0,pow(sin(diff/16.*PI),2.));		
		float eb = 8.0;
		if(a < btrir.x+(PI/eb))
		{
			rtrn *= smoothstep(0.0,1.0,a/(PI/eb));
		}
				
		if(a > btrir.y-(PI/eb))
		{
			float ad = a - (btrir.y-(PI/eb));
			rtrn *= smoothstep(1.,0.0,ad/(PI/eb));
		}
		return rtrn;
	}
	
	return 0.0;
}


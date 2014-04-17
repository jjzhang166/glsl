#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 point(float r, float theta)
{
	return r*vec2(sin(theta),cos(theta));
}

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	p.x *= resolution.x/resolution.y;
	
	gl_FragColor = vec4(.7,.85,1.,1.);
	//stamp of flower
	if(abs(p.x) < 0.02 && p.y < 0.)
	{
		gl_FragColor=vec4(0.1,0.8,0.1,1.0);
	} else if(abs(p.x) < 0.025 && p.y < 0.)
	{
		gl_FragColor=vec4(0.);
	}
	//leaves	  
	for(float i = 0.0; i<=10.0; i++)
	{
		float theta = float(i)*19.6;
		//leaves
		if((length(p-point(0.2,degrees(-60.+theta))) < 0.2) && ((length(p-point(0.2,degrees(+60.0+theta)))) < 0.2)) {
			gl_FragColor=vec4(1.,2.*length(p),1.5*length(p-point(0.2,degrees(-60.+theta))),1.);	
		}
		//outlines
		float lenght_of_outlines = 0.2;
		float thinkness_of_outlines = 0.2;
		if((length(p-point(0.2,degrees(-60.+theta))) < lenght_of_outlines) && ((length(p-point(0.2,degrees(+60.+theta)))) > 0.195) && ((length(p-point(0.2,degrees(+60.+theta)))) < thinkness_of_outlines))
		{
			gl_FragColor=vec4(1.);
		} else if((length(p-point(0.2,degrees(+60.+theta))) < lenght_of_outlines) && ((length(p-point(0.2,degrees(-60.+theta)))) > 0.195) && ((length(p-point(0.2,degrees(-60.+theta)))) < thinkness_of_outlines))
		{
			gl_FragColor=vec4(1.);
		}
	}
	//middle of flower
	if(length(p)<.1)
	{
		gl_FragColor=vec4((1.),(1.-3.*length(p)),.15,1.);
	} else if(length(p)<.105) {
		gl_FragColor=vec4(0.);
	}
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {
	float maxtime=500.0;
	
	bool t = false;
	vec2 centerP = mouse*resolution;

	vec3 textColor = vec3(0.2);
	vec3 color = vec3(1., 0., 0.);
	float alpha = 0.0;
	float s = 0.;
	
	//vec3 mixedColor = mix(vec3(0.), color, alpha);
	
	float distFromCenter = distance(gl_FragCoord.xy, centerP);
	if (distFromCenter>60.) {
		vec3 blackColor = vec3(sin(time*2.),0.,0.);
		
		if (distFromCenter<100.)
			s = smoothstep(60.,100.,distFromCenter);
		else
			s = 1.0;
		textColor = mix(textColor, blackColor, s);
		alpha = 0.0;
	}
	if (distFromCenter<120.){
		float startVal = abs(sin(time)*60.);
		s = smoothstep(startVal,60.,distFromCenter);
		if (distFromCenter>60.){
			startVal = abs(cos(time)*30.);
			s = 1.0-smoothstep(60.,60.+startVal,distFromCenter);
		}
		alpha  = s*0.1;
		
	}
	//(1.0-(maxtime-time)/maxtime )
	//color = mix (color, vec3(0,0,0), 1.-sin(time));
	textColor = mix (textColor, color, alpha);
	gl_FragColor = vec4( textColor, 1.0 );
}
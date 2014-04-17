// simple mouse follow demo

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 backColor = vec4(0.5, 0.5, 0.5, 1.0);

void createParticle(float x, float y)
{
	float particlePos = distance(gl_FragCoord.xy, vec2(x, y) * resolution);
	if (particlePos <= 60.0)
	{
		vec4 centerColor = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(0.0, 0.0, 1.0, 1.0), smoothstep(0.0, 30.0, particlePos));
		gl_FragColor =  mix(centerColor, gl_FragColor, smoothstep(0.0, 60.0, particlePos));
	}
	else if (particlePos >=20.0 && particlePos<=21.0)
	{
		// stupid antialiasing
		//gl_FragColor =  mix(vec4(0.0, 0.0, 0.0, 1.0), gl_FragColor, smoothstep(20.0, 21.0, particlePos));
	}
}

void createPointerCircle()
{
	// get fragment space pointer position
	float pointerPos = distance(gl_FragCoord.xy, mouse * resolution);
	// circle around our pointer
	if ( pointerPos <= 30.0 )
	{
		gl_FragColor = mix(vec4(1.0, 0.0, 0.0, 1.0), gl_FragColor, smoothstep(0.0, 30.0, pointerPos));
	}
	/*
	else if ( pointerPos >= 30.0 && pointerPos <= 31.0)
	{
		// stupid antialiasing
		gl_FragColor = mix(vec4(vec3(0.0), 1.0), gl_FragColor, smoothstep(30.0, 31.0, pointerPos));
	}
	*/
}

void main( void ) {

	// background
	gl_FragColor = backColor;
	
	// render particles
	float particlePos;
	for (float i=0.0; i<=1.0; i+=0.1)
	{
		float r = radians(i);
		createParticle(cos(time/2.0)/15.0+i, sin(time/2.0)/15.0+0.5);
		createParticle(cos(time)/15.0+i, sin(time)/15.0+0.4);
	}
	
	
	createPointerCircle();
	
//	gl_FragColor = finalColor;
}
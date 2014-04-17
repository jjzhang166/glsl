#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {	
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	float aspect = resolution.x / resolution.y;
	p.x *= aspect;
	vec2 m = vec2(mouse.x*aspect, mouse.y);
	
	vec2 timeOfDay = vec2(0.,0.);
	float timeStep = 0.5;
	timeOfDay.x += sin(time*timeStep)/1.5+1.;
	timeOfDay.y += cos(time*timeStep)/2.;
	
	vec3 color = vec3(0, 0, 0);
	
	float y = p.y*time;
	float t = 0.;
	
	color.g -= y+sin(p.x*10.-t)*50.+cos(p.x*2.5+t*(sin(t/200.)+1.))*100. - resolution.y/1.;
	
	
	
	
	float radius = 2.;
	color.rg += 1.-clamp(distance(radius*timeOfDay, radius*p), 0., 1.);
	
	color.b += mix(0.0, 1.0, timeOfDay.y);
	
	
	
	

	gl_FragColor = vec4(color.rgb, 1.0 );

}

//good job you fucking idiot you just made a green sky
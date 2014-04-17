// Based on davedes simple circle outline, not the best technique...

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;

void main( void ) {
	
	vec3 color;
	const float smooth1 = 1.0;
	const float smooth2 = 100.0;
	vec2 c = resolution *0.5;
	for (float i = 1.; i < 16.; ++i)
	{
		float s = mod(time,i);
		s = (s > 8.) ? 16.-s : s;
		float dist = resolution.y/s - distance(gl_FragCoord.xy, c);
		vec3 clr = vec3(dist);
		clr = mix(vec3(1.0), vec3(0.0), smoothstep(smooth1, smooth2, dist*dist));	
		clr = clamp(clr, 0.0, 1.0);
		clr *= vec3(pow(1.02,i*i),20./s,s*i);
		float m = fract(time*0.1)*0.5;
		m = m > 0.25 ? 0.5-m : m;
		m *= .5;
		color = mix(color,clr,m);
	}
	gl_FragColor = vec4(color, 1.0 );

}
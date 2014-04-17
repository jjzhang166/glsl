//interference 
//ripped from onefinger by kewlerz 
//because we love you, {

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;






void main()
{
	vec2 v_pos=0.9*gl_FragCoord.xy/resolution.xy;
	
	const int numCircles = 3;
	float u_time=time*0.07;
	float u_aspect=1.;
	vec3 u_col=vec3(0.6+0.1*abs(sin(time)),0.6+0.1*abs(sin(time*0.9)),0.6+0.1*abs(sin(time*2.)));
	
	float col = 0.0;

	for (int i = 0; i < numCircles; i++)
	{
		vec2 cpos = vec2(sin(float(i * 2) + u_time * 5.86) * 0.75, sin(float(i * 3) + u_time * 7.71) * 0.66);
		float dist = distance(cpos, v_pos * vec2(1.0, u_aspect));
		float ccol = sin(dist * 128.0) * 8.0;
		ccol = clamp(ccol, -1.0, 1.0) * 0.5 + 0.5;
		col = mix(col, 1.0 - col, ccol);
	}
	
	gl_FragColor = vec4(col * u_col, 1.0);
}
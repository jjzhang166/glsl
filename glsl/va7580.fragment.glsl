#ifdef GL_ES
precision mediump float;
#endif
#define timesteps 1000
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float stuff[timesteps];
void main( void ) {
	//USE 0.5 OR 1.0 IN THE DROPDOWN ABOVE
	float avg = 0.0;
	for(int i = 0; i < timesteps-1; i++)
	{
		
		stuff[i] = stuff[i+1];
		avg += stuff[i];
	}
	avg += time;
	stuff[timesteps-1] = time;
	avg /= float(timesteps);
	vec2 pos = (gl_FragCoord.xy ) / resolution.xy;
	gl_FragColor = vec4(0,0,sin(avg),0);

}
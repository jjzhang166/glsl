#ifdef GL_ES
precision mediump float;
#endif

//tigrou.ind@gmail.com 2012.11.22 (for gamedevstackexchange)
//update : adding several waves

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;

	for(int i =0 ; i < 3 ; i++)
	{
		float waves = sin(position.x*25.0+0.4)*0.01*sin(time*12.0)  +  sin(position.x*32.0+1.3)*0.02*sin(time*11.0+10.5);
		float color = position.y < waves ?(waves-position.y)*25.0 : 0.0;
		color = min(pow(color,0.5),1.0);
     	        gl_FragColor = max(gl_FragColor, vec4( position.y < waves ? mix(vec3(0.59,0.63,0.86),vec3(0.19,0.24,0.51),color) : vec3(0,0,0), 1.0 ));
		position.y += 0.07;
		position.x += 0.23+time*0.1;
	}

}
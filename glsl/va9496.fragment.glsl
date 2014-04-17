
precision mediump float;
uniform vec2 resolution;
uniform float time;

void main()
{
	
	if(mod(time, 2.0) < 1.0)
	{
		gl_FragColor = vec4(cos(gl_FragCoord.x+time), 0, tan(gl_FragCoord.y+time), 1);
		//gl_FragColor = vec4(0, 0, 0, 1);
	}
	else
	{
		gl_FragColor = vec4(tan(gl_FragCoord.x+time), 0, cos(gl_FragCoord.y+time), 1);
		//gl_FragColor = vec4(1, 1, 1, 1);
	}
}
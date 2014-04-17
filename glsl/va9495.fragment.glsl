precision mediump float;
uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

float per(float part, float whole)
{
	return (part/whole)*100.0;
}

void main()
{
	//sus ben
	
	/*if(mod(time, 2.0) < 1.0)
	{
		gl_FragColor = vec4(tan(gl_FragCoord.x-time), tan(gl_FragCoord.y-time), 0, 1);
	}
	else
	{
		gl_FragColor = vec4(tan(gl_FragCoord.x+time), tan(gl_FragCoord.y+time), 0, 1);
	}*/
	
	float mX = resolution.x;
	float mY = resolution.y;
	float x = mouse.x;
	float y = mouse.y;
	//float col = max(per(x, mX), per(y, mY));
	float col;
	
	if(mod(time, 2.0) < 1.0)
		col = sin(time);
	else
		col = sin(-time);
	
	gl_FragColor = vec4(per(x, mX), col, per(y, mY), 1);
}
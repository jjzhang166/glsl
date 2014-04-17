#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//gl_FragCoord.xy
	float x = gl_FragCoord.xy.x+time*30.0;
	float y = gl_FragCoord.xy.y;
	float green = sin(y*.07+sin(x*0.07)*.2+sin(x*0.2)*.1);
	green = max(green, 0.0);
	x += time*100.0;
	green += sin(y*.02+sin(x*0.001)*(.2+sin(x*.01))+sin(x*0.02)*.1)*.4;
	green = max(green, 0.0);
	if(mod(gl_FragCoord.xy.x, 16.0) < 1.0 || mod(gl_FragCoord.xy.y, 16.0) < 1.0)
	{
		green += .5;
	}
	else
	{
		green *= .5;
	}
	green += mod(gl_FragCoord.xy.x,.3)*.7+mod(y, .3)*.7+sin(time)*.1;
	gl_FragColor = vec4(green*.1, green*.5, green*.1, 1.0 );
}
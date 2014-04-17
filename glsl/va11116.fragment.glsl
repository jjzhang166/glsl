#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define FREQ 0.05
#define RFREQ 2.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	vec2 opos = FREQ*(gl_FragCoord.xy);
	vec2 round = vec2(sin(RFREQ*time),cos(RFREQ*time));
	float color = 0.0;
	float itr = 0.0;
	for(int i=0;i<4;i++)
	{
		float p = itr * time;
		vec2 pos = vec2(sin(opos.x),sin(opos.y)) + mouse.xy;
		opos = opos +  + 0.2*PI*round;
		float dist_squared = dot(pos, pos);
		if (dot(pos,pos) > 0.5*float(4-i) )
		{
			color = dot(pos,pos)*0.2;
	  		break;
		}
		itr = itr + 0.1;
	}
	
	gl_FragColor = vec4(color, itr, .90, 1.0);

}
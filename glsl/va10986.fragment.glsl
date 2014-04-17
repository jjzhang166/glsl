#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
void main( void ) 
{
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 0.1;
	float nd = 1.0;
	vec4 cbuff = vec4(0.0);
		
	for (float i = 0.0; i < 4.0; i++)
	{
		nd = sin(3.14 * 1.0 * pos.x + i * 800.0 + time) * 0.2 * (pos.x + 0.3) + 0.5;
		amnt = 1.0 / abs(nd - pos.x) * 0.005;
		
		cbuff += vec4(amnt * pos.x, amnt * 0.2, amnt * pos.x, 1.0);
	}
	
	for (float i = 0.0; i < 4.0; i++)
	{
		nd = sin(3.14 * 1.0 * pos.y + i * 1600.0 + time) * 0.3 * (pos.y + 0.3) + 0.5;
		amnt = 1.0 / abs(nd - pos.y) * 0.005;
		
		cbuff += vec4(amnt * 0.2, amnt * 0.3, amnt * pos.y, 1.0);
	}
	
	for (float i = 0.0; i < 2.0; i++)
	{
		nd = sin(3.14 * 1.0 * pos.y + i * 3200.0 + time) * 0.4 * (pos.y + 0.3) + 0.5;
		amnt = 1.0 / abs(nd - pos.y) * 0.005;
		
		cbuff += vec4(amnt * 0.7, amnt * pos.x, amnt * 0.2, 1.0);
	}
		
	vec4 dbuff =  texture2D(backbuffer, 1.0 - pos) * 0.4;
  	gl_FragColor = cbuff + dbuff;
}

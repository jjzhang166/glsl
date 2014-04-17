#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float angle = cos(time) / 2.;
	pos -= vec2(0.5);
	vec2 pos2 = vec2(pos.x * cos(angle) - pos.y * sin(angle), pos.x * sin(angle) + pos.y * cos(angle));
	pos2 += vec2(0.5);
	//vec2 mPos = resolution.xy * mouse;
	float amnt = 0.5;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i < 16.0; i += 2.0)
	{
		nd =cos(i) * i / 28. *cos(3.14159 * i * pos2.x + (i * 2.75) + time) / cos (time)* (pos2.x - 0.5) + 0.5;
		amnt = 1.0 / abs(nd - pos2.y) * 0.005; 
		
		cbuff += vec4(amnt, amnt * 0.2 , amnt * pos2.y, 2.0);
	}
	
	for(float i=0.0; i < 20.0; i += 2.0)
	{
		nd =9. +sin(i)*sin(i - 10.) *i*2.*cos(3.14159 * i * pos2.y + (i * 2.75) + time) * min(sin(time), atan(time * 2.)) * (pos2.y - 0.5) + 0.5;
		amnt = 1.0 / abs(nd - pos2.x) * 0.005 * i*20.; 
		
		cbuff += vec4(amnt * pos2.x , amnt * pos2.y , amnt * 0.9, 1.0);
	}
	
	
  	gl_FragColor = cbuff;
}

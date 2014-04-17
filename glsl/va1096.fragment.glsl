#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.1415926;


void main( void ) {

	vec2 position = gl_FragCoord.xy;
	vec2 center =vec2(200,150);
	vec4  color = vec4(0.0, 0.0, 0.0, 1.0);
	vec2 pos = vec2(5.0,5.0);
	float r = 80.0;
	float x = 240.0;
	float y = 190.0;
	
	//vec2 p = -1.0 + gl_FragCoord.xy / resolution.xy * 2.0;

	//vec2 m = vec2(0.2,1);
	//float phi = -atan ( (m.y - 0.5), (m.x - 0.5) );     	
	//vec2 t = vec2(p.x * cos(pi) - p.y * sin(pi), p.x * sin(pi) + p.y * cos(pi));
	//float l = ((t.y > 0.25) && (t.x < -0.666*t.y+1.0) &&(t.x > 0.666*t.y+0.0)) ? 1.0 : 0.0;
	
	//float g = t.y-0.01 < 0.0 ? mod(t.x,0.2) : 0.0; g = t.y+0.01 > 0.0 ? g : 0.0;	
	//float b = t.x-0.01 < 0.0 ? mod(t.y,0.2) : 0.0; b = t.x+0.01 > 0.0 ? b : 0.0;	
	if( length(  position - center) < r  )
	//if ((position.x > 200.0 && position.x < 300.0)&& (position.y > 100.0 && position.y < 200.0) )
	{
		color = vec4(1.0, 1.0, 0.0, 1.0);
		
	}
		
	//gl_FragColor = vec4( vec3( l, g, b ), 1.0 );

	gl_FragColor = color;
	

}
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.1415926;
float pi2 = pi * 2.0;

void main( void ) {

	vec2 m = mouse;
	vec2 p = -1.0 + gl_FragCoord.xy / resolution.xy * 2.0;	//move (0,0) to screen center

	float phi = -atan ( (m.y - 0.5), (m.x - 0.5) );         //-3.14 .. 3.14 clockwise
	
	vec2 t = vec2(p.x * cos(phi) - p.y * sin(phi),
                      p.x * sin(phi) + p.y * cos(phi));		//rotate by phi

	float r = ((t.y > 0.25) &&
		(t.x < -0.666*t.y+1.0) &&
		(t.x > 0.666*t.y+0.0)) ? 1.0 : 0.0;		//outer triangle
	
	r = ((t.x < 0.333+0.666*t.y) &&
		(t.x>-0.666*t.y+0.666) &&
		(t.y < 0.5)) ? 0.0 : r;				//inner triangle
  
	float g = t.y-0.01 < 0.0 ? mod(t.x,0.2) : 0.0; g = t.y+0.01 > 0.0 ? g : 0.0;	
	float b = t.x-0.01 < 0.0 ? mod(t.y,0.2) : 0.0; b = t.x+0.01 > 0.0 ? b : 0.0;	//axes
	gl_FragColor = vec4( vec3( r, g, b ), 1.0 );
}
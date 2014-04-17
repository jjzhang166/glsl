// rotwang: @mod+ tremble

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 point = vec2(0, 0);

float rand( const in vec2 v )
{
	float value = fract( sin(time + v.x * 1014.43572) * 31344.234 + sin(time + v.y * 3442.43572) * 543.234);
	
	return value;
}

void main( void ) {
	
	float speed = time*0.25;
	
	vec2 pos = vec2(gl_FragCoord.x - (resolution.x/2.0), gl_FragCoord.y - (resolution.y/2.0));
	
	vec2 modifier = vec2(sin(speed*3.0)*resolution.x/2.0*cos(speed*0.02), cos(time)*resolution.y/2.0*sin(speed*3.0));
	point += modifier;
	float ran = rand(point);
	float tremble = sin(ran)*8.0;
	point += tremble;	
	float f = 2.0 / exp2(distance(point, pos)*0.06);	

	vec3 color = vec3(0.3 + 0.2*tremble, 0.4+ 0.1*tremble, 0.8- 0.4*tremble) * f;
	gl_FragColor = vec4(color, 1.0);
}
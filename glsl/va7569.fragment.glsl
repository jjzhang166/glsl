#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 center = vec2(0.5,0.5);
float speed = 0.035;
float invAr = resolution.y / resolution.x;
void main(void)
{
	vec2 uv = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	
	//uv -= (mouse) ;
		
	float r = length(uv);
	float angle = atan(uv.x, uv.y) ;
	
	float numLeaves = 5.0;
	
	float x =  cos(numLeaves * (angle + sin(time)) ) * sin(10.0) / 2.0;
	float colorfx = step(x, r ) ;
	
	vec3 col = vec3(colorfx , 0.1, 0.1) ;
	
	gl_FragColor = vec4(col, 1.0);
}


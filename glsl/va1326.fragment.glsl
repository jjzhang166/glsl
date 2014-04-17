#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool inCircle(vec2 circleCenter, float radius)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if(temp.x*temp.x+temp.y*temp.y<radius*radius) return true;
	return false;
}

void main( void ) {
	vec2 center = resolution/2.0;
	float radius = 20.0;
	
	if(inCircle(center, radius)) 
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	else
		gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0);

}
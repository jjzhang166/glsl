#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool inCircle(vec2 circleCenter, float radius, vec2 temp) {
	if(temp.x*temp.x+temp.y*temp.y<radius*radius) return true;
	return false;
}

void main( void ) {
	vec2 center = resolution/2.0;
	float radius = 200.0;
	radius = radius + 80. * sin(time) * sin(time * .9) * cos(sin((time * 0.05)));
	vec2 temp = gl_FragCoord.xy - center.xy;
	if(inCircle(center, radius, temp)) 
		gl_FragColor = vec4( sin(temp.x ), cos(temp.y) + 0.1 * cos( time * 3.),  sin(temp.x + 4.* time) + sin(temp.x +  3. * time) ,1.0);
	else
		gl_FragColor = vec4( temp.y * 0.01, temp.y * 0.01, temp.y * 0.01, 1.0);

}
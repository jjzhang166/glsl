#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const vec4 GREEN = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 RED = vec4(1.0, 0.0, 0.0, 1.0);

vec4 bands(float pos, vec4 color1, vec4 color2, float width)
{
	return sin(pos / width) > 0.0 ? color1 : color2;
}

vec4 spiral(vec2 origin, int nArms, float tightness, float speed, vec4 color1, vec4 color2)
{
	vec2 toOrigin = gl_FragCoord.xy - origin;
	float dist = length(toOrigin);
	float angle = atan(toOrigin.y, toOrigin.x);
	return bands(dist + time * speed + tightness * float(nArms) * angle, color1, color2, tightness);
}

void main( void ) {
	vec2 origin = resolution / 2.0;
		
	gl_FragColor = spiral(origin, 6, 50.0, 80.0, GREEN, RED);

}
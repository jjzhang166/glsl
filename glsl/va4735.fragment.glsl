#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 p;

//phase modulation
//straight lines doesn't work, huh

vec3 plot(float f, vec3 col, float w)
{
	float dis = abs(f - p.y);
	if(dis < w) return col;
	return vec3(0.0);
}

void main( void ) {
	p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	vec3 color = vec3(0.0);
	
	color += plot(
		( sin((p.x * 3.14) * fract(p.x * 5.0))) * -0.5, vec3(0.0, 1.3, 0.0), 0.005);
	
	gl_FragColor = vec4( color, 2.0 );

}
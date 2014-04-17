//Entrance exam math problems Shizuoka University
//by Hosson(2013.8.22)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float Scale = 8.0;


float func(float X, float Y, vec2 pos)
{
	if (distance(vec2(X, Y), pos) < 0.06)
		return 1.0;
	return 0.0;
}

void main( void ) {
 	vec2 pos = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5, 0.5)) * Scale * 2.0;;
	float Depth = 0.2;

	float D = 0.0;
	//f(x) = x^4 - x^2 + 6 (|x| <= 1)
	if (abs(pos.x) <= 1.0)
		D += func(pos.x, pow(pos.x, 4.0) - pow(pos.x, 2.0) + 6.0, pos);	
	//f(x) = 12 / (|x| + 1) (|x| > 1)
	if (abs(pos.x) > 1.0)
		D += func(pos.x, 12.0 / (abs(pos.x) + 1.0), pos);	
	//g(x) = 1/2 cos(2 pi x) + 7/2 (|x| <= 2)
	if (abs(pos.x) <= 2.0)
		D += func(pos.x, 0.5 * cos(2.0 * 3.14159265358979 * pos.x) + 7.0 / 2.0, pos);
		
	Depth += clamp(D, 0.0, 1.0);

	
	vec3 color = vec3(Depth * 0.2,Depth * 0.3, Depth);
	
	gl_FragColor = vec4(color, 1.0);

}
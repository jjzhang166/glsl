#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float loopto(float a, float top) {
	a = mod(a, top*2.0);
	if(a < top)
		return a;
	else
		return top*2.0-a;
	
	int i=0;
}

void main( void ) {
	float time = time;
	if(time < 5000.)
	{
		time += 500.;
	}
	time = time / 50. ;
	float a = time, cosa = sin(a*0.01), sina = tan(a*2.);
	vec2 position = gl_FragCoord.xy / resolution.xy * 3.0 -2.  ;
	position = vec2(position.x * cosa - position.y * sina, position.y*cosa + position.x * sina) + 0.1 * cos(time);
	time = time * 3.;
	position = (sin(vec2(length(position), cos(atan(position.y / position.x)))));

	position *= ((acos(position) / (position * (time / 1.) * loopto(time, 5.3)))) / 5. * sin((position * 5.) * (time/200.));
	
	time = (time * 10.);
	gl_FragColor = (vec4(sin(2. * time) ,atan(time * 0.1) , abs(tan(-0.3* time)), 1.) * tan(position.y/ tan(position.x * 5.) + time  + tan(position.x) * time / 5. )) / 30.;
}
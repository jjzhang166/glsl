#ifdef GL_ES
precision highp float;
#endif

// Cable Hell
// Üstün Ergenoglu - ego@ustun.fi

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool isWave(vec2 pos)
{
	float x = mod(pos.x, 500.0);
	if (abs(x - (2.0 + sin(pos.y/800.0))*80.0) < 30.0)
		return true;
	
	x = mod(pos.x, 200.0);
	if (abs(x - (4.0 + cos(pos.y/90.0))*20.0) < 10.0)
		return true;
	
	x = mod(pos.x, 300.0);
	if (abs(x - (2.0 + cos(pos.y/70.0))*20.0) < 6.0)
		return true;

	x = mod(pos.x, 100.0);
	if (abs(x - (4.0 + sin(pos.y/40.0))*10.0) < 2.0)
		return true;
	
	return false;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy) + mouse.y;
	position.y += time * 560.0;

	float color = 0.3;
	if (isWave(position))
		color = 0.7;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color / 3.0 ) * 0.75 ), 1.0 );

}
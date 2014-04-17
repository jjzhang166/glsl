#ifdef GL_ES
precision mediump float;
#endif

// Greek Flag by Optimus
// I am not sure about the color or dimensions but one can fork this

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 blueish = vec3(0.0, 0.3, 0.9);
	vec3 white = vec3(1.0, 1.0, 1.0);
	vec3 finalcolor = vec3(0.0);

	float stripes = mod(position.y * 4.5, 1.0);
	vec3 stripecol = vec3(0.0);
	if (stripes < 0.5)
	{
		stripecol = blueish;
	}
	else
	{
		stripecol = white;
	}

	vec3 crosscol = vec3(0.0);
	if (position.x < 0.4 && position.y > 0.444)
	{
		crosscol = blueish;

		if (position.x > 0.15 && position.x < 0.25) crosscol = white;
		if (position.y > 0.666 && position.y < 0.778) crosscol = white;

		finalcolor = crosscol;
	}
	else
	{
		finalcolor = stripecol;
	}

	gl_FragColor = vec4( finalcolor, 1.0 );
}
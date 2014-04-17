#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float timeIndex = ((sin(time)+1.0) /2.0);
	float Height = resolution.y * timeIndex;
	if(gl_FragCoord.y > Height)
	{
		vec2 dist = gl_FragCoord.xy - vec2(resolution.x / 2.0, Height);
		dist = abs(dist);
		if(dist.x < 50.)
		{
			float distIndex = abs(dist.x - 50.);
			if(dist.y < distIndex) gl_FragColor = vec4(1.0);
		}	
	}
}
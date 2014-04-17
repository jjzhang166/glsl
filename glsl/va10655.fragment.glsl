#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;

	//RGBA : UV.R / UV.G / UV.R / UV.G
	
	float rood = position.r;
	float groen = position.g;
	float blauw = 1.0;
	float alpha = 1.0;
	
	if (position.x >= 100.0)
	{		
	    gl_FragColor = vec4(1, 1, 1, 1);		
	}
	else
	{
	    gl_FragColor = vec4(rood, groen, blauw, alpha);
	}
}
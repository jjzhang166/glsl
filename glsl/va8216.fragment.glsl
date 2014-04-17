#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 0.0;
	color += step(position.x, 0.5) + step(position.y, 0.5) ;
	color *= cos(position.x);
	color *= sin(position.x);

	for(int sample=0;sample<1000;sample++)
	{
		color += sin(float(sample) * sin(position.x));
		color += cos(float(sample) * cos(position.y));
		
		// ray
		float fray = sin(position.x * position.y);
		
		color += fray+sin(time*2.0);
		color *= cos(fray)+sin(fray)-0.5;
	}
	
	gl_FragColor = vec4( color,color,color, 1.0);

}
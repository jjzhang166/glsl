#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) / 2.0;

	float color = 0.0;

	for (float z = 0.0; z < 15.0; z+=1.0) {
		color += z-(cos(-z+p.y)+z*p.x*time*1.0*cos(p.y*z-time))-z;
		color -= cos(z*0.002+gl_FragCoord.x*time);
		color *= tan(z*time*0.01/p.y*0.01);
	}
	
	gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}
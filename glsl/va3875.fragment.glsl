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
		color += z-(cos(-z+p.y*0.02-p.x)+z*p.y*0.01*time*0.6*cos(p.y*z-time))-z*p.x*1.0;
		color *= z*cos(z*0.002+gl_FragCoord.x*time)*cos(p.x+p.y*0.03-z);
		color *= z*tan(z*0.2*time*p.y*0.1+p.y*0.01)*0.1;
		color += z*tan(z*time*0.01/p.y*0.01*cos(p.x+time))*p.y;
	}
	
	color /= cos(p.x*0.002+time) * sin(p.y*0.001+time);
	
	gl_FragColor = vec4( vec3( color/atan(p.y*3.2*time)*p.x*0.3, color*0.6+cos(p.x*0.02)*p.y*0.03, color*2.6+cos(p.y*0.02)*p.x*3.3), 1.0 );
}
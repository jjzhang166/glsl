#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.1, 0.3, 0.1)*vec3(rand(position+time/1000.));

	float d2 = 1.;

	if (cos(position.y*40.+time*3.)<-0.95)
		color += vec3(0,0.02,0);	

	if (0.99999+cos(position.y*1.+time*0.8)<0.)
		color += vec3(0,0.05,0);
	
	gl_FragColor = vec4( color, 1.0 );
	
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define numBoxes 5.

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

   	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 middle = vec2(.5,.5);
	float lensSize =1.;
    	vec2 d = position - middle;
    	float r = sqrt(dot(d, d)); // distance from center
	
	
	float color = 0.0;
	
	
	
	color = r;
	
	float rndm = rand(vec2(0., 1.));
	float red = (floor(numBoxes * position.x) / numBoxes) * abs(sin(time / 2.));
	float green = (floor(numBoxes * position.y) / numBoxes) * abs(sin(time / 7.));
	float blue = (floor(numBoxes * r+1.) / numBoxes) * abs(cos(time / 3.));
	
	/*
	if (mod((position.x * 40.), 2.) == 0.) {
		color = abs(sin(time)); //(0.);
	}
	
	if (mod((position.y * 40.), 5.) == 0.) {
		color = abs(cos(time));
	}
	*/
	
	vec3 theColor = vec3(color * red, color * green, color * blue); //vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 );

	/*
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	*/
	gl_FragColor = vec4( theColor, 1.0 );

}
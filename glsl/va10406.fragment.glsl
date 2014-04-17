#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float iterations = 80.0;

void main( void ) {

	vec2 position = 1.3 * vec2( (gl_FragCoord.x - (resolution.x)*0.5) / resolution.y * 2.0 , (gl_FragCoord.y - resolution.y*0.5)/ resolution.y * 2.0);
	float color = 0.0;

	float zr = position.x;
	float zi = position.y;
	
	float tr = (0.55 + sin(time/100.0)*0.05)*cos(time/10.0);
	float ti = (0.55 + sin(time/100.0)*0.05)*sin(time/10.0);
	
	float cr = tr - tr*tr + ti*ti;
	float ci = ti - 2.0*tr*ti;
	
	for (float i=0.0; i < iterations; i++) {
	
		float tempr = zr*zr - zi*zi + cr;
		zi = 2.0*zr*zi - ci;
		zr = tempr;
		
		if ( (zr*zr + zi*zi) > 4.0) {
			color = 1.0 - (i/iterations);
			break;
		}
	
	}

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}
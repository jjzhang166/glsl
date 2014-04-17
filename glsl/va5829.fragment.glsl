#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define R 480385

// This prints "rules" (cut down from parent shader)

float showText(vec2 p, float r0, float r1, float r2, float r3, float r4, float r5, float r6) {
	if(p.y < 0. || p.y > 7.) return 0.; // Bit count Y
	if(p.x < 0. || p.x > 20.) return 0.; // Bit count X
		
	float v = r0;
	v = mix(v, r1, step(p.y, 6.));
	v = mix(v, r2, step(p.y, 5.));
	v = mix(v, r3, step(p.y, 4.));
	v = mix(v, r4, step(p.y, 3.));
	v = mix(v, r5, step(p.y, 2.));
	v = mix(v, r6, step(p.y, 1.));
	
	
	return floor(mod(v/pow(2.,floor(p.x)), 2.0));
}


void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	float show = 0.;

        vec2 v = vec2(22.-position.x*25. + sin(time), (cos(time) + position.y*25.) - 8. );
	
	for (int i = 0; i < 2; i++) {
          // R U L E S 
          // S E L U R    
	  show = showText(vec2(v),  480375., 349252., 349252., 480375., 414785., 349249., 358263.)-.5;
	}

	
	if (show> .2) gl_FragColor = vec4(1);
	
	
	

}
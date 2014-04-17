#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// This prints "rules" or "sucks" based on whether the shader is compiled and executed correctly

// Can anyone explain how this works?
// The thumbnail image is what it shows on my nexus 4


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
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	if (showText(vec2(16.-position.x*35.,position.y*25.-17.),22359., 21845., 21845., 30039., 9558., 9557., 10101.)>.5) gl_FragColor = vec4(1.);
	
	if (showText(vec2(34.-position.x*35.,position.y*25.-17.),29812., 17476., 17476., 21620., 21524., 21524., 30583.)>.5) gl_FragColor = vec4(1.);
	
	if (showText(vec2(15.-position.x*35.,position.y*25.-9.),7647., 4437., 4437., 4437., 4437., 4437., 7637.)>.5) gl_FragColor = vec4(1.);

	if (showText(vec2(33.-position.x*35.,position.y*25.-9.),119927., 87109., 87109., 119927., 70726., 70725., 71541.)>.5) gl_FragColor = vec4(1.);
	
	float show = 0.;
	for (int i = 0; i < 2; i++) {
		show = showText(vec2(22.-position.x*25.,position.y*25.-1.),480375., 349252., 349252., 480375., 414785., 349249., 358263.)-.5;
	}
	if (abs(show)<.1) {
		show += showText(vec2(22.-position.x*25.,position.y*25.-1.),481111., 283732., 283732., 480359., 87121., 87121., 489303.)-.5;
	}
	
	if (show> .2) gl_FragColor = vec4(1);
	
	
	

}
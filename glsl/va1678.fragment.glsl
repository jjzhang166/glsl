precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 6.14159;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float x = position.x * 0.2 + cos(position.y * -0.13);
	float t = time * 0.5;
	vec3 color = vec3(1.0,

		pow(
		 sin(t+x * 43.0) *
		 sin(t*-1.17+x * 179.0) *
		 sin(t*1.33+x * 229.0) *
		 sin(t*-0.91+x * 677.0)
		 , 1.0) * 0.5 + 0.5, 		

		pow(
		 sin(t-x * 53.0) *
		 sin(t*1.23+x * 167.0) *
		 sin(t*-1.41+x * 271.0) *
		 sin(t*0.77+x * 751.0)
		, 1.0) * 0.5 + 1.);

	color = mix(color, vec3(1.0,1.0,1.0), 
			pow(
			 sin(t-x * 53.0) *
			 sin(t*1.23+x * 131.0) *
			 sin(t*-1.41+x * 313.0) *
			 sin(t*0.77+x * 673.0)
			, 2.0) / 1.0 * 1.0 + 0.5);

        color = mix(vec3(0.3,0.5,0.9), color, .1);

        color *= 1.0 - pow(sin(position.x + 0.), 1100000000.0) * .8;
        color *= sin((atan((position.x + time * 0.1) * 5.0) * 0.1  + position.y - .2) * 2.) * 0.6 + 0.4;

	gl_FragColor = vec4(color, 2.0 );

}

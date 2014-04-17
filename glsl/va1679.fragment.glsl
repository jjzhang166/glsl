precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 6.14159;


vec3 colorAt(float t, float x, float y) {
	vec3 color = vec3(1.0,

		pow(
		 sin(t+x * 43.0 + y*22.) *
		 sin(t*-1.17+x * 179.0 - y*123.) *
		 sin(t*1.33+x * 229.0 + y*113.) *
		 sin(t*-0.91+x * 677.0 - y*541.)
		 , 1.0) * 0.5 + 0.5, 		

		pow(
		 sin(t-x * 53.0) *
		 sin(t*1.23+x * 167.0) *
		 sin(t*-1.41+x * 271.0) *
		 sin(t*0.77+x * 751.0)
		, 1.0) * 0.5 + 1.);

	color = mix(color, vec3(1.0,1.0,1.0), 
			pow(
			 sin(t-x * 53.0  + y*34.1) *
			 sin(t*1.23+x * 131.0 - y*41.54) *
			 sin(t*-1.41+x * 313.0 + y*152.) *
			 sin(t*0.77+x * 673.0 - y*531.)
			, 2.0) / 1.0 * 1.0 + 0.5);

        return vec3(0.2,0.4,0.9) * color * 10.;
}

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float x = position.x-.5;
	float t = time * 0.5;
	vec3 color = vec3(0);
	const int maxiter = 20;
	for (int i = 0; i < maxiter; i++) {
		float z = (float(i)+1.-fract(time)+1e-5);
		float y2 = position.y*z*.1;
		color += colorAt(t,x*.05*z+sin(y2*3.+time*.1)*.01,z*.005)*(1.-z/float(maxiter))/(.1+.1/(y2*y2)+pow(y2*5.,5.));
	}
	color /= float(maxiter);
	

	gl_FragColor = vec4(sqrt(color), 2.0 );

}

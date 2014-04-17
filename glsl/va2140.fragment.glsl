#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	p = -1.0 + 2.0 * p;
	
	vec2 psource = p;
	
	float alpha = time * 0.13;
	float sinA = sin(alpha), cosA = cos(alpha);
	mat2 rotA = mat2( cosA, sinA, -sinA, cosA );
	p = p * rotA;
	
	p = (2.0 + sin(time * 0.41)) * p;
	p = cos(p * 3.1416);
	
	float color = 0.0;
	
	vec2 a1 = vec2( sin( time * 1.17 ), sin( time * 1.47 ) );
	vec2 a2 = vec2( sin( time * 1.41 ), sin( time * 1.07 ) );
	vec2 a3 = vec2( sin( time * 1.31 ), sin( time * 1.21 ) );
	vec2 a4 = vec2( sin( time * 1.19 ), sin( time * 1.36 ) );
	vec2 a5 = vec2( sin( time * 1.91 ), sin( time * 1.74 ) );
	vec2 a6 = vec2( sin( time * 1.37 ), sin( time * 1.34 ) );
	vec2 a7 = vec2( sin( time * 1.43 ), sin( time * 1.65 ) );
	vec2 a8 = vec2( sin( time * 1.29 ), sin( time * 1.11 ) );
	
	color += 1.0 / dot(p-a1, p-a1);
	color += 1.0 / dot(p-a2, p-a2);
	color += 1.0 / dot(p-a3, p-a3);
	color += 1.0 / dot(p-a4, p-a4);
	color += 1.0 / dot(p-a5, p-a5);
	color += 1.0 / dot(p-a6, p-a6);
	color += 1.0 / dot(p-a7, p-a7);
	color += 1.0 / dot(p-a8, p-a8);
	
	color = sin ( pow(0.8, color) * 50.0 - time * 0.333 );
	color = 1.0 + color / 2.0;
	color = pow(color, 3.0);
	color = atan(color);
	
	gl_FragColor = vec4( vec3( 1.0, 0.5, 0.2) * color + sin( color * 3.1416 * 3.0) * vec3(0.2, 0.8, 0.9), 1.0 );

}
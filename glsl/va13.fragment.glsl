// by @mrdoob, @paniq

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;
	vec2 position = vec2(0.707 * (p.x - p.y), 0.707 * (p.x + p.y));

	vec3 color;
	color += sin( position.x * cos( time / 3.0 ) * 81.0 ) + cos( position.y * cos( time / 7.0 ) * 13.0 ) * vec3(1,0.5,0.25);
	color += sin( position.x * sin( time / 5.0 ) * 11.0 ) + tan( position.y * sin( time / 13.0 ) * 83.0 ) * vec3(0.25,0.5,1);
	color *= 1.0/3.0;

	gl_FragColor = vec4( color, 2.0 );

}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float red = mod(1./255.+texture2D(backbuffer, position).r, 1.);
	float yoffset = texture2D(backbuffer, position).r;
	float color = 1./255.;
	vec2 oldpos1 = vec2(resolution.x-1.0, resolution.y);
	vec2 oldpos2 = vec2(resolution.x-2.0, resolution.y);
	float green = mod((texture2D(backbuffer, oldpos1).g+texture2D(backbuffer, oldpos2).g), 2.)*distance(yoffset, position.y);


	gl_FragColor = vec4( vec3(red , green+color, color ), 1.0 );
	//gl_FragColor = vec4( vec3(color), 1.0 );

}
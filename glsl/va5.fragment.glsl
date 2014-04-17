// by Fcuking_Someone
// based on clover leaf from http://www.youtube.com/watch?v=-z8zLVFCJv4

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 pattern( vec2 p, vec3 c, float m ) {

	float r = sqrt( dot( p, p ) );
	float a = atan( p.y, p.x ) + time * 9.1;
	float s = 0.9 + 0.75 * sin( .0 / a );
	float t = 0.25 + 0.05 * pow( s, 0.5 );
	t += 0.1 * pow( 0.0125 + 0.25 * cos( 10.0 * a ), 0.95 );
	float h = r/t;
	float f = 0.0;
	if ( h > 1.0 ) f = 1.0;
	return vec4( mix( vec3( 0.250, 0.250, 0.250 ), h / c, m * f ), h*h ); 
}

void main( void ) {

        vec2 position = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x/resolution.y;

	vec2 p = position * 2.0 - 1.0 - 2.0 * mouse + 1.0;
	p.x *= aspect; 

	float k = 0.5 + abs(sin(0.125*time) )* 0.825;

	vec4 c1 = pattern(p * k, vec3(0.0), 0.0); 
	
	vec4 c2 = pattern(p*0.012, vec3(0.9, 0.5, 0.0), 1.0); 

	gl_FragColor = 1.0 - c1.w * c1 + (1.0 - c1.w) *c2;
	gl_FragColor = mix( gl_FragColor, gl_FragColor + gl_FragColor, k );

	gl_FragColor.xyz = clamp( gl_FragColor.xxz, vec3(0.0), vec3(1.2) );

	gl_FragColor = vec4( mix( gl_FragColor.rgb, vec3( 0.0 ), dot( position - 0.5, aspect + (position - 0.5)) ), gl_FragColor.a );
	gl_FragColor = mix( gl_FragColor, texture2D( backbuffer, position ), 0.8 ) ;

}
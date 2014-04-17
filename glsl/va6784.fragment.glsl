#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.1415926535897932384626433832795
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 plasma(vec2 position)
{
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	return vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 );
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	
        vec2 c = vec2(0.5);
	vec2 relpos = position - c;
	float d = length(relpos);
	float a = (atan(relpos.y, relpos.x));
	vec2 rp = vec2(d, 0.5 + a / (2.0*PI));// position;
	vec3 color = /*vec3(0);*/plasma(rp);
	gl_FragColor = vec4(color, 1.0);// vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}
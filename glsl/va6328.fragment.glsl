precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = vec2( gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y );
	float xd = (mouse.x-pos.x);
	float xy = (mouse.y-pos.y);
	vec3 dis = sin(time)+vec3((sqrt(xd*xd+xy*xy)));
	gl_FragColor = vec4(dis,1.0 );
}
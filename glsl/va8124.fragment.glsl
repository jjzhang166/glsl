#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0);
	float a = atan(p.y-0.5,p.x-0.5)+3.1492*0.5;
	vec3 t = texture2D(backbuffer,(p-vec2(0.5)*vec2(cos(a),sin(a))*length(p)*-0.1)).rgb;
	t = texture2D(backbuffer,(p-vec2(0.5)*vec2(cos(a-t.r*0.1),sin(a-(t.g)*0.1))*(length(p)-(t.b))*0.03)).rgb;
	color = pow(1.0-length(p-mouse)*0.8,80.)*100.*vec3(sin(time*vec3(1.1,1.4,1.8)));
	color =	(color*0.2+t*0.995);
	gl_FragColor = vec4( color, 1.0 );
	
}
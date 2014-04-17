#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec2 uv = position - mouse;
	//uv-=(mouse);
	
	vec4 col;
	col.r = 5. * length(uv); //.1/(length(uv)+.009);
	
	col = pow(col.r,1.)*vec4(0.0,0.0,1.0,0.0);
	
	float scale=1.5;
	float attenuation=.9;
	vec2 displacement=vec2(0.,0);
	
	//col+=attenuation*texture2D(bb,((position))*scale+.5)-.005;

	gl_FragColor = col;
}
#ifdef GL_ES
precision highp float;
#endif

//uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

//uniform sampler2D tex;

vec4 asd(float px, float py){
	float color = 0.0;
	
	vec2 p = vec2(px-0.8, py-0.8);
	
	if (length(p)<.125) color = 1.0;
	return vec4( vec3( color, color, color ), 1.0 );

//	return texture2D(tex, vec2(px,py));

}

void main( void ) {
	float d = 0.16;
	vec2 pos = (gl_FragCoord.xy / 10.0) ;

//	vec2 pos = gl_TexCoord[0].st;
	
	vec4 cola = asd(pos.x, pos.y);
	vec4 col1 = asd(pos.x-d, pos.y) / 3.0;
	vec4 col2 = asd(pos.x+d, pos.y) / 3.0;
	
	gl_FragColor = vec4(cola.r+col1.r+cola.r, cola.g+col1.g+col2.g, cola.b+col2.b, 1.0);
}
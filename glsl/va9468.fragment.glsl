#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

bool isRelativeEqual(vec2 v1, vec2 v2, float bias){
	return (v1.x - bias < v2.x && v1.x + bias > v2.x && v1.y - bias < v2.y && v1.y + bias > v2.y);
}
	
void main( void ) {

	float muli = 4.0;	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 off = 1.0 / resolution; 
	

	vec4 pix = texture2D(tex, position);


	

	vec4 opix = texture2D(tex, position + vec2(0.0, off.y * muli));
	opix += texture2D(tex, position + vec2(0.0, -off.y * muli));
	opix += texture2D(tex, position + vec2(-off.x * muli, 0.0 ));
	opix += texture2D(tex, position + vec2(off.x * muli, 0.0));
	opix += pix;
	
	opix /= 5.0;
	
	pix = opix - vec4(0.00004,0.00005,0.0000001,0.0);


	
	pix -= vec4(0.0004,0.00005,0.0000001,0.0);

	if(isRelativeEqual(position,mouse, 0.01)){
		pix = vec4(1.0,0.25,0.5, 1.0);
	}
	
	gl_FragColor = pix;
	

}
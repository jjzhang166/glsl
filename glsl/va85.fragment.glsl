// @Flexi23 - Wolframs rule [imaginary unit product]
// forked from http://glsl.heroku.com/85/5

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

void main( void ) {
 	vec2 pos = gl_FragCoord.xy / resolution;
 	vec2 pixel = 1. / resolution;

	bool mousePixel = pos.x + pixel.x > mouse.x && pos.x < mouse.x && pos.y + pixel.y > mouse.y && pos.y < mouse.y;
	float seed = mousePixel ? 1. : 0.;

	vec2 borderSize = pixel*4.;
	bool borderMask = pos.x < borderSize.x || pos.x > 1.-borderSize.x || pos.y < borderSize.y || pos.y > 1.- borderSize.y ;

	// Wolfram rule in .x

	float dx = (mouse.x-0.5)*4.;

	vec4 left = texture2D(backbuffer, pos + vec2(dx,1.)*pixel);
	vec4 center = texture2D(backbuffer, pos + vec2(dx,0)*pixel);
	vec4 right = texture2D(backbuffer, pos + vec2(dx,-1.)*pixel);

	// rule 90
	vec4 wolfram54  = left * (1.-center) * right+ left * (1.-center) * (1.-right) + (1.-left) * (1.-right) * center + (1.-left) * right * (1.-center);
	vec4 wolfram90  = left * center * (1.-right)+ left * (1.-center) * (1.-right) + (1.-left) * right * center + (1.-left) * right * (1.-center);
	vec4 wolfram126 = 1.- ( left * center * right + (1.-left) * (1.-center) * (1.-right));
	vec4 wolfram150 = left * center * right + left * (1.-center) * (1.-right) + (1.-left) * center * (1.-right)+ (1.-left) * (1.-center) * right;
	
	gl_FragColor = vec4(0);
	gl_FragColor.z = borderMask ? 0. : wolfram150.z + seed;
	gl_FragColor.y = borderMask ? 0. : wolfram90.y + seed;
	gl_FragColor.x = borderMask ? 0. : wolfram126.x + seed;
	gl_FragColor.a = 1.;
}
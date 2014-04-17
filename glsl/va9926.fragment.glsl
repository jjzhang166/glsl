#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI  4.*atan(1.) 

//many thanks to http://glsl.heroku.com/e#9921.1
//sphinx

float box(vec2 p, vec2 s, vec2 uv);

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);

	vec4 color;

	float angle = atan(position.x,position.y);
	
	color = vec4( 
		(sin(angle-(3.0*PI/2.0))+1.0)/2.0,
		(sin(angle)+1.0)/2.0,
		(sin(angle+(3.0*PI/2.0))+1.0)/2.0,
		 PI*sin(length(position))
		);
	
	
	//Display Box
	vec2 boxScale = vec2(16., 9.);
	vec2 boxPosition = position + vec2(0.5);
	float boxMask = box(mouse, boxScale, boxPosition);
	vec2 tpos = mouse + vec2(0.5);
	vec2 t = position*boxScale-tpos*boxScale;
	vec2 uv = fract(t);
	vec2 boxSample = uv*boxMask;
	
	angle -= angle-atan(mouse.x - .5, mouse.y - .5);
	
	vec4 boxColor =
		vec4( 
			(sin(angle-(3.0*PI/2.0))+1.0)/2.0,
			(sin(angle)+1.0)/2.0,
			(sin(angle+(3.0*PI/2.0))+1.0)/2.0,
			PI * sin(length(vec2(0.5, 0.5) - mouse))
		);
	
	float boxBorder = box(mouse-vec2(0.003, 0.0061), boxScale * .9, boxPosition);
	
	boxColor *= boxColor.a;
	boxColor *= vec4(boxMask);
	boxColor = clamp(boxColor, 0., 1.);
	
	
	color = color * color.a;
	color *= 1.-vec4(boxBorder);
	color = clamp(color, 0., 1.);
	
	color += boxColor;
	
	gl_FragColor = color;
}


float box(vec2 p, vec2 s, vec2 uv){
	vec2 t = uv*s-p*s;
				 
	float b = 0.;			 
	
	b = (t.x > 0. && t.y > 0.) && (t.x < 1. && t.y < 1.) ? 1. : 0.;
	
	return b;
}
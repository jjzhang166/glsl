
//Conway's game of life--not really working yet

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool first = true;
uniform sampler2D buffoon;
vec4 live = vec4(1.,1.,1.,1.);
vec4 dead = vec4(0.,0.,0.,0.);

float rand(vec2 n)
{
  return (fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453) < 0.2) ? 1. : 0.;
}


bool close(vec2 a, vec2 b){
	vec2 diff = a - b;
	return (abs(diff.x) < .1 && abs(diff.y) < .1);
}

void main( void ) {
	//return;
	vec2 position = gl_FragCoord.xy;
	if(mouse.xy.x<=.05){
		//if(position.x < 100.){
		//float c = rand(gl_FragCoord.xy);
		//gl_FragColor = vec4(c,c,c,c);
		if(close(position , vec2(1., 1.)) || close(position.xy , vec2(1., 1.)) || close(position.xy , vec2(1., 1.))){
gl_FragColor = live;
}

	}else{
		float sum = 0.;
		sum += texture2D(buffoon, position + vec2(-1., -1.)).x;
		sum += texture2D(buffoon, position + vec2(-1., 0.)).x;
		sum += texture2D(buffoon, position + vec2(-1., 1.)).x;
		sum += texture2D(buffoon, position + vec2(1., -1.)).x;
		sum += texture2D(buffoon, position + vec2(1., 0.)).x;
		sum += texture2D(buffoon, position + vec2(1., 1.)).x;
		sum += texture2D(buffoon, position + vec2(0., -1.)).x;
		sum += texture2D(buffoon, position + vec2(0., 1.)).x;

		if(texture2D(buffoon, position).x == 0.){
			if((sum - 3.) < .1){
				//gl_FragColor = live;
			}
		}else{
			if(sum >= 1.9 && sum <= 3.1){
				//gl_FragColor = live;
			}
			//gl_FragColor = live;
		}
	}
	
}
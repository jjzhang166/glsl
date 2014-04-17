#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//FlexiFlower by CuriousChettai@gmail.com

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center

	float angle = atan(uPos.y, uPos.x);
	float len = sqrt(uPos.x*uPos.x + uPos.y*uPos.y);

	float newAngle = angle - 0.1*sin(len*20.0-time*8.0) - 0.9*sin(len*5.0-time);
	float flower = 1.0 - smoothstep(0.2, 0.5, len);;
	flower *= 5.0 * (sin(newAngle*20.0 )+1.0);	
	vec3 flowerColor = vec3(flower*0.4, flower*0.1, flower*0.6);
	
	float gradient = smoothstep(0.5, 1.5, len);
	vec3 gradientColor = vec3(gradient*0.4, gradient*0.1, gradient*0.6);
	
	vec3 color = flowerColor + gradientColor;
	gl_FragColor = vec4(color, 1.0);
}
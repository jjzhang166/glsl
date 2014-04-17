#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position =  ( gl_FragCoord.xy / resolution.xy ) * 4.0  - 2.0;

	vec2 firstLight;
	firstLight.x = cos(time) * 0.8;
	firstLight.y = sin(time) * 0.8;
	
	vec2 secondLight;
	secondLight.x = firstLight.x + sin(time * 2.0) * 0.5;
	secondLight.y = cos(time / time ) * 0.8;
	
	vec2 thirdLight;
	thirdLight.x = firstLight.x - sin(time * 6.0) * 0.5;
	thirdLight.y = secondLight.y + cos(time * 6.0) * 0.5;
	
	float firstLightRot = dot(position - firstLight, position - firstLight) * pow(50.0, 1.5);
	float secondLightRot = dot(position - secondLight, position - secondLight) * 16.0;
	float thirdLightRot = dot(position - thirdLight, position - thirdLight) * 4.0;
	
	float color = pow(1.0 / firstLightRot + 1.0 / secondLightRot + 1.0 / thirdLightRot, 0.4);
	
	float dist = distance(firstLight, secondLight + thirdLight);
	

	gl_FragColor = vec4(color / sqrt(dist), sqrt(color * color) * dist, color * dist + color , 1.0 );

}
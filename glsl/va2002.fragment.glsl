#ifdef GL_ES
precision mediump float;
#endif
//sfafg
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	const float lightStrenght = 0.4; //0 is no light 1 is full
	
	vec4 ambientColor = vec4(0,0,0,1);
	vec4 lightColor = vec4(1,1,1,1);
	vec2 lightPos = mouse;
	float aspectRatio = resolution.x/resolution.y;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);
	
	float xDif = abs(mouse.x-position.x);
	float yDif = abs(mouse.y-position.y)/aspectRatio;
	float dist = sqrt(xDif*xDif + yDif*yDif);
	
	me = ambientColor + lightStrenght-(dist * lightColor) * 5.0;
	
	gl_FragColor = me;
	
}
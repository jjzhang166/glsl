#ifdef GL_ES
precision mediump float;
#endif
//sfafg
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	
	vec4 ambientColor = vec4(0,0,0,1);
	vec4 lightColor = vec4(1,1,1,1);
	vec2 lightPos = mouse;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);
	
	float xDif = abs(mouse.x-position.x);
	float yDif = abs(mouse.y-position.y);
	float dist = sqrt(xDif*xDif + yDif*yDif);
	
	me = ambientColor + 1.0-(dist * lightColor) * 5.0 ;
	
	gl_FragColor = me * vec4(cos(time / position.x),cos(time / position.y),cos(time / position.x),1.0);
	
}
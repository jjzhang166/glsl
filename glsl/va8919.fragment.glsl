#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

			 
void main( void ) {
	vec2 mouseCoord = mouse*resolution;
	vec2 distance = gl_FragCoord.xy - mouseCoord;
	   
	float scale = resolution.y*10.0;
	
	//Tyler's stupid radius
	float radius = scale + 0.5*scale*sin(time*3.0);
	   
	gl_FragColor=mix( vec4(1.0, 1.0, 1.0, 1.0), vec4( texture2D(backbuffer, gl_FragCoord.xy / resolution) ),
					smoothstep( radius, radius*radius / (scale * 0.5), dot(distance, distance) ) );
	
	gl_FragColor -= 0.5*vec4(0.01, 0.02, 0.03, 1.0);
}
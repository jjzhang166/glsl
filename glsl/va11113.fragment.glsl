#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = mouse;
	vec3 colour = vec3(1, 0, 0);
	float zoomRate = 1.0;
	
	if(length(mouse*resolution-gl_FragCoord.xy) > 20.)
	{
		float deltax = gl_FragCoord.x / resolution.x - mouse.x;
        	float deltay = gl_FragCoord.y / resolution.y - mouse.y;
		float angleRadians = atan(deltay, deltax) + 3.14159265;
		float newx = gl_FragCoord.x + cos(angleRadians) * zoomRate;
	        float newy = gl_FragCoord.y + sin(angleRadians) * zoomRate;
		
		colour.r = newx;
		colour.g = newy;
	}
	
	gl_FragColor = vec4( colour, 1);

}
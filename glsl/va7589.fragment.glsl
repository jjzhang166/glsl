#ifdef GL_ES
precision highp float;
#endif


uniform sampler2D backbuffer;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
     	float pixelwide = 1.0 / resolution.x;
     	float pixelhigh = 1.0 / resolution.y;
	
     	vec2 position = gl_FragCoord.xy / resolution.xy;

    	 vec2 v = position - mouse;
	
	float w = (position.x - mouse.x) * (resolution.x / resolution.y);
	float h = position.y - mouse.y;
	float dist = sqrt(w * w + h * h);

	float radius = 0.1;
	vec4 maxColor = vec4(sin(time * 3.0) + 0.25 + 0.75, cos(time * 3.0) * 0.25 + 0.75, sin(time * 1.0) * 0.5 + 0.5, 1.0);
	vec4 minColor = vec4(0.0, 0.0, 0.0, 0.0);
	float x = dist * (1.0 / radius);
	
	//color from mouse
        vec4 newColor = smoothstep(maxColor, minColor, vec4(x, x, x, 1.0));
	
	//rotate
	vec2 moved = position - vec2(0.5, 0.5);
	moved *= 1.01; /*いじると面白�?/
	float theta = .1; /*いじると面白�?/
	moved *= vec2(resolution.x / resolution.y, 1.0); /*幅補�?/
	vec2 rotated = vec2(moved.x * cos(theta) - moved.y * sin(theta), 
			    	        moved.x * sin(theta) + moved.y * cos(theta));
	rotated /= vec2(resolution.x / resolution.y, 1.0); /*幅補�?/
	vec2 result = rotated + vec2(0.5, 0.5);
	gl_FragColor = max(texture2D(backbuffer, result), newColor) * 0.999;
	

     	if(abs(position.y - 1.0) < 0.01)
          	gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

     //gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}      

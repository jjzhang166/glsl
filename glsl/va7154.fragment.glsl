#ifdef GL_ES
precision mediump float;
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
	
	
	
	bool isCircle = false;
	
	float step = 0.015;
	float offset = -step * 30.0;
	for(int i = 0 ; i < 60 ; ++i)
	{
		offset += step;
		float w = (position.x - (offset + mouse.x)) * (resolution.x / resolution.y);
		float h = position.y - mouse.y;
		if(sqrt(w * w + h * h) < 0.01)
		{
			isCircle = true;
			break;
		}
	}
	
	if(isCircle)
	{
		gl_FragColor = vec4(sin(time * 3.0 + offset * 100.0) * 0.25 + 0.75, sin(time * 2.0) * 0.25 + 0.75, sin(time * 1.0) * 0.5 + 0.5, 1.0);
	}
	else
	{
		vec4 self = texture2D(backbuffer, position);
		
		vec4 up = texture2D(backbuffer, position - vec2(0, pixelhigh));
		
		
		
		gl_FragColor = texture2D(backbuffer, position + vec2(0, pixelhigh * 2.0));
	}
	
	if(abs(position.y - 1.0) < 0.01)
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	
	//gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}	 
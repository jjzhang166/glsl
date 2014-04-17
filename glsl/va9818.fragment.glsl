#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	const float M_PI = 3.1415926535897932384626433832795; 
	float m_CoolDownLeft = mod(time, 20.0) / 10.0 - 1.0;

	vec4 color = vec4(1, 0, 0, 1);
	
	float pPart = -m_CoolDownLeft * M_PI - M_PI / 2.0;
	float angle = atan(position.y - 0.5, position.x - 0.5);
	if (angle > M_PI / 2.0 && angle < M_PI){
		pPart = M_PI / 2.0 + pPart;
		angle = angle - M_PI - M_PI / 2.0;
	}

	if (angle < pPart){
		color.rgb *= 0.5;
	}
	
	gl_FragColor = color;

}
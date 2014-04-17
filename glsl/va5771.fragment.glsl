# ifdef GL_ES
precision mediump float;
# endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main()
{
	vec3 layerOne;
	
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	
	vec2 screen =  (gl_FragCoord.xy / resolution.xy) / 2.0;
	
	float shiftX = mod( screen.x + (time / 25.0), 0.1);
	float shiftY = mod( screen.y + (time / 50.0), 0.1);
	
	r = (sin(time) / 2.0) + 1.0;
	r *= -( screen.x ) + 1.0;
	
	g = (-sin(time) / 2.0) + 1.0;
	g *= screen.y;
	
	b = 0.5;
	
	layerOne = vec3( vec3(r - shiftX, (g - shiftY - 0.3), b - (shiftY + shiftX)) * 0.5);
	
	//------------------------------
	
	vec3 layerTwo;
	
	float r2 = 0.0;
	float g2 = 0.0;
	float b2 = 0.0;
	
	r2 = (-sin(time)) - 0.2;
	g2 = (sin(time)) - 0.7;
	b2 = mod(screen.x, mod(b2, 2.0));
	
	layerTwo = vec3( r2, g2 - 0.3, b2);

	gl_FragColor = vec4( (layerTwo + layerOne) * 0.75, 1.0);
}

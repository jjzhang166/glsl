#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Shader by Stefan (ish) Popp - TiTANDemo 2012 #titandemo at Efnet / IshaV6 
// Twitter - @fuxx0r

#define M_PI 3.14159265

float booble(float x, float y) {
	
	float thing;

	thing += (sin(x)*M_PI*2.0)+cos(x+time);
	thing += (cos(y)*M_PI)+sin(y+time);
	return thing;
}

float scrollBlobs(float x, float y) {
	float thing = (sin(time+x)/M_PI)-(cos(gl_FragCoord.y/100.0));
	thing -= sin(time+y) / cos(y)*100.0;
	return pow(thing/1000.0,cos(time));
}

void main()
{

	vec3 colorDivision = vec3(4.449, 12.236, 20.0);
	
	float zoom = 10.0;
	float cameraX = (zoom*5.0)/10.0;
	float cameraY = (zoom*3.0)/10.0-0.5;

	vec2 p = vec2(gl_FragCoord.xy / (resolution.x * 1.0 / zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	
	float a = booble(x,y);
	float b = scrollBlobs(x,y);

	gl_FragColor = vec4((sqrt(a)+sqrt(b))/colorDivision.x, (sqrt(a)+sqrt(b))/colorDivision.y, (sqrt(a)+sqrt(b))/colorDivision.z, 1.0);
}
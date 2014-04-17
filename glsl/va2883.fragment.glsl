// ish #titandemo @efnet
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265

float booble(float x, float y) {
	
	float thing;

	thing = atan(sin(x))*sin(y)*cos(y*x)*(M_PI*0.5*cos(x));
	float cross = clamp(cos(sqrt(sqrt(x*time)*y)*(0.5))*(M_PI)*(x/y*(sin(time)*atan(time)*M_PI)), 2.0, 50.0);
	
	thing *= cross;
	thing *= 10.0;
	return thing;
}

float waves(float x, float y) {
	float wave = sqrt(cos(time))*sqrt(cos(time*x*y));
	return wave;
}


void main()
{

	vec3 colorDivision = vec3(9.089, 100.0, 87.642);
	
	float zoom = clamp(10.0/smoothstep((cos(time/2.0)/M_PI),10.0, 5.0), 2.0, 50.0);
	float cameraX = (zoom*5.0)/15.0*cos(time/2.0)*M_PI;
	float cameraY = (zoom*3.0)/15.0-0.5*sin(time/2.0)*(M_PI*2.0);

	vec2 p = vec2(gl_FragCoord.xy / (resolution.y * 1.0 / zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	
	float a = booble(y,y);
	float b = waves(x, y);

	gl_FragColor = vec4((sqrt(a)*sqrt(b))/colorDivision.x, (sqrt(a)+sqrt(b))/colorDivision.y, (sqrt(a)+sqrt(b))/colorDivision.z, 1.0);
}

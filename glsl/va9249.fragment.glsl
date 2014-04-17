#ifdef GL_ES
precision lowp float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D buff;

//Mathematical constants
const float pi = 3.14159;

//Spacial constants
const int   iters = 50;
const float zoom = 0.25;
const float centerx = 0.0;
const float centery = 0.0;

//Temporal constants
const float period = 50.0;
const float mint = -0.5;
const float maxt = 0.6;
const float alpha = 0.002;
const float beta = 0.5;

//Color constants
const float sharpness = 10000.0;

vec2 chaosGame(vec2 v, float t) {
	return vec2(
		v.y + v.x*t + mouse.x,
		v.y*v.x - t - v.x + mouse.y
	);
}

void main() {
	//Get time and space parameters
	vec2 p = (gl_FragCoord.xy - resolution*0.5) / (resolution * zoom) - vec2(centerx, centery);
	float t = (sin(time * pi * 2.0 / period)*(maxt - mint) + (maxt + mint))*0.5;
	vec4 oldCol = texture2D(buff,gl_FragCoord.xy/resolution);
	
	//Setup equation
	vec2 v = vec2(t,t);
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

	//Iterate
	for (int i = 0; i < iters; i++) {
		//Main update equation
		v = chaosGame(v, t);

		//Calculate distance
		vec2 diff = v - p;
		float dist = diff.x*diff.x + diff.y*diff.y;
		float mult = 1.0/(dist*sharpness + 1.0);

		//Update color
		float r = mod(float(i)*71.0, 250.0)/250.0;
		float g = mod(float(i)*31.0, 250.0)/250.0;
		float b = mod(float(i)*201.0, 250.0)/250.0;
		color += vec4(r, g, b, 0.0)*mult;
	}
	
	//Draw the point in the correct color
	gl_FragColor = max(oldCol - vec4(alpha),color);
}
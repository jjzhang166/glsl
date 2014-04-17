#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float myMod(float x, float y);

void main( void ) {
/*
	float myTime = time * 6.5;
	myTime = time + (sin(myTime) > 0.5 ? sin(myTime) : 0.5);
	vec2 pos = vec2(0.5, 0.5) - ( gl_FragCoord.xy / resolution.xy );
//	vec2 pos = vec2(sin(myTime) / 2.0 + 0.5, cos(myTime) / 2.0 + 0.5) - ( gl_FragCoord.xy / resolution.xy );
	float l = 1. - sqrt(pos.x * pos.x + pos.y * pos.y);
	float g =l < 0.8 ? pos.x * cos(myTime) + pos.y * sin(myTime) < 0.0 ? 0.0 : 1.0 : 1.0;
	float r = l < 0.8 ? pos.y * -cos(myTime) + pos.x * sin(myTime) < 0.0 ? 0.0 : 1.0 : 1.0;
	float b = l < 0.8 ? pos.x * cos(myTime) + pos.y * sin(myTime) > 0.0 ? 0.0 : 1.0 : 1.0;
	gl_FragColor = vec4(r, g, b, 1.0);
/*/
//*/
	float test = (10.0 - myMod(time * 23.0, 10.0)) / 10.0;
	float speed = time / 50.0;
	float myTime2 = (sin(speed) > 0.5 ? sin(speed) : 0.5);
	float myTime = time + myTime2;
	vec2 pos = vec2(0.5, 0.5) - ( gl_FragCoord.xy / resolution.xy );
//	vec2 pos = vec2(sin(myTime) / 2.0 + 0.5, cos(myTime) / 2.0 + 0.5) - ( gl_FragCoord.xy / resolution.xy );
//*
	float l = 1. - sqrt(pos.x * pos.x + pos.y * pos.y);
	float r = l < 1.2 - myTime2 / 1.5 ? pos.y * -cos(myTime) + pos.x * sin(myTime) < 0.0 ? 0.0 : 1.0 : test;
	float g = l < 1.2 - myTime2 / 1.5 ? pos.x * cos(myTime) + pos.y * sin(myTime) < 0.0 ? 0.0 : 1.0 : test;
	float b = l < 1.2 - myTime2 / 1.5 ? pos.x * cos(myTime) + pos.y * sin(myTime) > 0.0 ? 0.0 : 1.0 : test;
/*/
	float r, g, b;
	const int count = 200;
	const float size = 0.02;
	for(int i = 0; i < count; ++i){
		float radius = float(i)/ float(count);
		vec2 bPos = vec2(sin(speed * float(i)) * radius / 2.0, cos(speed * float(i)) * radius / 2.0);
		float c = length(pos - bPos) > 0.01 ? 0.0 : 1.0;
		r += c * radius; g += c / radius; b += c;
	}
//*/
//*
	gl_FragColor = vec4(r, g, b, 1.0);
/*/
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
//*/
}

float myMod(float x, float y){ return x - y * float(int(x / y)); }
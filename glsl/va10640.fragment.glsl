#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 pb1;
vec2 pb2;
vec2 pb3;

vec2 runner;

vec2 bezier2(vec2 p1, vec2 p2, vec2 p3, float u)
{
	vec2 p12 = p1 + ((p2 - p1)* u);
	vec2 p23 = p2 + ((p3 - p2) * u);
	
	return p12 + ((p23 - p12) * u);
}

vec2 circlePos(vec2 center, float radius, float angle)
{
	return center + (vec2(cos(angle), sin(angle)) * radius);
}

void setPoints() {
	pb1 = circlePos(vec2(0.5, 0.5), 0.1, time);
	pb2 = circlePos(pb1, 0.1, -1.0*time/2.0);
	pb3 = circlePos(pb1, cos(time)*0.3, sin(time)+2.0);
	
	//pb1 = vec2(0.2, 0.2);
	//pb2 = vec2(.5,.7);
	//pb3 = vec2(.8,.3);
	
	runner = bezier2(mouse, pb2, pb3, (sin(time)+1.)*0.5);
}


void main( void ) {

	vec2 uv = gl_FragCoord.xy/resolution;
	
	setPoints();
	
	vec3 color = vec3(1.0, 1.0, 1.0);
	
	float l1 = length(pb1 - uv);
	float l2 = length(pb2 - uv);
	float l3 = length(pb3 - uv);
	
	
	vec3 light1 = vec3(l1, l1, l1) * 9.0;
	vec3 light2 = vec3(l2, l3, l2) * 5.0;
	vec3 light3 = vec3(l3, l3, l3) * 15.0;
	
	
	vec3 ambColor = vec3(color * light1 * light2 * light3);
	
	vec3 runColor = vec3(1.0, 1.0, 1.0);
	
	float distRunner = length(runner - uv);
	if (distRunner < 0.005) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	} else
	{
		gl_FragColor = vec4(runColor / ambColor, 1.0);
	}

}
#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float SCREENZOOM = 7.0;

float bpm = 0.7;
float speed = 0.01;

vec3 blob(vec2 p, float speed, float x, float y, vec3 color, float size) {
	float stime = time * speed;
	float crazy1 = stime;
	float crazy2 = bpm * stime;
	vec2 pos = vec2(cos(crazy1*(x + 3.0)),sin(crazy2*(y + 3.0)));
	return color * size/(distance(p, pos));
}

void main( void ) {
	//bpm = sin(time / 5000.0);
	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM;
	vec3 color = vec3(0.0);

	for(float i = 0.; i < 50.0; i++){
		color += blob(p, speed, i, i, vec3(cos(time * bpm), -sin(time * bpm), sin(time * bpm)), 0.08);
	}
	color /= 20.0;

	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;

}
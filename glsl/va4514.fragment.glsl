#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float SCREENZOOM = 5.0;
float BUFFERZOOM = 0.998;
float BUFFERFADE = 0.0;

float bpm = 140.56 / 120.0;

vec3 blob(vec2 p, float speed, float x, float y, vec3 color, float size) {
	float stime = time * speed;
	float crazy1 = stime;
	float crazy2 = bpm * stime;
	vec2 pos = vec2(cos(crazy1*(x + 2.0)),sin(crazy2*(y + 3.0)));
	return color * size/(distance(p, pos));
}

float rand(vec2 co){
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM * 0.7;
	vec3 color = vec3(0.0);
	
	for(float i = 0.; i < 25.0; i++){
		color += blob(p, 0.16, i, i, vec3(cos(i/25.0), sin(i/25.0), exp(-i)), 0.05);
	}
	color /= 4.0;
	
	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;

}
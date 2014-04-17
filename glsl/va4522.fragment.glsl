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

vec3 blob(vec2 p, float speed, float x, float y, vec3 color, float size) {
	float stime = time * speed;
	vec2 pos = vec2(cos(stime*x),sin(stime*y));
	return color * size/(distance(p, pos));
}

float rand(vec2 co){
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM * 0.7;
	vec3 color = vec3(0.0);
	
	for(float i = 0.; i < 25.; i++){
		color += blob(p, 0.6, i, i, vec3(cos(i/25.), sin(i/25.), exp(-i)), 0.05);
	}
	color /= 3.0;
	
	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;

}
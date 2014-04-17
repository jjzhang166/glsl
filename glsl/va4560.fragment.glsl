#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//uniform samp
//	D bb;

float SCREENZOOM = 20.0;
float BUFFERZOOM = 0.998;
float BUFFERFADE = 0.0;

float bpm = 140.56 / 1200.0;

vec3 blob(vec2 p, float speed, float x, float y, vec3 color, float size,float offsetX,float offsetY) {
	float stime = time * speed;
	float crazy1 = stime;
	float crazy2 = bpm * stime;
	vec2 pos = vec2(offsetX+cos(crazy1*(x + 2.0)),offsetY+sin(crazy2*(y + 3.0)));
	return color * size/(distance(p, pos));
}

float rand(vec2 co){
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM * 0.7;
	vec3 color = vec3(0.0);
	
	for(float i = 0.; i < 20.0; i++){
		color += blob(p, 0.16, i, i, vec3(1.5*cos(i/25.0), 0.6*sin(i/25.0), 0.0*exp(-i/50.0)), 0.05,0.0,0.0);
		color += blob(p, 0.16, i, i, vec3(1.3*sin(i/25.0), 0.6*cos(i/25.0), 0.5*exp(-i/50.0)), 0.05,2.0,0.0);
		color += blob(p, 0.16, i, i, vec3(1.4*cos(i/25.0), 2.0*sin(i/25.0), 1.0*exp(-i/50.0)), 0.05,4.0,0.0);
		color += blob(p, 0.16, i, i, vec3(1.0*cos(i/25.0), 5.0*sin(i/25.0), 1.5*exp(-i/50.0)), 0.05,2.0,2.0);
		color += blob(p, 0.16, i, i*0.5, vec3(1.5*cos(i/25.0), 0.6*sin(i/25.0), 0.0*exp(-i/50.0)), 0.05,2.0,-2.0);
	}
	color /= 5.0;	
	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;
	//gl_FragColor.x += sin(gl_FragColor.x)
	///gl_FragColor += vec4(col2,1.0);
	//gl_FragColor += vec4(col3,1.0);
}
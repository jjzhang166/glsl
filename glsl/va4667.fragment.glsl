#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}


void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos.x += time/4.0;
	vec3 col = vec3(0.0);
	float y = pos.y + sin(pos.x*8.0)*rand(pos);
		

	float rad = 0.1;
	float az =  0.25;
	if (y > 0.0) {
		vec2 xp = gl_FragCoord.xy / resolution.xx;
		float d = distance(xp, vec2(0.5, az));
		if (d < rad)
			col = vec3(1.0)-y;
		else
			col = vec3(rad + 1.0 - d * 0.2 + 0.05, rad - d * 0.35 + 0.05, rad - 0.1 - d * 0.3 + 0.05) * 10.0 * 0.5;
		col += pow(max((0.3- y * 0.2) * 3.0, 0.0), 4.0) * (1.0 - az);
	}
	gl_FragColor = vec4(col, 1.0);
}
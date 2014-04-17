#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float radius;
float depth;
float angle;
vec3 pos;
vec3 normal;
vec3 color;

float ring(vec2 pos, vec2 center){
	return length(pos - center);
}

void lights(){
	float movement = mod(-time, 6.0);
	vec3 lightpos = vec3(0, 0.45, (floor((depth - movement) / 6.0 + 0.5)) * 6.0 + movement);

	vec3 toLight = lightpos - pos;
	color *= dot(toLight, normal) * 2.3 / pow(length(toLight), 2.0);
}

void stripes(){
	if(mod(floor(depth + time), 2.0) == 0.0)
		color = vec3(0.9, 0.9, 0.9);
	else
		color = vec3(0.2, 0.2, 0.2);
}

void fog(){
	color = mix(color, vec3(0.8, 0.3, 0.2), clamp(depth / 42.0, 0.0, 1.0));
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.y - vec2(resolution.x / resolution.y / 2.0, 0.5);
	
	radius = ring(position, vec2(0.0, 0.0));
	depth = 1.0 / radius;
	angle = atan(position.y, position.x);
	pos = vec3(position*depth, depth);
	normal = normalize(vec3(-pos.xy, 0));

	
	color = vec3(0.5, 0.5, 0.5);
	stripes();
	lights();
	fog();
	
	gl_FragColor = vec4(color, 1.0 );

}
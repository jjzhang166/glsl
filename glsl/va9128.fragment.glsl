#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec3 p) //by. Las^Mercury
{
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
	vec3 f = cos((p-i)*acos(-1.))*(-.5)+.5;
	a = mix(sin(cos(a)*a),sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = mix(a.xz, a.yw, f.y);
	return length(a);

}

vec3 crater(float r, float x, float y) {
    	float z = sqrt(r*r - x*x - y*y) * 2.5;

    	vec3 normal = normalize(vec3(x, y, z));
	
	return normal;
}

void main( void ) {
	vec2 center = resolution / 2.;
	vec2 pos = gl_FragCoord.xy - center;

	
	vec3 color = vec3(0.);

	
	color += crater(100., pos.x, pos.y);
	
	
	
	
	gl_FragColor = vec4(color, 1.0);
}
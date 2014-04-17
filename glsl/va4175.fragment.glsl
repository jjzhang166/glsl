#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rotMatrix( float r ) {
	return mat2(vec2(cos(r), -sin(r)), vec2(sin(r), cos(r)));	
}

vec2 rotate(vec2 v, float r) {
	return v * rotMatrix(r);	
}

mat3 transMatrix( vec2 v ) {
	return mat3(vec3(1., 0., v.x), vec3(0., 1., v.y), vec3(0., 0., 1.));		
}

vec2 translate(vec2 v, vec2 t) {
	vec3 result = vec3(v.x, v.y, 1.0) * transMatrix(t);
	return vec2(result.x, result.y);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 origin = vec2(0.5, 0.5);
	
	float dist = distance( position, origin );
	
	position = translate(position, -origin);
	position = rotate(position, time * time * 50. * sin(dist) * cos(dist));
	position = translate(position, origin);
	
	float color = 0.0;
	
	if (position.x > 0.5)
		color = position.x;
	else
		color = 0.0;
	
	gl_FragColor = vec4( vec3(0.5, color, color ), 1.0 );

}
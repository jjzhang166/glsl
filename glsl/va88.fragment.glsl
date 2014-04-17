// by @super_eggbert

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float NUM_BUBBLES = 80.0;

vec4 doBubble(vec2 coord,  float bubble){
	float mtime = time * 500.0 + bubble * 1000.0;
	vec4 result = vec4(0.0,0.0,0.0,1.0);
	vec3 position = vec3(
		cos( mtime / (500.0 + bubble * 5.0) ) * 0.2 + mod( bubble / 10.0, 1.0 ) / 10.0 - sin( bubble * 370.0 )*resolution.x/resolution.y,
		- mod( ( mtime /  2000.0 * (cos(bubble*3.0)+2.0) ), 3.0 + bubble / 100.0) + 1.0,
		0
	);
	float radius = 0.05 * ( cos( bubble * 3.0) + 1.0 ) + 0.05;
	vec3 color = vec3( -0.1, -0.15, -0.25 );
	float l = length( vec3(coord,0.0) - position );
	if ( l < radius  ){
		vec3 shading = ( vec3( coord, 0.0 ) - position ) / radius;
		shading.z = 1.0 - length( shading );
		float intensity = dot( shading, vec3( -0.707, 0.707, 0.4 ) );
		if ( intensity < 0.0 ) intensity *= -1.5;
		color *= intensity + 1.0;
		color += pow( intensity, 3.0 );
		if (l > radius * 0.95){
			color *= 1.0 - ( l - radius * 0.95 ) / ( radius * 0.05);
		}
		result = vec4( color, 1.0 );
	} else {
		vec3 streak = vec3( coord, 0.0 ) - position + vec3( -0.707, 0.707, 0.0 ) * radius * 5.0;
		float value = dot( normalize(streak), vec3( -0.707, 0.707, 0.0 ) ) ;
		float l = length( streak );
		float amount = max( 0.0, value * pow( 10.0 / l*radius, 2.0 ) );
		if(value > 0.98 && l > radius * 5.0){
			amount *= min( 1.0, ( value - 0.98 ) / 0.02 * 5.0);
			color = vec3( -0.01, -0.01, -0.01 ) * amount;
			color *= ( bubble + 1.0 ) / NUM_BUBBLES * 0.8 + 0.2;
			result = vec4( color, 1.0 );
		}
	}
	return result;
}

void main( void ){
	vec4 result = vec4( 0.69, 0.89, 0.99, 1.0 );
	vec2 coord = (( gl_FragCoord.xy / resolution.xy )-0.5)*vec2(2.0*resolution.x/resolution.y,2.0);
	coord.y=-coord.y;
	for( float i = 0.0; i < NUM_BUBBLES; i += 1.0 ){
		result += doBubble( coord,  i );
	}
	float fade = ( coord.y + 1.0 ) * 0.5;
	result = ( 1.0 - fade ) * result + fade * vec4( 0.12, 0.25, 0.32, 1.0 );
	gl_FragColor = result;
}
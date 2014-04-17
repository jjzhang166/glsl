#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define unitSize 0.8
#define modulation 11.0
#define strokeWidth 0.25

void main( void ) {

	float aspectRatio = resolution.x / resolution.y;
	
	vec2 unitPosition = gl_FragCoord.xy / resolution.xy;
	unitPosition.x *= aspectRatio;
	
	vec2 modulatedUnitPosition = fract( modulation * unitPosition );
	vec2 modulatedCenter = fract( modulation * vec2( 0.5, 0.5 ) );
	modulatedUnitPosition = modulatedUnitPosition - modulatedCenter;
	modulatedUnitPosition = abs( modulatedUnitPosition );
	modulatedUnitPosition *= 3.0;
	
	float angle = atan(modulatedUnitPosition.y, modulatedUnitPosition.x);
	angle = mod( angle, 3.1415 / ( 11.0 * ( 0.5 + 0.1 * sin( time ) ) ) );
	float radius = length( modulatedUnitPosition );
 	vec2 reModulatedUnitPosition = vec2( cos( angle ) * radius, sin( angle ) * radius ) - modulatedCenter;
	
	vec3 color = vec3( 0.0, 0.0, 0.0 );
	
	float distanceToModulatedCenter = length( reModulatedUnitPosition );
	float targetSize = unitSize * ( 1.0 + 0.5 * sin( time ) );
	if( distanceToModulatedCenter < targetSize && distanceToModulatedCenter > targetSize - strokeWidth ) {
		color = vec3( 1.0, 1.0, 1.0 );	
	}

	gl_FragColor = vec4( color, 1.0 );
}
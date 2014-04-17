#ifdef GL_ES
precision mediump float;
#endif

// Possible SailfishOS icon shapes
// by Yaniel

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 cell = floor(4.0 * gl_FragCoord.xy / resolution.xy );
	vec2 cellPos = 2.0*(fract(4.0 * gl_FragCoord.xy / resolution.xy)-0.5);
	float rdist = length(cellPos);
	float id = 4.0*cell.y + cell.x;

	vec4 color = vec4(cell.x*0.25, cell.y*0.25, 1.0-id/16.0, 1.0);
	color *= step(cellPos.x, 0.8) * step(-0.8, cellPos.x) * step(cellPos.y, 0.8) * step(-0.8, cellPos.y);

	if(cellPos.x > 0.0 && cellPos.y > 0.0 && cell.x < 2.0)
		color *= step(rdist, 0.8);
	if(cellPos.x < 0.0 && cellPos.y > 0.0 && cell.y < 2.0)
		color *= step(rdist, 0.8);
	if(cellPos.x < 0.0 && cellPos.y < 0.0 && mod(cell.x, 2.0) == 0.0)
		color *= step(rdist, 0.8);
	if(cellPos.x > 0.0 && cellPos.y < 0.0 && mod(cell.y, 2.0) == 0.0)
		color *= step(rdist, 0.8);

	gl_FragColor = color;
}
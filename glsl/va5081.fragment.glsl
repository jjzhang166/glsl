#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

struct Point {
	vec4 col;
	float powv;
};
Point points[1];

 highp float rand(highp vec2 co){
     return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
 }

void main( void ) {
	for (int i = 0; i < 1; i++) {
		vec4 col = vec4(0, 0, 0, 1);
		vec2 p = ( gl_FragCoord.xy / resolution.xy ) - rand(resolution.xy);
		p.x *= resolution.x/resolution.y;
		
		Point point = points[i];
		
		point.col = vec4( 1,0,0,1 );
		point.powv = 100.0;
	
		float dist = distance( p, gl_FragColor.xy );
		vec4 c = point.col * (1.0 - smoothstep(0.0, 0.1, dist));
		col += c;
		gl_FragColor = col;
	}
}


precision mediump float;
uniform vec2 resolution; // window size.xy
uniform float time;

void main() {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	float color = 0.0;
        color += sin( position.x * sin( time / 15.0 ) * 80.0 ) + cos( position.y * sin( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
        
        color *= asin( time / 50.0 ) * 0.6;

        gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 4.0 ) * 0.8 ), 0.2 );
}
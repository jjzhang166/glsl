#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// somewhere from net
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 0.0;
	color += rand(vec2(position.y*time, position.x*time))* distance(position.x, 0.48)*0.5;
	color += rand(vec2(position.y*time, position.x*time))* distance(position.x, 0.5)*0.5;
	color += rand(vec2(position.y*time, position.x*time))* distance(position.x, 0.52)*0.5;
	
	color *= (color*0.8);

	gl_FragColor = vec4( color,color,color, 1.0);

}
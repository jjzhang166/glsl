#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color;

	color += distance(position.x, position.y)+sin( sqrt(position.y) );
	color *= color*sqrt(-color);
	
	color = color * cos ( color * position.x + color * position.y );
	
	
	vec3 _normalDir = normalize(color);
	
	color += dot(_normalDir, _normalDir + vec3(1.0, 0.0, 0.0))*0.1;
	
	
	// tree
	color.g += (1.0 / distance(position+sin(time*cos(position.x))*3.0, vec2(0.5, 0.5)))*0.05;
	color.r += (1.0 / distance(position+sin(time*sin(position.y)), vec2(0.0, 0.0)))*0.05;
	color.b += (1.0 / distance(position+cos(time)*2.0, vec2(1.0, 1.0)))*0.05;
	
	gl_FragColor = vec4( color, 1.0 );

}